# Utiliser une image de base appropriée
FROM ubuntu:20.04

# Installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    ca-certificates \
    && apt-get clean

# Télécharger et installer Flutter
RUN curl -LO https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.3-stable.tar.xz \
    && tar xf flutter_linux_3.24.3-stable.tar.xz \
    && mv flutter /usr/local/flutter \
    && rm flutter_linux_3.24.3-stable.tar.xz

# Ajouter Flutter au PATH
ENV PATH="$PATH:/usr/local/flutter/bin"

# Créer un utilisateur non-root et définir le répertoire de travail
RUN useradd -m flutteruser
USER flutteruser

# Activer le support Web dans Flutter
RUN flutter config --enable-web

# Configurer le répertoire de travail de l'application
WORKDIR /app

# Copier les fichiers du projet
COPY --chown=flutteruser:flutteruser . .

# Installer les dépendances Flutter
RUN flutter pub get

# Exposer un port si nécessaire (par exemple, pour une application web Flutter)
EXPOSE 8080

# Commande d'exécution par défaut (pour une application Web Flutter)
CMD ["flutter", "build", "web", "--release"]
