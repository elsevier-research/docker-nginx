#
# Nginx image
#

FROM 1science/alpine:3.1

# Nginx and Consul template version
ENV NGINX_VERSION=1.9.0 NGINX_HOME=/usr/share/nginx CONSUL_TEMPLATE_VERSION=0.9.0

# Build Nginx from source and install consul template
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
        --sbin-path=/usr/sbin/nginx && \
    make && \
    make install && \
    apk del build-base && \
    rm -rf /tmp/* && \
    curl -Ls https://github.com/hashicorp/consul-template/releases/download/v${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.tar.gz | tar -xz -C /usr/share && \
    cp -f /usr/share/consul-template*/consul-template /usr/sbin/consul-template && rm -fr /usr/share/consul-template* && \
    echo -ne "- with `nginx -v 2>&1`\n" >> /root/.built

# Forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# Add Nginx and Consul Template service
ADD nginx.service /etc/service/nginx/run
ADD consul-template.service /etc/service/consul-template/run
ADD nginx.conf /etc/nginx/

# Expose HTTP and HTTPS ports
EXPOSE 80 443

# Run services located in /etc/service directory
CMD ["s6-svscan", "-t0", "/etc/service"]