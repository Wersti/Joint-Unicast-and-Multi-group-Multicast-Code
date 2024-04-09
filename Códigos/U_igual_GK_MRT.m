clc; 
clear; 
close all;

% Parámetros de simulación
iter = 2;
W = 20; % MHz
P_max_norm = 10 / (20 * 10^6 * 10^((-174 - 30) / 10));
P_un = P_max_norm / 2;
P_mu = P_max_norm / 2;
N = 400;
G_set = 1:10;
K_set = 20; % Utilizando solo un valor de K

% Inicialización de matrices para almacenar resultados
SE_jk_mu = zeros(length(G_set), iter);
SSE_m_un = zeros(length(G_set), iter);

SE = zeros(length(G_set), 1);
SSE = zeros(length(G_set), 1);

% Llamada a la función de simulación y obtención de resultados
for G = 1:length(G_set)
    for i = 1:iter
        resp = Simulation_th1y3([G_set(G)*K_set, ones(1, G_set(G)) * K_set], N, P_un, P_mu);
        SE_jk_mu(G, i) = resp.SE_jk_mu;
        SSE_m_un(G, i) = resp.SSE_m_un;
    end
    SE(G) = mean(SE_jk_mu(G, :));
    SSE(G) = mean(SSE_m_un(G, :)) / (G*K_set); % Dividir por G para obtener SSE/U
end

% Graficación de las medias de SE y SSE
figure;

yyaxis left;
plot(G_set*K_set, SE, 'LineWidth', 2, 'DisplayName', 'SE mínima multicast (bps/Hz)');
ylabel('SE');

hold on;

yyaxis right;
plot(G_set*K_set, SSE, 'LineWidth', 2, 'DisplayName', 'SE media unicast (bps/HZ)');
ylabel('SSE/U');

xlabel('Número usuarios unicast/multicast');
%title('Medias de SE y SSE/U respecto a G');
legend('Location', 'Best');

% Personalización adicional de la gráfica
set(gca, 'FontSize', 12);
grid on;
box on;
xlim([1, 10*20]); % Limitar el eje x para una mejor visualización
