// animation_point.sce

clear; xdel(winsid());

// Create data
t = 0:0.005:1;    // Time data
x = sin(2*%pi*t); // Position data

// Draw initial figure
figure(1);
plot(x(1),0,'o');
h_compound = gce();
h_compound.children.mark_size = 20;
h_compound.children.mark_background = 2;
h_axes = gca();
h_axes.data_bounds = [-1.5,-1.5;1.5,1.5];

// Animation Loop
i = 1;
while i<=length(x)
    drawlater();
    h_compound.children.data = [x(i),0];
    drawnow();
    i = i+1;
end
