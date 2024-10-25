#!/bin/bash

# Installer AIDE (Advanced Intrusion Detection Environment)
apt-get update
apt-get install -y aide

# Initialiser la base de données d'AIDE (cela peut prendre un peu de temps)
echo "Initialisation de la base de données AIDE en cours..."
aideinit &  # Exécuter en arrière-plan
wait        # Attendre que l'initialisation soit terminée avant de continuer

# Mettre à jour la configuration d'AIDE pour inclure les fichiers critiques
echo "Mise à jour de la configuration AIDE pour les fichiers critiques..."
cat <<EOL >> /etc/aide/aide.conf
/etc/ssh/sshd_config
/etc/fstab
/etc/hosts
/etc/hostname
EOL

# Recréer la base de données après avoir ajouté les nouveaux fichiers à surveiller
echo "Recréation de la base de données AIDE..."
aide --init &  # Exécuter en arrière-plan
wait           # Attendre que la recréation soit terminée

# Déplacer la nouvelle base de données pour la rendre active
mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db

# Lancer une vérification initiale des fichiers
echo "Vérification initiale des fichiers surveillés par AIDE..."
aide --check &  # Exécuter en arrière-plan
wait            # Attendre que la vérification soit terminée

echo "AIDE configuré pour surveiller les fichiers système critiques."
