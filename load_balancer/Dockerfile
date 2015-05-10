#
# Load balancer based on Nginx and Consul template
#
FROM 1science/nginx:1.9.0

# Consul template version
ENV CONSUL_TEMPLATE_VERSION=0.9.0
ENV PATH=${PATH}:${CONSUL_TEMPLATE_HOME}/bin

# Install consul template
RUN curl -Ls https://github.com/hashicorp/consul-template/releases/download/v${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.tar.gz | tar -xz -C /usr/share && \
    ln -s /usr/share/consul-template_0.9.0_linux_amd64/consul-template /usr/local/sbin/consul-template

# Install S6 (init system)
ADD s6-2.0.0.1.tar.gz /
ADD service /etc/service
RUN mkdir -p /var/spool/cron/crontabs

# Add NGinx and Consul Template service
ADD nginx.service /etc/service/nginx/run
ADD consul-template.service /etc/service/consul-template/run

USER root
ENTRYPOINT ["/usr/bin/s6-svscan", "-t0"]

CMD ["/etc/service"]