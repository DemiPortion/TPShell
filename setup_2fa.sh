#!/bin/bash

# Charger le fichier de configuration
source ./Configuration/config.sh

# Installation de Google Authenticator PAM
apt-get update
apt-get install -y libpam-google-authenticator

# Vérifier si Google Authenticator est installé avec succès
if ! command -v google-authenticator &> /dev/null; then
  echo "Erreur : Google Authenticator n'a pas été installé correctement."
  exit 1
fi

# Vérifier si l'utilisateur Admin existe
if ! id "$DEFAULT_USER" &>/dev/null; then
  echo "Erreur : L'utilisateur $DEFAULT_USER n'existe pas."
  exit 1
fi

# Configuration pour chaque utilisateur
echo "Configuration de Google Authenticator pour l'utilisateur $DEFAULT_USER"
sudo -u "$DEFAULT_USER" google-authenticator -t -d -f -r 3 -R 30 -W

# Vérification de l'exécution correcte
if [ $? -ne 0 ]; then
  echo "Erreur lors de la configuration de Google Authenticator."
  exit 1
fi

# Configuration de SSH pour 2FA
echo "Modification de la configuration SSH pour activer 2FA"
sed -i 's/^#\?ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#\?UsePAM yes/UsePAM yes/' /etc/ssh/sshd_config

# Configuration de PAM pour 2FA
echo "Ajout de l'authentification à deux facteurs dans /etc/pam.d/sshd"
if ! grep -q "auth required pam_google_authenticator.so" /etc/pam.d/sshd; then
  echo "auth required pam_google_authenticator.so" >> /etc/pam.d/sshd
fi

# Redémarrer SSH
echo "Redémarrage de SSH pour appliquer les changements..."
systemctl restart ssh

echo "Authentification à deux facteurs configurée avec succès."
