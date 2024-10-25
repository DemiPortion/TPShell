#!/bin/bash

# Charger le fichier de configuration
source ./Configuration/config.sh

# Afficher les services à désactiver
echo "Services à désactiver : ${DISABLED_SERVICES[@]}"

# Désactiver chaque service listé dans DISABLED_SERVICES
for service in "${DISABLED_SERVICES[@]}"; do
  echo "Vérification du service $service..."

  # Désactiver le service pour qu'il ne démarre pas automatiquement
  systemctl disable "$service"
  
  # Masquer le service pour empêcher tout démarrage manuel
  systemctl mask "$service"

  echo "Service $service désactivé et masqué."
done

echo "Script terminé."
