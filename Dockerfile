# Build (Preparación)
FROM nginx:alpine AS builder
RUN rm -rf /usr/share/nginx/html/*

# Producción Segura (No-Root)
FROM nginx:alpine

# Copiado desde la etapa anterior
COPY index.html app.js /usr/share/nginx/html/
COPY default.conf /etc/nginx/conf.d/default.conf

# Configuración obligatoria para que Nginx pueda correr sin ser ROOT
RUN chown -R nginx:nginx /usr/share/nginx/html /var/cache/nginx /var/log/nginx /etc/nginx && \
    chmod -R g+w /var/cache/nginx /var/log/nginx /etc/nginx

# Usuario común y corriente sin privilegios para correr Nginx de forma segura
RUN sed -i 's|/var/run/nginx.pid|/tmp/nginx.pid|g' /etc/nginx/nginx.conf

USER nginx

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]