clc; clear; close all;

iter = 300;
% Definir el rango de valores para x
x_values = linspace(0, 1, 21);
W = 20; % MHz
% Coherence bandwith 200 kHz
% Coherence time 1 ms
P_max_norm = 10 / (20 * 10^6 * 10^((-174 - 30) / 10));

% Corregir el error tipográfico
P_un = P_max_norm/2;
P_mu = P_max_norm/2;

% Valores de N y U para la gráfica
N_values = 100:20:400;
U_values = 1:10:251;

% Llamar a la función de simulación y obtener los resultados
resultados_totales = zeros(length(N_values), length(U_values));

for n = 1:length(N_values)
    for u = 1:length(U_values)
        for j = 1:iter
            if N_values(n)> U_values(u)+1
                resp = Simulation_th2y4([U_values(u), 100, 100, 100, 100, 100, 100, 100, 100, 100, 100], N_values(n), P_un, P_mu);
                resultados_totales(n, u, j) = resp.SSE_m_un;
            else
                 resultados_totales(n, u, j) = 0;
            end
        end
    end
end

% Calcular la media de los resultados
media_resultados = mean(resultados_totales, 3);

% Crear la gráfica 3D
figure;
%surf(N_values, U_values, real(media_resultados));
surf(U_values, N_values, media_resultados);
xlabel('Número de UT unicast "U"');
ylabel('Nümero de antenas "N"');
zlabel('SSE unicast (bps/Hz)');
%title('Gráfico 3D en función de N y U');


% Personalizar la vista de la gráfica
view(-5, 30);

% Añadir grid
grid on;

% Añadir transparencia a la superficie
alpha(0.9); % Valor entre 0 (totalmente transparente) y 1 (totalmente opaco)
