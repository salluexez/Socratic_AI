import { spawn } from "node:child_process";
import net from "node:net";

const npmCmd = process.platform === "win32" ? "npm.cmd" : "npm";
const pythonCmd = process.platform === "win32" ? "python" : "python3";

function run(command, label) {
  return new Promise((resolve, reject) => {
    console.log(`\n[${label}] ${command}`);
    const child = spawn(command, {
      stdio: "inherit",
      shell: true,
      env: process.env,
    });

    child.on("error", reject);
    child.on("close", (code) => {
      if (code === 0) resolve();
      else reject(new Error(`${label} failed with exit code ${code}`));
    });
  });
}

function start(command, label) {
  console.log(`\n[${label}] ${command}`);
  const child = spawn(command, {
    stdio: "inherit",
    shell: true,
    env: process.env,
  });

  child.on("error", (err) => {
    console.error(`[${label}] error:`, err.message);
  });

  return child;
}

function isPortInUse(port, host = "127.0.0.1") {
  return new Promise((resolve) => {
    const server = net.createServer();
    server.once("error", (err) => {
      if (err && err.code === "EADDRINUSE") resolve(true);
      else resolve(false);
    });
    server.once("listening", () => {
      server.close(() => resolve(false));
    });
    server.listen(port, host);
  });
}

async function main() {
  await run(`${npmCmd} run build --workspace=@socratic-ai/web`, "build:web");
  await run(`${npmCmd} run build --workspace=@socratic-ai/backend`, "build:backend");

  const serviceDefs = [
    { label: "web", port: 3001, command: `${npmCmd} run start --workspace=@socratic-ai/web -- -p 3001` },
    { label: "backend", port: Number(process.env.PORT || 5000), command: `${npmCmd} run start --workspace=@socratic-ai/backend` },
    { label: "python", port: 8000, command: `${pythonCmd} apps/script/socratic.py` },
  ];
  const processes = [];

  for (const service of serviceDefs) {
    const occupied = await isPortInUse(service.port);
    if (occupied) {
      console.log(`\n[skip:${service.label}] Port ${service.port} is already in use. Keeping existing service.`);
      continue;
    }
    processes.push(start(service.command, service.label));
  }

  if (processes.length === 0) {
    console.log("\nAll services appear to be running already. Nothing new to start.");
    return;
  }

  let shuttingDown = false;
  const shutdown = (signal = "SIGTERM") => {
    if (shuttingDown) return;
    shuttingDown = true;
    for (const p of processes) {
      if (!p.killed) p.kill(signal);
    }
    setTimeout(() => process.exit(0), 250);
  };

  process.on("SIGINT", () => shutdown("SIGINT"));
  process.on("SIGTERM", () => shutdown("SIGTERM"));

  processes.forEach((p, index) => {
    p.on("close", (code) => {
      if (!shuttingDown) {
        console.error(`Process ${index + 1} exited with code ${code}. Shutting down all services.`);
        shutdown("SIGTERM");
      }
    });
  });
}

main().catch((err) => {
  console.error(err.message);
  process.exit(1);
});
