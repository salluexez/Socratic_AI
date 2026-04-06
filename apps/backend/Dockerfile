FROM oven/bun:latest

WORKDIR /app

# Copy package.json
COPY package.json ./

# Install dependencies
RUN bun install

# Copy source code
COPY . .

# Expose port (Render will override this with PORT env var)
EXPOSE 5000

# Start the application using bun
CMD ["bun", "run", "src/index.ts"]
