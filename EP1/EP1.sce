/*
Escola Politécnica da USP
Disciplina - PME3200 - Mecânica Geral II (2018)

Exercício de Simulação Numérica
Atividade 1 - Estudo do movimento de um pêndulo com massa fixa acoplada
Casos:
    - Pêndulo sem amortecimento
    - Pêndulo com amortecimento viscoso
    - Pêndulo com amortecimento viscoso e momento oscilatório de excitação
*/

//LIMPEZA DE AMBIENTE
clear;
clc;    // Limpeza de variáveis e do console
xdel(winsid()); // Fecha as janelas abertas

//CASOS ESTUDADOS
//caso = 'sem-amortecimento';
//caso = 'amortecido';
caso = 'amortecido-excitado';

// PARÂMETROS DO MODELO
m = 0.1;                 //Massa m em kg
g = 9.81;                //Aceleração da gravidade em m/s^2
L = 0.213;               //Comprimento da barra em metros
c = 0.002;               //Constante de dissipação angular viscosa em N*m*s/rad
Mo = 0.9;               //Magnitude do momento angular em N*m
wn = sqrt((6*g)/(7*L));  //Frequência natural do sistema em rad/s
wm = 1.0*wn;            //Frquência de excitação do momento externo
//wm = 0.1*wn;           //Com o mesmo momento, ao afastar sua frequência de excitação da frequência natural altera a influência da força no sistema
fi = 0;                  //Ângulo de fase da excitação em rad

//CONDICOES INICIAIS
//teta0 = %pi/180;         //Posição angular inicial da barra (rad)
teta0 = %pi - 0.01; // Item f e i
//teta_dot0 = 0.0;         //Velocidade angular inicial da barra (rad/s)
teta_dot0 = 5.0; // Item i
t0 = 0.0;                //Tempo inicial da simulação (s)
tf = 40;                 //Tempo final da simulação (s)
t = t0:0.01:tf; //Esse comando cria o vetor t, começando do t=0s até t=5s, com intervalos de 0.01s entre cada casa

//ESPAÇO DE ESTADOS
/* É um vetor utilizado para facilitar a integração no Scilab, pois, assim,
você só precisa utilizar uma ode para integrar o vetor. Sua forma é
esp = [teta
    teta_ponto]
*/

esp0 = [teta0
        teta_dot0];

function [desp_dt] = deriva(t,esp)
//Essa função recebe o teta e a velocidade angular, e calcula suas derivadas. Ela retorna um vetor
//Cuja primeira casa tem a sua velocidade angular atual e a segunda tem sua aceleração angular atual
    teta = esp(1,:);
    dteta_dt = esp(2,:);
    
    // Equações diferenciais do sistema
    if caso == 'sem-amortecimento' then
        d2teta_dt2 = -(6*g*sin(teta))/(7*L); // Caso sem amortecimento
    elseif caso == 'amortecido' then
        d2teta_dt2 = -(6*g*sin(teta))/(7*L)-(3*c*dteta_dt)/(7*m*L^2); // Caso amortecido
    elseif caso == 'amortecido-excitado' then
        d2teta_dt2 = -(6*g*sin(teta))/(7*L) -(3*c*dteta_dt)/(7*m*L^2) + Mo*sin(wm*t + fi); //Descomente para o caso amortecido e excitado
    end
    
    desp_dt = [dteta_dt; d2teta_dt2];
endfunction

/*A função ODE integra o vetor do espaço de estados desp_dt obtendo o vetor esp
que tem formato 
esp = [teta
teta_ponto]*/

esp = ode(esp0, t0, t, deriva);

teta = esp(1,:);
teta_dot = esp(2,:);

//GRÁFICOS
//Plotagem dos gráficos
//Gráfico da Teta x Tempo
f1 = scf(1);
    plot(t,teta);
    xtitle("Posição de Teta em função do tempo","t","teta");
    xlabel ('tempo(s)');
    ylabel ('Theta (rad)');

//Gráfico da Velocidade X Tempo
f2 = scf(2);
    plot(t,teta_dot);
    xtitle("Velocidade angular em função do tempo","t","w");
    xlabel ('tempo(s)');
    ylabel ('Velocidade angular (rad/s)');
    
f3 = scf(3);
    plot(teta,teta_dot);
    xtitle("Espaço de fases do sistema");
    xlabel ('Theta (rad)')
    ylabel ('Velocidade angular (rad/s)')

// Desenho da animação
f4 = scf(4); clf;
xtitle('Movimento do sistema para teta0 =' +string(teta0) + " rad e w0 = " + string(teta_dot0)+ ' rad/s.');
xlabel ('X(m)');
ylabel ('Y(m)');
isoview on
xgrid

//Desenhando figura inicial
//Desenhando a Origem
plot(0,0,'o');

//Desenhando a caixa do tempo
format(5); //Printa até 3 algarismos significativos para o tempo
xstring(L,1.85*L,"t =" + string(t(1)) + "s");
box_tempo = gce()
box_tempo.font_size = 3
box_tempo.box = "On"

//Desenhando a barra
Po_barra = [0,0]
Pf_barra = 2*L*[sin(teta(1)),-cos(teta(1))];
plot([Po_barra(1), Pf_barra(1)], [Po_barra(2), Pf_barra(2)], 'red');

barra_componentes = gce();
barra_pontos = barra_componentes.children;
barra_pontos.thickness = 6;
barra_eixos = gca();
barra_eixos.data_bounds = [-2.5*L,-2.5*L ; 2.5*L,2.5*L];
realtimeinit(0.02); // Tempo entre um frame e outro

//Loop da animação (atualiza-se as coordenadas para cada imagem)
i = 2;
N_t = length(t);

while (i <= N_t) then
    drawlater(); // Fixa a tela
    realtime(i);// Espera 0.1 segundos antes de desenhar a nova posição
    box_tempo.text = "t =" + string(t(i)) + "s";
    
    Pf_barra = 2*L*[sin(teta(i)),-cos(teta(i))];
    //Atualizando o gráfico
    barra_pontos.data=[Po_barra; Pf_barra];
    drawnow(); // Desenha a nova tela
    i = i+1;
end
