# 1. Using an ancient, unpatched base image (High CVE count)
FROM node:12.18.1

# 2. Running as root (The default, but dangerous)
# No USER directive means the container has root privileges by default.

# 3. Installing unnecessary, vulnerable packages
RUN apt-get update && apt-get install -y \
    curl \
    netcat \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# 4. Hardcoding sensitive credentials (Secret leakage)
ENV ADMIN_PASSWORD="Password1234!"
ENV AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"

# 5. Setting overly permissive file permissions
WORKDIR /app
COPY . .
RUN chmod -R 777 /app

# Expose only the ports required by the application — SSH (22) removed
EXPOSE 80 443
CMD ["sh", "-c", "node app.js"]
