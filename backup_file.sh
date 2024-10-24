#!/bin/bash

backup_file() {
  local file=$1
  if [ -f "$file" ]; then
    cp "$file" "$file.bak_$(date +%F_%T)"
    echo "Sauvegarde de $file réalisée : $file.bak_$(date +%F_%T)"
  else
    echo "Erreur : Fichier $file introuvable, impossible de le sauvegarder."
  fi
}

# Appel de test : sauvegarde du fichier /etc/hostname
# backup_file "/etc/hostname"