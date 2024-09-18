# Utiliser une image Ubuntu de base pour la phase de construction
FROM ubuntu:20.04 AS build

# Configurer le fuseau horaire par défaut et éviter les invites interactives
ENV DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && apt-get update && apt-get install -y \
    tzdata

# Installer les dépendances nécessaires en une seule couche
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    libglu1-mesa \
    openjdk-11-jdk \
    && rm -rf /var/lib/apt/lists/*

# Télécharger et installer Flutter
RUN curl -LO https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.3-stable.tar.xz \
    && tar xf flutter_linux_3.24.3-stable.tar.xz \
    && mv flutter /usr/local/flutter \
    && rm flutter_linux_3.24.3-stable.tar.xz






# Ajouter Flutter au PATH
ENV PATH="/usr/local/flutter/bin:${PATH}"

# Vérifier l'installation de Flutter
RUN flutter --version

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
