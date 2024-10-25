#!/bin/bash

# Charger le fichier de configuration
source ./Configuration/config.sh

# Vérifier si l'utilisateur par défaut existe
if ! id "$DEFAULT_USER" &>/dev/null; then
  echo "Erreur : L'utilisateur $DEFAULT_USER n'existe pas."
  exit 1
fi

# Définir le chemin du répertoire .ssh de l'utilisateur
SSH_DIR="/home/$DEFAULT_USER/.ssh"

# Vérifier si la clé SSH existe
if [ ! -f "$SSH_KEY_PATH" ]; then
  echo "Erreur : Clé SSH non trouvée à l'emplacement $SSH_KEY_PATH."
  exit 1
fi

# Créer le répertoire .ssh de l'utilisateur s'il n'existe pas
if [ ! -d "$SSH_DIR" ]; then
  mkdir -p "$SSH_DIR"
  chmod 700 "$SSH_DIR"
  chown "$DEFAULT_USER:$DEFAULT_USER" "$SSH_DIR"
fi

# Ajouter la clé publique dans authorized_keys
cat "$SSH_KEY_PATH" >> "$SSH_DIR/authorized_keys"
chmod 600 "$SSH_DIR/authorized_keys"
chown "$DEFAULT_USER:$DEFAULT_USER" "$SSH_DIR/authorized_keys"

echo "Clé SSH ajoutée avec succès à l'utilisateur $DEFAULT_USER."
