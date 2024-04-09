% Gráfica para teoremas 1 y 3
clc; clear; close all;

iter = 1600;
% Definir el rango de valores para x
x_values = linspace(0, 1, 21);
W = 20 ; % MHz
% Coherence bandwith 200 kHz
% Coherence time 1 ms
P_max_norm = 10/(20*10^6*10^((-174-30)/10));
% Calcular los valores para cada punto del gráfico
P_un_values = P_max_norm*(1-x_values);
P_mu_values = P_max_norm*x_values;



% Valores de N para la gráfica
N_values = [100, 150, 200, 250, 300];
U = 50; % Usuarios unicast
G = 10;

% Llamar a la función de simulación y obtener los resultados
resultados_totales = zeros(length(P_un_values), 2, length(N_values));

for n = 1:length(N_values)
    for i = 1:length(P_un_values)
        for j = 1:iter
                resp = Simulation_th2y4([50, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100], N_values(n), P_un_values(i), P_mu_values(i));
                resultados_totales(i, :, n, j) = [resp.SE_jk_mu, resp.SSE_m_un];
        end
    end
end
% Calcular la media de los resultados
media_resultados = mean(resultados_totales, 4);

figure;
hold on;

% Paleta de colores más llamativos
n_colors = length(N_values);
color_order = parula(n_colors);

for n = 1:length(N_values)
    % Usar diferentes marcadores para cada gráfica
    marker = {'o', 's', '^', 'd' ,'x'};
    
    % Seleccionar el color de la paleta
    color = color_order(n, :);
    
    % Seleccionar el marcador y estilo de línea
    style = strcat(marker{n}, '-');
    
    plot(media_resultados(:, 1, n), media_resultados(:, 2, n), style, ...
        'Color', color, 'MarkerSize', 8, 'LineWidth', 2, 'DisplayName', sprintf('N = %d', N_values(n)));
end

% Etiquetas y leyenda
xlabel('SE multicast (bps/Hz)');
ylabel('SSE unicast (bps/Hz)');
%title('Optimización con codificación ZF');
legend('Location', 'best'); % Ubicar la leyenda en la mejor posición
grid on;
hold off;


