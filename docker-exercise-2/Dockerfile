FROM nginx:alpine

# Add metadata
LABEL maintainer="your-email@example.com"
LABEL version="1.0"
LABEL description="Custom web server for Docker learning"

# Copy HTML file
COPY index.html /usr/share/nginx/html/

# Expose port
EXPOSE 80

# Add health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1