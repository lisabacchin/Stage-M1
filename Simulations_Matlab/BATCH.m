
% Tableau des valeurs de nutriments et de facteurs de croissance qu'on veut
% parcourir 

%mu_values = [ 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4];
%G_values  =  [0, 0.025, 0.05, 0.075, 0.10, 0.2, 0.3, 0.4];
mu_values = [0.25];
G_values  = [0.03];

% Nombre de cellules initial
Number1 = 250000;

% Temps de simulation
tend1 = 300000;

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

        fprintf('Running mu=%g G=%g\n',mu0,G0);

        % Choix du programme à lancer
        Modele_2D(mu0,G0,Number1,tend1,dossier1, rd );
        %Modele_1D(mu0,G0,Number1,tend1,dossier1, rd );
        
        
    end

end

