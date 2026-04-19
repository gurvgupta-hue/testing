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

# 6. Exposing dangerous ports
# Using a port typically associated with unauthenticated services
EXPOSE 22 80 443

# 7. Insecure startup command
# Using shell form and potentially executing unverified scripts
CMD ["sh", "-c", "node app.js"]
