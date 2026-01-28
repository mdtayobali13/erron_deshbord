# ----------------------------
# Build stage
# ----------------------------
FROM ghcr.io/cirruslabs/flutter:3.29.0 AS build

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

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
