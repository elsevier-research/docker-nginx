# Consul Nginx image

This image inherits from the ```1science/nginx``` image adding support to manage the  Nginx configuration through [Consul](https://consul.io/)

It includes : 
  - [S6 Overlay](https://github.com/just-containers/s6-overlay) to properly manage multiple services in one container
  - [Consul template](https://github.com/hashicorp/consul-template) to manage dynamic configuration based on Consul
  - [Fileconsul](https://github.com/foostan/fileconsul) an utility to synchronize files on Consul
  
# Thanks

We would like to thanks [John Regan](https://github.com/jprjr) for his work on the [S6 system init](http://blog.tutum.co/2015/05/20/s6-made-easy-with-the-s6-overlay/) which is just awesome.
