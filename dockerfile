# ----------------------------
# Build stage
# ----------------------------
FROM flutter:3.22.0 AS build

# Set working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.yaml pubspec.lock ./

# Get dependencies
RUN flutter pub get

# Copy rest of the app
COPY . .

# Build web release
RUN flutter build web --release

# ----------------------------
# Serve stage
# ----------------------------
FROM nginx:alpine

# Copy built web app from build stage
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Run nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
