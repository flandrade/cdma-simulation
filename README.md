# Simulation of CDMA communication system
This program simulates a basic CDMA communication system using Matlab. It includes the following components:

![Diagram](https://github.com/flandrade/cdma-simulation/blob/master/images/diagram.png)

**cdma.m** is the main file.

## Components and options

### Input voices
Four .wav files to simulate four users (variables x1, x2, x3 and x4). The program plots these input signals.

### Quantization
This program plots the first input signal with the levels of quantization and the quantized signal.

**nivel**: the number of levels for quantization.

**opcion**: quantization processes. Available options:
- 1 - Uniform
- 2 - Mu-Law
- 4 - A-Law

**errorcuantizacion**: quantization error.

### Multiple Access
**opt**: type of code for CDMA access. Available options:
- 1 = Orthogonal (Synchronous)
- 2 = Random (Asynchronous)

**gp**: GP value for correlation matrix.

### Modulation
BPSK modulation is performed.

### AWGN Channel
This module simulates a AWGN channel where noise is added to the communication.

**ebno**: Eb/N0. It is the energy per bit to noise power spectral density ratio. Value between 1 and 10, where 10 is for the least noisy channel.

## Output

### BER Curves  
This module uses a loop in order to simulate an AWGN channel with several Eb/N0 values (between 1 and 10)m and it plots the BER curve for the selected voice.

Demodulation and the division of users are performed in this loop.

**errorpe**: probability of error. It gives the average rate of occurrence of decoding errors.

### Final message
You can either select to play one user voice or all users voices. The program plots the output signal.

## Graphs

![Plots](https://github.com/flandrade/cdma-simulation/blob/master/images/plot.jpg)

### Acknowledgements
This program was developed during the communication course "Comunicación y codificación digital" at Universidad de las Fuerzas Armadas ESPE.
