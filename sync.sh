#!/bin/bash

# Variables
REPO_URL="${REPO_URL}"  # URL del repositorio de Git (HTTPS)
BRANCH="${BRANCH}"  # Rama del repositorio
DIRECTORY="${DIRECTORY}"  # Directorio montado donde están los archivos de guardado
COMMIT_MESSAGE="${COMMIT_MESSAGE:-"Auto-commit: Updated save files"}"  # Mensaje de commit

# Verificar si el directorio está vacío
if [ ! "$(ls -A $DIRECTORY)" ]; then
  echo "El directorio está vacío. Clonando el repositorio..."
  git clone $REPO_URL $DIRECTORY
fi

cd $DIRECTORY

# Configurar Git
git config --global --add safe.directory /config/saved/server
git init
git remote add origin $REPO_URL || true  # Añadir remote si no existe
git fetch origin $BRANCH
git checkout $BRANCH || git checkout -b $BRANCH
git config user.name "GitHub Sync Bot"
git config user.email "bot@example.com"

# Configurar credenciales (opcional, si no quieres introducirlas cada vez)
git config credential.helper store

# Monitorear cambios y sincronizar con el repositorio
while true; do
  echo "Checking for changes in save files..."

  # Buscar cambios en archivos de guardado
  if git status --porcelain | grep -q .; then
    echo "Changes detected! Preparing to commit and push..."

    # Agregar archivos cambiados al commit
    git add .

    # Commit con mensaje predefinido
    git commit -m "$COMMIT_MESSAGE"

    # Hacer push a la rama
    if git push origin $BRANCH; then
      echo "Push successful!"
    else
      echo "Push failed. Please check the repository status."
    fi
  else
    echo "No changes detected."
  fi

  # Esperar 5 minutos antes de verificar nuevamente (configurable)
  sleep 300
done


