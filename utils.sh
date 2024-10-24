#!/bin/bash

# Vérification si un fichier existe
check_file() {
  if [ ! -f "$1" ]; then
    echo "Erreur : Fichier $1 non trouvé."
    exit 1
  else
    echo "Le fichier $1 existe."
  fi
}

# Vérification si une commande existe
check_command() {
  if ! command -v "$1" &> /dev/null; then
    echo "Erreur : Commande $1 non trouvée."
    exit 1
  else
    echo "La commande $1 est disponible."
  fi
}

# Appels de test pour vérifier les fonctions

# Tester la fonction check_file
check_file "/etc/passwd"  # Ce fichier existe sur presque toutes les distributions Linux
check_file "/nonexistent/file"  # Test avec un fichier qui n'existe pas

# Tester la fonction check_command
check_command "bash"  # Bash devrait être présent
check_command "fakecommand"  # Test avec une commande qui n'existe pas
