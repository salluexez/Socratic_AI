#!/bin/bash

# Function to clean up background processes on exit
cleanup() {
    echo ""
    echo "Stopping all services..."
    # Kill all child processes of this script
    pkill -P $$ 2>/dev/null
    
    # Force kill ports just in case PIDs were lost
    lsof -ti:5000,8000 | xargs kill -9 2>/dev/null
    exit
}

# Trap SIGINT (Ctrl+C) and SIGTERM
trap cleanup SIGINT SIGTERM EXIT

echo "🚀 Starting Socratic AI Combined Services..."

# 0. Initial Cleanup (Ensuring ports are free)
echo "🧹 Cleaning up existing processes on ports 5000 and 8000..."
lsof -ti:5000,8000 | xargs kill -9 2>/dev/null || true

# 1. Start Python AI Model
echo "🐍 Starting Python AI Model..."
(
    cd backend/src/script || exit
    if [ -d "venv" ]; then
        source venv/bin/activate
    fi
    python3 socratic_ai.py
) &

# 2. Start Bun Backend
echo "🍱 Starting Bun Backend Server..."
(cd backend && bun run dev) &

# Give backend a moment to start
echo "⏳ Waiting for services to initialize..."
sleep 3

# 3. Start Flutter App
echo "📱 Starting Flutter App..."
flutter run
