#!/bin/bash

# Demander à l'utilisateur de fournir son nom de session Windows
read -p "Entrez le nom de votre session Windows : " nomsession

# Chemin de la clé publique SSH sur la machine Windows (via SCP)
chemin_cle="C:/Users/$nomsession/.ssh/id_rsa.pub"

# Demander les informations du serveur distant pour utiliser scp
read -p "Entrez l'adresse du serveur distant (ex: user@hostname): " serveur_distant

# Vérifier si le fichier id_rsa.pub existe à l'emplacement donné
if [ -f "$chemin_cle" ]; then
    echo "Clé SSH trouvée, préparation pour la copie..."
    
    # Copier la clé publique via SCP vers /tmp sur le serveur distant
    scp "$chemin_cle" "$serveur_distant:/tmp/"
    
    if [ $? -eq 0 ]; then
        echo "Clé copiée avec succès dans /tmp sur le serveur distant."
    else
        echo "Erreur lors de la copie de la clé sur le serveur distant."
    fi
else
    echo "Clé SSH non trouvée. Vérifiez que le fichier existe à l'emplacement : $chemin_cle"
fi
