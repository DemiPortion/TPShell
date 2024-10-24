#!/bin/bash

# Chemin vers le fichier de clé publique
SSH_KEY_PATH="./Configuration/id_rsa.pub"

# Vérifier si le fichier de clé publique existe
if [ ! -f "$SSH_KEY_PATH" ]; then
    echo "Erreur : Le fichier de clé publique $SSH_KEY_PATH n'existe pas."
    exit 1
fi

# Créer le dossier ~/.ssh s'il n'existe pas
mkdir -p ~/.ssh

# Ajouter la clé publique à authorized_keys
cat "$SSH_KEY_PATH" >> ~/.ssh/authorized_keys

# Ajuster les permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

echo "La clé a été ajoutée à ~/.ssh/authorized_keys avec succès."
