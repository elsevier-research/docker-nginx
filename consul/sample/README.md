# How to setup Nginx as a dynamic load balancer ?

The following application demonstrate how to setup a dynamic load balancing with :

  - [Nginx](http://nginx.org/en/docs/http/load_balancing.html) as a load balancer
  - [Consul](http://progrium.com/blog/2014/08/20/consul-service-discovery-with-docker/) as service registry
  - [Registrator](http://progrium.com/blog/2014/09/10/automatic-docker-service-announcement-with-registrator/) as service registrator
  - [Hello World application](https://github.com/tutumcloud/docker-hello-world) as sample application


# How to use ?


First of all you have to install [Consul](https://www.consul.io/intro/getting-started/install.html) and [Consul UI](https://www.consul.io/downloads.html).


Then you have to start Consul as an agent server on the docker host.

```
consul agent -server -bootstrap-expect 1 -data-dir /tmp/consul -ui-dir /usr/local/share/consul --client 0.0.0.0
```

Then you can start the services :

```
docker-compose up 
```

This should start all services defined in ```docker-compose.yml```.


The sample app should be running and being available at ```http://localhost/```, displaying the hostname of the container serving the application. 


Now we want to scale up the sample application :

```
docker-compose scale app=5
```

and we can see refreshing the sample app in your favorite browser, the hostname should change. 


If you check the Consul UI located at ```http://localhost:8500/ui```, you you should see 5 instances of the sample application (named app).


Now we can scale down the sample application :

```
docker-compose scale app=1
```

and the containers should be stopped and destroyed.


# How it works ?

The [registrator](https://github.com/gliderlabs/registrator) container is responsable for registering and deregistering services based on container start and die events from Docker. 

The [consul](https://github.com/progrium/docker-consul) container maintain the service registry. 

The [nginx](https://github.com/1science/docker-nginx) use [S6](http://skarnet.org/software/s6/) as system init to run nginx and [consul-template](https://github.com/hashicorp/consul-template) in the same container. 

The role of consul-template is to generate a valid nginx configuration file in ```/etc/nginx/conf.d``` directory based on a [template](templates/app.conf) and reload Nginx when new services are registered in Consul.


# Thanks

We would like to thanks :

 - [Jeff Lindsay](http://progrium.com/) for the fantastic work he did for building [registrator](https://github.com/gliderlabs/registrator) and [consul](https://github.com/progrium/docker-consul) docker images.
 - [John Regan](https://github.com/jprjr) for his article on [S6 system init](http://blog.tutum.co/2014/12/02/docker-and-s6-my-new-favorite-process-supervisor/) which is a great system init.
 - [Shane Sveller]() from [Tutum](https://www.tutum.co/) for his article on [load balancing with Nginx and consul-template]( https://tech.bellycard.com/blog/load-balancing-docker-containers-with-nginx-and-consul-template/) which inspired this prototype
