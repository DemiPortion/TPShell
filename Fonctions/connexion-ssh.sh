#!/bin/bash

# Chemin vers le fichier de clé publique
SSH_KEY_PATH="../Configuration/id_rsa.pub"

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

# Modifier la configuration SSH pour n'accepter que les connexions par clé
CONFIG_FILE="/etc/ssh/sshd_config"

# Vérifier si la ligne "PasswordAuthentication" existe et la modifier
if grep -q "^PasswordAuthentication yes" "$CONFIG_FILE"; then
    sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' "$CONFIG_FILE"
else
    echo "PasswordAuthentication no" >> "$CONFIG_FILE"
fi

# Vérifier si la ligne "ChallengeResponseAuthentication" existe et la modifier
if grep -q "^ChallengeResponseAuthentication yes" "$CONFIG_FILE"; then
    sed -i 's/^ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' "$CONFIG_FILE"
else
    echo "ChallengeResponseAuthentication no" >> "$CONFIG_FILE"
fi

# Redémarrer le service SSH pour appliquer les changements
systemctl restart sshd

echo "La configuration SSH a été mise à jour pour n'accepter que les connexions par clé."
