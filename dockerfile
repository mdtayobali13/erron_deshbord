# ---------- BUILD STAGE ----------
FROM cirrusci/flutter:stable AS build

WORKDIR /app

# Enable web support
RUN flutter config --enable-web

# Copy pubspec first (better cache)
COPY pubspec.yaml pubspec.lock* ./
RUN flutter pub get

# Copy rest of the project
COPY . .

# Build web
RUN flutter build web --release


# ---------- RUN STAGE ----------
FROM nginx:alpine

# Remove default nginx files
RUN rm -rf /usr/share/nginx/html/*

# Copy flutter web build
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
