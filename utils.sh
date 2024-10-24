#!/bin/bash

# Vérification si un fichier existe
check_file() {
  if [ ! -f "$1" ]; then
    echo "Erreur : Fichier $1 non trouvé."
    exit 1
  else
    echo "Le fichier $1 existe."
  fi
}

# Vérification si une commande existe
check_command() {
  if ! command -v "$1" &> /dev/null; then
    echo "Erreur : Commande $1 non trouvée."
    exit 1
  else
    echo "La commande $1 est disponible."
  fi
}
