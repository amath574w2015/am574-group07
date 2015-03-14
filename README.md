# am574-group07

## Title:

Models of Traffic Flow with Discontinuous and Non-convex Flux

## Abstract: 

In this project, we investigate two models of traffic flow based on Lighthill-Whitham-Richards model. In the first part, we look into the model of traffic flow on freeway, where the flux function is discontinuous and piecewise linear. We utilize the method of mollification to smooth out the discontinuity, and construct the convex hull to solve the problem. Additionally, a numerical PDE solver in CLAWPACK and a ODE solver of car-following model are designed to simulate the results. In the second part, the car-following model of night-time driving is explored. With or without perturbing the velocities, we could observe the instability and clustering of cars with uniform initial density.

## Final paper:

* [Paper.pdf](Paper/Paper.pdf)

## Codes:

CLAWPACK codes can be found in the folder Free_Way_PDE. 

Car-following codes can be found in presentation file:

* [presentation.ipynb](presentation/presentation.ipynb)

## Presentation:

* [Slides](presentation/presentation.slides.html)

Note:

Reveal.js (please do "git checkout 2.6.2") is needed for our slides: 

https://github.com/hakimel/reveal.js
