%% firing_rate
% 
%  Compute average Firing rate of the network over trials
%
%% Syntax
%
%  value=firing_rate(numRedes,N,numTrials,timeSimulation,peso,qtd,transiente)
%
%% Arguments
%
%   Input:
%   
%   modelo                  Number of the model according to the paper (it is used just to
%                           save data in different folders for different models)
%   numRedes                Number of networks (Channels)
%   N                       Number of neurons
%   numTrials               Number of trials
%   timeSimulation          simulation time in seconds 
%   peso                    synaptic weight
%   qtd                     number of long range connection
%   transiente              transient steps in time series
%
%   Output: 
%
%   valor          =1       when code performs OK
%
%% Description
%
% This function computes the average firing rate over neurons and over trials. 

% Autor: Ronaldo  Nunes (ronaldovnunes@gmail.com)

function valor=firing_rate(modelo, numRedes,N,numTrials,timeSimulation,peso,qtd,transiente)

    Ne=0.8*N; % Number of excitatory neurons 
    
    path=strcat('/home/Modelo_',num2str(modelo),'/'); 
    firing_rate_network_matrix=zeros(numTrials, numRedes,2);

    for trials=1:numTrials
     name=strcat('file_',num2str(peso),'_',num2str(qtd),'_trial',num2str(trials),'_modelo3');
     load(strcat(path,name,'.mat'),'firings')

        firings=firings(firings(:,2)>=transiente,:); % Transiente
        firingRate_neuron=nan(numRedes,N);
        firingRate_network=nan(numRedes,2);   % 2 = excitatory and inhibitory   


        % Compute the firing rate for each neuron from each network
        for i=1:numRedes
            for j=1:N        
                if(size(firings,2)==3) % more than one network
                     t=firings(firings(:,1)==i & firings(:,3)==j,2);    
                else % just one network
                    t=firings(firings(:,1)==j,2);    
                end

                % firing rate for each neuron
                firingRate_neuron(i,j)=size(t,1)/timeSimulation;        
            end
        end

        % Compute the average firing rate for each nework
        % Excitatory
        firingRate_network(:,1)=sum(firingRate_neuron(:,1:Ne),2)/Ne;
        % Inhibitory
        firingRate_network(:,2)=sum(firingRate_neuron(:,(Ne+1):N),2)/(N-Ne);

        firing_rate_network_matrix(trials,:,:)=firingRate_network;

    end
    
    % Average Firing Rate
    media=mean(firing_rate_network_matrix,1);
    % Standard deviation of Firing Rate
    desvio=std(firing_rate_network_matrix,0,1);
    
    save(strcat(path,'firingRate_',num2str(peso),'_peso',num2str(qtd),'_qtd',num2str(modelo),'_modelo','.mat'),'-v7.3');
    
    valor=1
end