FROM nginx:latest

RUN set -x && \
    # tiny helper to reload nginx config
    printf '#!/bin/bash\n/usr/sbin/nginx -s reload\n' >> /usr/local/bin/nginx-reload && \
    chmod +x /usr/local/bin/nginx-reload && \
    # delete nginx default server config
    rm /etc/nginx/conf.d/default.conf

COPY ./config/webserver/default /etc/nginx/

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

# Self-signed certification generation
# Copy into the container
COPY build/webserver/entrypoint.sh /usr/local/bin/entrypoint.sh

# Give permission for the file
RUN chmod +x /usr/local/bin/entrypoint.sh

# Run the command inside the container
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
