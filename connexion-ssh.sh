#!/bin/bash

# Récupérer le chemin de la clé SSH depuis l'argument passé
SSH_KEY_PATH="$1"

# Vérifier si la clé existe
if [ ! -f "$SSH_KEY_PATH" ]; then
  echo "Erreur : Clé SSH non trouvée à l'emplacement $SSH_KEY_PATH."
  exit 1
fi

# Créer le répertoire .ssh s'il n'existe pas
if [ ! -d "$HOME/.ssh" ]; then
  mkdir "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
fi

# Ajouter la clé publique dans le fichier authorized_keys
cat "$SSH_KEY_PATH" >> "$HOME/.ssh/authorized_keys"
chmod 600 "$HOME/.ssh/authorized_keys"
echo "Clé SSH ajoutée avec succès."
