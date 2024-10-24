#!/bin/bash

# Charger le fichier de configuration
source ./Configuration/config.sh

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
    log_message "Erreur : Fichier $file non trouvé."
    exit 1
  fi
done

# Étape 2 : Sauvegarde des fichiers critiques avant modification
echo "Sauvegarde des fichiers critiques..."
for file in "${CONFIG_FILES_TO_BACKUP[@]}"; do
  if backup_file "$file"; then
    log_message "Sauvegarde du fichier $file réalisée."
  else
    log_message "Erreur lors de la sauvegarde du fichier $file."
    exit 1
  fi
done

# Étape 3 : Installation et configuration des services (SSH)
echo "Installation et configuration de SSH..."
source ./serverSSH.sh
source ./connexion-ssh.sh "$SSH_KEY_PATH"
source ./durcissement-ssh.sh

# Étape 4 : Sécurisation du système (Pare-feu)
echo "Configuration et activation du pare-feu..."
source ./firewall.sh
if [ $? -eq 0 ]; then
  log_message "Pare-feu activé et configuré avec succès."
else
  log_message "Erreur lors de la configuration du pare-feu."
  exit 1
fi

# Étape 5 : Automatisation et surveillance
echo "Configuration des mises à jour automatiques et surveillance de l'espace disque..."
source ./updates.sh
source ./monitor_disk_space.sh
log_message "Mises à jour automatiques et surveillance de l'espace disque configurées."

# Étape 6 : Vérifications finales et utilitaires
echo "Vérifications des permissions critiques et des commandes nécessaires..."
check_permissions "/etc/ssh/sshd_config" "644"
check_command "ufw"

# Création d'un utilisateur et ajout au groupe sudo
create_user() {
  local username="$DEFAULT_USER"
  useradd -m "$username"
  passwd "$username"
  usermod -aG sudo "$username"
  echo "Utilisateur $username ajouté avec succès au groupe sudo."
}

create_user

echo "Script terminé avec succès."
log_message "Script terminé avec succès."
