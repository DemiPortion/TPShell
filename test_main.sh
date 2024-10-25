#!/bin/bash

# Charger le fichier de configuration
source ./Configuration/config.sh

echo "===== DÉBUT DES TESTS DE VÉRIFICATION APRÈS L'EXÉCUTION DU MAIN.SH ====="

# Test 2 : Vérification de la création de l'utilisateur
echo "Test 2 : Vérification de la création de l'utilisateur..."
if id "$DEFAULT_USER" &>/dev/null; then
  echo "Test 2 : Utilisateur $DEFAULT_USER créé avec succès : Validé"
else
  echo "Test 2 : Échec de la création de l'utilisateur $DEFAULT_USER."
fi

# Test 3 : Vérification de la configuration SSH
echo "Test 3 : Vérification de la configuration SSH..."
if grep -q "PasswordAuthentication no" /etc/ssh/sshd_config && grep -q "PermitRootLogin no" /etc/ssh/sshd_config; then
  echo "Test 3 : Configuration SSH durcie : Validé"
else
  echo "Test 3 : Configuration SSH incorrecte ou non appliquée."
fi

# Test 4 : Vérification du pare-feu (UFW)
echo "Test 4 : Vérification du pare-feu (UFW)..."
if ufw status | grep -q "active"; then
  echo "Test 4 : UFW activé et configuré : Validé"
else
  echo "Test 4 : UFW n'est pas activé."
fi

# Test 5 : Vérification de l'activation de Google Authenticator (2FA)
echo "Test 5 : Vérification de l'activation de Google Authenticator (2FA)..."
if grep -q "auth required pam_google_authenticator.so" /etc/pam.d/sshd; then
  echo "Test 5 : Google Authenticator activé : Validé"
else
  echo "Test 5 : Google Authenticator non activé."
fi

# Test 6 : Vérification des services essentiels (SSH et UFW)
echo "Test 6 : Vérification des services SSH et UFW..."
services=("ssh" "ufw")
for service in "${services[@]}"; do
  if systemctl is-active --quiet "$service"; then
    echo "Test 6 : Service $service actif : Validé"
  else
    echo "Test 6 : Service $service non actif."
  fi
done

# Test 7 : Vérification des services désactivés
echo "Test 7 : Vérification de la désactivation des services inutiles..."
for service in "${DISABLED_SERVICES[@]}"; do
  if systemctl is-active --quiet "$service"; then
    echo "Test 7 : Service $service encore actif. Désactivation non réussie."
  else
    echo "Test 7 : Service $service désactivé : Validé"
  fi
done

# Test 8 : Vérification des mises à jour automatiques
echo "Test 8 : Vérification de la configuration des mises à jour automatiques..."
if systemctl is-enabled unattended-upgrades &>/dev/null; then
  echo "Test 8 : Mises à jour automatiques activées : Validé"
else
  echo "Test 8 : Mises à jour automatiques non configurées."
fi

echo "===== FIN DES TESTS ====="
