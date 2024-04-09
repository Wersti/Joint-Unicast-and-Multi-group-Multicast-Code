function resultados = Simulation_th1y3(tam_grupos, N, P_un, P_mu,R)

    %% Definición de Parámetros conocidos
    % P_un potencia asignada para unicast
    % P_mu potencia asignada para multicast
    % R Radio del espacio de simulación
    if nargin < 5
        % Asignar un valor predeterminado si no se proporciona R
        R = 500;
    end
    
    d_min = 35; % Radio de la distancia mínima de simulación
    T = 200;    % Intervalo de coherencia de T símbolos, T = C_b*C_T (coherence bandwith, coherence time)

    E_jk  = 0.1*200/(20*10^6*10^((-174-30)/10)); % Energía de los terminales multicast
    E_m   = 0.1*200/(20*10^6*10^((-174-30)/10)); % Energía de los terminales unicast


    P_normalizada = P_un + P_mu; % Potencia total de la BS

    %% Simulación de los grupos de usuarios
    num_grupos = length(tam_grupos);
    distancias_grupos = cell(1, num_grupos);
    
    for i = 1:num_grupos 

        theta = 2 * pi * rand(1, tam_grupos(i));
        r = d_min + (R - d_min) * sqrt(rand(1, tam_grupos(i)));

        x = r .* cos(theta);
        y = r .* sin(theta);

        distancia_desde_el_centro = sqrt(x.^2 + y.^2);
        distancias_grupos{i} = distancia_desde_el_centro;
    end

    beta_u = 10^(-3.5)./(distancias_grupos{1}.^3.76);
    eta_g = cell(num_grupos-1, 1);
    for i = 1:(num_grupos-1)
        eta_g{i} = 10^(-3.5)./(distancias_grupos{i+1}.^3.76);
    end

    %% Cálculos teorema 1

    Y_j = cell2mat(cellfun(@(j) min(((E_jk*j.^2)./(1+j*P_normalizada))), eta_g, 'UniformOutput', false));

    x_jk_opt = cell(num_grupos-1, 1);
    for j = 1:(num_grupos-1)
        x_jk_opt{j} = ((1+eta_g{j}*P_normalizada)./(eta_g{j}.^2)) * Y_j(j);
    end

    Sum = 0;
    for j = 1:(num_grupos-1)
        Sum = Sum + sum (1./eta_g{j});
    end

    tao_opt = tam_grupos(1)+num_grupos-1;
    TAO = (N*P_mu)/(sum(1./Y_j)+Sum+P_normalizada*(sum(tam_grupos)-tam_grupos(1)));

    q_up_opt = cell(num_grupos-1, 1);
    for j = 1:(num_grupos-1)
        q_up_opt{j} = ((1+eta_g{j}*P_normalizada)./(eta_g{j}.^2)) * Y_j(j);
    end

    q_dl_opt = zeros(num_grupos-1, 1);
    for j = 1:(num_grupos-1)
        q_up_opt_cell = q_up_opt{j};  % Convertir q_up_opt{j} en un cell array
        q_dl_opt(j) = TAO/(N*Y_j(j))*(1+sum(x_jk_opt{j}.*eta_g{j}));
    end

    SE_jk_mu = (1 - (tao_opt)/T)*log2(1+TAO);
    

    %% Cálculos teorema 3
    p_up_opt = E_m/tao_opt;
    alpha_m = 1;
    %v = 3.76;
    v_m_opt = (E_m*beta_u.^2)./(1 + E_m*beta_u);
    F = (1+beta_u*P_normalizada)./(N*v_m_opt);
    %p_dl_opt = max([0, alpha_m./(v*log(2))-(1+beta_u*P_normalizada)./(N*v_m_opt)]); 

    p_dl_opt = water_fill(P_un, F); % Aplicar el algoritmo de Water filling
    SSE_m_un = (1-tao_opt/T)*sum(alpha_m*log2(1+(N*p_dl_opt.*v_m_opt)./(1+beta_u*P_normalizada)));

    % Devolver los resultados en una estructura
    resultados.SE_jk_mu = real(SE_jk_mu);
    resultados.SSE_m_un = real(SSE_m_un);

    % Si deseas verificar y establecer resultados negativos a cero, puedes utilizar:
    % resultados.SE_jk_mu = max(0, real(SE_jk_mu));
    % resultados.SSE_m_un = max(0, real(SSE_m_un));
