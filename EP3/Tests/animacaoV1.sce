// Desenhando a figura inicial

//Orgigem
O = [0 0]
plot(O(1),O(2),"o")
L = 1
a=gca() //obtendo o manipulador dos novos eixos criados
a.data_bounds=[-1.1*L,-1.1*L;1.1*L,1.1*L]; //Os extremos do gráfico

//Desenhando a barra
Pf_barra = L*[sin(teta(1)),-cos(teta(1))] //Pf = [Xfinal,Yfinal]
plot([O(1),Pf_barra(1)],[O(2),Pf_barra(2)], 'red');
plot_barra = gce();
plot_barra.children.thickness = 4;

//Desenhando a massa
Px = x(1)*[sin(teta(1)),-cos(teta(1))]
plot(Px(1),Px(2),"o") //Desenha uma linha de O até Pf
massa_plot = gce();
massa_plot.children.mark_size = 20;
massa_plot.children.thickness = 1;

//Loop para a animação
i = 1
while i <= length(t)
    drawlater();
    
    //Informações da massa
    massa_plot.children.data = x(i)*[sin(teta(i)),-cos(teta(i))]
    
    //Informações da barra
    Pf_barra = L*[sin(teta(i)),-cos(teta(i))] //Pf = [Xfinal,Yfinal]
    x_barra = [0 Pf_barra(1)];
    y_barra = [0 Pf_barra(2)];
    
    plot_barra.children.data = [x_barra; y_barra];
    
    drawnow();
    
    i = i+1;
end
