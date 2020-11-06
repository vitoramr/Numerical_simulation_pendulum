/*
Escola Politécnica da USP
Disciplina - PME3200 - Mecânica Geral II (2018)

Exercício de Simulação Numérica
Atividade 2 - Estudo da colisão de um pêndulo com massa fixa acoplada

Casos:
    - Pêndulo sem amortecimento
    - Pêndulo com amortecimento viscoso
    - Pêndulo com amortecimento viscoso e momento oscilatório de excitação
*/


//LIMPEZA DE AMBIENTE
clear;
clc;    // Limpeza de variáveis e do console
xdel(winsid()); // Fecha as janelas abertas

// PARÂMETROS DA ANIMAÇÃO
save_frames = %F   // Setar save frames para %T para salvar os frames em ".gif"
frame_rate = 40;   // Taxa de frames por segundo (não utilizado quando a opção salvar como gif está ativa)
save_directory = 'Frames'

//PARÂMETROS DO SISTEMA
m = 0.1;                        //Massa m em kg
g = 9.81;                       //Aceleração da gravidade em m/s^2
L = 0.213;                      //Comprimento da barra em metros
c = 0.01;                       //Constante de dissipação angular viscosa em N*m*s/rad
Momento = 0
//Momento = 0.03                  //Magnitude do momento angular em N*m (ATUALIZE O MOMENTO NESSA VARIÁVEL)
t_momento = 5;                  //Tempo em que o momento começa a ser aplicado (s)
wn = sqrt((9*g)/(16*L));        //Frequência angular natural (rad/s)
wm = 1*wn;                      //Frquência de excitação (rad/s)
fi = 0;                         //Ângulo de fase da excitação em rad
teta_lim = -(%pi)/8             //Ângulo do batente em rad
e = 0.8                         //Coeficiente de restituição da colisão

// CONSTANTES
Mo = 0.0;                       //Váriavel usada para o momento (OBS: Não atualize esse valor, atualize em "Momento")
dt = 0.05;                     //Espaçamento de tempo em s

//CONDICOES INICIAIS
teta0 = %pi - 0.001;            //Posição angular inicial da barra
//teta0 = 0                  
teta_dot0 = 0;                 //Velocidade angular inicial da barra
t0 = 0.0;                      //Tempo inicial da simulação
tf = 10;                       //Tempo final da simulação

// VARIÁVEIS PARA SALVAR OS FRAMES
base_path = pwd(); // Diretório atual onde o Scilab está aberto
s = filesep();     // Separador de arquivos para o OS atual ( '\' para Windows e '/' para Linux)
frames_directory = base_path + s + save_directory;

//FUNÇÕES

//Equações diferenciais do sistema
function [z_dot] = deriva(t,z)
/*Essa função recebe o teta e o teta ponto, e calcula suas derivadas. Portanto, ela retorna um vetor cuja primeira
casa contém a sua velocidade angular (teta ponto) e a segunda contém a sua aceleração angular (teta dois pontos)
*/
    teta = z(1,:);
    teta_dot = z(2,:);
    dteta_dt = teta_dot;
    if t >= t_momento then
        Mo = Momento; //Atualizar aqui o valor do momento que passa a ser aplicado em t = t_momento
    end
    
    d2teta_dt2 = -(9*g*sin(teta))/(16*L) - (3/(16*m*L^2))*c*teta_dot + (3/(16*m*L^2))*Mo*sin(wm*t+fi);
    z_dot = [dteta_dt; d2teta_dt2];
endfunction

//Função que limita o integrador até o momento do choque, quando "colide" == 0
function [colide] = raiz(t,z)
    colide = z(1) - teta_lim;
endfunction

//O vetor geral do movimento é o vetor z, t
z = []
t = []
z0_mov = [teta0; teta_dot0]
t0_mov = t0
t_choque = 0;

//Programa
while t_choque ~= tf //Enquanto ele não chega no tempo final, ele continua colidindo
    t_mov = t0_mov:dt:tf
    
    //Integra até a colisão
    [z_mov rd] = ode('root',z0_mov,t0_mov,t_mov,deriva,1,raiz);
    
    t_choque = rd(1,1) //É o tempo em que ocorre a colisão
    [linhas n_mov] = size(z_mov);
    
    if t_choque //Se colidiu, então
        // Armazenando o vetor de tempo até o choque
        t_mov(n_mov) = t_choque;
        t_mov = t_mov(1:n_mov);
        
        //Atualiza-se os valores iniciais para o próximo movimento
        t0_mov = t_choque;
        teta_dot_choque = (-e)*(z_mov(2,n_mov));
        z0_mov = [teta_lim; teta_dot_choque];
    else //Se não colidiu, t_choque = tf para o fim do loop
        t_choque = tf
    end
    
    //Agora, concatena-se esse vetor entre choques aos vetores z e t gerais do movimento
    z = [z,z_mov];
    t = [t,t_mov];
end

// Separação das variáveis do sistema
teta = z(1,:);
teta_dot = z(2,:);

// Cálclo de energia
Ec = ((16*m*L^2)/6)*z(2,:)^2; // Vetor da energia cinética do movimento
Ep = 3*m*g*L*(1 - cos(z(1,:))); // Vetor da energia potencial do movimento
Et = Ec + Ep // Vetor da energia total do movimento

// Aceleração angular é a derivada da velocidade angular
alfa = diff(z(2,:))

//GRÁFICOS
//Plotagem dos gráficos
//Gráfico de Teta x Tempo
f1 = scf(1);
plot(t,teta);
plot(t,linspace(teta_lim,teta_lim,length(t)),"g") //Plotando a linha do batente
xtitle("Posição angular em função do tempo","t","teta");
xlabel ('Tempo(s)')
ylabel ('Teta (rad)')
xgrid
h1 = legend(['Posição do pêndulo';'Posição do batente'],1)


//Gráfico de Teta ponto X Tempo
f2 = scf(2);
plot(t,teta_dot);
xtitle("Velocidade angular em função do tempo","t","w");
xlabel ('Tempo(s)')
ylabel ('Velocidade angular (rad/s)')
xgrid

//Gráfico de Teta x Teta ponto
f3 = scf(3);
plot(teta,teta_dot);
xtitle("Espaço de fases do sistema");
xlabel ('Teta (rad)')
ylabel ('Velocidade angular (rad/s)')
xgrid

f4 = scf(4);
plot(t,Ec(1,:),"b");
plot(t,Ep(1,:),"r");
plot(t,Et(1,:),"g");
xlabel ('Tempo(s)')
ylabel ('Energia (J)');
h4 = legend(['Energia cinética';'Energia potencial';'Energia Mecânica'],1)

f5 = scf(5);
plot(t(2:length(t)),alfa);
xtitle("Aceleração angular em função do tempo","t","Alfa (rad/s^2");
xlabel ('Tempo(s)')
ylabel ('Teta (rad)')
xgrid


// Desenho da animação
f8 = scf(8);
format(4); //Printa até 1 algarismo significativo para o título
xtitle("Movimento do sistema para teta0 =" + string(teta0) + "rad, w0 =" + string(teta_dot0)+"rad/s");
xlabel ('X(m)')
ylabel ('Y(m)')
isoview
xgrid

//Desenhando figura inicial
//Desenhando a Origem
plot(0,0,'o');
//Desenhando o Batente
plot(2*L*sin(teta_lim), -2*L*cos(teta_lim),'d>')

//Desenhando a caixa do tempo
format(5); //Printa até 3 algarismos significativos para o tempo
xstring(L,1.85*L,"t =" + string(t(1)) + "s");
box_tempo = gce()
box_tempo.font_size = 3
box_tempo.box = "On"

//Desenhando a barra
Po_barra = [0,0]
Pf_barra = 2*L*[sin(teta(1)),-cos(teta(1))];
plot([Po_barra(1),Pf_barra(1)],[Po_barra(2),Pf_barra(2)], 'red');

barra_componentes = gce();
barra_pontos = barra_componentes.children;
barra_pontos.thickness = 6;
barra_eixos = gca();
barra_eixos.data_bounds = [-2.5*L,-2.5*L ; 2.5*L,2.5*L];
realtimeinit(0.1); // Tempo entre um frame e outro

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


