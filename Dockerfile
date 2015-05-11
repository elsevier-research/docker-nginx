#
# Nginx image
#

FROM 1science/alpine:3.1

# Nginx and Consul template version
ENV NGINX_VERSION=1.9.0 NGINX_HOME=/usr/local/nginx CONSUL_TEMPLATE_VERSION=0.9.0

# Build Nginx from source and install consul template
RUN apk-install openssl-dev pcre-dev zlib-dev wget build-base && \
    curl -Ls http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz | gunzip | tar -x -C /tmp && \
    cd /tmp/nginx-${NGINX_VERSION} && \
    ./configure \
        --with-http_ssl_module \
        --with-http_gzip_static_module \
        --prefix=${NGINX_HOME} \
        --conf-path=/etc/nginx.conf \
        --http-log-path=/proc/self/fd/1 \
        --error-log-path=/proc/self/fd/2 \
        --sbin-path=/usr/local/sbin/nginx && \
    make && \
    make install && \
    apk del build-base && \
    rm -rf /tmp/nginx-${NGINX_VERSION} && \
    curl -Ls https://github.com/hashicorp/consul-template/releases/download/v${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.tar.gz | tar -xz -C /usr/share && \
    ln -s /usr/share/consul-template_0.9.0_linux_amd64/consul-template /usr/local/sbin/consul-template && \
    echo -ne "- with `nginx -v 2>&1`\n" >> /root/.built

ENV PATH=${PATH}:${NGINX_HOME}/sbin

# Add Nginx and Consul Template service
ADD nginx.service /etc/service/nginx/run
ADD consul-template.service /etc/service/consul-template/run

# Expose HTTP and HTTPS ports
EXPOSE 80 443

# Run services located in /etc/service directory
CMD ["s6-svscan", "-t0", "/etc/service"]