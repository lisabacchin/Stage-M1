function Modele_1D(mu0,G0,Number, tend, dossier, random)
%mod 
%%%%%%%%%%%%%%%%%%%%%%%
% ora mi ritorna valori ma le oscillazioni si smorzano
%%%%%%%%%%%%%%%%%%%%%%%
% DEVO CONTROLLARE CHE TUTTO SIA IN mm, h

implicit = 1;
esplicit = 0;
bwdeuler = 0;
modlin   = 0;

%mu0 = 0.20;    % RGM: 0.25 ca.
%G0 = 0.1;     % RGM: 0.1
%Number = 25000;
%tend = 40000;


% time
t0 = 0;
%tend = 250;
dt = 1;
time = t0:dt:tend;
tdim = length(time);
% stability condition per metodo esplicito dt < dx^2/Dn

% space
x0 = 0;
%xend = 2.5;
xend = 25;    % largezza fov lente 4x
yend = 0.2;
dx = 0.1;
xall = x0:dx:xend;
yall = x0:dx:yend;
xdim = length(xall);
ydim = length(yall);


% variabili esplicite
Dn = 1.8e-6;    % Mobilità misurata
% Dmu = 2.36e1;
Dmu = 2.36;
% Dmu = 2.36e-1;
DG = 0e-8;      % G immobile
%DG = 1.8e-5;   % G 10 volte più mobile rispetto alle cellule
%DG = 0.236;    % Mobilità calcolata da Stokes


Vol = 1/48;
 





% mu0 = 1;
% G0=1;
% considero mu e G che variano tra 0 e 1

% Ss = 0.31;
% a_mu = 0.007;
% a_G = 1;

% valori dei parametri per equilibri stabili
Ss = 1e-6;
a_mu = 2.5e-6;
a_G = 0;



% VERSIONE DEFINITIVA DEL FITTING
a = 2.216504469713153;
h1 = 3.2140126746328654;
h2 = 11.191866190850709;


% con media pesata
mn=0.0131264;


if random 
    fprintf('random');
else
    rng(12);    % random seed

end


% ultima versione per f(n)
if modlin
    f1 =@(n,mu, G) (a .* G.*mu) .*n - mn.*n;
    f2 =@(n,mu, G) (-a_mu .*mu .*n .*G) + Vol.*(mu0-mu);
    f3 =@(n,G) (-a_G .* G.*n) + Ss.*n + Vol.*(G0-G);
else
    f1 =@(n,mu, G) (a .* G.*mu) ./ ((h1.*mu +1).*( h2.*G + 1)) .*n - mn.*n;
    f2 =@(n,mu, G) (-a_mu .*mu .*n .*G) ./((h1.*mu +1).*( h2.*G + 1)) + Vol.*(mu0-mu);
    f3 =@(n,G) (-a_G .* G.*n) ./(h2.*G+1) + Ss.*n + Vol.*(G0-G);
end
nxt  = zeros(xdim*ydim,tdim);
Gxt  = zeros(xdim*ydim,tdim);
muxt = zeros(xdim*ydim,tdim);
% n(x_i,y_k,t_j) = n^j_{(i-1)*xdim + k}



%% matrici del metodo implicito

[X,Y] = meshgrid(0:dx:xend, 0:dx:yend);
M = xdim -1;        % è il numerod i intervalli definiti per lo spazio
N= ydim -1;        % serve se poi faccio dominio non quadrato
dy=dx;

%da codice della prof
% matrici ausiliarie
R= zeros (M+1,M+1);R(1 ,1) = -1; R(1 ,2) =1; R(M+1,M)=1; R(M+1,M+1) = -1; 
i=2; j=1;
while i <=M && j <=M
    R(i,j)=1; R(i,j+1) = -2; R(i,j+2) =1;
    i=i+1; j=j+1;
end
R =1/( dx)^2*R;

S =1/( dy)^2* eye(M+1);
T=-S;
V=2*T;

% matrice finale
A= zeros ((M+1) *(N+1) , (M+1) *(N+1));
A(1:M+1 ,1:M+1)=R+T; A(1:M+1, M+2:M+2+M)=S;
i=M+2; j=1;
while i <=(M+1) *(N) && j <=(M+1) *(N+1)
    A(i:i+M, j:j+M)=S;
    A(i:i+M, j+M+1:j+M+1+M)=R+V;
    A(i:i+M,j+M+1+M+1:j+M+1+M+1+M)=S;
    i=i+M+1; j=j+M+1;
end
A((M+1) *(N+1) -M:(M+1) *(N+1) , (M+1) *(N+1) -M:(M+1) *(N+1))=R+T;
A((M+1) *(N+1) -M:(M+1) *(N+1) , (M+1) *(N+1) -M-M -1:( M+1) *(N+1) -M -1)=S;
A= sparse (A);


%% vettore noto

% M_n = Dn *dt *A;
% M_mu = Dmu *dt *A;
% M_G = DG *dt *A;

%n0 = 162/10;
%sd = sqrt(n0)/n0;
%noise = rand([-sd,sd], 1, length(xall));
%noise = rand((M+1) *(N+1))*2 -1;

% condizioni iniziali
n0 = Number/(xend*yend);
sd = sqrt(n0);
noise = randi([-1, 1], (M+1) *(N+1),1);
%noise = rand((M+1) *(N+1)) * 2 -1;
n = n0 + sd*noise;
mu = mu0 * ones((M+1) *(N+1),1);
G = G0 * ones((M+1) *(N+1),1);


% inizializzo i parametri
% n = nxt(:,1);
% mu = muxt(:,1);
% G = Gxt(:,1);
n1 = n0;
mu1 = mu0;
G1 = G0;
k=1;        % coefficiente del tempo, vedo solo se è la prima iterazione
z=0;        % tempo al quale risolvo lo schema
nt = zeros(tdim,1);

% plot temporale
figure(10)
parN = n;
Nsup = reshape(parN,[M+1,N+1])';

h = surf(X,Y,Nsup);
shading interp
view(2)

% clim([0 max(Nsup(:))]);
% clim([0 3.5]);      % per tenere la barra fissa, non so se è molto bello
hcb = colorbar;
hcb.Label.String = 'cell density n(x,y;t)';

xlabel('X'); ylabel('Y');
title(sprintf('n(x,t) at t = %.2f, V = %.2f', z, Vol));
drawnow;
step = 0;

if implicit
    while z <=tend
        F1 = f1(n,mu,G);
        F2 = f2(n,mu,G);
        F3 = f3(n,G);
        F1_1 = f1(n1,mu1,G1);
        F2_1 = f2(n1,mu1,G1);
        F3_1 = f3(n1,G1);
    
        n2 = n;
        mu2 = mu;
        G2 = G;
    
        if k==1
            n = (speye ((M+1) *(N+1))-Dn*dt*A)\(n+dt* F1);
            mu = (speye ((M+1) *(N+1))-Dmu*dt*A)\(mu+dt* F2);
            G = (speye ((M+1) *(N+1))-DG*dt*A)\(G+dt* F3);
            k=2;
        else
            n = (3*speye ((M+1) *(N+1))-2*Dn*dt*A)\(4*n-n1+2*dt* (2*F1-F1_1));
            mu = (3*speye ((M+1) *(N+1))-2*Dmu*dt*A)\(4*mu-mu1+2*dt* (2*F2-F2_1));
            G = (3*speye ((M+1) *(N+1))-2*DG*dt*A)\(4*G-G1+2*dt* (2*F3-F3_1));
            k=k+1;
        end
        n1=n2;
        mu1=mu2;
        G1=G2;
    
        nt_tot = sum(n(:,:)) * dx^2;
        nt(k) = nt_tot;
        
        % salvo i valori nelle matrici esterne
        % devo vedere bene come fare, e se le dimensioni di nxt sono corrette
        %ntx(k*)
        
        % aggiungo il plot temporale
        step = step + 1;
        if mod(step,500) == 0
            parN = n;
            Nsup = reshape(parN,[M+1,N+1])';
    
            % Update surface without creating a new plot
            set(h,'ZData',Nsup);
    
            % Update colors
            %clim([0 max(Nsup(:))]);
    
            % Update title
            title(sprintf('n(x,y;t) at t = %.2f, cells = %.2f, mu = %.3f, G = %.3f ', z, Number, mu0, G0));
    
            drawnow;
        end

        % if (mod(z,10000) == 0) 
        %     figure (2)
        %     parN =n;%(1 : M*N);
        %     Nsup = reshape(parN,[M+1,N+1])';
        %     surf(X,Y,Nsup);
        %     shading interp
        %     view (2);
        % 
        %     % axis equal;
        %     clim([0 max(Nsup(:))]);
        %     hcb = colorbar;
        %     hcb.Label.String = 'cell density n(x,y;t)';
        % 
        %     title(sprintf('n(x,t) at t = %.2f, cells = %.2f, mu = %.3f, G = %.3f ', z, Number, mu0, G0));%, 'FontSize', 14, 'FontWeight', 'bold');
        %     xlabel('X');
        %     ylabel('Y');
        %     figDir = fullfile(pwd,'Evoltemp_1D3');
        % 
        %     if ~exist(figDir,'dir')
        %         mkdir(figDir);
        %     end
            % 
            % % Nom propre (IMPORTANT)
            % filename = sprintf('mu_%0.3f_G_%0.3f_t_%0.0f_cell_%0.0f', mu0, G0, z, Number);
            % 
            % outputPNG = fullfile(figDir, [filename '.png']);
            % outputMAT = fullfile(figDir, [filename '.mat']);
            % 
            % % Sauvegarde des données
            % save(outputMAT, 'X','Y','Nsup');
            % 
            % % Sauvegarde image PNG
            % exportgraphics(gcf, outputPNG, 'Resolution', 300);

        % end
        
        z=z+dt;
    end
    
    
    
    figure (2)
    parN =n;%(1 : M*N);
    Nsup = reshape(parN,[M+1,N+1])';
    surf(X,Y,Nsup);
    shading interp
    view (2);
    
    % axis equal;
    clim([0 max(Nsup(:))]);
    hcb = colorbar;
    hcb.Label.String = 'cell density n(x,y;t)';
    
    title(sprintf('n(x,t) at t = %.2f, cells = %.2f, mu = %.3f, G = %.3f ', tend, Number, mu0, G0));%, 'FontSize', 14, 'FontWeight', 'bold');
    xlabel('X');
    ylabel('Y');
figDir = fullfile(pwd,dossier);

if ~exist(figDir,'dir')
    mkdir(figDir);
end

% Nom propre (IMPORTANT)
filename = sprintf('mu_%0.3f_G_%0.3f_t_%0.0f_cell_%0.0f', mu0, G0, tend, Number);

outputPNG = fullfile(figDir, [filename '.png']);
outputMAT = fullfile(figDir, [filename '.mat']);

% Sauvegarde des données
save(outputMAT, 'X','Y','Nsup');

% Sauvegarde image PNG
exportgraphics(gcf, outputPNG, 'Resolution', 300);

% %%
%_______   GIOVANNI Autocorrelation
    %figure(101)
    % CC = CrossCorr2(Nsup);
    % CC = CC/max(CC(:));
    % surf(X,Y,CC);
    % shading interp
    % view (2);
    % 
    % figure(102)
    % [G,R,THETA] = PolarInterp(CC,'bicubic')
    % surf(R,THETA,G);
    % shading interp
    % view (2);
    % 
    % figure(103)
    % Gr = mean(G,1);
    % plot(R,Gr)
%_______  
% %%
end

%% metodo esplicito


N = xdim;    
if esplicit
    fprintf('stability dt<dx^2/Dn: dt=%.2f, dx^2/Dn=%.2f ', dt, dx^2/Dn)
    fprintf('stability dt<dx^2/Dmu: dt=%.2f, dx^2/Dmu=%.2f ', dt, dx^2/Dmu)

    e = ones(N+1,1);
    A = spdiags([e -2*e e], -1:1, N, N);
    A(1,2) = 2; A(end,end-1) = 2;
    Id = speye(N);
    D2 = kron(Id,A) + kron(A,Id);
    
    f1D = @(n,mu,G) (a.*G.*mu)./((h1.*mu+1).*(h2.*G+1)).*n  - mn.*n + (Dn/dx^2)*(D2*n);
    
    f2D = @(n,mu,G) (-a_mu.*mu.*n.*G)./(h1.*mu+1) + Vol.*(mu0-mu) + (Dmu/dx^2)*(D2*mu);
    
    f3D = @(n,G) (-a_G .* G .* n) ./ (h2 .* G + 1) + Ss .* n + Vol .* (G0 - G) + (DG/dx^2) * (D2 * G);
    
    % nx  = n0 + randi([-sd,sd],N*N,1);
    % mux = mu0*ones(N*N,1);
    % Gx  = G0*ones(N*N,1);
    nx  = n0 + randi([-sd,sd],N,N);
    mux = mu0*ones(N,N);
    Gx  = G0*ones(N,N);
    % 
    % figure(2)
    % h = surf(X,Y,reshape(nx,[N,N])); shading interp; view(2);
    % 
    for t = 1:tdim
        
        dn  = f1D(nx(:),mux(:),Gx(:));
        dmu = f2D(nx(:),mux(:),Gx(:));
        dG  = f3D(nx(:),Gx(:));  
    
        nx(:)  = nx(:)  + dt*dn;
        mux(:) = mux(:) + dt*dmu;
        Gx(:)  = Gx(:)  + dt*dG;
        
        nt_tot = sum(nx(:));
        nt(t) = nt_tot;
    
        if mod(t,500) == 0
            nn = reshape(nx,[N,N]);
            set(h,'ZData',nn);
            title(sprintf('n(x,y;t) at t = %.2f, V = %.2f',t*dt,Vol));
            %clim([0 max(nx)]);
            drawnow;
        end
    end

    figure (2)
    parN =nx;%(1 : M*N);
    %Nsup = reshape(parN,[N+1,N+1])';
    surf(X,Y,nx);
    shading interp
    view (2);
    
    
    % axis equal;
    %clim([0 max(Nsup(:))]);
    hcb = colorbar;
    hcb.Label.String = 'cell density n(x,y;t)';
    
    title(sprintf('n(x,t) at t = %.2f, V = %.2f', tend, Vol));%, 'FontSize', 14, 'FontWeight', 'bold');
    xlabel('X');
    ylabel('Y');
end


%% metodo backward euler
% non può funzionare, è scritto per x in 1D

if bwdeuler
    e = ones(N+1,1);
    A = spdiags([e -2*e e], -1:1, N, N);
    A(1,2) = 2; A(end,end-1) = 2;
    % (inverse) iteration matrix
    B1 = - dt*D/dx^2*A + (1-dt*ff1)*speye(N,N);
    B2 = - dt*D/dx^2*A + (1-dt*ff2)*speye(N,N);
    B3 = - dt*D/dx^2*A + (1-dt*ff3)*speye(N,N);
    % initial condition
    nxt = zeros(tdim,N);
    nx  = n0 + randi([-sd,sd],N,N);
    mux = mu0*ones(N,N);
    Gx  = G0*ones(N,N);
    % backward Euler
    for n = 1:Ndt-1

        ff1  = f1(nx(:),mux(:),Gx(:));
        ff2 = f2(nx(:),mux(:),Gx(:));
        ff3  = f3(nx(:),Gx(:));

        B1 = - dt*D/dx^2*A + (1-dt*ff1)*speye(N,N);
        B2 = - dt*D/dx^2*A + (1-dt*ff2)*speye(N,N);
        B3 = - dt*D/dx^2*A + (1-dt*ff3)*speye(N,N);
        Y(n+1,:) = (B \ Y(n,:)')';
    end

end

%% plot integrale di n in t


figure()
hold on
title('n(t) totale')
xlabel('Time[h]')
ylabel('n(t)')
plot(time,nt(1:length(time)))
ylim([0,max(nt)])

filename = sprintf('mu_%0.3f_G_%0.3f_t_%0.0f_cell_%0.0f_n(t)', mu0, G0, tend, Number);

outputPNG = fullfile(figDir, [filename '.png']);

% Sauvegarde image PNG
exportgraphics(gcf, outputPNG, 'Resolution', 300);
hold off





return;





% qui ancora non è cambiato
%  devo cambiare i nomi dei parametri
n_vec=zeros(1,tdim);
t_vec = [];

for i = 1:5:tdim
    n_vec(i) = sum(nxt(:,i));
    t_vec = [t_vec;i*dx];
end
n_vec = n_vec(n_vec ~= 0);

figure()
hold on
title('n(t) totale')
xlabel('Time[h]')
ylabel('n(t)')
plot(t_vec,n_vec)
ylim([0,max(n_vec)])
hold off


return;
close all
clear;
end

%%  DA QUI IN POI NO










% %% METODO IMPLICITO, vecchio codice
% % diag_n = dx^2/(dt*Dn);
% % diag_mu = dx^2/(dt*Dmu);
% % diag_G = dx^2/(dt*DG);
% % v1 = ones(xdim-1,1);
% % v0 = (diag_n+2)*ones(xdim,1);
% % M_n = -diag(v1, -1) + diag(v0,0) -diag(v1,1);
% % M_n(1,2) = -2;
% % M_n(xdim, xdim-1) = -2;
% % 
% % v0 = (diag_mu+2)*ones(xdim,1);
% % M_mu = -diag(v1, -1) + diag(v0,0) -diag(v1,1);
% % M_mu(1,2) = -2;
% % M_mu(xdim, xdim-1) = -2;
% % 
% % v0 = (diag_G+2)*ones(xdim,1);
% % M_G = -diag(v1, -1) + diag(v0,0) -diag(v1,1);
% % M_G(1,2) = -2;
% % M_G(xdim, xdim-1) = -2;
% 
% 
% % % matrice per nxt
% % Dn_fac = Dn*dt/dx^2;
% % diag_n = 4 * Dn_fac +1;
% % v0 = (diag_n)*ones(xdim^2,1);
% % v1 = -Dn_fac * ones(xdim^2-1,1);
% % v2 = -Dn_fac * ones(xdim^2-xdim,1);
% % M_n = diag(v0) + diag(v1,1) + diag(v1,-1) + diag(v2,xdim) + diag(v2,-xdim);
% % 
% % for r = 1:xdim
% %     jR = r*xdim;             % right boundary index
% %     jL = (r-1)*xdim + 1;     % left boundary index
% %     if jR < xdim^2
% %         M_n(jR, jR+1) = 0;
% %     end
% %     if jL > 1
% %         M_n(jL, jL-1) = 0;
% %     end
% % end
% % for k = 1:xdim
% %     % bottom row
% %     j = k;
% %     M_n(j,j) = M_n(j,j) + Dn_fac;
% %     % top row
% %     jtop = (xdim-1)*xdim + k;
% %     M_n(jtop,jtop) = M_n(jtop,jtop) + Dn_fac;
% % end
% % for i = 1:xdim
% %     jL = (i-1)*xdim + 1;
% %     M_n(jL,jL) = M_n(jL,jL) + Dn_fac;
% %     jR = i*xdim;
% %     M_n(jR,jR) = M_n(jR,jR) + Dn_fac;
% % end
% % 
% % % matrice per muxt
% % Dm_fac = Dmu*dt/dx^2;
% % diag_mu = 4 * Dm_fac +1;
% % v0 = (diag_mu)*ones(xdim^2,1);
% % v1 = -Dm_fac * ones(xdim^2-1,1);
% % v2 = -Dm_fac * ones(xdim^2-xdim,1);
% % M_mu = diag(v0) + diag(v1,1) + diag(v1,-1) + diag(v2,xdim) + diag(v2,-xdim);
% % 
% % for r = 1:xdim
% %     jR = r*xdim;             % right boundary index
% %     jL = (r-1)*xdim + 1;     % left boundary index
% %     if jR < xdim^2
% %         M_mu(jR, jR+1) = 0;
% %     end
% %     if jL > 1
% %         M_mu(jL, jL-1) = 0;
% %     end
% % end
% % for k = 1:xdim
% %     % bottom row
% %     j = k;
% %     M_mu(j,j) = M_mu(j,j) + Dm_fac;
% %     % top row
% %     jtop = (xdim-1)*xdim + k;
% %     M_mu(jtop,jtop) = M_mu(jtop,jtop) + Dm_fac;
% % end
% % for i = 1:xdim
% %     jL = (i-1)*xdim + 1;
% %     M_mu(jL,jL) = M_mu(jL,jL) + Dm_fac;
% %     jR = i*xdim;
% %     M_mu(jR,jR) = M_mu(jR,jR) + Dm_fac;
% % end
% % 
% % 
% % % matrice per Gxt
% % DG_fac = DG*dt/dx^2;
% % diag_G = 4 * DG_fac +1;
% % v0 = (diag_G)*ones(xdim^2,1);
% % v1 = -DG_fac * ones(xdim^2-1,1);
% % v2 = -DG_fac * ones(xdim^2-xdim,1);
% % M_G = diag(v0) + diag(v1,1) + diag(v1,-1) + diag(v2,xdim) + diag(v2,-xdim);
% % 
% % for r = 1:xdim
% %     jR = r*xdim;             % right boundary index
% %     jL = (r-1)*xdim + 1;     % left boundary index
% %     if jR < xdim^2
% %         M_G(jR, jR+1) = 0;
% %     end
% %     if jL > 1
% %         M_G(jL, jL-1) = 0;
% %     end
% % end
% % for k = 1:xdim
% %     % bottom row
% %     j = k;
% %     M_G(j,j) = M_G(j,j) + DG_fac;
% %     % top row
% %     jtop = (xdim-1)*xdim + k;
% %     M_G(jtop,jtop) = M_G(jtop,jtop) + DG_fac;
% % end
% % for i = 1:xdim
% %     jL = (i-1)*xdim + 1;
% %     M_G(jL,jL) = M_G(jL,jL) + DG_fac;
% %     jR = i*xdim;
% %     M_G(jR,jR) = M_G(jR,jR) + DG_fac;
% % end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% 
% 
% 
% 
% 
% %%
% 
% %voglio l'animazione dell'evoluzione temporale di n
% 
% figure
% 
% x1 = copy(xall);
% x2 = copy(xall);
% 
% [X1,X2] = meshgrid(x1, x2);
% % devo definire una funzione che associa ai x1,x2 il relativo nxt
% ...
% 
% 
% 
% % pos = get(gcf, 'Position');  % [x0, y0, width, height]
% % 
% % pos(2) = 40;
% % pos(3) = 550;   
% % pos(4) = 750;   % così la figura è più lunga
% % 
% % set(gcf, 'Position', pos);
% % 
% % % n(x,t)
% % ax1 = subplot(3,1,1);   
% % h_1 = plot(ax1, xall, nxt(:,1), 'LineWidth', 1.5);  
% % xlabel(ax1, 'space')
% % ylabel(ax1, 'n(x,t)')
% % % if V>0.4
% % %     ylim(ax1, [0, 20])
% % % else 
% % %     ylim(ax1, [0,2.5])
% % % end
% % ylim(ax1, [0, max(nxt(:))])
% % title(ax1, 'n(x,t)')
% % grid(ax1, 'on')
% % 
% % % mu(x,t)
% % ax2 = subplot(3,1,2);
% % h_2 = plot(ax2, xall, muxt(:,1), 'LineWidth', 1.5);
% % xlabel(ax2, 'space')
% % ylabel(ax2, '\mu(x,t)')
% % ylim(ax2, [0, 1])     
% % title(ax2, '\mu(x,t)')
% % grid(ax2, 'on')
% % 
% % % G(x,t)
% % ax3 = subplot(3,1,3);
% % h_3 = plot(ax3, xall, Gxt(:,1), 'LineWidth', 1.5);
% % xlabel(ax3, 'space')
% % ylabel(ax3, 'G(x,t)')
% % ylim(ax3, [0, 1.2])    
% % title(ax3, 'G(x,t)')
% % grid(ax3, 'on')
% % 
% % if tend>1500
% %     step=10;
% % else
% %     step=5;
% % end
% % 
% % for i = 1:tdim
% %     if mod(i,step) == 0
% %         t_current = time(i);
% %         if isvalid(h_1)
% %             set(h_1, 'YData', nxt(:,i));
% %             title(ax1, sprintf('n(x,t) at t = %.2f', t_current))
% %         end
% %         if isvalid(h_2)
% %             set(h_2, 'YData', muxt(:,i));
% %             title(ax2, sprintf('\\mu(x,t) at t = %.2f', t_current))
% %         end
% %         if isvalid(h_3)
% %             set(h_3, 'YData', Gxt(:,i));
% %             title(ax3, sprintf('G(x,t) at t = %.2f', t_current))
% %         end
% % 
% %         drawnow limitrate
% %     end
% % end
% % 
% 
% 
% 
% %% plot
% 
% fig = 1;
% 
% if fig == 1
%     figure()
%     hold on
%     xlabel('space')
%     ylabel('n(x,t)')
%     %ylim([4,14])
% 
%     i = 1;
%     plot(xall, nxt(1:xdim,i))
%     hold on
%     %pause(0.05)
% 
%     i = floor(tdim/10);
%     plot(xall, nxt(1:xdim,i))
%     hold on
%     %pause(0.05)
% 
%     i = floor(tdim/2);
%     plot(xall, nxt(1:xdim,i))
%     hold on
%     %pause(0.05)
% 
%     i = tdim;
%     plot(xall, nxt(1:xdim,i))
% 
% 
%     title('Cells density')
%     legend('t=0','t=tend/10','t = tend/2', 't=tend')
% end
% 
% 
% %% plot di mu e G per vedere che non escano da [0,1]
% 
% 
% % % muxt = zeros(length(xall),length(time));
% % % Gxt = zeros(length(xall),length(time));
% % % for j =1:xdim
% % %     muxt(j,1) = mu0;
% % %     Gxt(j,1) = G0;
% % % end
% % % 
% % % 
% % % for i=2:tdim
% % %     for j =1:xdim
% % %         muxt(j,i) = mu(nxt(j,i));
% % %         Gxt(j,i) = G(nxt(j,i));
% % %     end
% % % end
% % 
% % fig_mu = 1;
% % 
% % if fig_mu == 1
% %     figure()
% %     hold on
% %     xlabel('space')
% %     ylabel('mu(n(x,t))')
% %     %ylim([4,14])
% % 
% %     i = 1;
% %     plot(xall, muxt(:,i))
% %     hold on
% %     %pause(0.05)
% % 
% %     i = floor(tdim/10);
% %     plot(xall, muxt(:,i))
% %     hold on
% %     %pause(0.05)
% % 
% %     i = floor(tdim/2);
% %     plot(xall, muxt(:,i))
% %     hold on
% %     %pause(0.05)
% % 
% %     i = tdim;
% %     plot(xall, muxt(:,i))
% % 
% %     %yline(mu0, '--k', 'mu0')
% %     ylim([0,1])
% %     title('Nutrients density, in [0,1]')
% %     legend('t=0','t=tend/10','t = tend/2', 't=tend')
% % end
% % 
% % 
% % fig_G = 1;
% % 
% % if fig_G == 1
% %     figure()
% %     hold on
% %     xlabel('space')
% %     ylabel('G(n(x,t))')
% %     %ylim([4,14])
% % 
% %     i = 1;
% %     plot(xall, Gxt(:,i))
% %     hold on
% %     %pause(0.05)
% % 
% %     i = floor(tdim/10);
% %     plot(xall, Gxt(:,i))
% %     hold on
% %     %pause(0.05)
% % 
% %     i = floor(tdim/2);
% %     plot(xall, Gxt(:,i))
% %     hold on
% %     %pause(0.05)
% % 
% %     i = tdim;
% %     plot(xall, Gxt(:,i))
% % 
% %     %yline(G0, '--k', 'G0')
% %     ylim([0,1])
% %     title('Growth factors density, in [0,1]')
% %     legend('t=0','t=tend/10','t = tend/2', 't=tend')
% % end
% % 
