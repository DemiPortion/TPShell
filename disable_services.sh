#!/bin/bash

# Charger le fichier de configuration
source ./Configuration/config.sh

for service in "${services[@]}"; do
  if systemctl is-active --quiet "$service"; then
    echo "Désactivation du service $service..."
    systemctl stop "$service"
    systemctl disable "$service"
    echo "Service $service désactivé."
  else
    echo "Service $service déjà désactivé."
  fi
done
