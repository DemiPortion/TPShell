#!/bin/bash

# Demander à l'utilisateur de fournir son nom de session Windows
read -p "Entrez le nom de votre session Windows : " nomsession

# Chemin de la clé publique SSH sur la machine Windows
chemin_cle="C:/Users/$nomsession/.ssh/id_rsa.pub"

# Demander l'adresse IP de la machine Windows
read -p "Entrez l'adresse IP de la machine Windows : " ip_windows

# Vérifier si l'adresse IP a été fournie
if [ -z "$ip_windows" ]; then
    echo "Vous devez fournir une adresse IP valide."
    exit 1
fi

echo "Adresse IP de la machine Windows : $ip_windows"

# Afficher la commande utilisée pour récupérer la clé
echo "Commande utilisée pour récupérer la clé : scp $nomsession@$ip_windows:$chemin_cle /tmp/"

# Vérifier si le fichier id_rsa.pub existe sur la machine Windows
if ssh "$nomsession@$ip_windows" "[ -f '$chemin_cle' ]"; then
    echo "Clé SSH trouvée sur la machine Windows, préparation pour la copie..."

    # Copier la clé publique via SCP vers /tmp sur la VM distante
    scp "$nomsession@$ip_windows:$chemin_cle" /tmp/
    
    if [ $? -eq 0 ]; then
        echo "Clé copiée avec succès dans /tmp sur la VM."
    else
        echo "Erreur lors de la copie de la clé depuis la machine Windows."
    fi
else
    echo "Clé SSH non trouvée sur la machine Windows. Vérifiez que le fichier existe à l'emplacement : $chemin_cle"
fi
