clc; 
clear; 
close all;

% Parámetros de simulación
iter = 200;
W = 20; % MHz
P_max_norm = 10 / (20 * 10^6 * 10^((-174 - 30) / 10));

P_un_values = linspace(0.05, 10 / (20 * 10^6 * 10^((-174 - 30) / 10)), 100); % Potencia media de usuarios únicos

% Valores de P_mu y R a variar
R_values = linspace(36, 1000, 50); % Radio del espacio de simulación
U = 50; % Numero de usuarios unicast
G = 10; % Número de grupos multicast
K = 100; % Número de usuarios por grupo multicast
N = 400; % Número de Antenas BS

% Inicialización de matriz para almacenar resultados de SE
SSE_matrix = zeros(length(P_un_values), length(R_values));

% Llamada a la función de simulación y obtención de resultados
parfor i = 1:length(P_un_values)
    SSE_temp = zeros(1, length(R_values)); % Matriz temporal para almacenar los resultados de cada iteración
    for j = 1:length(R_values)
        sum_aux = 0;
        if j > 40
            iteraciones = 15 * iter;
        else
            iteraciones = iter;
        end
        for it = 1:iteraciones
            resp = Simulation_th1y3([U, ones(1, G) * K], N, P_un_values(i), P_max_norm - P_un_values(i), R_values(j));
            SSE_temp(j) = SSE_temp(j) + resp.SSE_m_un;
        end
        SSE_temp(j) = SSE_temp(j) / iteraciones;
    end
    SSE_matrix(i, :) = SSE_temp; % Asignar los resultados de la matriz temporal a la matriz principal
    display(i/length(P_un_values));
end


% Graficación de la SE en función de P_mu y R
figure;
surf( P_un_values,R_values, SSE_matrix');
ylabel('Radio R (m)');
xlabel('Potencia P\_un');
zlabel('SE (bps/Hz)');
%title('SE promedio en función de P_mu y R ');
%colorbar;

surf_edge_alpha = 0.3; % Ajusta el nivel de transparencia de las líneas de borde
set(findobj(gca, 'type', 'surface'), 'EdgeAlpha', surf_edge_alpha);
% Añadir líneas de contorno
hold on;
contour3(P_un_values,R_values, SSE_matrix', 10, 'k'); % Ajusta el número de líneas de contorno según sea necesario
hold off;

view(-125,8)
