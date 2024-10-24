#!/bin/bash

check_permissions() {
  local file=$1
  local expected_permissions=$2
  current_permissions=$(stat -c "%a" "$file")
  
  if [ "$current_permissions" != "$expected_permissions" ]; then
    chmod "$expected_permissions" "$file"
    echo "Permissions de $file corrigées à $expected_permissions."
  else
    echo "Les permissions de $file sont correctes ($current_permissions)."
  fi
}

# Appel de test : vérifier les permissions du fichier /etc/hostname
# check_permissions "/etc/hostname" "644"
