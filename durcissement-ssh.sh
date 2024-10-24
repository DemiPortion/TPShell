#!/bin/bash

# Modifier la configuration SSH pour n'accepter que les connexions par clé
CONFIG_FILE="/etc/ssh/sshd_config"

# 1. Désactiver l'authentification par mot de passe
if grep -q "^PasswordAuthentication yes" "$CONFIG_FILE"; then
    sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' "$CONFIG_FILE"
else
    echo "PasswordAuthentication no" >> "$CONFIG_FILE"
fi

# 2. Limiter l'accès SSH à certains utilisateurs ou groupes
# Remplacez 'allowed_user' par le nom de l'utilisateur autorisé
ALLOWED_USERS="allowed_user"
if ! grep -q "^AllowUsers" "$CONFIG_FILE"; then
    echo "AllowUsers $ALLOWED_USERS" >> "$CONFIG_FILE"
else
    sed -i "s/^AllowUsers .*/AllowUsers $ALLOWED_USERS/" "$CONFIG_FILE"
fi

# 3. Désactiver l'accès root via SSH
if grep -q "^PermitRootLogin yes" "$CONFIG_FILE"; then
    sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' "$CONFIG_FILE"
else
    echo "PermitRootLogin no" >> "$CONFIG_FILE"
fi

# 4. Utilisation d’une liste blanche d’adresses IP pour SSH
# Remplacez '192.168.1.*' par votre plage d'adresses IP autorisées
ALLOWED_IPS="192.168.1.*"
if ! grep -q "^Match Address $ALLOWED_IPS" "$CONFIG_FILE"; then
    echo -e "\nMatch Address $ALLOWED_IPS\n    AllowUsers $ALLOWED_USERS" >> "$CONFIG_FILE"
fi

# Redémarrer le service SSH pour appliquer les changements
systemctl restart sshd

echo "La configuration SSH a été mise à jour."
