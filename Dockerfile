# Stage 1: Build the Flutter web application
FROM ghcr.io/cirruslabs/flutter:stable AS build

# Set the working directory
WORKDIR /app

# Enable Flutter web support
RUN flutter config --enable-web

# Copy the pubspec and lock files first to cache dependencies
COPY pubspec.yaml pubspec.lock ./

# Get dependencies
RUN flutter pub get

# Copy the rest of the application code
COPY . .

# Build the application for the web with base-href
RUN flutter build web --release --base-href=/deshbord/

# Stage 2: Serve the application with Nginx
FROM nginx:alpine

# Remove default nginx config
RUN rm -rf /etc/nginx/conf.d/default.conf

# Copy the build artifacts to the deshbord subdirectory
COPY --from=build /app/build/web /usr/share/nginx/html/deshbord

# Copy the custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Ensure permissions are correct
RUN chmod -R 755 /usr/share/nginx/html

# Expose port 8080 (must match Coolify port and nginx listen port)
EXPOSE 8080

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
