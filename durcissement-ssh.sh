#!/bin/bash

# Charger le fichier de configuration
source ./Configuration/config.sh

# Fichier de configuration SSH
CONFIG_FILE="/etc/ssh/sshd_config"

# Utilisateur autorisé et IP autorisée depuis le fichier de config
ALLOWED_USERS="$DEFAULT_USER"
ALLOWED_IPS="$ALLOWED_IPS"

# 1. Désactiver l'authentification par mot de passe pour forcer l'utilisation des clés SSH
echo "Désactivation de l'authentification par mot de passe..."
if grep -q "^PasswordAuthentication" "$CONFIG_FILE"; then
    sed -i 's/^PasswordAuthentication .*/PasswordAuthentication no/' "$CONFIG_FILE"
else
    echo "PasswordAuthentication no" >> "$CONFIG_FILE"
fi

# 2. Limiter l'accès SSH à l'utilisateur mentionné dans le fichier de configuration
echo "Limitation de l'accès SSH à l'utilisateur autorisé : $ALLOWED_USERS..."
if grep -q "^AllowUsers" "$CONFIG_FILE"; then
    sed -i "s/^AllowUsers .*/AllowUsers $ALLOWED_USERS/" "$CONFIG_FILE"
else
    echo "AllowUsers $ALLOWED_USERS" >> "$CONFIG_FILE"
fi

# 3. Désactiver l'accès root via SSH
echo "Désactivation de l'accès root via SSH..."
if grep -q "^PermitRootLogin" "$CONFIG_FILE"; then
    sed -i 's/^PermitRootLogin .*/PermitRootLogin no/' "$CONFIG_FILE"
else
    echo "PermitRootLogin no" >> "$CONFIG_FILE"
fi

# 4. Utilisation d’une liste blanche d'adresses IP pour SSH
#echo "Mise en place d'une liste blanche d'adresses IP autorisées pour SSH : $ALLOWED_IPS..."
#if ! grep -q "^Match Address" "$CONFIG_FILE"; then
#    for ip in $ALLOWED_IPS; do
#        echo -e "\nMatch Address $ip\n    AllowUsers $ALLOWED_USERS" >> "$CONFIG_FILE"
#    done
#fi

# Vérifications supplémentaires pour renforcer la configuration

# Désactiver X11 Forwarding pour empêcher le détournement d'affichage
echo "Désactivation de X11 Forwarding..."
if grep -q "^X11Forwarding" "$CONFIG_FILE"; then
    sed -i 's/^X11Forwarding .*/X11Forwarding no/' "$CONFIG_FILE"
else
    echo "X11Forwarding no" >> "$CONFIG_FILE"
fi

# Désactiver les redirections d'agents et de ports pour limiter les risques de transfert
echo "Désactivation des redirections d'agents et de ports..."
if grep -q "^AllowTcpForwarding" "$CONFIG_FILE"; then
    sed -i 's/^AllowTcpForwarding .*/AllowTcpForwarding no/' "$CONFIG_FILE"
else
    echo "AllowTcpForwarding no" >> "$CONFIG_FILE"
fi

if grep -q "^AllowAgentForwarding" "$CONFIG_FILE"; then
    sed -i 's/^AllowAgentForwarding .*/AllowAgentForwarding no/' "$CONFIG_FILE"
else
    echo "AllowAgentForwarding no" >> "$CONFIG_FILE"
fi

# Redémarrer le service SSH pour appliquer les changements
echo "Redémarrage du service SSH pour appliquer les changements..."
systemctl restart sshd

echo "La configuration de durcissement SSH a été appliquée avec succès pour l'utilisateur $ALLOWED_USERS et les IPs $ALLOWED_IPS."