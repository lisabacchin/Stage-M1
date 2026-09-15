
% Tableau des valeurs de nutriments et de facteurs de croissance qu'on veut
% parcourir 

%mu_values = [  0.2, 0.3, 0.4, 0.5, 0.6];
%G_values  =  [ 0.025, 0.05, 0.075, 0.10, 0.2, 0.3, 0.4];
mu_values = [0.25];
G_values  = [0.03];

% Nombre de cellules initial
Number1 = 8000;


% Temps de simulation

tend2 = 300000;


% Dossier de stockage des simulations
dossier1 = 'Figure2';

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
        Modele_1D(mu0,G0,Number1,tend2,dossier1, rd );
        
        %Modele_1D(mu0,G0,Number1,tend1,dossier1, rd );
        
        
    end

end

