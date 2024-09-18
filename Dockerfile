# Utiliser une image officielle de Flutter avec la version 3.24.0
FROM cirrusci/flutter:3.24.0 AS build

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de configuration du projet
COPY pubspec.* ./
RUN flutter pub get

# Copier le reste des fichiers du projet
COPY . .

# Activer la plateforme Web et construire l'application
RUN flutter config --enable-web && flutter build web

# Utiliser une image minimale pour servir l'application web
FROM nginx:alpine

# Copier les fichiers de build Flutter dans le répertoire Nginx
COPY --from=build /app/build/web /usr/share/nginx/html

# Exposer le port 80
EXPOSE 80

# Commande de démarrage Nginx
CMD ["nginx", "-g", "daemon off;"]
