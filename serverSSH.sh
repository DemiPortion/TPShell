#!/bin/bash

# Vérifier si le script est exécuté en tant que root
if [ "$EUID" -ne 0 ]; then
    echo "Veuillez exécuter ce script en tant que root."
    exit 1
fi

# Vérifier si OpenSSH est installé
if ! command -v sshd &> /dev/null; then
    echo "OpenSSH n'est pas installé. Installation en cours..."
    apt update
    apt install -y openssh-server

    echo "OpenSSH a été installé avec succès."
else
    echo "OpenSSH est déjà installé."
fi

# Vérifier si le service SSH est actif
if systemctl is-active --quiet sshd; then
    echo "Le serveur SSH est déjà démarré."
else
    echo "Le serveur SSH n'est pas démarré. Démarrage en cours..."
    systemctl start sshd

    if systemctl is-active --quiet sshd; then
        echo "Le serveur SSH a été démarré avec succès."
    else
        echo "Erreur : Impossible de démarrer le serveur SSH."
        exit 1
    fi
fi

# Vérifier l'état du service SSH
if systemctl is-enabled --quiet sshd; then
    echo "Le serveur SSH est activé pour démarrer au démarrage du système."
else
    echo "Le serveur SSH n'est pas activé pour démarrer au démarrage. Activation en cours..."
    systemctl enable sshd
    echo "Le serveur SSH a été activé pour démarrer au démarrage."
fi

# Afficher l'état final du service SSH
systemctl status sshd
