

# Stage M1 : Formation spontanée de motifs spatiaux dans une population cellulaire soumise à des ressources limitées<img width="4908" height="215" alt="image" src="https://github.com/user-attachments/assets/90658bb1-b44a-48af-a859-1e5ac0f79d98" />


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





