function resultados = Simulation_th2y4(tam_grupos, N, P_un, P_mu, R)
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

    E_jk  = 0.1*200/(20*10^6*10^((-174-30)/10));
    E_m  = 0.1*200/(20*10^6*10^((-174-30)/10));

    P_normalizada = P_un + P_mu;

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

    beta_u = (10^(-3.5))./(distancias_grupos{1}.^3.76);
    eta_g = cell(num_grupos-1, 1);
    for i = 1:(num_grupos-1)
        eta_g{i} = (10^(-3.5))./(distancias_grupos{i+1}.^3.76);
    end

    %% Cálculos teorema 2
    Y_j = cell2mat(cellfun(@(j) min(((E_jk*j.^2)./(1+j*P_normalizada))), eta_g, 'UniformOutput', false));

    B_j = 1./Y_j;
    for j = 1:(num_grupos-1)
        B_j(j) = B_j(j) + sum(1./eta_g{j})+tam_grupos(j+1)*P_normalizada;
    end

    Sum = 0;
    for j = 1:(num_grupos-1)
        Sum = Sum + sum(1./eta_g{j});
    end

    tao_opt = tam_grupos(1)+num_grupos-1;

    TAO = ((N-tao_opt)*P_mu)/(sum(1./Y_j)+Sum+P_normalizada*(sum(tam_grupos)-tam_grupos(1))-P_normalizada*(num_grupos-1));

    q_up_opt = cell(num_grupos-1,1);
    for j = 1:(num_grupos-1)
        q_up_opt = (1+eta_g{j}*P_normalizada)./(tao_opt*eta_g{j}.^2)*Y_j(j);
    end

    q_dl_opt = zeros(num_grupos-1);
    for j = 1:(num_grupos-1)
        q_dl_opt(j) = sum((B_j-P_normalizada)./(B_j(j)-P_normalizada)).^(-1)*P_mu;
    end

    SE_jk_mu = (1 - (tao_opt)/T)*log2(1+TAO);

    %% Cálculos teorema 4
    p_up_opt = E_m/tao_opt;
    alpha_m = 1; % Son los pesos de los usuarios , para unicast es de 1 

    v_m_opt = (E_m*beta_u.^2)./(1 + E_m*beta_u);
    F = (1+(beta_u-v_m_opt)*P_normalizada)./((N-tao_opt)*v_m_opt);
    p_dl_opt = water_fill(P_un,F);

    SSE_m_un = (1-tao_opt/T)*sum(alpha_m*log2(1+((N-tao_opt)*p_dl_opt.*v_m_opt)./(1+(beta_u-v_m_opt)*P_normalizada)));

    % Devolver los resultados en una estructura
    resultados.SE_jk_mu = real(SE_jk_mu);
    resultados.SSE_m_un = real(SSE_m_un);

    % Si deseas verificar y establecer resultados negativos a cero, puedes utilizar:
    % resultados.SE_jk_mu = max(0, real(SE_jk_mu));
    % resultados.SSE_m_un = max(0, real(SSE_m_un));
end
