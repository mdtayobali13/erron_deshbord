# ---------- BUILD ----------
FROM ghcr.io/cirruslabs/flutter:3.22.0 AS build
# Dart >= 3.10 included

WORKDIR /app

# Only pubspec first (better cache)
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copy rest of the source
COPY . .

# Build Flutter web
RUN flutter build web --release

# ---------- RUN ----------
FROM nginx:alpine

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy build output
COPY --from=build /app/build/web /usr/share/nginx/html

# Optional: custom nginx config (SPA support)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
