%% izhikevich_simulation
% 
%  Compute the membrane potential. the recovery variable and the LFP signal
%  by integrating the Izhikevich model
%
%% Syntax
%
%  [v, u, LFP, firings]=izhikevich_simulation(N,Ne,Ni,pesos,qtd,D...
%                        delayMax,inputExt,parameters)
%
%% Arguments
%
%    Input: 
%   
%    N              Total number of neurons in each network
%    Ne             Number of excitatory neurons in each network     
%    Ni             Number of inhibitory neurons in each network 
%    pesos          Struct with synaptic weights
%    qtd            Struct with the number of connections
%    D              Struct with delays   
%    inputExt       External input
%    p              Struct with network parameters
%
%    Output:
%
%    v              Membrane potential for each neuron in each network 
%                   (it should be adjusted to output all the time series) 
%    u              Recovery variable for each neuron in each network  
%                   (it should be adjusted to output all the time series)
%    LFP            LFP signal
%    firings        spike for each neuron (network, time, neuron)
%
%% Description
%
%   This function computes the membrane potential, recovery variable, and 
%   LFP by integrating the Izhikevich model [1]. The output v and u are the
%   values in the last time step. This code should be adjusted to output all the 
%   time series for v and u.  LFP is computed as the average of the current
%   arriving at excitatory neurons [2].
%  
%   LFP(t,rede1) -  LFP signal from network 1 in time t
%   firings(:,1)==1 - spiking time for network 1
%
%
% Autor: Ronaldo Nunes (ronaldovnunes@gmail.com)
%% References
%
% [1] Izhikevich, Eugene M. "Simple model of spiking neurons." 
%     IEEE Transactions on neural networks 14.6 (2003): 1569-1572.
% [2] Mazzoni, Alberto, et al. "Computing the local field potential (LFP) 
%     from integrate-and-fire network models." 
%     PLoS computational biology 11.12 (2015): e1004584.
%


function [v, u, LFP_current, firings]=izhikevich_simulation(N,Ne,Ni,pesos,qtd,D,inputExt,p)

% Maximum number of neurons
numNeurons=max(N.Rede(:));

% LFP 
LFP_current=zeros(p.T-1,p.numRedes);

% arrays
v = nan(numNeurons,p.numRedes);% voltage array
u = nan(numNeurons,p.numRedes);% recovery array

% Activation list for external input
neuron.ext.actList=zeros(numNeurons,p.numRedes);
AmpaActList=zeros(numNeurons,p.numRedes);
GabaActList=zeros(numNeurons,p.numRedes);

% Spikes   
firings=[];    

% Connection matrices 
connections=matrixConnections(N,Ne,Ni,p.numRedes,pesos,qtd);


% Delays 
[delays,post]=delay(Ne,Ni,p.numRedes,D,max([D.delayMaxI D.delayMaxE]),connections); 

for rede=1:p.numRedes;    
    % membrane potential
    v(1:N.Rede(rede),rede) = p.v_ini;   
    
    % recovery variable
    u(1:N.Rede(rede),rede) = p.b(1:N.Rede(rede),rede).*v(1:N.Rede(rede),rede);
 
    % Activation list Ampa
    neuron.ampa.Rede(rede).actList=zeros(numNeurons,1+D.delayMaxE);
   
    % Activation list Gaba
    neuron.gaba.Rede(rede).actList=zeros(numNeurons,1+D.delayMaxI);
end

% Set Synaptic current
neuron.Eex=p.E_ex;
neuron.Ein=p.E_in;

%----------------------------------------------------------------
% Configure external input channels
%----------------------------------------------------------------
neuron.ext.tau1  =      p.tau_ext1; 
neuron.ext.tau2  =      p.tau_ext2;   
neuron.ext.imax  =      1;
neuron.ext = configureChannel(neuron.ext, numNeurons, p.numRedes, p.dt);
%----------------------------------------------------------------
% Configure AMPA channels
%----------------------------------------------------------------
neuron.ampa.tau1    =    p.tau_ampa1; 
neuron.ampa.tau2    =    p.tau_ampa2; 
neuron.ampa.imax    =    1;
neuron.ampa = configureChannel(neuron.ampa, numNeurons, p.numRedes, p.dt);

%----------------------------------------------------------------
% Configure GABA channels
%----------------------------------------------------------------
neuron.gaba.tau1    =    p.tau_gaba1;
neuron.gaba.tau2    =    p.tau_gaba2;
neuron.gaba.imax    =    1;
neuron.gaba = configureChannel(neuron.gaba, numNeurons, p.numRedes, p.dt);

% Poisson parameters
spikesPerS=p.spikeRatePoisson; 
timeStepS=p.dt/10^3; % step in seconds
    
% Simulation
for t=1:p.T-1;
        
    for rede=1:p.numRedes;
      
      % Poisson spikes
      vt=rand(N.Rede(rede),1);
      spikes = (spikesPerS(rede)*timeStepS) > vt;
                
              
      % Activation list for external current 
      neuron.ext.actList(1:N.Rede(rede),rede)=[inputExt.XE.Rede(rede).*spikes(1:Ne.Rede(rede));...
          inputExt.XI.Rede(rede).*spikes(Ne.Rede(rede)+1:N.Rede(rede))]; 
      
             
      % index of neurons that fired
      fired=find(v(:,rede)>=p.v_crit);
      
      if fired>0
      
          % reset membrane potential
          v(fired,rede)=p.c(fired,rede);
          u(fired,rede)=u(fired,rede)+p.d(fired,rede);

          % count spikes         
          firings=[firings; rede+0*fired, t+0*fired,fired];
          indices=firings(:,1)==rede & firings(:,2)==t; %logical
          disparos=firings(indices,2:3);
                  
      
       for k=1:size(disparos,1);
        for rede2=1:p.numRedes;  
       
            % Delay
            listaDelays=find(~cellfun(@isempty,delays(disparos(k,2),:,rede2,rede))); 
            for delayIndex=listaDelays
                del=delays{disparos(k,2),delayIndex,rede2,rede};
                ind = post{disparos(k,2),rede2,rede}(del);
                              
                if disparos(k,2)<=Ne.Rede(rede)
                    % Activation list AMPA
                    neuron.ampa.Rede(rede2).actList(ind,1+delayIndex)=...
                        neuron.ampa.Rede(rede2).actList(ind,1+delayIndex)...
                        +connections.W(rede2,rede).matriz(ind,disparos(k,2))./p.dt; 
                else
                    % Activation list GABA
                    neuron.gaba.Rede(rede2).actList(ind,1+delayIndex)=...
                        neuron.gaba.Rede(rede2).actList(ind,1+delayIndex)...
                        +connections.W(rede2,rede).matriz(ind,disparos(k,2))./p.dt; 
                end
                
            end
        end
       end
      end
    end
    
    
    for rede=1:p.numRedes
        AmpaActList(:,rede)=neuron.ampa.Rede(rede).actList(:,1); 
        GabaActList(:,rede)=neuron.gaba.Rede(rede).actList(:,1); 
        
        if(nnz(neuron.ampa.Rede(rede).actList(:,1)))
            neuron.ampa.Rede(rede).actList(neuron.ampa.Rede(rede).actList(:,1)~=0,1)=0;
        end
        
        if(nnz(neuron.gaba.Rede(rede).actList(:,1)))
            neuron.gaba.Rede(rede).actList(neuron.gaba.Rede(rede).actList(:,1)~=0,1)=0;
        end
        
        % Adjust activation list
        neuron.ampa.Rede(rede).actList(:,1:end)=...
                [neuron.ampa.Rede(rede).actList(:,2:end) neuron.ampa.Rede(rede).actList(:,1)];
        neuron.gaba.Rede(rede).actList(:,1:end)=...
                [neuron.gaba.Rede(rede).actList(:,2:end) neuron.gaba.Rede(rede).actList(:,1)];
    end
    
    
    % Evaluates the External synaptic current
    neuron.ext.Ys = neuron.ext.Xs .* neuron.ext.Y1 + neuron.ext.Ys .* neuron.ext.Y2;
	neuron.ext.Xs = neuron.ext.mod *neuron.ext.actList.* neuron.ext.X1 + neuron.ext.Xs.* neuron.ext.X2;
    gExt = neuron.ext.Ys .* neuron.ext.norm; %(microS)
           
    % Evaluates the AMPA synaptic current
    neuron.ampa.Ys = neuron.ampa.Xs .* neuron.ampa.Y1 + neuron.ampa.Ys .* neuron.ampa.Y2;
    neuron.ampa.Xs = neuron.ampa.mod *AmpaActList.* neuron.ampa.X1 + neuron.ampa.Xs.* neuron.ampa.X2;
    gAmpa = neuron.ampa.Ys .* neuron.ampa.norm; %(microS)
    
    % Evaluates the GABA synaptic current
    neuron.gaba.Ys = neuron.gaba.Xs .* neuron.gaba.Y1 + neuron.gaba.Ys .* neuron.gaba.Y2;
    neuron.gaba.Xs = neuron.gaba.mod *GabaActList .* neuron.gaba.X1 + neuron.gaba.Xs .* neuron.gaba.X2;
    gGaba= neuron.gaba.Ys .* neuron.gaba.norm; %(microS)
       
    
    % Izhikevich Model        
     
    % Total current
    I_Ampa=((neuron.Eex-v).*gAmpa);
    I_Gaba=((neuron.Ein-v).*gGaba);
    I_Ext=((neuron.Eex-v).*gExt);
    I=I_Ampa+I_Gaba+I_Ext; %(nA)
           
    % membrane potential
    v=v+p.dt*(0.04*v.^2+5*v+140-u+I); % (mV)              
      
    % recovery variable
    u=u+p.dt*(p.a.*(p.b.*v-u));                 
        
    % LFP 
    LFP_current(t,:)=sum(abs(I_Ampa(1:Ne.Rede,:)))+sum(abs(I_Gaba(1:Ne.Rede,:)))+sum(abs(I_Ext(1:Ne.Rede,:))); 
    LFP_current(t,:)=LFP_current(t,:)./Ne.Rede;
end
end