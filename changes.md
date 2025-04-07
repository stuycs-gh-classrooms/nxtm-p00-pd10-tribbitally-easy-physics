Here are some of the changes we made from the original:
* Refactored code to actually represent five different simulations instead of just one with toggles
* Refactored driver file to reorganize toggle elements
* Added two fixed orbs to spring and combination simulations since that's required for the spring simulation
* Changed background and environment to represent a solar system
* Added different solar system named Alpha Centauri (a real solar system that's the closest one to ours) with different drag coefficient for drag simulation (since that's required for the drag simulation)
* Gave up on implementing electric field/electric field lines, so we just scrapped that feature
* Refactored code to not show simulation-specific properties in other simulations (i.e. displaying charge stroke color in simulations other than the electrostatic and combination sims, for the others it's just set to white; etc.)
