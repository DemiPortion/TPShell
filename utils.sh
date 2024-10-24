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

check_permissions() {
  local file=$1
  local expected_permissions=$2
  current_permissions=$(stat -c "%a" "$file")
  
  if [ "$current_permissions" != "$expected_permissions" ]; then
    chmod "$expected_permissions" "$file"
    echo "Permissions de $file corrigées à $expected_permissions."
  else
    echo "Les permissions de $file sont correctes ($current_permissions)."
  fi
}

# Appel de test : vérifier les permissions du fichier /etc/hostname
# check_permissions "/etc/hostname" "644"
