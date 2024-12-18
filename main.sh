#!/bin/bash

# Charger le fichier de configuration
source ./Configuration/config.sh

# Inclure utils.sh pour accéder aux fonctions check_permissions et check_command
source ./utils.sh

# Vérification si le script est exécuté en tant que root
if [ "$EUID" -ne 0 ]; then
  echo "Le script doit être exécuté en tant que root. Relance du script avec sudo..."
  exec sudo "$0" "$@"
  exit 1
else
  echo "Script exécuté en tant que root."
fi

# Définition du fichier log
LOGFILE="/var/log/system_setup.log"

# Fonction pour enregistrer dans le fichier log
log_message() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') : $1" >> "$LOGFILE"
}

log_message "Script exécuté en tant que root."

# Étape 1 : Vérification des fichiers de configuration avant toute installation
echo "Vérification des fichiers de configuration critiques..."
for file in "${CONFIG_FILES_TO_CHECK[@]}"; do
  if check_file "$file"; then
    log_message "Fichier $file vérifié avec succès."
  else
    log_message "Erreur : Fichier $file non trouvé, mais le script continue."
    echo "Attention : Le fichier $file est introuvable, mais le script continue."
  fi
done

# Étape 2 : Sauvegarde des fichiers critiques avant modification
echo "Sauvegarde des fichiers critiques..."
for file in "${CONFIG_FILES_TO_BACKUP[@]}"; do
  if backup_file "$file"; then
    log_message "Sauvegarde du fichier $file réalisée."
  else
    log_message "Erreur lors de la sauvegarde du fichier $file, mais le script continue."
    echo "Attention : Impossible de sauvegarder $file, mais le script continue."
  fi
done

# Étape 3 : Création d'un utilisateur et ajout au groupe sudo
echo "Création d'un utilisateur..."
if source ./create_user.sh; then
  log_message "Utilisateur créé avec succès."
else
  log_message "Erreur lors de la création de l'utilisateur."
  echo "Erreur : Échec de la création de l'utilisateur."
  exit 1
fi

# Étape 4 : Installation et configuration des services (SSH)
echo "Installation et configuration de SSH..."
source ./serverSSH.sh
source ./connexion-ssh.sh "$SSH_KEY_PATH"
source ./durcissement-ssh.sh

# Étape 5 : Activation de l'authentification à deux facteurs (Google Authenticator)
echo "Activation de la double authentification pour SSH (Google Authenticator)..."
source ./setup_2fa.sh
if [ $? -eq 0 ]; then
  log_message "Double authentification activée avec succès."
else
  log_message "Erreur lors de l'activation de la double authentification, mais le script continue."
  echo "Attention : Échec de la configuration de Google Authenticator, mais le script continue."
fi

# Étape 6 : Sécurisation du système (Pare-feu)
echo "Configuration et activation du pare-feu..."
source ./firewall.sh
if [ $? -eq 0 ]; then
  log_message "Pare-feu activé et configuré avec succès."
else
  log_message "Erreur lors de la configuration du pare-feu, mais le script continue."
  echo "Attention : Problème lors de l'activation du pare-feu, mais le script continue."
fi

# Étape 7 : Automatisation et surveillance
echo "Configuration des mises à jour automatiques et surveillance de l'espace disque..."
source ./updates.sh
source ./monitor_disk_space.sh
log_message "Mises à jour automatiques et surveillance de l'espace disque configurées."

# Étape 8 : Vérifications finales et utilitaires

# Vérification des commandes nécessaires
echo "Vérification des commandes nécessaires..."
commands=("ufw" "ssh" "chpasswd")

for cmd in "${commands[@]}"; do
  check_command "$cmd"
done

# Vérification des permissions critiques
echo "Vérification des permissions critiques..."

files=(
    "/etc/ssh/sshd_config"
    "/etc/hostname"
    "/etc/hosts"
    "/etc/fstab"
    "/etc/network/interfaces"
)

for file in "${files[@]}"; do
  check_permissions "$file" "644"
done

# Vérification des services essentiels 
echo "Vérification des services SSH et UFW..."
services=("ssh" "ufw")

for service in "${services[@]}"; do
  if systemctl is-active --quiet "$service"; then
    echo "Service $service est actif."
  else
    echo "Alerte : Le service $service n'est pas actif. Tentative de démarrage..."
    
    # Tentative d'activation du service s'il n'est pas actif
    systemctl start "$service"

    # Vérifier à nouveau si le service est actif après la tentative d'activation
    if systemctl is-active --quiet "$service"; then
      echo "Service $service a été activé avec succès."
    else
      echo "Erreur : Impossible d'activer le service $service."
      log_message "Erreur : Impossible d'activer le service $service."
      # Ne pas interrompre le script, continuer
    fi
  fi
done

# Etape 9 : Désactivation des services inutiles
echo "Désactivation des services inutiles..."
source ./disable_services.sh
log_message "Services inutiles désactivés avec succès."

# Étape 10 : Surveillance de l'intégrité des fichiers avec Tripwire
# echo "Mise en place de la surveillance de l'intégrité des fichiers..."
# source ./file_integrity_monitor_tripwire.sh
# log_message "Surveillance de l'intégrité des fichiers configurée avec succès."

echo "Script terminé avec succès."
log_message "Script terminé avec succès."
