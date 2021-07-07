A microservice to re-direct requests for [validly-formed GUIDS](https://github.com/harvard-lil/perma/blob/a1f38e4d7d254ee1efaa3b3fde9315ac4439ce31/perma_web/perma/urls.py#L17) to Perma.

Why?
----
Some early adopters of Perma participated in a beta program in which they used and cited Perma not at perma.cc, but at their own custom domain. The program was ended and custom domains are no longer supported, but we maintain this redirection service to help prevent those early adopters' citations from rotting: using a DNS CNAME record, they can point their custom domains to this service.

Local development
-----------------

Increment the image tag in `docker-compose.yml`

Run ```docker-compose up``` to build the container (or ```docker-compose up --build``` to subsequently force a rebuild).

- Visit http://localhost. You should get "400 Invalid Path".
- Visit http://localhost/asdfasdfasdfasdfasdf. You should get "400 Invalid Path".
- Visit http://localhost/asdf-asdf. You should be redirected to https://perma.cc/asdf-asdf.


Deployment
----------

This microservice is currently deployed at [fly.io](https://fly.io/). I decided to have fly deploy from a built image available from the LIL registry, rather than having it re-build the image itself during deployment using the Dockerfile. To be discussed: that may be unnecessarily complicated.

To redeploy:

Push the image to the LIL registry:
```
docker push registry.lil.tools/harvardlil/perma-redirector:0.x
```

Update the tag in `fly.toml`:
```
[build]
  image = "registry.lil.tools/harvardlil/perma-redirector:0.x"
```

Run `flyctl deploy`.


SSL
---

I ran `flyctl certs create custom.perma.cc` to get SSL working. I have no idea if that will keep working in perpetuity, or if we have to renew occasionally... but I think it should just work.
```
The certificate for custom.perma.cc has been issued.

Hostname                  = custom.perma.cc

DNS Provider              = cloudflare

Certificate Authority     = Let's Encrypt

Issued                    = ecdsa,rsa

Added to App              = 1 minute ago

Source                    = fly
```
