#!/bin/bash

# Fonction pour vérifier l'utilisation du disque
check_disk_space() {
  threshold=80  # Seuil d'alerte (80%)
  
  # Obtenir l'utilisation du disque en pourcentage pour le système racine
  usage=$(df / | grep / | awk '{ print $5 }' | sed 's/%//')

  # Comparer l'utilisation actuelle avec le seuil
  if [ "$usage" -ge "$threshold" ]; then
    echo "Alerte : L'utilisation du disque est à $usage%."
    # Envoyer une notification ou log
    echo "Alerte : Espace disque utilisé à $usage%." | mail -s "Alerte Espace Disque" user@example.com
  else
    echo "Espace disque suffisant : $usage% utilisé."
  fi
}

# Boucle infinie qui vérifie l'utilisation du disque toutes les 24 heures
while true; do
  check_disk_space
  sleep 86400  # Pause de 24 heures (86400 secondes)
done &
