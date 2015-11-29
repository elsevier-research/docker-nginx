#
# Nginx image with Consul Template and Fileconsul
#
FROM 1science/nginx:1.9.6

# Consul template for configuration management
ENV S6_OVERLAY_VERSION=1.9.1.3 CONSUL_TEMPLATE_VERSION=0.11.0

# Install S6 Overlay, Consul Template and Fileconsul
RUN curl -Ls https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz | tar -xz -C / && \
    curl -Ls https://github.com/hashicorp/consul-template/releases/download/v${CONSUL_TEMPLATE_VERSION}/consul_template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -o consul-template.zip && unzip consul-template.zip -d /usr/local/bin && \
    rm -f consul-template* && \
    echo -ne "- with `consul-template -v 2>&1`\n" >> /root/.built

# Add services configuration
ADD etc /etc

ENTRYPOINT ["/init"]
CMD ["nginx", "-g", "daemon off;"]