#!/bin/bash

# Fonction de configuration des mises à jour automatiques
configure_updates() {
  echo "Mise à jour de la liste des paquets..."
  if sudo apt-get update; then
    echo "Liste des paquets mise à jour avec succès."
  else
    echo "Erreur lors de la mise à jour des paquets. Abandon."
    exit 1
  fi

  echo "Installation du paquet unattended-upgrades..."
  if sudo apt-get install -y unattended-upgrades; then
    echo "Paquet unattended-upgrades installé avec succès."
  else
    echo "Erreur lors de l'installation du paquet unattended-upgrades. Abandon."
    exit 1
  fi

  # Activer les mises à jour automatiques
  echo "Configuration des mises à jour automatiques..."
  if sudo dpkg-reconfigure -plow unattended-upgrades; then
    echo "Mises à jour automatiques configurées avec succès."
  else
    echo "Erreur lors de la configuration des mises à jour automatiques."
    exit 1
  fi

  echo "Script terminé avec succès. Les mises à jour automatiques sont activées."
}
