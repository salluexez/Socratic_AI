FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/cache/*

# Copy requirements and install
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY . .

# Expose port
EXPOSE 8000

# Start the application using uvicorn
# We host on 0.0.0.0 to allow connections from the proxy/gateway
CMD ["uvicorn", "socratic_ai:app", "--host", "0.0.0.0", "--port", "8000"]
