#!/bin/bash

# Charger le fichier de configuration
source ./Configuration/config.sh

# Afficher les services à désactiver pour vérifier
echo "Services à désactiver : ${DISABLED_SERVICES[@]}"

for service in "${DISABLED_SERVICES[@]}"; do
  echo "Vérification du service $service..."

  if systemctl is-active --quiet "$service"; then
    echo "Désactivation du service $service..."
    systemctl stop "$service"
    systemctl disable "$service"
    echo "Service $service désactivé."
  else
    echo "Service $service déjà désactivé."
  fi
done

echo "Script terminé."