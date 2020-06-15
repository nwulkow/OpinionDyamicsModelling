Copyright 2020, All Rights Reserved
Code by Niklas Wulkow
For Paper, "Memory-based reduced modeling and data-based estimation of opinion spreading"
by Niklas Wulkow, Peter Koltai and Christof Schuette

This toolbox contains two executable Matlab-scripts and several functions.
Detailed (mathematical) descriptions can be found in the paper (link to be added). 

The script "henonExtendedSINARExe.m" contains the methodology of section 4 of the paper:
The creation of a trajectory of an extended Hénon system and the subsequent recovery of parameters
and reconstruction of the trajectory with the SINAR algorithm (section 3 of the paper).

The script abmExe.m contains the code used for section 5 of the paper. This means:
- Creation of realisations of the agent-based model for the evolution of opinions
among members of a closed society
- Using SINAR for determination of model coefficients of a nonlinear autoregressive model (derivation
in section 2 of the paper) and reconstruction of evolutions of the opinion percentages with this model
- Plotting of results