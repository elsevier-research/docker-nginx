#
# Nginx image
#

FROM 1science/alpine:3.1

# Nginx version
ENV NGINX_VERSION=1.9.6 NGINX_HOME=/usr/share/nginx

# Build Nginx from source
RUN apk-install openssl-dev pcre-dev zlib-dev wget build-base && \
    curl -Ls http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz | tar -xz -C /tmp && \
    cd /tmp/nginx-${NGINX_VERSION} && \
    ./configure \
        --with-http_ssl_module \
        --with-http_gzip_static_module \
        --prefix=${NGINX_HOME} \
        --conf-path=/etc/nginx/nginx.conf \
        --http-log-path=/var/log/nginx/access.log \
        --error-log-path=/var/log/nginx/error.log \
        --pid-path=/var/run/nginx.pid \
        --sbin-path=/usr/sbin/nginx && \
    make && \
    make install && \
    apk del build-base && mkdir -p /etc/nginx/conf.d && \
    rm -rf /tmp/* && \
    echo -ne "- with `nginx -v 2>&1`\n" >> /root/.built

# Forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# Add Nginx default config
ADD etc /etc

# Expose HTTP and HTTPS ports
EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]