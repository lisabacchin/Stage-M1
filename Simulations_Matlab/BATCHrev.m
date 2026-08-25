% Tableau des valeurs de nutriments et de facteurs de croissance qu'on veut
% parcourir pour la phase 1 et pour la phase 2. 

%mu_values = [ 0.3, 0.35 ];
mu_values = [  0.8];
G_values  = [ 0.03];

mu_values1 = [ 0.6];
G_values1  = [ 0.03];
%G_values  = [ 0.2, 0.3, 0.4];
% Nombre de cellules initial
Number = 250000;

% Temps de simulation
tend = 300000;

% Dossier de stockage des simulations
dossier1 = 'Test';

% Répartition des cellules
% rd = 0 veut dire que toutes les simulations commencent avec la meme base
% aléatoire, rd = 1 toutes les simulations commenencent avec une répartitio
% n aléatoire. 
rd = 0;


for imu = 1:length(mu_values)

    for iG = 1:length(G_values) 

        mu0 = mu_values(imu);
        G0  = G_values(iG);
        
        for imu1 = 1:length(mu_values1)

            for iG1 = 1:length(G_values1) 

                mu1 = mu_values1(imu1);
                G1  = G_values1(iG1);

                fprintf('Running mu0=%g G0=%g mu1=%g G1=%g\n',mu0,G0, mu1, G1);

                Modele_2D_rev(mu0,G0,mu1, G1, Number,tend, dossier1, rd);

            end

        end
        

    end

end