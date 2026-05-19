# Build (Preparación)
FROM nginx:alpine AS builder
RUN rm -rf /usr/share/nginx/html/*

# Producción Segura (No-Root)
FROM nginx:alpine

# Copiado desde la etapa anterior
COPY index.html app.js /usr/share/nginx/html/
COPY default.conf /etc/nginx/conf.d/default.conf

# Configuración obligatoria para que Nginx pueda correr sin ser ROOT
RUN sed -i 's|/var/run/nginx.pid|/tmp/nginx.pid|g' /etc/nginx/nginx.conf && \
    sed -i '/http {/a \    client_body_temp_path /tmp/client_body;\n    proxy_temp_path /tmp/proxy_temp;\n    fastcgi_temp_path /tmp/fastcgi_temp;\n    uwsgi_temp_path /tmp/uwsgi_temp;\n    scgi_temp_path /tmp/scgi_temp;' /etc/nginx/nginx.conf && \
    chown -R nginx:nginx /usr/share/nginx/html /var/cache/nginx /var/log/nginx /etc/nginx

# Usuario común y corriente sin privilegios para correr Nginx de forma segura
USER nginx

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]