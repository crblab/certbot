# Certbot Docker Image
Docker image for Let's Encrypt Certbot enabled DNS plugins with auto-renew cronjob.

## How to deploy?
The project can be deployed quickly via docker-compose command:
```
$ git clone https://github.com/hieupth/certbot
$ cd certbot
$ docker-compose up -d
```

## Configuration
Copy <strong>.env.template</strong> file to <strong>.env</strong> file and then edit it as your own needs.

## Environment Variables
* <strong>DOMAINS</strong>: a space or comma separated list of domains for which you want to generate certificates. 
* <strong>WEBROOT</strong>: set this variable to the webroot path if you want to use the webroot plugin. Leave to use the standalone webserver.
* <strong>EMAIL</strong>: where you will receive updates from letsencrypt.
*  <strong>CONCAT</strong>: true or false, whether you want to concatenate the certificate's full chain with the private key (required for e.g. haproxy), or keep the two files separate (required for e.g. nginx or apache).
* <strong>SEPARATE</strong>: true or false, whether you want one certificate per a domain or one certificate valid for all domains.
If you use a DNS server to manage your domain, you can configure these environment variables:
* <strong>WEBROOT</strong>: set this variable to the webroot path if you want to use the webroot plugin.
* <strong>CLOUDFLARE</strong>: set this variable to your Cloudflare API token if you want to automate the process of completing challenge when you use Cloudflare as DNS server.
* <strong>DIGITALOCEAN</strong>: set this variable to your DigitalOcean API token if you want to automate the process of completing challenge when you use DigitalOcean as DNS server.
* <strong>DNSIMPLE</strong>: set this variable to your DNSimple API token if you want to automate the process of completing challenge when you use DNSimple as DNS server.

## Certifications
All obtained certifications are placed in <strong>/certs</strong> folder which linked to <strong>${CERTS_DIR}</strong> as in <strong>docker-compose.yml</strong> file:
* <strong>.crt</strong>: the signed certification.
* <strong>.chn</strong>: the certificate chain (root certificate and all intermediate certificates) needed to validate the certificate is signed by a trusted root certificate.
* <strong>.key</strong>: the private key. please keep this file private and secure at all times.
* <strong>.pem</strong>: a combination of both certification and chain.

### Notice
The first time you start it up, you may want to run the certificate generation script immediately:
```
docker exec certbot ash -c "/scripts/run_certbot.sh"
```

### ACME Validation challenge
To authenticate the certificates, the you need to pass the ACME validation challenge. This requires requests made on <strong>port 80</strong> to <strong>your.domain.com/.well-known/</strong> to be forwarded to this container. <br><br>
The recommended way to use this image is to set up your reverse proxy to automatically forward requests for the ACME validation challenges to this container.

#### HA Proxy Example
```
frontend http
    bind *:80
    acl letsencrypt_check path_beg /.well-known
    use_backend certbot if letsencrypt_check

backend certbot
    server certbot certbot:80 maxconn 32
```

#### Nginx Example
```
upstream certbot {
    server certbot:80;
}

server {
    listen    80;
    location  '/.well-known/acme-challenge' {
        default_type    "text/plain";
        proxy_pass      http://certbot;
    }
}
```

## Maintainers
* [**Hieu Pham**](https://github.com/hieupth) (author)

## License
[MIT License](https://github.com/hieupth/certbot/blob/main/LICENSE) <br>
Copyright &copy; 2020, [Hieu Pham](https://github.com/hieupth). All rights reserved.