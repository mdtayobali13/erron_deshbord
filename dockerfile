# ----------------------------
# Build stage
# ----------------------------
FROM ghcr.io/cirruslabs/flutter:latest AS build

# Suppress the "running as root" warning
ENV PUB_CACHE=/app/.pub-cache

WORKDIR /app

# Copy pubspec files first (better caching)
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copy rest of the app
COPY . .

# Build Flutter web
RUN flutter build web --release

# ----------------------------
# Serve stage
# ----------------------------
FROM nginx:alpine

# Copy built web app
COPY --from=build /app/build/web /usr/share/nginx/html

# Copy custom nginx config for SPA routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
