FROM nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY 400.html /usr/share/nginx/html/400.html
ENV NGINX_PORT=8080
