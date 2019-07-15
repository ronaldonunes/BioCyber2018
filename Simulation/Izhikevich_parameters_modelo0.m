%% izhikevich_parameters_model0
% 
%  Set the parameters for model 0[1]
%
%% Syntax
%
%  [N,Ne,Ni,pesos,qtd,D,inputExt,parameters]=Izhikevich_parameters_modelo0(qtd_ex,W_ex)  
%
%% Arguments
%
%    Input:
%
%    qtd_ex        Number of long-range excitatory connections E->E 
%    W_ex          Synpatic weights long-range excitatory connections E->E
%
%    Output: 
%   
%    N              Total number of neurons in each network
%    Ne             Number of excitatory neurons in each network     
%    Ni             Number of inhibitory neurons in each network 
%    pesos          Struct with synaptic weights
%    qtd            Struct with quantity of connections
%    D              Struct with delays   
%    inputExt       External input
%    parameters    Struct with network parameters
%
%% Description
%
%   This function sets the parameters for simulation of model 0 [1,2].
%   Model 0 is composed of five isolated networks (without long-range
%   connections)
%
%   Autor: Ronaldo Nunes (ronaldovnunes@gmail.com)
%% References
%
% [1] Izhikevich, Eugene M. "Simple model of spiking neurons." IEEE Transactions 
%     on neural networks 14.6 (2003): 1569-1572.
% [2] Nunes, Ronaldo V., Marcelo B. Reyes, and Raphael Y. De Camargo. 
%     "Evaluation of connectivity estimates using spiking neuronal 
%     network models." Biological cybernetics 113.3 (2019): 309-320.

function [N,Ne,Ni,pesos,qtd,D,inputExt,parameters]=Izhikevich_parameters_modelo0(qtd_ex,W_ex)    
  %% General parameters
    parameters.numRedes=5; % number of networks 
    parameters.T=2*10^5; % Steps (Time in ms=T*dt)  
    parameters.dt=0.05; % integration step (ms)
    parameters.E_ex=0.0; % reversal potential for excitatory synapses (mV)
    parameters.E_in=-80.0; % reversal potential for inhibitory synapses (mV)
    parameters.tau_gaba1=[6.0 6.0 6.0 6.0 6.0]; % time constant  GABA (ms)
    parameters.tau_gaba2=[1.0 1.0 1.0 1.0 1.0]; % time constant GABA (ms)
    parameters.tau_ampa1=[5.0 5.0 5.0 5.0 5.0]; % time constant AMPA (ms) 
    parameters.tau_ampa2=[5.0 5.0 5.0 5.0 5.0]; % time constant AMPA (ms)
    parameters.tau_ext1=[5.0 5.0 5.0 5.0 5.0];  % time constant AMPA external input (ms)
    parameters.tau_ext2=[5.0 5.0 5.0 5.0 5.0];  % time constant AMPA external input (ms)
    parameters.v_ini=-65.0;     % initial value of membrane potential (mV)
    parameters.v_crit=30.0;     % threshold of membrane potential (mV)        

    %% Number of neurons

    % Network 1
    N.Rede(1)=10^3; 

    % Network 2
    N.Rede(2)=10^3; 

    % Network 3
    N.Rede(3)=10^3;

    % Network 4
    N.Rede(4)=10^3;

    % Network 5
    N.Rede(5)=10^3;

    % Number of excitatory and inhibitory neurons
    for i=1:parameters.numRedes
        Ne.Rede(i)=0.8*N.Rede(i); % 80% excitatory 
        Ni.Rede(i)=0.2*N.Rede(i); % 20% inhibitory
    end


    %% Poisson 
    parameters.spikeRatePoisson=nan(1,parameters.numRedes);

    % Network 1 - Poisson 10 Hz
    parameters.spikeRatePoisson(1)=10.0;  %(spikes/s)

    % Network 2 - Poisson 10 Hz
    parameters.spikeRatePoisson(2)=10.0;  %(spikes/s)

    % Network 3 - Poisson 10 Hz
    parameters.spikeRatePoisson(3)=10.0;  %(spikes/s)

    % Network 4 - Poisson 10 Hz
    parameters.spikeRatePoisson(4)=10.0;  %(spikes/s)

    % Network 5 - Poisson 10 Hz
    parameters.spikeRatePoisson(5)=10.0;  %(spikes/s)

    %% Synaptic weight of external input
    
    % Network 1
    inputExt.XE.Rede(1)=1.2;
    inputExt.XI.Rede(1)=1.1; 

    % Network 2
    inputExt.XE.Rede(2)=1.2; 
    inputExt.XI.Rede(2)=1.1; 

    % Network 3
    inputExt.XE.Rede(3)=1.2; 
    inputExt.XI.Rede(3)=1.1;

    % Network 4
    inputExt.XE.Rede(4)=1.2; 
    inputExt.XI.Rede(4)=1.1;

    % Network 5
    inputExt.XE.Rede(5)=1.2; 
    inputExt.XI.Rede(5)=1.1;

    %% Delays 

    % Delays for connections Network 1 -> Network 1
    D.Rede(1,1).Dmin.EE=1/parameters.dt; 
    D.Rede(1,1).Dmin.EI=1/parameters.dt;
    D.Rede(1,1).Dmin.IE=1/parameters.dt;
    D.Rede(1,1).Dmin.II=1/parameters.dt;
    D.Rede(1,1).Dmax.EE=10/parameters.dt;
    D.Rede(1,1).Dmax.EI=5/parameters.dt;   
    D.Rede(1,1).Dmax.IE=1/parameters.dt;
    D.Rede(1,1).Dmax.II=1/parameters.dt;

    % Delays for connections Network 2 -> Network 2
    D.Rede(2,2).Dmin.EE=1/parameters.dt;
    D.Rede(2,2).Dmin.EI=1/parameters.dt;
    D.Rede(2,2).Dmin.IE=1/parameters.dt;
    D.Rede(2,2).Dmin.II=1/parameters.dt;
    D.Rede(2,2).Dmax.EE=10/parameters.dt;
    D.Rede(2,2).Dmax.EI=5/parameters.dt;
    D.Rede(2,2).Dmax.IE=1/parameters.dt;
    D.Rede(2,2).Dmax.II=1/parameters.dt;

    % Delays for connections Network 3 -> Network 3
    D.Rede(3,3).Dmin.EE=1/parameters.dt;
    D.Rede(3,3).Dmin.EI=1/parameters.dt;
    D.Rede(3,3).Dmin.IE=1/parameters.dt;
    D.Rede(3,3).Dmin.II=1/parameters.dt;
    D.Rede(3,3).Dmax.EE=10/parameters.dt;
    D.Rede(3,3).Dmax.EI=5/parameters.dt;
    D.Rede(3,3).Dmax.IE=1/parameters.dt;
    D.Rede(3,3).Dmax.II=1/parameters.dt;

    % Delays for connections Network 4 -> Network 4
    D.Rede(4,4).Dmin.EE=1/parameters.dt;
    D.Rede(4,4).Dmin.EI=1/parameters.dt;
    D.Rede(4,4).Dmin.IE=1/parameters.dt;
    D.Rede(4,4).Dmin.II=1/parameters.dt;
    D.Rede(4,4).Dmax.EE=10/parameters.dt;
    D.Rede(4,4).Dmax.EI=5/parameters.dt;
    D.Rede(4,4).Dmax.IE=1/parameters.dt;
    D.Rede(4,4).Dmax.II=1/parameters.dt;

    % Delays for connections Network 5 -> Network 5
    D.Rede(5,5).Dmin.EE=1/parameters.dt;
    D.Rede(5,5).Dmin.EI=1/parameters.dt;
    D.Rede(5,5).Dmin.IE=1/parameters.dt;
    D.Rede(5,5).Dmin.II=1/parameters.dt;
    D.Rede(5,5).Dmax.EE=10/parameters.dt;
    D.Rede(5,5).Dmax.EI=5/parameters.dt;
    D.Rede(5,5).Dmax.IE=1/parameters.dt;
    D.Rede(5,5).Dmax.II=1/parameters.dt;

    % Delays for connections Network 1 -> Network 2
    D.Rede(2,1).Dmin.EE=15/parameters.dt;
    D.Rede(2,1).Dmin.EI=15/parameters.dt;
    D.Rede(2,1).Dmin.IE=15/parameters.dt;
    D.Rede(2,1).Dmin.II=15/parameters.dt;
    D.Rede(2,1).Dmax.EE=15/parameters.dt;
    D.Rede(2,1).Dmax.EI=15/parameters.dt;
    D.Rede(2,1).Dmax.IE=15/parameters.dt;
    D.Rede(2,1).Dmax.II=15/parameters.dt;

    % Delays for connections Network 1 -> Network 3
    D.Rede(3,1).Dmin.EE=15/parameters.dt;
    D.Rede(3,1).Dmin.EI=15/parameters.dt;
    D.Rede(3,1).Dmin.IE=15/parameters.dt;
    D.Rede(3,1).Dmin.II=15/parameters.dt;
    D.Rede(3,1).Dmax.EE=15/parameters.dt;
    D.Rede(3,1).Dmax.EI=15/parameters.dt;
    D.Rede(3,1).Dmax.IE=15/parameters.dt;
    D.Rede(3,1).Dmax.II=15/parameters.dt;

    % Delays for connections Network 1 -> Network 4
    D.Rede(4,1).Dmin.EE=15/parameters.dt;
    D.Rede(4,1).Dmin.EI=15/parameters.dt;
    D.Rede(4,1).Dmin.IE=15/parameters.dt;
    D.Rede(4,1).Dmin.II=15/parameters.dt;
    D.Rede(4,1).Dmax.EE=15/parameters.dt;
    D.Rede(4,1).Dmax.EI=15/parameters.dt;
    D.Rede(4,1).Dmax.IE=15/parameters.dt;
    D.Rede(4,1).Dmax.II=15/parameters.dt;

    % Delays for connections Network 1 -> Network 5
    D.Rede(5,1).Dmin.EE=15/parameters.dt;
    D.Rede(5,1).Dmin.EI=15/parameters.dt;
    D.Rede(5,1).Dmin.IE=15/parameters.dt;
    D.Rede(5,1).Dmin.II=15/parameters.dt;
    D.Rede(5,1).Dmax.EE=15/parameters.dt;
    D.Rede(5,1).Dmax.EI=15/parameters.dt;
    D.Rede(5,1).Dmax.IE=15/parameters.dt;
    D.Rede(5,1).Dmax.II=15/parameters.dt;

    % Delays for connections Network 2 -> Network 1
    D.Rede(1,2).Dmin.EE=15/parameters.dt;
    D.Rede(1,2).Dmin.EI=15/parameters.dt;
    D.Rede(1,2).Dmin.IE=15/parameters.dt;
    D.Rede(1,2).Dmin.II=15/parameters.dt;
    D.Rede(1,2).Dmax.EE=15/parameters.dt;
    D.Rede(1,2).Dmax.EI=15/parameters.dt;
    D.Rede(1,2).Dmax.IE=15/parameters.dt;
    D.Rede(1,2).Dmax.II=15/parameters.dt;

    % Delays for connections Network 2 -> Network 3
    D.Rede(3,2).Dmin.EE=15/parameters.dt;
    D.Rede(3,2).Dmin.EI=15/parameters.dt;
    D.Rede(3,2).Dmin.IE=15/parameters.dt;
    D.Rede(3,2).Dmin.II=15/parameters.dt;
    D.Rede(3,2).Dmax.EE=15/parameters.dt;
    D.Rede(3,2).Dmax.EI=15/parameters.dt;
    D.Rede(3,2).Dmax.IE=15/parameters.dt;
    D.Rede(3,2).Dmax.II=15/parameters.dt;

    % Delays for connections Network 2 -> Network 4
    D.Rede(4,2).Dmin.EE=15/parameters.dt;
    D.Rede(4,2).Dmin.EI=15/parameters.dt;
    D.Rede(4,2).Dmin.IE=15/parameters.dt;
    D.Rede(4,2).Dmin.II=15/parameters.dt;
    D.Rede(4,2).Dmax.EE=15/parameters.dt;
    D.Rede(4,2).Dmax.EI=15/parameters.dt;
    D.Rede(4,2).Dmax.IE=15/parameters.dt;
    D.Rede(4,2).Dmax.II=15/parameters.dt;

    % Delays for connections Network 2 -> Network 5
    D.Rede(5,2).Dmin.EE=15/parameters.dt;
    D.Rede(5,2).Dmin.EI=15/parameters.dt;
    D.Rede(5,2).Dmin.IE=15/parameters.dt;
    D.Rede(5,2).Dmin.II=15/parameters.dt;
    D.Rede(5,2).Dmax.EE=15/parameters.dt;
    D.Rede(5,2).Dmax.EI=15/parameters.dt;
    D.Rede(5,2).Dmax.IE=15/parameters.dt;
    D.Rede(5,2).Dmax.II=15/parameters.dt;

    % Delays for connections Network 3 -> Network 1
    D.Rede(1,3).Dmin.EE=15/parameters.dt;
    D.Rede(1,3).Dmin.EI=15/parameters.dt;
    D.Rede(1,3).Dmin.IE=15/parameters.dt;
    D.Rede(1,3).Dmin.II=15/parameters.dt;
    D.Rede(1,3).Dmax.EE=15/parameters.dt;
    D.Rede(1,3).Dmax.EI=15/parameters.dt;
    D.Rede(1,3).Dmax.IE=15/parameters.dt;
    D.Rede(1,3).Dmax.II=15/parameters.dt;

    % Delays for connections Network 3 -> Network 2
    D.Rede(2,3).Dmin.EE=15/parameters.dt;
    D.Rede(2,3).Dmin.EI=15/parameters.dt;
    D.Rede(2,3).Dmin.IE=15/parameters.dt;
    D.Rede(2,3).Dmin.II=15/parameters.dt;
    D.Rede(2,3).Dmax.EE=15/parameters.dt;
    D.Rede(2,3).Dmax.EI=15/parameters.dt;
    D.Rede(2,3).Dmax.IE=15/parameters.dt;
    D.Rede(2,3).Dmax.II=15/parameters.dt;

    % Delays for connections Network 3 -> Network 4
    D.Rede(4,3).Dmin.EE=15/parameters.dt;
    D.Rede(4,3).Dmin.EI=15/parameters.dt;
    D.Rede(4,3).Dmin.IE=15/parameters.dt;
    D.Rede(4,3).Dmin.II=15/parameters.dt;
    D.Rede(4,3).Dmax.EE=15/parameters.dt;
    D.Rede(4,3).Dmax.EI=15/parameters.dt;
    D.Rede(4,3).Dmax.IE=15/parameters.dt;
    D.Rede(4,3).Dmax.II=15/parameters.dt;

    % Delays for connections Network 3 -> Network 5
    D.Rede(5,3).Dmin.EE=15/parameters.dt;
    D.Rede(5,3).Dmin.EI=15/parameters.dt;
    D.Rede(5,3).Dmin.IE=15/parameters.dt;
    D.Rede(5,3).Dmin.II=15/parameters.dt;
    D.Rede(5,3).Dmax.EE=15/parameters.dt;
    D.Rede(5,3).Dmax.EI=15/parameters.dt;
    D.Rede(5,3).Dmax.IE=15/parameters.dt;
    D.Rede(5,3).Dmax.II=15/parameters.dt;

    % Delays for connections Network 4 -> Network 1
    D.Rede(1,4).Dmin.EE=15/parameters.dt;
    D.Rede(1,4).Dmin.EI=15/parameters.dt;
    D.Rede(1,4).Dmin.IE=15/parameters.dt;
    D.Rede(1,4).Dmin.II=15/parameters.dt;
    D.Rede(1,4).Dmax.EE=15/parameters.dt;
    D.Rede(1,4).Dmax.EI=15/parameters.dt;
    D.Rede(1,4).Dmax.IE=15/parameters.dt;
    D.Rede(1,4).Dmax.II=15/parameters.dt;

    % Delays for connections Network 4 -> Network 2
    D.Rede(2,4).Dmin.EE=15/parameters.dt;
    D.Rede(2,4).Dmin.EI=15/parameters.dt;
    D.Rede(2,4).Dmin.IE=15/parameters.dt;
    D.Rede(2,4).Dmin.II=15/parameters.dt;
    D.Rede(2,4).Dmax.EE=15/parameters.dt;
    D.Rede(2,4).Dmax.EI=15/parameters.dt;
    D.Rede(2,4).Dmax.IE=15/parameters.dt;
    D.Rede(2,4).Dmax.II=15/parameters.dt;

    % Delays for connections Network 4 -> Network 3
    D.Rede(3,4).Dmin.EE=15/parameters.dt;
    D.Rede(3,4).Dmin.EI=15/parameters.dt;
    D.Rede(3,4).Dmin.IE=15/parameters.dt;
    D.Rede(3,4).Dmin.II=15/parameters.dt;
    D.Rede(3,4).Dmax.EE=15/parameters.dt;
    D.Rede(3,4).Dmax.EI=15/parameters.dt;
    D.Rede(3,4).Dmax.IE=15/parameters.dt;
    D.Rede(3,4).Dmax.II=15/parameters.dt;

    % Delays for connections Network 4 -> Network 5
    D.Rede(5,4).Dmin.EE=15/parameters.dt;
    D.Rede(5,4).Dmin.EI=15/parameters.dt;
    D.Rede(5,4).Dmin.IE=15/parameters.dt;
    D.Rede(5,4).Dmin.II=15/parameters.dt;
    D.Rede(5,4).Dmax.EE=15/parameters.dt;
    D.Rede(5,4).Dmax.EI=15/parameters.dt;
    D.Rede(5,4).Dmax.IE=15/parameters.dt;
    D.Rede(5,4).Dmax.II=15/parameters.dt;

    % Delays for connections Network 5 -> Network 1
    D.Rede(1,5).Dmin.EE=15/parameters.dt;
    D.Rede(1,5).Dmin.EI=15/parameters.dt;
    D.Rede(1,5).Dmin.IE=15/parameters.dt;
    D.Rede(1,5).Dmin.II=15/parameters.dt;
    D.Rede(1,5).Dmax.EE=15/parameters.dt;
    D.Rede(1,5).Dmax.EI=15/parameters.dt;
    D.Rede(1,5).Dmax.IE=15/parameters.dt;
    D.Rede(1,5).Dmax.II=15/parameters.dt;

    % Delays for connections Network 5 -> Network 2
    D.Rede(2,5).Dmin.EE=15/parameters.dt;
    D.Rede(2,5).Dmin.EI=15/parameters.dt;
    D.Rede(2,5).Dmin.IE=15/parameters.dt;
    D.Rede(2,5).Dmin.II=15/parameters.dt;
    D.Rede(2,5).Dmax.EE=15/parameters.dt;
    D.Rede(2,5).Dmax.EI=15/parameters.dt;
    D.Rede(2,5).Dmax.IE=15/parameters.dt;
    D.Rede(2,5).Dmax.II=15/parameters.dt;

    % Delays for connections Network 5 -> Network 3
    D.Rede(3,5).Dmin.EE=15/parameters.dt;
    D.Rede(3,5).Dmin.EI=15/parameters.dt;
    D.Rede(3,5).Dmin.IE=15/parameters.dt;
    D.Rede(3,5).Dmin.II=15/parameters.dt;
    D.Rede(3,5).Dmax.EE=15/parameters.dt;
    D.Rede(3,5).Dmax.EI=15/parameters.dt;
    D.Rede(3,5).Dmax.IE=15/parameters.dt;
    D.Rede(3,5).Dmax.II=15/parameters.dt;

    % Delays for connections Network 5 -> Network 4
    D.Rede(4,5).Dmin.EE=15/parameters.dt;
    D.Rede(4,5).Dmin.EI=15/parameters.dt;
    D.Rede(4,5).Dmin.IE=15/parameters.dt;
    D.Rede(4,5).Dmin.II=15/parameters.dt;
    D.Rede(4,5).Dmax.EE=15/parameters.dt;
    D.Rede(4,5).Dmax.EI=15/parameters.dt;
    D.Rede(4,5).Dmax.IE=15/parameters.dt;
    D.Rede(4,5).Dmax.II=15/parameters.dt;


    D.delayMaxE=0;
    D.delayMaxI=0;
    for i=1:parameters.numRedes
        for j=1:parameters.numRedes
            D.delayMaxE = max([D.delayMaxE D.Rede(i,j).Dmax.EE D.Rede(i,j).Dmax.EI]); 
            D.delayMaxI = max([D.delayMaxI D.Rede(i,j).Dmax.IE D.Rede(i,j).Dmax.II]); 
        end
    end
    %% Synaptic Weights and number of connections 

    %%%%%%%%%%%%%%%%%% Recurrent Connections %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Synaptic  Weight Network 1 -> Network 1
    pesos.Rede(1,1).EE=0.015; 
    pesos.Rede(1,1).EI=0.03; 
    pesos.Rede(1,1).IE=0.06; 
    pesos.Rede(1,1).II=0.07;   
    
    % Number of connections Network 1 -> Network 1
    qtd.Rede(1,1).EE=40; 
    qtd.Rede(1,1).EI=40;
    qtd.Rede(1,1).IE=20;
    qtd.Rede(1,1).II=10; 

    % Synaptic  Weight Network 2 -> Network 2
    pesos.Rede(2,2).EE=0.015; 
    pesos.Rede(2,2).EI=0.03; 
    pesos.Rede(2,2).IE=0.06;  
    pesos.Rede(2,2).II=0.07;   

    % Number of connections Network 2 -> Network 2
    qtd.Rede(2,2).EE=50;  
    qtd.Rede(2,2).EI=30; 
    qtd.Rede(2,2).IE=20; 
    qtd.Rede(2,2).II=10;  

    % Synaptic  Weight Network 3 -> Network 3
    pesos.Rede(3,3).EE=0.015; 
    pesos.Rede(3,3).EI=0.03;  
    pesos.Rede(3,3).IE=0.06; 
    pesos.Rede(3,3).II=0.07;   

    % Number of connections Network 3 -> Network 3
    qtd.Rede(3,3).EE=40;  
    qtd.Rede(3,3).EI=30; 
    qtd.Rede(3,3).IE=20; 
    qtd.Rede(3,3).II=10; 

    % Synaptic  Weight Network 4 -> Network 4
    pesos.Rede(4,4).EE=0.015; 
    pesos.Rede(4,4).EI=0.03; 
    pesos.Rede(4,4).IE=0.06; 
    pesos.Rede(4,4).II=0.07; 

    % Number of connections Network 4 -> Network 4
    qtd.Rede(4,4).EE=60;  
    qtd.Rede(4,4).EI=40; 
    qtd.Rede(4,4).IE=20; 
    qtd.Rede(4,4).II=10; 

    % Synaptic  Weight Network 5 -> Network 5
    pesos.Rede(5,5).EE=0.015; 
    pesos.Rede(5,5).EI=0.03; 
    pesos.Rede(5,5).IE=0.06; 
    pesos.Rede(5,5).II=0.07; 

    % Number of connections Network 5 -> Network 5
    qtd.Rede(5,5).EE=80;  
    qtd.Rede(5,5).EI=75; 
    qtd.Rede(5,5).IE=30; 
    qtd.Rede(5,5).II=20; 

    %% Parameters of Izhikevich model 

    numNeurons=max(N.Rede(:)); % Maximum number of neurons

    % Inicia Matrizes
    parameters.a = nan(numNeurons,parameters.numRedes);    
    parameters.b = nan(numNeurons,parameters.numRedes);   
    parameters.c = nan(numNeurons,parameters.numRedes);    
    parameters.d = nan(numNeurons,parameters.numRedes);    

    % Network 1 
    parameters.a(1:N.Rede(1),1)=[0.018+(0.022-0.018).*rand(Ne.Rede(1),1,1);   0.08+(0.12-0.08).*rand(Ni.Rede(1),1,1)];
    parameters.b(1:N.Rede(1),1)=[0.18+(0.22-0.18).*rand(Ne.Rede(1),1,1);      0.18+(0.22-0.18).*rand(Ni.Rede(1),1,1)];
    parameters.c(1:N.Rede(1),1)=[-65.2+(-64.8+65.2).*rand(Ne.Rede(1),1,1);    -65.2+(-64.8+65.2).*rand(Ni.Rede(1),1,1)];
    parameters.d(1:N.Rede(1),1)=[7.8+(8.2-7.8).*rand(Ne.Rede(1),1,1);         1.8+(2.2-1.8).*rand(Ni.Rede(1),1,1)]; 

    % Network 2
    parameters.a(1:N.Rede(2),2)=[0.018+(0.022-0.018).*rand(Ne.Rede(2),1,1);   0.08+(0.12-0.08).*rand(Ni.Rede(2),1,1)];
    parameters.b(1:N.Rede(2),2)=[0.18+(0.22-0.18).*rand(Ne.Rede(2),1,1);      0.18+(0.22-0.18).*rand(Ni.Rede(2),1,1)];
    parameters.c(1:N.Rede(2),2)=[-65.2+(-64.8+65.2).*rand(Ne.Rede(2),1,1);    -65.2+(-64.8+65.2).*rand(Ni.Rede(2),1,1)];
    parameters.d(1:N.Rede(2),2)=[7.8+(8.2-7.8).*rand(Ne.Rede(2),1,1);         1.8+(2.2-1.8).*rand(Ni.Rede(2),1,1)]; 

    % Network 3
    parameters.a(1:N.Rede(3),3)=[0.018+(0.022-0.018).*rand(Ne.Rede(3),1,1);   0.08+(0.12-0.08).*rand(Ni.Rede(3),1,1)];
    parameters.b(1:N.Rede(3),3)=[0.18+(0.22-0.18).*rand(Ne.Rede(3),1,1);      0.18+(0.22-0.18).*rand(Ni.Rede(3),1,1)];
    parameters.c(1:N.Rede(3),3)=[-65.2+(-64.8+65.2).*rand(Ne.Rede(3),1,1);    -65.2+(-64.8+65.2).*rand(Ni.Rede(3),1,1)];
    parameters.d(1:N.Rede(3),3)=[7.8+(8.2-7.8).*rand(Ne.Rede(3),1,1);         1.8+(2.2-1.8).*rand(Ni.Rede(3),1,1)]; 

    % Network 4
    parameters.a(1:N.Rede(4),4)=[0.018+(0.022-0.018).*rand(Ne.Rede(4),1,1);   0.08+(0.12-0.08).*rand(Ni.Rede(4),1,1)];
    parameters.b(1:N.Rede(4),4)=[0.18+(0.22-0.18).*rand(Ne.Rede(4),1,1);      0.18+(0.22-0.18).*rand(Ni.Rede(4),1,1)];
    parameters.c(1:N.Rede(4),4)=[-65.2+(-64.8+65.2).*rand(Ne.Rede(4),1,1);    -65.2+(-64.8+65.2).*rand(Ni.Rede(4),1,1)];
    parameters.d(1:N.Rede(4),4)=[7.8+(8.2-7.8).*rand(Ne.Rede(4),1,1);         1.8+(2.2-1.8).*rand(Ni.Rede(4),1,1)]; 

    % Network 5
    parameters.a(1:N.Rede(5),5)=[0.018+(0.022-0.018).*rand(Ne.Rede(5),1,1);   0.08+(0.12-0.08).*rand(Ni.Rede(5),1,1)];
    parameters.b(1:N.Rede(5),5)=[0.18+(0.22-0.18).*rand(Ne.Rede(5),1,1);      0.18+(0.22-0.18).*rand(Ni.Rede(5),1,1)];
    parameters.c(1:N.Rede(5),5)=[-65.2+(-64.8+65.2).*rand(Ne.Rede(5),1,1);    -65.2+(-64.8+65.2).*rand(Ni.Rede(5),1,1)];
    parameters.d(1:N.Rede(5),5)=[7.8+(8.2-7.8).*rand(Ne.Rede(5),1,1);         1.8+(2.2-1.8).*rand(Ni.Rede(5),1,1)];                     

 end
