#!/bin/bash

# Chemin du fichier de clé SSH publique
SSH_KEY_PATH="/root/script/TPShell/Configuration/id_rsa.pub"

# Fichiers et dossiers à vérifier avant toute modification (sans SSH et UFW)
CONFIG_FILES_TO_CHECK=(
    "/etc/hostname"           # Nom d'hôte du système
    "/etc/hosts"              # Résolution des noms d'hôte
    "/etc/fstab"              # Montage des partitions au démarrage
    "/etc/network/interfaces" # Configuration réseau (selon la distribution)
)

# Fichiers à sauvegarder avant modification (sans SSH et UFW)
CONFIG_FILES_TO_BACKUP=(
    "/etc/hostname"
    "/etc/hosts"
    "/etc/fstab"
    "/etc/network/interfaces"
)
# Nom de l'utilisateur à ajouter au groupe sudo
DEFAULT_USER="Admin"

# Mot de passe par défaut pour l'utilisateur
DEFAULT_PASSWORD="Admin"

# Liste des services à désactiver
DISABLED_SERVICES=("avahi-daemon" "cups" "bluetooth")

# Adresse IP autorisées pour SSH
ALLOWED_IPS="10.213.208.68" # TONY 192.168.56.1 MARC 10.213.67.171