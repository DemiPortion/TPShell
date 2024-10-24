#!/bin/bash

# Charger le fichier de configuration
source ./Configuration/config.sh

# Fonction pour créer un utilisateur et l'ajouter au groupe sudo
create_user() {
  local username="$DEFAULT_USER"
  local password="$DEFAULT_PASSWORD"
  
  # Créer l'utilisateur
  if useradd -m "$username"; then
    log_message "Utilisateur $username créé avec succès."
  else
    log_message "Erreur : Impossible de créer l'utilisateur $username."
    echo "Erreur : Impossible de créer l'utilisateur $username."
    return 1
  fi
  
  # Assigner le mot de passe par défaut à l'utilisateur
  if echo "$username:$password" | chpasswd; then
    log_message "Mot de passe pour $username assigné avec succès."
  else
    log_message "Erreur : Impossible d'assigner un mot de passe à l'utilisateur $username."
    echo "Erreur : Impossible d'assigner un mot de passe à l'utilisateur $username."
    return 1
  fi
  
  # Ajouter l'utilisateur au groupe sudo
  if usermod -aG sudo "$username"; then
    log_message "Utilisateur $username ajouté avec succès au groupe sudo."
  else
    log_message "Erreur : Impossible d'ajouter l'utilisateur $username au groupe sudo."
    echo "Erreur : Impossible d'ajouter l'utilisateur $username au groupe sudo."
    return 1
  fi
  
  echo "Utilisateur $username ajouté avec succès au groupe sudo."
  echo "Mot de passe pour $username : $password"
}

# Exécuter la fonction create_user
create_user
