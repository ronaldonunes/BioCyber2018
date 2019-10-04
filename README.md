# **BiolCyber2019**

Nunes, Ronaldo V., Marcelo B. Reyes, and Raphael Y. De Camargo. "Evaluation of connectivity estimates using spiking neuronal network models." [Biological cybernetics](https://link.springer.com/article/10.1007%2Fs00422-019-00796-8) 113.3 (2019): 309-320.

## Simulation

The model simulates 5 spiking neuronal networks where the weights and number of connections within networks and between networks can be defined in the codes. The values of the parameters are the same used in the paper.

## Analysis 

It was analyzed the [GPDC](https://ieeexplore.ieee.org/document/4288544) between LFP signals generated for each spiking neuronal network. Besides that, it was verified the ROC curves to evaluate the relation between inference of effective connectivity and synaptic weight and noise. Finally, it was analyzed the relation between the peak of GPDC and coupling.

## Plot

The codes in this folder were used to create the paper figures. It is important to generate the analyzed data before running these codes or download the dataset used in the paper.

## Dependences

The analysis requires the mvar code from toolbox [AsymPDC](http://www.lcs.poli.usp.br/~baccala/pdc/). For some functions in plot folder, it is important to download the package [bondedline](https://github.com/kakearney/boundedline-pkg). 

## DataSet

The dataset used in the paper is avaliable in [Zenodo]()

## Key references


1. Izhikevich, Eugene M. "Simple model of spiking neurons." IEEE Transactions on neural networks 14.6 (2003): 1569-1572.
2. Baccalá, Luiz A., K. Sameshima, and D. Y. Takahashi. "Generalized partial directed coherence." 2007 15th International conference on digital signal processing. IEEE, 2007.
3. Sato, Joao R., et al. "Frequency domain connectivity identification: an application of partial directed coherence in fMRI." Human brain mapping 30.2 (2009): 452-461.
