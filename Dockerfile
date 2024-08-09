# Use an official Alpine Linux as a base image
FROM alpine:latest

# Install necessary packages, for example, Nginx
RUN apk add --no-cache nginx

# Copy your configuration or application files
COPY ./my-nginx-config.conf /etc/nginx/nginx.conf

# Expose ports and set up commands
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
