# Historical Perma redirector

Production redirects moved to Cloudflare on September 16, 2026. Both
`custom.perma.cc` and `perma.law.harvard.edu` now redirect at the edge, with
certificates managed by Cloudflare. Configuration and operations are in
[lil-terraform/perma-redirector](https://github.com/harvard-lil/lil-terraform/tree/main/perma-redirector).

This repository preserves the former Nginx implementation. Do not redeploy it;
operational fixes belong in Terraform. The old Fly app still needs
decommissioning. The instructions below are historical.

A microservice to re-direct requests for [validly-formed GUIDS](https://github.com/harvard-lil/perma/blob/a1f38e4d7d254ee1efaa3b3fde9315ac4439ce31/perma_web/perma/urls.py#L17) to Perma.

Why?
----
Some early adopters of Perma participated in a beta program in which they used and cited Perma not at perma.cc, but at their own custom domain. The program was ended and custom domains are no longer supported, but we maintain this redirection service to help prevent those early adopters' citations from rotting: using a DNS CNAME record, they can point their custom domains to this service.

Local development
-----------------

Increment the image tag in `docker-compose.yml`

Run ```docker-compose up``` to build the container (or ```docker-compose up --build``` to subsequently force a rebuild).

- Visit http://localhost. You should get "400 Invalid Path".
- Visit http://localhost/asdf.png. You should get You should get "400 Invalid Path".
- Visit http://localhost/asdf/asdf. You should get You should get "400 Invalid Path".
- Visit http://localhost/asdf-asdf. You should be redirected to https://perma.cc/asdf-asdf.
- Visit http://localhost/asdf-asdf]. You should be redirected to https://perma.cc/asdf-asdf], and then to https://perma.cc/asdf-asdf.


Deployment
----------

This microservice was deployed at [fly.io](https://fly.io/) from a built image
in the LIL registry. These steps describe the retired deployment.

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
