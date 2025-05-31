FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libonig-dev \
    libzip-dev \
    libxml2-dev

# Install Xdebug only if the build argument INSTALL_XDEBUG is set to true
ARG INSTALL_XDEBUG=false
RUN if [ "$INSTALL_XDEBUG" = "true" ]; then \
    pecl install xdebug && docker-php-ext-enable xdebug; \
    fi

# Update the PHP-FPM configuration to listen on all addresses
RUN sed -i 's/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/' /usr/local/etc/php-fpm.d/www.conf

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

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Expose port 9000 and start php-fpm server
EXPOSE 9000

CMD ["php-fpm"]
