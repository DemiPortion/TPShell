#!/bin/bash

# Définir la clé SSH publique comme une variable
SSH_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCmW8sKyRIfeCT/igaSXl/sXzEE6ahQ83qY0qgucb3sO7EL8Z31xUoOJxtnZgVVnjVqnKExpE20JOYBid/+wUZAZHKMeKs2bFWqxO5oVKOzg0R9o+JTa4ykrvjKnIRwtQ7u3B4PpL+GUg0bepit5iMrKibe35sV+X3lIKJfqcFJwZUyVAEgS3fW05z9OOnJVomK6UcnygMPRomU08zFLK+OaqLEHbltJnnBMozQTNarhoTUTDdShqObyOFLA8QpbyKMsdApFa059Crp+JMIvYtxr/7RFIPbYzvXgSWWmEZ5BrR0uETk9td+RhTdbQzouvUmOJfM409fChI+VDhYuOwHz0ClnBzs82/Bzim6tvP9Ueb6MFPUwvTUaMApTKwBqtYiyJ1XmmU9Wg22YXN/Yh7oWqd4itrkvEQ6me4+fYe5pZ97291MP5ukxQxe5ZhAsmJXnSPpNaCiaKSGdjtZAp8nfE3RwZM0KPu+L47Y+6Nu1jHhQpSLqge23aPdMvmDaea9bFf9hX34BiuYSpoMxAj259ihf8wlvc8Cj/8s5HC359mkw7IR9knNJCa50thNoOpRk4CaTyX8gJCumGhUgoeT+n5oOI6gzw6y6BCtHRFUe0jsg/JWPUuSZziuX8A9WVOtw2iN/tM5hq2uNsJRY2r3VbT8wHMEvaevFUuvp3JKfw== marc.telena@gmail.com"

# Créer le dossier ~/.ssh s'il n'existe pas
mkdir -p ~/.ssh

# Ajouter la clé publique à authorized_keys
echo "$SSH_KEY" >> ~/.ssh/authorized_keys

# Ajuster les permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

echo "La clé a été ajoutée à ~/.ssh/authorized_keys avec succès."

# Modifier la configuration SSH pour n'accepter que les connexions par clé
CONFIG_FILE="/etc/ssh/sshd_config"

# Vérifier si la ligne "PasswordAuthentication" existe et la modifier
if grep -q "^PasswordAuthentication yes" "$CONFIG_FILE"; then
    sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' "$CONFIG_FILE"
else
    echo "PasswordAuthentication no" >> "$CONFIG_FILE"
fi

# Vérifier si la ligne "ChallengeResponseAuthentication" existe et la modifier
if grep -q "^ChallengeResponseAuthentication yes" "$CONFIG_FILE"; then
    sed -i 's/^ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' "$CONFIG_FILE"
else
    echo "ChallengeResponseAuthentication no" >> "$CONFIG_FILE"
fi

# Redémarrer le service SSH pour appliquer les changements
systemctl restart sshd

echo "La configuration SSH a été mise à jour pour n'accepter que les connexions par clé."
