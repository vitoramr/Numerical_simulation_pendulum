// PME3200 Mecânica II Exercício 3 de Modelagem e Simulação Computacional

clc                  // limpa a tela
clear                // apaga a memória de todas as variáveis

//CONSTANTES
m = 0.1;             // Massa m em kg
g = 9.81;            // Aceleração da gravidade em m/s^2
L = 0.213;           // Comprimento l em metros
c = 0.002;           // Constante de dissipação angular viscosa em N*m*s/rad
f_1 = 2;             // Frequência natural do conjunto partícula/mola (Hz)
k = m*(2*f_1*%pi)^2  // Constante elástica da mola [N/m]
a = L - m*g/k        // É a posição de equilíbrio da mola
Mo = 0

//Geração do vetor de instantes de tempo para o integrador
t0 = 0.0;            // Instante de tempo inicial
tf = 10.0;           // Instante de tempo final
dt = 0.0025;           // Intervalo de tempo para obter 100 fps (intervalo de 1ms entre frames)
t = t0:dt:tf;        // Vetor de tempo indo de t0 a tf em intervalos dt

//Definição das condições iniciais
x0 = L;              // Posição inicial da partícula
teta0 = 1.5;         // Ângulo inicial da barra
xponto0 = 0;         // Velocidade inicial da partícula
tetaponto0 = 0.0;    // Velocidade angular inicial da barra

//Equação dinâmica do sistema declarada em espaço de estados

function dy = f(t,y)
    //A função retornará um vetor dy das derivadas de y, onde: 
    //y = [x; xponto; teta; tetaponto]
    //dy = [xponto;x2pontos;tetaponto;teta2pontos]
    
    x = y(1)
    xdot = y(2)
    teta = y(3)
    tetadot = y(4)
    
    dy(1) = xdot;
    dy(2) = x*(tetadot^2) - (k/m)*(x - a) + g*cos(teta);
    dy(3) = tetadot;
    dy(4) = (-2*m*x*xdot*tetadot - m*g*(x + L)*sin(teta) - (c*tetadot) + Mo)/(m*x^2+4*m*(L^2)/3);
endfunction

//Integração da função f para as condições iniciais yO, começando em t0 nos instantes t  
y0 = [x0; xponto0; teta0; tetaponto0];
y = ode(y0, t0, t, f);

//Declaração das variáveis do problema
x = y(1,:);
xponto = y(2,:);
teta = y(3,:);
tetaponto = y(4,:);

/*
//Plotagem dos gráficos
f1 = scf(1);
f1.figure_position = [0,0]
f1.figure_size=[1400,700]

subplot(3,2,1) //f2 = scf(2) //Se quiser o gráfico em janela separada
plot(t,x);
xtitle("Posição x em função do tempo");
xlabel ('tempo(s)')
ylabel ('Posição x (m)')
xgrid

//f3 = scf(3) //Se quiser o gráfico em janela separada
subplot(3,2,2)
plot(t,xponto);
xtitle("X ponto em função do tempo");
xlabel ('tempo(s)')
ylabel ('X ponto (m/s)')
xgrid

//f4 = scf(4) //Se quiser o gráfico em janela separada
subplot(3,2,3)
plot(t,teta);
xtitle("Teta em função do tempo");
xlabel ('tempo(s)')
ylabel ('Teta (rad)')
xgrid

//f5 = scf(5) //Se quiser o gráfico em janela separada
subplot(3,2,4)
plot(t,tetaponto);
xtitle("Teta ponto em função do tempo");
xlabel ('tempo(s)')
ylabel ('Teta ponto (rad/s)')
xgrid

//f6 = scf(6) //Se quiser o gráfico em janela separada
subplot(3,2,5)
plot(teta,tetaponto);
xtitle("Teta ponto em função de teta");
xlabel ('Teta(rad)')
ylabel ('Teta ponto (rad/s)')
xgrid

//f7 = scf(7) //Se quiser o gráfico em janela separada
subplot(3,2,6)
plot(x,xponto);
xtitle("X ponto em função de x");
xlabel ('x(m)')
ylabel ('X ponto (m/s)')
xgrid
*/

//JANELA PARA A ANIMAÇÃO
f8 = scf(8);
format(4); //Printa até 1 algarismo significativo para o título
xtitle("Movimento do sistema para x0 =" + string(x0) + "m, v0 =" + string(xponto0) + "m/s, teta0 =" + string(teta0) + "rad, w0 =" + string(tetaponto0)+"rad/s");
xlabel ('X(m)')
ylabel ('Y(m)')
isoview
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
Pf_barra = 2*L*[sin(teta(1)),-cos(teta(1))] //Pf = [Xfinal,Yfinal]
plot([0,Pf_barra(1)],[0,Pf_barra(2)], 'red');

barra_componentes = gce();
barra_componentes.children.thickness = 6;
barra_eixos = gca();
barra_eixos.data_bounds = [-2.2*L,-2.2*L;2.2*L,2.2*L];

//Desenhando a massa
Px = x(1)*[sin(teta(1)),-cos(teta(1))]
plot(Px(1),Px(2)) //Desenha o ponto da massa

massa_componentes = gce();
massa_componentes.children.mark_style = 0 //A massa é vista por um marcador redondo
massa_componentes.children.mark_size = 15;
massa_componentes.children.mark_foreground = 2;
massa_eixos = gca();
massa_eixos.data_bounds = [-2.2*L,-2.2*L;2.2*L,2.2*L]; //Define os limites do gráfico

//Loop da animação (atualiza-se as coordenadas para cada imagem)
i = 1;
while i<=length(t)
    drawlater();
    //Atualizando o tempo
    box_tempo.text = "t =" + string(t(i)) + "s";
    
    //Atualizando coordenadas da massa
    massa_componentes.children.data = x(i)*[sin(teta(i)),-cos(teta(i))];
    
    //Atualizando coordenadas da barra
    Pf_barra = 2*L*[sin(teta(i)),-cos(teta(i))] //Pf = [Xfinal,Yfinal]
    inicio_barra = [0 0];
    fim_barra = [Pf_barra(1) Pf_barra(2)];
    
    barra_componentes.children.data = [inicio_barra; fim_barra]
    
    drawnow();

    i = i+1;
end







