clc; clear; close all;

iter = 200;
W = 20; % MHz
% Coherence bandwith 200 kHz
% Coherence time 1 ms
P_max_norm = 10 / (20 * 10^6 * 10^((-174 - 30) / 10));

% Calcular los valores para cada punto del gráfico
P_un = P_max_norm /2;
P_mu = P_max_norm /2;

% Valores de N, G, K para la gráfica
N_values = [100, 250, 500];
%G_set = [1,2:2:10];
G_set = [1,2:1:10];
K_set = [1,2:2:6 , 10:5:100];


% Llamar a la función de simulación y obtener los resultados
resultados_totales = zeros(length(G_set), 3, length(K_set),iter);

for n = 1:3
    for G = 1:length(G_set)
        for K = 1:length(K_set)
            for i = 1:iter 
                resp = Simulation_th1y3([50, ones(1,G_set(G))*K_set(K)],N_values(n), P_un, P_mu);
                resultados_totales(G, n, K,i) = resp.SE_jk_mu;
            end
        end
    end
end
% Calcular la media de los resultados
media_resultados = mean(resultados_totales, 4);

% Graficar todas las superficies en una sola gráfica
figure;

hold on;

for indice_N = 1:length(N_values)
    % Preparar matrices G y K para la gráfica
    [G_matrix, K_matrix] = meshgrid(G_set, K_set);

    % Obtener los datos para el valor específico de N
    datos_grafica = squeeze(media_resultados(:, indice_N, :));

    % Graficar los resultados con un esquema de colores diferente (jet)
    surf(G_matrix, K_matrix, datos_grafica');

    % Añadir el valor de N sobre la gráfica
    text(G_set(1), K_set(1), max(max(datos_grafica)), ['N = ' num2str(N_values(indice_N))], 'FontSize', 10, 'FontWeight', 'bold');
end

hold off;

% Etiquetas y título
xlabel('G (Número de grupos multicast)');
ylabel('K (Número de usuarios por grupo)');
zlabel('SE mínima (bps/Hz)');
%title('SE mínima  vs G vs K para MRT');

% Cambiar el esquema de colores (jet)
%colormap jet;

% Añadir una barra de color
%colorbar;

% Personalizar la vista de la gráfica
view(235, 10);

% Añadir grid
grid on;

% Añadir transparencia a la superficie
alpha(0.9); % Valor entre 0 (totalmente transparente) y 1 (totalmente opaco)