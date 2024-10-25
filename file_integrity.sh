#!/bin/bash

# Installer AIDE (Advanced Intrusion Detection Environment)
apt-get install -y aide

# Initialiser la base de données d'AIDE
aideinit

# Mettre à jour la configuration d'AIDE pour inclure les fichiers critiques
cat <<EOL >> /etc/aide/aide.conf
/etc/ssh/sshd_config
/etc/fstab
/etc/hosts
/etc/hostname
EOL

# Lancer une vérification initiale des fichiers
aide --check

echo "AIDE configuré pour surveiller les fichiers système critiques."
