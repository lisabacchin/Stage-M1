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





