FROM openresty/openresty:alpine

# Install necessary packages
RUN apk update && \
    apk add --no-cache \
    git \
    make \
    gcc \
    musl-dev \
    bash \
    curl \
    openssl \
    libc6-compat

# Create nginx user and group
RUN addgroup -S nginx && adduser -S nginx -G nginx

# Clone and install lua-resty-http
RUN mkdir -p /usr/local/openresty/lualib && \
    cd /usr/local/openresty/lualib && \
    git clone https://github.com/ledgetech/lua-resty-http.git && \
    cp -r lua-resty-http/lib/resty /usr/local/openresty/lualib/

# Copy Nginx configuration and Lua script
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY route.lua /usr/local/openresty/nginx/lua/route.lua

# Set correct permissions
RUN chown -R nginx:nginx /usr/local/openresty/nginx

# Expose port 80
EXPOSE 80

# Switch to nginx user
USER nginx

# Start OpenResty
CMD ["openresty", "-g", "daemon off;"]
