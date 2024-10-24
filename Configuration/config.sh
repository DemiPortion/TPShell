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
