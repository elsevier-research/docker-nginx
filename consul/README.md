[![](https://badge.imagelayers.io/1science/nginx:consul.svg)](https://imagelayers.io/?images=1science/nginx:consul 'Get your own badge on imagelayers.io')

# Consul Nginx image

This image inherits from the ```1science/nginx``` image adding support to manage the  Nginx configuration through [Consul](https://consul.io/)

It includes : 
  - [S6 Overlay](https://github.com/just-containers/s6-overlay) to properly manage multiple services in one container
  - [Consul template](https://github.com/hashicorp/consul-template) to manage dynamic configuration based on Consul
  - [Fileconsul](https://github.com/foostan/fileconsul) an utility to synchronize files on Consul

# Usage

### Consul Template

The following example mount the [Consul template](https://github.com/hashicorp/consul-template) configuration in the container: 

```
docker run --name nginx-consul -v etc/consul-template:/etc/consul-template:ro -d 1science/nginx:consul

```

or you can create your own ```Dockerfile```:

```
FROM 1science/nginx:consul

ADD etc/consul-template /etc/consul-template
```

## Fileconsul

The following example use [Fileconsul](https://github.com/foostan/fileconsul) to synchronize configuration files with Consul: 

```
docker run --name nginx-consul \ 
-e CONSUL_URL=localhost:8500 \
-e FILECONSUL_PREFIX=app \
-e FILECONSUL_DC=local \
-e FILECONSUL_BASEPATH=/app/etc \
-d 1science/nginx:consul
```

This synchronize the configuration files in Consul defined in the KV folder ```app``` in the local directory ```/app/etc```, then [reload](etc/periodic/1min/fileconsul) the nginx process.

# Load Balancing Sample

The [sample application](sample) demonstrate how to achieve load balancing with Nginx, [Consul](https://www.consul.io/) and [Registrator](http://progrium.com/blog/2014/09/10/automatic-docker-service-announcement-with-registrator/).

# Thanks

We would like to thanks [John Regan](https://github.com/jprjr) for his work on the [S6 system init](http://blog.tutum.co/2015/05/20/s6-made-easy-with-the-s6-overlay/) which is just awesome.
