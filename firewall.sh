#!/bin/bash

# Installation et configuration du pare-feu UFW
configure_firewall() {
  apt-get update
  apt-get install -y ufw

  # Activer le pare-feu
  ufw default deny incoming
  ufw default allow outgoing

  # Autoriser les connexions SSH, HTTP, et HTTPS
  ufw allow ssh
  ufw allow http
  ufw allow https

  # Activer UFW
  ufw --force enable
  echo "Pare-feu UFW configuré et activé."
}