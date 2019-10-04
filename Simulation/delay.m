%% delay 
% 
%
%  Generate a matrix (cells) with the delay for each synapse for each neuron.
%  It also returns the post-synaptic neurons connected to each pre-synaptic neuron i.
%
%
%% Syntax 
%
%   [atrasos,post] = delay(Ne,Ni,numRedes,D,delayMax,connections)
%
%
%% Arguments 
%
%    Input: 
%
%    Ne             Number of excitatory neurons in each network     
%    Ni             Number of inhibitory neurons in each network
%    numRedes       Number of networks
%    D.DminEE         Minimum delay for synapses E-E
%    D.DminEI         Minimum delay for synapses E-I
%    D.DminII         Minimum delay for synapses I-I
%    D.DminIE         Minimum delay for synapses I-E
%    D.DmaxEE         Maximum delay for synapses E-E
%    D.DmaxEI         Maximum delay for synapses E-I
%    D.DmaxII         Maximum delay for synapses I-I
%    D.DmaxIE         Maximum delay for synapses I-E
%    delayMax         Maximum delay for all neurons
%    connections      Matrices of connections 
%
%   Output:
%
%   atrasos         number of synapses in each delay
%   post            post-synaptic neurons for each pre-synaptic 
%
%% Description 
%
%
%   This function returns the Matlab structure cells. The delays are in the
%   first output, where rows correspond to neurons and columns, correspond 
%   to the delay values. Each cell is the number of synapses.  Post-synaptic 
%   neurons are the second output. In this case, each row corresponds to a neuron, 
%   the other two dimensions are the networks. In each cell, we have the index
%   of presynaptic neurons.
%
%   The delays are integer random values inside an interval [Dmin,Dmax]
%
%   In order to generate random values inside an interval we used, for example,
%   round(DminEE+(DmaxEE-DminEE)*rand)
%
%   This function was adapted. The original script is in Izhikevich site 
%      (https://www.izhikevich.org/publications/index.htm)
%
%   Autor: Ronaldo Nunes (ronaldovnunes@gmail.com)
%

function [atrasos,post] = delay(Ne,Ni,numRedes,D,delayMax,connections)

clear atrasos post;

% Total number of neurons for each netowork
N.Rede(1:numRedes)=Ne.Rede(1:numRedes)+Ni.Rede(1:numRedes);

% Cells with the number of synapses for each neuron in each delay
atrasos = cell(max(N.Rede(:)),delayMax,numRedes,numRedes);

% Cells for the postsynaptic neurons
post=cell(max(N.Rede(:)),numRedes,numRedes);

% Fill post with the postsynaptic neurons
for rede=1:numRedes
    for rede2=1:numRedes
        for i=1:N.Rede(rede)
            post{i,rede2,rede}=find(connections.W(rede2,rede).matriz(:,i)~=0)';
        end
    end
end


% Delays
for rede=1:numRedes
    for rede2=1:numRedes
                
        % maximum and minimum delay for each synapse type
        delayMaxEE=D.Rede(rede2,rede).Dmax.EE;
        delayMinEE=D.Rede(rede2,rede).Dmin.EE;
        delayMaxEI=D.Rede(rede2,rede).Dmax.EI;
        delayMinEI=D.Rede(rede2,rede).Dmin.EI; 
        delayMaxIE=D.Rede(rede2,rede).Dmax.IE;
        delayMinIE=D.Rede(rede2,rede).Dmin.IE;
        delayMaxII=D.Rede(rede2,rede).Dmax.II;
        delayMinII=D.Rede(rede2,rede).Dmin.II;
        
        for i=1:Ne.Rede(rede)
           % number of synapses for neuron i
           snp=size(post{i,rede2,rede},2);
                     
           for j=1:snp
                if(post{i,rede2,rede}(j)<=Ne.Rede(rede2)) % delay for synapses E-E
                    atrasos{i, round(delayMinEE+(delayMaxEE-delayMinEE)*rand),rede2,rede}(end+1) = j;
                else % delay for synapses E-I
                    atrasos{i, round(delayMinEI+(delayMaxEI-delayMinEI)*rand),rede2,rede}(end+1) = j;
                end
           end
        end
        
        for i=Ne.Rede(rede)+1:N.Rede(rede)
           % number of synapses for neuron i
           snp=size(post{i,rede2,rede},2);
            for k=1:snp   
                if(post{i,rede2,rede}(k)<=Ne.Rede(rede2)) % delay for synapses I-E
                    atrasos{i, round(delayMinIE+(delayMaxIE-delayMinIE)*rand),rede2,rede}(end+1) = k;
                else % delay for synapses I-I
                    atrasos{i, round(delayMinII+(delayMaxII-delayMinII)*rand),rede2,rede}(end+1) = k;
                end    
            end
        end
    end
end
