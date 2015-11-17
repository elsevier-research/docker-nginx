[![](https://badge.imagelayers.io/1science/nginx:latest.svg)](https://imagelayers.io/?images=1science/nginx:latest 'Get your own badge on imagelayers.io')

# What is Nginx?

![logo](https://raw.githubusercontent.com/1science/docker-nginx/latest/logo.png)

Nginx (pronounced "engine-x") is an open source reverse proxy server for HTTP, HTTPS, SMTP, POP3, and IMAP protocols, as well as a load balancer, HTTP cache, and a web server (origin server). The nginx project started with a strong focus on high concurrency, high performance and low memory usage. It is licensed under the 2-clause BSD-like license and it runs on Linux, BSD variants, Mac OS X, Solaris, AIX, HP-UX, as well as on other *nix flavors. It also has a proof of concept port for Microsoft Window..

> [wikipedia.org/wiki/Nginx](https://en.wikipedia.org/wiki/Nginx)


# Usage

## Hosting some simple static content

```
docker run --name some-nginx -v /some/content:/usr/share/nginx/html:ro -d 1science/nginx
```

Alternatively, a simple `Dockerfile` can be used to generate a new image that includes the necessary content (which is a much cleaner solution than the bind mount above):

```
FROM 1science/nginx
COPY static-html-directory /usr/share/nginx/html
```

Place this file in the same directory as your directory of content ("static-html-directory"), run `docker build -t some-content-nginx .`, then start your container:

```
docker run --name some-nginx -d some-content-nginx
```

## Exposing the port

```
docker run --name some-nginx -d -p 8080:80 some-content-nginx
```

Then you can hit `http://localhost:8080` or `http://host-ip:8080` in your browser.

## Complex configuration

```
docker run --name some-nginx -v /some/nginx.conf:/etc/nginx/nginx.conf:ro -d 1science/nginx
```

For information on the syntax of the Nginx configuration files, see [the official documentation](http://nginx.org/en/docs/) (specifically the [Beginner's Guide](http://nginx.org/en/docs/beginners_guide.html#conf_structure)).

Be sure to include `daemon off;` in your custom configuration to ensure that Nginx stays in the foreground so that Docker can track the process properly (otherwise your container will stop immediately after starting)!

If you wish to adapt the default configuration, use something like the following to copy it from a running Nginx container:

```
docker cp some-nginx:/etc/nginx/nginx.conf /some/nginx.conf
```

As above, this can also be accomplished more cleanly using a simple `Dockerfile`:

```
FROM 1science/nginx
COPY nginx.conf /etc/nginx/nginx.conf
```

Then, build with `docker build -t some-custom-nginx .` and run:

```
docker run --name some-nginx -d some-custom-nginx
```

## Dynamic configuration with Consul

Sometimes, it might be necessary to change the Nginx configuration dynamically for example to add hosts to achieve load balancing.

To do that we've built an [image](consul) based on [Consul](https://consul.io/) and [Consul template](https://github.com/hashicorp/consul-template)

# Build

This project is configured as an [automated build in Dockerhub](https://hub.docker.com/r/1science/nginx/). 

Each branch give the related image tag.  

# License

All the code contained in this repository, unless explicitly stated, is
licensed under ISC license.

A copy of the license can be found inside the [LICENSE](LICENSE) file.
