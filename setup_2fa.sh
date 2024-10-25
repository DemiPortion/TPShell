#!/bin/bash

#Installation de Google Authenticator PAM
apt-get install -y libpam-google-authenticator

#Configuration pour chaque utilisateur
echo "Configuration de Google Authenticator pour l'utilisateur Admin"
sudo -u Admin google-authenticator -t -d -f -r 3 -R 30 -W

#Configuration de SSH pour 2FA
echo "Modification de la configuration SSH pour activer 2FA"
sed -i 's/^#(ChallengeResponseAuthentication) no/\1 yes/' /etc/ssh/sshd_config
sed -i 's/^#(UsePAM) yes/\1 yes/' /etc/ssh/sshd_config

#Configuration de PAM pour 2FA
echo "Ajout de l'authentification à deux facteurs dans /etc/pam.d/sshd"
echo "auth required pam_google_authenticator.so" >> /etc/pam.d/sshd

#Redémarrer SSH
systemctl restart ssh

echo "Authentification à deux facteurs configurée avec succès."