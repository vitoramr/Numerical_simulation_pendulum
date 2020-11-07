# Numerical simulation of a pendulum
## Escola Politécnica da Universidade de São Paulo
### PME 3200 - General mechanics II

These programs were developed on *Scilab 6.1*, a open source software for numerical computation that can be downloaded on the [software's website](https://www.scilab.org/).

The codes were conceived while I was monitor of the subject "PME 3200 - General mechanics II". The goals of these exercises were to teach the students enrolled at the subject concepts such as: mechanical systems modelling, states vector, numerical solving of ODEs, as well as the interactions on systems with multiple degrees of freedom.

The exercises consists on the modelling of a pendulum and at each exercise more complex mechanical interactions were added to the system, accordingly to the topics the students were learning. The first exercise consists of a pendulum with viscous friction and an oscillating external momentum. On the following exercise, collision was added, and the pendulum collides with a wall at a given angle with a coefficient of restitution. At last, the mass, which was fixed to the pendulum, was replaced by a mass with a spring attached to the pendulum's joint and the system gained an additional degree of freedom.

The model images of each exercise are listed below.

### 1st Exercise (EP1)


The first exercise consists of a pendulum with a mass attached to the middle of its lenght. The forces acting in the pendulum are the gravity weight, a friction viscous moment and an external oscillating momentum.

<p align="center">
  <img width="200" src="https://github.com/vitoramr/Numerical_simulation_pendulum/blob/main/EP1/Model_EP1.PNG" alt="EP2 Model"/>
</p>

The model's state variables are:
- ![theta](https://latex.codecogs.com/gif.latex?%5Ctheta%28t%29%20%3D%20%5Ctext%7BPendulum%20angular%20position%20%5Brad%5D%7D)
- ![theta dot](https://latex.codecogs.com/gif.latex?%5Cdot%7B%5Ctheta%7D%28t%29%20%3D%20%5Ctext%7BPendulum%20angular%20velocity%20%5Brad/s%5D%7D)

The model's parameters are:

- ![theta0](https://latex.codecogs.com/gif.latex?%5Ctheta_0) = Initial angular position [rad]
- ![theta dot 0](https://latex.codecogs.com/gif.latex?%5Cdot%7B%5Ctheta%7D_0) = Initial angular velocity [rad/s]
- ![t0](https://latex.codecogs.com/gif.latex?t_0) = Initial time of the simulation [s]
- ![tf](https://latex.codecogs.com/gif.latex?t_f) = Final time of the simulation [s]
- *m* = Mass of the fixed body [kg]
- *L* = Pendulum length [m]
- *c* = Viscous angular friction coefficient [Nms/rad]
- ![Momentum](https://latex.codecogs.com/gif.latex?M%5E%7Bext%7D%20%3D%20M_o%20%5Ccdot%20%5Csin%20%28%5Comega_m%20t%20&plus;%20%5Cphi%29) = Oscillating external momentum [Nm]
- *Mo* = Momentum amplitude [Nm]
- ![Omega m](https://latex.codecogs.com/gif.latex?%5Comega_m) = Momentum oscillating frequency [rad/s]
- ![Phi](https://latex.codecogs.com/gif.latex?%5Cphi) = Momentum initial fase [rad/s]

### 2st Exercise (EP2)

The second exercise uses a model similar to the first one. The difference is that the fixed body is attached to the edge of the pendulum and there is a wall that stops the pendulum from advancing to the left. Hence, the collision between the pendulum and the wall has also to be dealt with.

<p align="center">
  <img width="200" src="https://github.com/vitoramr/Numerical_simulation_pendulum/blob/main/EP2/Model_EP2.PNG" alt="EP2 Model"/>
</p>

The additional parameters for the second model are:
- ![theta lim](https://latex.codecogs.com/gif.latex?%5Ctheta_%7Blim%7D%20%3D%20-%5Cpi/8) = Wall angular position [rad]
- *e* = Coefficient of restitution
- ![tm](https://latex.codecogs.com/gif.latex?t_m) = Initial time for the momentum activation [s]


### 3st Exercise (EP3)

<p align="center">
  <img width="200" src="https://github.com/vitoramr/Numerical_simulation_pendulum/blob/main/EP3/Model_EP3.PNG" alt="EP3 Model"/>
</p>

The final exercise added a spring between the mass and the pendulum joint, in a manner that the mass is still dragged by the pendulum, while moving relatively to it.

Therefore, the model gains an additional degree of freedom and the states vector is now described by:
- ![space vector](https://latex.codecogs.com/gif.latex?%5Cboldsymbol%7Bx%7D%20%3D%20%5Cbegin%7Bbmatrix%7D%20x%28t%29%5C%5C%20%5Cdot%7Bx%7D%28t%29%5C%5C%20%5Ctheta%28t%29%5C%5C%20%5Cdot%7B%5Ctheta%7D%28t%29%20%5Cend%7Bbmatrix%7D)

Where *x* represents the position of the body relative to the pendulum (in m).

The video with the result of a simulation can be [downloaded here](https://github.com/vitoramr/Numerical_simulation_pendulum/blob/main/EP3/EP3_Vid.mp4?raw=true).

