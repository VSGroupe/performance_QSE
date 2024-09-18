# Utiliser une image officielle de Flutter
FROM cirrusci/flutter:stable AS build

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers du projet dans le conteneur
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
