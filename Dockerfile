# Build (Preparación)
FROM nginx:alpine AS builder
RUN rm -rf /usr/share/nginx/html/*

# Producción Segura (No-Root)
FROM nginx:alpine

# Copiado desde la etapa anterior
COPY --from=builder /usr/share/nginx/html/ /usr/share/nginx/html/
COPY index.html app.js /usr/share/nginx/html/
COPY default.conf /etc/nginx/conf.d/default.conf

# Configuración obligatoria para que Nginx pueda correr sin ser ROOT
RUN touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid /usr/share/nginx/html /var/cache/nginx /var/log/nginx /etc/nginx

# Usuario común y corriente sin privilegios para correr Nginx de forma segura
USER nginx

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]