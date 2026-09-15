# Stage-M1

Ce dossier guithub est composé de 5 catégories, les programmes matlab permettant de résoudre le modele mathématique et permettant de faire des simulations, les programmes python permettant d'extraire des résultats des simulations et ainsi que de creer des figures et des programmes permettant de traiter des images venant des expériences, ainsi que les macros figi permettant de trier et organiser les images, ainsi que les fichiers sketchup permettant de réaliser les puces 1D.

# Partie 1 : Simulations Matlab

Les simulations matlab prennent en entrée les parametres suivants 

1. Concentration en nutriment ( mu)
2. Contration en facteur de croissance (G)
3. Quantité de cellule initiale (number)
4. Le temps de simulation (tend)
5. Dossier où les résutats de simulations sont enregistrés (dossier)
6. variable valant 1 ou 0 afin de dire si la répartition est aléatoire pour toutes les simulations (1° ou aléatoire mais commune à toutes les simulations ( 0) (random)

La fonction Modele_2D(mu0,G0,Number, tend, dossier, random) résout les équations pour les parametrés d'entrée données sur un dommaine de 4x4 mm. Elle enregistre l'image de la quantité de cellule en fonction de l'espace, ainsi que le fichier matlab contenant la matrice de répartition cellulaire et les vecteurs de l'espace afin de reconstruire l'image finale. Les données sont enregistrer avec pour titre mu_0.xxx_G_0.xxx_t_xxx_cell_xxx. 

lA FONCTION Modele_1D((mu0,G0,Number, tend, dossier, random) fait la meme chose pour un domaine quasi unidimentionel de 0.2x25 mm.

La fonction Modele_2D_rev(mu0,G0,mu1, G1, Number,tend, dossier1, random) admet d'autres parametres d'entree de concentration, des concentrations pour une premiere phase quelle execute pendant une turee tend, et une deuxieme concentration quelle execute pour une durée tend, la deuxieme phase est exécutée sur la répartition cellulaire de la premiere.
L'image et son fichier .m associé sont enregistrés à la fin de chaque phase sous le nom : mu0_0.XXX_G0_0.XXX_mu1_0.XX_G1_0.XX_t_XXX_cells_XXX_Phase_X.

Aprés la correction des codes cf rapport on obtenient deux nouveaux programmes
Modele_2D_corrige et Modele_1D_corrige c'est programmes ont les méme fonctionnenment mais avec les corrections  effctuées. 
Un changement est néanmoins présent : le parametre number qui initialement represente le nombre de cellules initiales dans le domaine, est ici le nombre de cellules initiales pour un puits d'une plaque 24 puits, le programme fait ensuite lui meme la conversion.

# Partie 2 : Traitement simulations

Des programmes pythons permettent de lire les fichiers matlab obtenus par les simulations et d'en extraire des résultats.
Le programme traitement_1D va traiter les simulations effectuées dans le domaine en 1D il va donc calculer des parametres comme la distance moyenne entre motifs, la largeur moyenne des motifs ect..
Des cellules sont alors présentes pour réaliser les differentes figures présentes dans le rapport : diagramme de phase, ect...

Le programme traitement_1D va traiter les simulations effectuées dans le domaine en 2D il va donc calculer des parametres comme la distance moyenne entre premiers voisins l'autocorrelation ect..
Des cellules sont alors présentes pour réaliser les differentes figures présentes dans le rapport : diagramme de phase, ect...

Le programme 2D_rev va traiter les données issues des simulations de type rev et réaliser un graphe avec une premiere colonne representant la premiere phase et les autres colonnes les phases appliquées à la premiere ( cf figure 12 du rapport )

Le programme Evolparam va traiter des dossiers de données 1D ou on a écranté un parametre et fixés les autres, par exemple on enregistre le résultat des images tous les 500 h. Il va alors reconstruire une image 1D à partir des images concatées et va pouvoir faire une graphhe avec le parametre ecranté en ordonnée. On peut ecranté le temps mais aussi les nutriments et les facteurs de croissances ect...

# Partie 3 : Traitement images

Le traitement d'image va constituer du programme taille_espacement_motifs.
Ce programme va recuperer des données .csv enregistrés par imagej. Ces fichiers csv sont traités pour calculer le diametre équivalent moyen, on peut ensuite calculer l'espacement moyen etre premier voisin (2D) et l'espacement moyen (1D).


# Partie 4 : Macros figi + protocole stitching

Protocole stitching, pour les images des domaines 1D ont prend plusieurs images à differents endroits de la puce et on reconstruit l'image entiere en faisant un stitching sur nous images. Ce protocole est expliqué dans le document associé. 

Des macros figi permettent de traiter facilement et rapidement les données, ce programme prend en entrée un dossier avec des sous dossiers par exemple un dossier comprenant une plaque 2D, chaque sous dossier correspond à un puit et les images dans le sous dossiers sont les images prisent au cours du temps pour ce puits ( images .tif).
On donne en entrée ce dossier et le programme va automatiquement traiter chaque image .tif, lui mettre une barre d'echelle, ajuster le contraste et la brillance, et l'enregistrer au format jpg qui est moins lourd pour déplacer les images. Une macro est utilisée pour les images 2D qui sont prises en 4x et une macro pour les images 1D prises en 10x.

# Partie 5 : Fichiers sketchup pour l'impression 3D
Les fichiers sketchups utilisés pour imprimer le moule du dispositif 1D, sont disponibles. On a des fichiers .skp et .stl afin de pouvoir imprimer à la forge via bambulab. On a un dispotif avec une largeur de fente de 1mm et l'autre de 0.5mm.

# Stage M1 — Modélisation, simulations et analyse d'images

Ce dépôt GitHub regroupe l'ensemble des programmes, scripts et fichiers développés au cours du stage de Master 1.

Le dépôt est organisé en **cinq catégories principales** :

1. **Simulations MATLAB** : résolution du modèle mathématique et réalisation des simulations numériques.
2. **Traitement des simulations** : extraction et analyse des résultats numériques avec Python.
3. **Traitement des images expérimentales** : analyse quantitative des images issues des expériences.
4. **Macros Fiji et protocole de stitching** : automatisation du traitement des images et reconstruction des domaines 1D.
5. **Fichiers SketchUp** : conception des dispositifs 1D destinés à l'impression 3D.

---

# 1. Simulations MATLAB

Cette partie regroupe les programmes MATLAB permettant de résoudre le modèle mathématique et de réaliser les simulations numériques.

## 1.1. Paramètres d'entrée

Les simulations utilisent les paramètres suivants :

| Paramètre | Description                                                         |
| --------- | ------------------------------------------------------------------- |
| `mu`      | Concentration en nutriment                                          |
| `G`       | Concentration en facteur de croissance                              |
| `Number`  | Nombre initial de cellules                                          |
| `tend`    | Durée de la simulation                                              |
| `dossier` | Dossier dans lequel enregistrer les résultats                       |
| `random`  | Paramètre contrôlant la répartition initiale aléatoire des cellules |

Le paramètre `random` peut prendre deux valeurs :

* `1` : une répartition aléatoire différente est générée pour chaque simulation ;
* `0` : une même répartition aléatoire est utilisée pour l'ensemble des simulations.

---

## 1.2. Modèle 2D

La fonction :

```matlab
Modele_2D(mu0, G0, Number, tend, dossier, random)
```

résout les équations du modèle sur un domaine bidimensionnel de **4 × 4 mm**.

La simulation enregistre notamment :

* une image de la répartition spatiale des cellules ;
* le fichier MATLAB contenant la matrice de densité cellulaire ;
* les vecteurs `X` et `Y` permettant de reconstruire l'image.

Les résultats sont enregistrés avec un nom permettant d'identifier les paramètres utilisés, sous la forme :

```text
mu_0.xxx_G_0.xxx_t_xxx_cell_xxx
```

---

## 1.3. Modèle 1D

La fonction :

```matlab
Modele_1D(mu0, G0, Number, tend, dossier, random)
```

fonctionne selon le même principe que le modèle 2D, mais sur un domaine **quasi-unidimensionnel de 0,2 × 25 mm**.

Elle permet notamment d'étudier la formation et l'évolution des motifs cellulaires dans un domaine allongé.

---

## 1.4. Modèle avec changement de conditions — `Modele_2D_rev`

La fonction :

```matlab
Modele_2D_rev(mu0, G0, mu1, G1, Number, tend, dossier1, random)
```

permet de réaliser une simulation en **deux phases successives**.

* La première phase est réalisée avec les paramètres `mu0` et `G0` pendant une durée `tend`.
* La deuxième phase est réalisée avec les paramètres `mu1` et `G1`, en utilisant comme condition initiale la répartition cellulaire obtenue à la fin de la première phase.

Les résultats sont enregistrés à la fin de chaque phase.

Le nom des fichiers permet d'identifier les paramètres des deux phases :

```text
mu0_0.XXX_G0_0.XXX_mu1_0.XX_G1_0.XX_t_XXX_cells_XXX_Phase_X
```

Cette simulation permet notamment d'étudier l'évolution des motifs cellulaires lors d'un changement de conditions environnementales.

---

## 1.5. Versions corrigées du modèle

À la suite des corrections apportées au modèle, présentées dans le rapport de stage, deux nouvelles versions des programmes ont été développées :

```text
Modele_2D_corrige
Modele_1D_corrige
```

Ces programmes conservent le même fonctionnement général que les versions précédentes, mais intègrent les corrections apportées au modèle mathématique.

### Modification du paramètre `Number`

Une différence importante concerne l'interprétation du paramètre `Number`.

Dans les anciennes versions, `Number` correspond au **nombre initial de cellules présentes dans le domaine simulé**.

Dans les versions corrigées, `Number` correspond au **nombre initial de cellules par puits d'une plaque 24 puits**. Le programme effectue ensuite automatiquement la conversion nécessaire pour obtenir la quantité initiale de cellules dans le domaine simulé.

---

# 2. Traitement des simulations

Cette partie regroupe les programmes Python permettant de lire les fichiers produits par les simulations MATLAB et d'en extraire des grandeurs quantitatives.

Les scripts permettent également de produire les différentes figures présentées dans le rapport.

---

## 2.1. Analyse des simulations 1D

Le programme :

```text
traitement_1D
```

traite les simulations réalisées dans le domaine quasi-unidimensionnel.

Il permet notamment de calculer différents paramètres caractérisant les motifs cellulaires, tels que :

* la distance moyenne entre les motifs ;
* la largeur moyenne des motifs ;
* et différentes grandeurs permettant de caractériser quantitativement les structures observées.

Le programme contient également les fonctions nécessaires à la réalisation de plusieurs figures, notamment les **diagrammes de phase**.

---

## 2.2. Analyse des simulations 2D

Le programme :

```text
traitement_2D
```

traite les simulations réalisées dans le domaine bidimensionnel.

Il permet notamment de calculer :

* la distance moyenne entre premiers voisins ;
* l'autocorrélation spatiale ;
* différentes grandeurs permettant de caractériser les motifs cellulaires en 2D.

Il contient également les fonctions utilisées pour générer différentes figures du rapport, notamment les **diagrammes de phase**.

---

## 2.3. Analyse des simulations à deux phases

Le programme :

```text
2D_rev
```

traite les données issues des simulations réalisées avec `Modele_2D_rev`.

Il permet de représenter les résultats sous la forme d'une matrice de figures :

* une première colonne correspondant à la répartition obtenue lors de la première phase ;
* les colonnes suivantes correspondant aux différentes conditions appliquées lors de la deuxième phase.

Cette représentation permet de visualiser directement l'évolution des motifs cellulaires lors du changement de conditions.

> Voir notamment la figure 12 du rapport.

---

## 2.4. Évolution d'un paramètre

Le programme :

```text
Evolparam
```

permet d'analyser l'évolution des motifs lorsque l'un des paramètres du modèle est modifié tandis que les autres sont maintenus constants.

Par exemple, il est possible d'enregistrer les résultats d'une simulation toutes les 500 h et de reconstruire une représentation spatio-temporelle de l'évolution du système.

Le programme permet :

* de reconstruire une image 1D à partir des différents profils enregistrés ;
* de représenter l'évolution spatiale au cours du temps ;
* de faire varier un paramètre donné en ordonnée.

Le paramètre étudié peut notamment être :

* le temps ;
* la concentration en nutriment `μ` ;
* la concentration en facteur de croissance `G` ;
* ou tout autre paramètre disponible dans les simulations.

---

# 3. Traitement des images expérimentales

Cette partie regroupe les programmes permettant d'effectuer l'analyse quantitative des images obtenues expérimentalement.

Le principal programme est :

```text
taille_espacement_motifs
```

Ce programme utilise les fichiers `.csv` générés à partir des images avec **ImageJ/Fiji**.

Les données sont ensuite traitées afin d'obtenir différentes caractéristiques géométriques des motifs cellulaires.

Le programme permet notamment de calculer :

* le diamètre équivalent moyen des motifs ;
* l'espacement moyen entre premiers voisins pour les images 2D ;
* l'espacement moyen entre les motifs pour les images 1D.

Ces grandeurs peuvent ensuite être comparées aux résultats obtenus numériquement.

---

# 4. Macros Fiji et protocole de stitching

## 4.1. Stitching des images 1D

Les domaines expérimentaux 1D étant plus longs que le champ de vision d'une seule image, plusieurs images sont acquises à différentes positions le long de la puce.

Ces différentes images sont ensuite assemblées afin de reconstruire l'ensemble du domaine expérimental.

La procédure de **stitching** utilisée pour reconstruire les images 1D est décrite dans le document associé au dépôt.

---

## 4.2. Macros Fiji

Des macros **Fiji/ImageJ** ont été développées afin d'automatiser le traitement des images expérimentales.

Le programme prend en entrée un dossier contenant plusieurs sous-dossiers. Par exemple, pour une expérience réalisée sur une plaque 2D :

```text
Plaque/
├── Puits_1/
│   ├── image_001.tif
│   ├── image_002.tif
│   └── ...
├── Puits_2/
│   ├── image_001.tif
│   ├── image_002.tif
│   └── ...
└── ...
```

Chaque sous-dossier correspond à un puits et contient les images acquises au cours du temps.

La macro traite automatiquement chaque image `.tif` et réalise notamment :

* l'ajout d'une barre d'échelle ;
* l'ajustement du contraste ;
* l'ajustement de la luminosité ;
* l'enregistrement de l'image au format `.jpg`.

Le passage au format `.jpg` permet de réduire la taille des fichiers et de faciliter leur transfert et leur stockage.

Deux macros sont disponibles selon le type d'acquisition :

* une macro pour les images **2D acquises avec un objectif 4×** ;
* une macro pour les images **1D acquises avec un objectif 10×**.

---

# 5. Fichiers SketchUp — Dispositifs 1D

Cette dernière partie contient les fichiers de conception des dispositifs expérimentaux 1D utilisés pour l'impression 3D du moule.

Les fichiers sont disponibles dans les formats :

```text
.skp
.stl
```

Le format `.skp` peut être utilisé pour modifier la géométrie avec **SketchUp**, tandis que le format `.stl` est directement adapté à la préparation de l'impression 3D.

Les fichiers correspondent notamment à deux dispositifs présentant des largeurs de fente différentes :

* **1 mm** ;
* **0,5 mm**.

Ces fichiers permettent de reproduire les moules utilisés pour la fabrication des dispositifs 1D, notamment avec une imprimante 3D **Bambu Lab**.

---

# Organisation générale du dépôt

En résumé, le dépôt contient :

```text
Stage-M1/
│
├── Simulations_Matlab/
│   ├── Modele_1D
│   ├── Modele_2D
│   ├── Modele_2D_rev
│   ├── Modele_1D_corrige
│   └── Modele_2D_corrige
│
├── Traitement_simulations/
│   ├── traitement_1D
│   ├── traitement_2D
│   ├── 2D_rev
│   └── Evolparam
│
├── Traitement_images/
│   └── taille_espacement_motifs
│
├── Macros_Fiji/
│   ├── Macros_2D
│   ├── Macros_1D
│   └── Stitching
│
└── SketchUp/
    ├── dispositif_1mm
    └── dispositif_0.5mm
```

## Objectif du dépôt

L'objectif de ce dépôt est de regrouper l'ensemble de la chaîne d'analyse développée au cours du stage, depuis la **simulation numérique du modèle mathématique**, jusqu'à l'**analyse quantitative des résultats numériques et expérimentaux**, en passant par le traitement et la préparation des images.

Il permet ainsi de conserver une trace reproductible des méthodes utilisées pour obtenir les résultats et les figures présentés dans le rapport de stage.




