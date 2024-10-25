#!/bin/bash

# Fonction de configuration des mises à jour automatiques
configure_updates() {
  echo "Mise à jour de la liste des paquets..."
  if apt-get update; then
    echo "Liste des paquets mise à jour avec succès."
  else
    echo "Erreur lors de la mise à jour des paquets. Abandon."
    exit 1
  fi

  echo "Installation du paquet unattended-upgrades..."
  if apt-get install -y unattended-upgrades; then
    echo "Paquet unattended-upgrades installé avec succès."
  else
    echo "Erreur lors de l'installation du paquet unattended-upgrades. Abandon."
    exit 1
  fi

  # Activer les mises à jour automatiques
  echo "Activation des mises à jour automatiques..."
  dpkg-reconfigure --priority=low unattended-upgrades

  # Vérifier si le service unattended-upgrades est activé
  if systemctl is-enabled unattended-upgrades &>/dev/null; then
    echo "Mises à jour automatiques activées."
  else
    echo "Erreur : les mises à jour automatiques ne sont pas activées."
    exit 1
  fi

  echo "Script terminé avec succès. Les mises à jour automatiques sont activées."
}

# Exécution de la fonction
configure_updates
