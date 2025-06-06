[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/gbHItYk9)

## Project 00

### NeXTCS

### Period: 10

## Name0: Devon Fung

## Name1: Matthew Gultom

---

This project will be completed in phases. The first phase will be to work on this document. Use github-flavoured markdown. (For more markdown help [click here](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) or [here](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax) )

All projects will require the following:

- Researching new forces to implement.
- Method for each new force, returning a `PVector`  -- similar to `getGravity` and `getSpring` (using whatever parameters are necessary).
- A distinct demonstration for each individual force (including gravity and the spring force).
- A visual menu at the top providing information about which simulation is currently active and indicating whether movement is on or off.
- The ability to toggle movement on/off
- The ability to toggle bouncing on/off
- The user should be able to switch _between_ simluations using the number keys as follows:
  - `1`: Gravity
  - `2`: Spring Force
  - `3`: Drag
  - `4`: Custom Force
  - `5`: Combination

## Phase 0: Force Selection, Analysis & Plan

---------- 

#### Custom Force: Electrostatic force (w/ given electric field)

### Formula

What is the formula for your force? Including descriptions/definitions for the symbols. (You may include a picture of the formula if it is not easily typed.)

The formula for calculating the **electrostatic force** between two charges, $\vec{F_e}$, is as follows:

$$\vec{F_e} = \frac{kq_1q_2}{r^{2}}$$

* $k$ is coulomb's constant, which is $8.99\cdot10^{9}$ $\frac{\text{Nm}^{2}}{\text{C}^{2}}$
  
  * A coulomb is a unit of charge such that two objects with that charge one meter apart feel a force of $8.99\cdot10^{9}$ Newtons.

* $q_1$ and $q_2$ are the actual charges involved, both expressed in coulomb units ($\text{C}$).

* $r$ is the distance between the centers of $q_1$ and $q_2$.

* $\vec{F_e}$ is the electrostatic force, expressed in Newtons.

### Custom Force

- What information that is already present in the `Orb` or `OrbNode` classes does this force use?
  
  - The distance between the orbs, or orb nodes.

- Does this force require any new constants, if so what are they and what values will you try initially?
  
  - This force requires $k$, coulomb's constant, and the charges of the orbs, each expressed as $q$. The values of these constants are already explained in the equation above, so we will use the actual values in our project.

- Does this force require any new information to be added to the `Orb` class? If so, what is it and what data type will you use?
  
  - It requires that the orbs now have their own charges. We can simply use the `float` variable type to store the values of these charges, since they'll either be positive or negative.

- Does this force interact with other `Orbs`, or is it applied based on the environment?
  
  - The electrostatic force is a result of two orbs' charges, so yes, it would require interaction between the two of them.

- In order to calculate this force, do you need to perform extra intermediary calculations? If so, what?
  
  - The equation above will simply just calculate the electrostatic force for us.

---

### Simulation 1: Gravity

Describe how you will attempt to simulate orbital motion.

There will be a sun (`FixedOrb`) in the middle, which will exert a gravitational force between the "orbiting" orbs. The gravitational force formula ($\vec{F_g} =$ $\frac{Gm_1m_2}{r^2}$ $\hat{AB}$) will be used to calculate the force between the sun and each orb in the array.

This simulation will use an array of orbs.

--- 

### Simulation 2: Spring

Describe what your spring simulation will look like. Explain how it will be setup, and how it should behave while running.

Between each consecutive orb, springs will be used to pull together two orb nodes when stretched and push apart two orb nodes when compressed. There will be two fixed orb nodes, each on the left and right sides of the screen. The spring force formula ($\vec{F_{sp}} = k\Delta x$) will be used to calculate the force between the orb nodes connected by a spring.

This simulation will use a linked list of orb nodes.

--- 

### Simulation 3: Drag

Describe what your drag simulation will look like. Explain how it will be setup, and how it should behave while running.

There will be two planetary systems where the drag coefficient will be different: the usual Solar System and the Alpha Centauri System. The background color will be different for each planetary system, and there will be indicators on the screen for each system. The drag coefficient will affect the drag force being exerted on each orb, since the drag force formula ($$\vec{F}\_{drag} =$$ $$-\frac{1}{2}$$ $$\left|\vec{v}\right|^{2} C_{d} {\hat v}$$) is being used to calculate it. 

This simulation will use an array of orbs.

--- 

### Simulation 4: Custom force

Describe what your Custom force simulation will look like. Explain how it will be setup, and how it should behave while running.

Our custom force will be the electrostatic force between two charged orb nodes. Each orb node will be given a random charge (+/-) and will attract oppositely-charged orb nodes and repel same-charged orb nodes based on their distance from each other. The electrostatic force formula above will be used to calculate the force.  

The amount of charge that each orb node has, whether positive or negative, will be shown through their stroke color. A green stroke means that charge is positive and a red stroke means that charge is negative. It will be coded such that the shade of the stroke depends on the amount of charge that orb node has. For example, a more saturated and dark red shade means that charge has a high negative charge. A more light and closer to neon green shade means that charge has a high positive charge. Based on this, neutral charges will have a stroke color close to white. 

Orbs and orb nodes not in the electrostatic simulation (or combination simulation) will simply have a stroke color of white.

This simulation will use a linked list of orb nodes.

--- 

### Simulation 5: Combination

Describe what your combination simulation will look like. Explain how it will be setup, and how it should behave while running.

Our combination simulation will combine the spring, drag, and electrostatic simulations. Like the spring simulation, there will be two fixed orb nodes, each on the left and right sides of the screen. 

Since the drag simulation is involved now, each fixed orb node will be in a different planetary system. The connected orb nodes to that fixed orb node experiencing a different drag force due to the drag coefficient being different for each. 

The electrostatic force between the orb nodes will be applied as usual. 

This simulation will use a linked list of orbs.
