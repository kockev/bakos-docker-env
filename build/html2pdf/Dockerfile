FROM node:16

# Install necessary dependencies for Puppeteer and Chromium
RUN apt-get update && apt-get install -y \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libxrender1 \
    libxcursor1 \
    libxss1 \
    libxtst6 \
    xdg-utils \
    lsb-release \
    wget \
    curl \
    ca-certificates \
    chromium \
    libxkbcommon0 \
    --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app/pdf

# Copy only package.json and package-lock.json first for better cache handling
COPY pdf-service/package*.json ./

# Install dependencies
RUN npm install --verbose || echo "NPM install failed"

# Debugging: Check the contents of the working directory after running npm install
RUN echo "Installed node_modules contents:" && ls -la /usr/src/app/pdf && ls -la /usr/src/app/pdf/node_modules || echo "node_modules not found"

# Now copy the rest of the app files (including server.js)
COPY pdf-service/ .

EXPOSE 3000

CMD ["npm", "start"]

# Set the build-time variable
ARG ENVIRONMENT

# Set the environment variable for runtime
ENV ENVIRONMENT=${ENVIRONMENT}

# Set the shell prompt color based on the environment
RUN if [ "$ENVIRONMENT" = "local" ]; then \
    echo 'PS1="\[\033[01;32m\]\u@\h:\w\$ \[\033[00m\]"' >> /root/.bashrc; \
    elif [ "$ENVIRONMENT" = "staging" ]; then \
    echo 'PS1="\[\033[01;33m\]\u@\h:\w\$ \[\033[00m\]"' >> /root/.bashrc; \
    elif [ "$ENVIRONMENT" = "production" ]; then \
    echo 'PS1="\[\033[01;31m\]\u@\h:\w\$ \[\033[00m\]"' >> /root/.bashrc; \
    fi \
 && echo 'source /root/.bashrc' >> /root/.bash_profile \
 && echo "Contents of /root/.bashrc:" \
 && cat /root/.bashrc
