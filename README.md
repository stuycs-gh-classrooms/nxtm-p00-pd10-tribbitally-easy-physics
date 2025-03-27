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

$$\vec{F_e} = \frac{kq_1q_2}{r^2}$$

* $k$ is coulomb's constant, which is $\textstyle8.99 * 10^9\tfrac{\text{Nm}^2}{\text{C}^2}$
  
  * A coulomb is a unit of charge such that two objects with that charge one meter apart feel a force of $8.99 * 10^9$ Newtons.

* $q_1$ and $q_2$ are the actual charges involved, both expressed in coulomb units ($\text{C}$).

* $r$ is the distance between the centers of $q_1$ and $q_2$.

* $\vec{F_e}$ is the electrostatic force, expressed in Newtons.

The formula for calculating the **electric field**, $\vec{E}$, is as follows:

$$\left|\vec{E}\right| = \left|\frac{kQ}{r^2}\right|$$

* $k$ is coulomb's constant, which is $\textstyle8.99 * 10^9\tfrac{\text{Nm}^2}{\text{C}^2}$

* $Q$ is the charge creating the electric field (usually positive since $\vec{E}$ points out from positive charges, and into negative charges)

* $r$ is the distance between a given charge that experiences $\vec{E}$, and $Q$.



Remember that the $\vec{F_e}$ points in the opposite direction as $\vec{E}$. In addition, simply dividing $\vec{F_e}$ by $q$ will give you the value of $\vec{E}$.

### Custom Force

- What information that is already present in the `Orb` or `OrbNode` classes does this force use?
  
  - The distance between the orbs, or orb nodes.

- Does this force require any new constants, if so what are they and what values will you try initially?
  
  - This force requires $k$, coulomb's constant, and the charges of the orbs, each expressed as $q$. The values of these constants are already explained in the equations above.

- Does this force require any new information to be added to the `Orb` class? If so, what is it and what data type will you use?
  
  - It requires that the orbs now have their own charges. We can simply use the `int` variable type to store the values of these charges, since they'll either be positive or negative.

- Does this force interact with other `Orbs`, or is it applied based on the environment?
  
  - The electrostatic force is a result of two orbs' charges, so yes, it would require interaction between the two of them.

- In order to calculate this force, do you need to perform extra intermediary calculations? If so, what?
  
  - The equation above will simply just calculate the electrostatic force for us.

---

### Simulation 1: Gravity

Describe how you will attempt to simulate orbital motion.

We will use Gravity between two different orbs to pull these two orbs together when they move. Gravity will depend on the gravitational constant and the gravitational force formula.

--- 

### Simulation 2: Spring

Describe what your spring simulation will look like. Explain how it will be setup, and how it should behave while running.

Between each consecutive orb, springs will be used to pull together two orbs when stretched and push apart two orbs when compressed. The spring force will depend on the string constant. It will be setup with applyForce(getGravity(orb, g_constant)).

--- 

### Simulation 3: Drag

Describe what your drag simulation will look like. Explain how it will be setup, and how it should behave while running.

Drag will be used to dampen the motion of orbs as they travel through the space. It will be enacted through the applyForce function within the Orb class.

--- 

### Simulation 4: Custom force

Describe what your Custom force simulation will look like. Explain how it will be setup, and how it should behave while running.

Our custom force is Electrostatic force. Each orb will be given a random charge (+/-) and will attract oppositely-charged orbs and repel same-charged orbs based on its distance from the orb. We will apply an electrostatic field and use the applyForce function within the Orb class.

--- 

### Simulation 5: Combination

Describe what your combination simulation will look like. Explain how it will be setup, and how it should behave while running.

The combination of Spring, Drag, and Electrostatic force will show a mixture of attraction and repulsion from both Spring and Electrostatic. Drag will dampen the force of the other two. It will be applied with the applyForce method in the Orb class.
