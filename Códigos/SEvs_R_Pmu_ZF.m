clc; 
clear; 
close all;

% Parámetros de simulación
iteraciones = 30;
W = 20; % MHz
P_max_norm = 10 / (20 * 10^6 * 10^((-174 - 30) / 10));

P_mu_values = linspace(0.05, 10 / (20 * 10^6 * 10^((-174 - 30) / 10)), 100); % Potencia media de usuarios únicos

% Valores de P_mu y R a variar
R_values = linspace(36, 1000, 100); % Radio del espacio de simulación
U = 50; % Numero de usuarios unicast
G = 10; % Número de grupos multicast
K = 100; % Número de usuarios por grupo multicast
N = 400; % Número de Antenas BS

% Inicialización de matriz para almacenar resultados de SE
SE_matrix = zeros(length(P_mu_values), length(R_values));

% Llamada a la función de simulación y obtención de resultados
for it = 1:iteraciones
    for i = 1:length(P_mu_values)
        for j = 1:length(R_values)
            P_un = P_max_norm - P_mu_values(i);
            resp = Simulation_th2y4([U, ones(1, G) * K], N, P_un, P_mu_values(i), R_values(j));
            SE_matrix(i, j) = SE_matrix(i, j) + resp.SE_jk_mu;
        end
    end
end

% Calcular el promedio
SE_matrix = SE_matrix / iteraciones;

% Graficación de la SE en función de P_mu y R
figure;
surf( P_mu_values,R_values, SE_matrix');
ylabel('Radio R (m)');
xlabel('Potencia P\_mu');
zlabel('SE (bps/Hz)');
%title('SE promedio en función de P_mu y R ');
%colorbar;

surf_edge_alpha = 0.3; % Ajusta el nivel de transparencia de las líneas de borde
set(findobj(gca, 'type', 'surface'), 'EdgeAlpha', surf_edge_alpha);
% Añadir líneas de contorno
hold on;
contour3(P_mu_values,R_values, SE_matrix', 10, 'k'); % Ajusta el número de líneas de contorno según sea necesario
hold off;

view(-125,8)