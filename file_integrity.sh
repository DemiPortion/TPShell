#!/bin/bash

# Installer Tripwire
apt-get update
apt-get install -y tripwire

# Configurer les clés locales et le site de Tripwire
echo "Initialisation de Tripwire..."
twadmin --generate-keys -m local /etc/tripwire/tw.cfg
twadmin --generate-keys -m site /etc/tripwire/site.key

# Initialiser la base de données de Tripwire
echo "Initialisation de la base de données Tripwire en cours..."
tripwire --init &  # Exécuter en arrière-plan

# Ajouter les fichiers critiques à surveiller
echo "Mise à jour de la configuration de Tripwire..."
cat <<EOL >> /etc/tripwire/twpol.txt
/etc/ssh/sshd_config -> $(ReadOnly),
/etc/fstab -> $(ReadOnly),
/etc/hosts -> $(ReadOnly),
/etc/hostname -> $(ReadOnly),
EOL

# Recréer la politique de Tripwire après mise à jour
echo "Recréation de la politique Tripwire..."
twadmin --create-polfile /etc/tripwire/twpol.txt
tripwire --init

# Vérification des fichiers avec Tripwire
echo "Vérification initiale des fichiers surveillés par Tripwire..."
tripwire --check &  # Exécuter en arrière-plan

echo "Tripwire est configuré pour surveiller les fichiers système critiques."