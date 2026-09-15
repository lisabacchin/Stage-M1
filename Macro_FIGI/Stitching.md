# Protocole de stitching des images avec Fiji

Cette procédure décrit la méthode utilisée pour réaliser un **stitching d’images avec Fiji** afin de reconstruire une image de grande dimension à partir de plusieurs acquisitions réalisées sur des zones adjacentes.

Cette étape est réalisée après l’acquisition des images en **multi-position**. L'acquisition produit un ensemble d'images correspondant à différentes positions le long de la zone étudiée. Le stitching permet ensuite de les assembler automatiquement afin de reconstruire une image complète du domaine.

## 1. Ouverture du module de stitching

Ouvrir **Fiji** puis accéder au module :

**Plugins → Stitching → Grid/Collection stitching**

Une fenêtre de paramètres s'ouvre alors.

## 2. Paramétrage du stitching

Dans la fenêtre **Grid/Collection stitching**, renseigner les paramètres suivants :

* **Type** : `Positions from file`
* **Order** : `Defined by image metadata`

Ces paramètres permettent à Fiji d'utiliser les informations de position enregistrées lors de l'acquisition pour déterminer automatiquement la disposition des différentes images.

## 3. Sélection des images

Dans le champ **Browse**, sélectionner la **première image du dossier contenant les acquisitions**.

Fiji utilise alors les métadonnées associées aux images pour retrouver les autres images appartenant à la série et déterminer leur position relative.

## 4. Précision du calcul

Cocher l'option :

**Subpixel accuracy**

Cette option permet d'améliorer la précision de l'alignement entre les différentes images en autorisant un déplacement inférieur à un pixel lors du calcul du stitching.

## 5. Enregistrement du résultat

Dans **Image output**, sélectionner :

**Write to disk**

Le résultat du stitching sera ainsi directement enregistré sur le disque plutôt que conservé uniquement en mémoire.



brose : on ouvre la premiere image du dossier
on coche subpixel accuracy
"image outbut" : wrtite to disk.
