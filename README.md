# Stage-M1

Ce dossier guithub est composé de 4 catégories, les programmes matlab permettant de résoudre le modele mathématique et permettant de faire des simulations, les programmes python permettant d'extraire des résultats des simulations et ainsi que de creer des figures et des programmes permettant de traiter des images venant des expériences, ainsi que les macros figi permettant de trier et organiser les images.

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


