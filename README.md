# Simulation of CDMA communication system
This program simulates a basic CDMA communication system using Matlab. It includes the following components:

![Diagram](https://github.com/flandrade/cdma-simulation/blob/master/images/diagram.png)

**cdma.m** is the main file

## Components and options

### Input voices
Four .wav files to simulate four users (variables x1, x2, x3 and x4)

### Quantization
**nivel**: the number of levels for quantization.

**opcion**: quantization processes. Available options:
- 1 - Uniform
- 2 - Mu-Law
- 4 - A-Law

### Multiple Access
**opt**: type of code for CDMA access. Available options:
- 1 = Orthogonal (Synchronous)
- 2 = Random (Asynchronous)

**gp**: GP value for correlation matrix

## Output

### Receptor
You can either select to play one user voice or all users voices

## Graphs

![Plots](https://github.com/flandrade/cdma-simulation/blob/master/images/plot.jpg)

### Acknowledgements
This program was developed during the communication course "Comunicación y codificación digital" at Universidad de las Fuerzas Armadas ESPE.
