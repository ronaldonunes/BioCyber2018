%% Connections
% 
%  Generate a connection matrix 
%
%% Syntax
%
%  W = Connections(neReceiver,niReceiver,neSender,niSender,pesos,qtd,diagonal)
%
%% Arguments
%
%    Input: 
%
%    neReceiver     Number of excitatory neurons in receiver network
%    niReceiver     Number of inhibitory neurons in receiver network
%    neSender       Number of excitatory neurons in sender network
%    niSender       Number of inhibitory neurons in receiver network
%    pesos          synaptic weights 
%    qtd            number of synapses for each neuron
%    diagonal       "1" means main diagonal = 0 
%
%    Output:
%
%    W              Connection matrix
%
%% Description
%
%    This function generates a matrix of connections between neurons. Columns correspond to presynaptic
%    neurons. Rows correspond to postsynaptic neurons.
%  
%    W(j,i) = connection from i to j 
%
%    Synaptic weights "pesos" is a matlab struct 
%
%    Each neuron receives a fixed quantity of synapses giver by qtd
%
%
%    Autor: Ronaldo Nunes (ronaldovnunes@gmail.com
%

function  W = Connections(neReceiver,niReceiver,neSender,niSender,pesos,qtd,diagonal)

% number of neurons
numNeuronsReceiver=neReceiver+niReceiver;
numNeuronsSender=neSender+niSender;

if (numNeuronsReceiver~=numNeuronsSender) && diagonal ~=0
    error('A matriz nao e quadrada')
end

% Check if pesos and qtd are different from zero.
if(nnz(structfun(@(x) (any(x)), pesos))~=0 && nnz(structfun(@(x) (any(x)), qtd)~=0))

    if pesos.EE==0;
         qtdValuesEE=0;
         diagonalValuesEE=0;
    else
        if diagonal==1;
            if qtd.EE==0; 
                 qtdValuesEE=neSender-1;
            else
                 qtdValuesEE=neSender-1-qtd.EE;
            end
            diagonalValuesEE=0; % diagonal values
        else
            if qtd.EE==0;
                 qtdValuesEE=neSender;
            else
                 qtdValuesEE=neSender-qtd.EE;
            end
            diagonalValuesEE=pesos.EE;
        end
    end


    if pesos.II==0;
        qtdValuesII=0;
        diagonalValuesII=0;
      else
        if diagonal==1;
            if qtd.II==0; 
                 qtdValuesII=niSender-1;
            else
                 qtdValuesII=niSender-1-qtd.II;
            end
            diagonalValuesII=0; % diagonal values
        else
            if qtd.II==0;
                 qtdValuesII=niSender;
            else
                 qtdValuesII=niSender-qtd.II;
            end
            diagonalValuesII=pesos.II;
        end  
    end

    if pesos.EI==0;
        qtdValuesEI=0;
    else
        if qtd.EI==0; 
            qtdValuesEI=neSender;
        else
            qtdValuesEI=neSender-qtd.EI;
        end
    end

    if pesos.IE==0;
        qtdValuesIE=0;
    else
        if qtd.IE==0; 
           qtdValuesIE=niSender;
        else
           qtdValuesIE=niSender-qtd.IE;
        end
    end
    
    % list of connections 
    % column 1 -> source
    % column 2 -> target
    % column 3 -> weigth
    listConnections=zeros((neReceiver*(neSender+niSender))+...
                            (niReceiver*(neSender+niSender)),3); 
    indices=0;
                        
    for i=1:neReceiver  % Arriving to Excitatory

        vetorTemp=[pesos.EE*ones(1,neSender) pesos.IE*ones(1,niSender)];
        vetorTemp(1,i)=diagonalValuesEE; % Main diagonal

        % Exc-Exc
        vetorTemp(randsample(find(vetorTemp(1,1:neSender)~=0),qtdValuesEE))=0;

        % Ini-Exc
        vetorTemp(randsample(find(vetorTemp(1,neSender+1:numNeuronsSender)~=0),qtdValuesIE)+neSender)=0;

        indices=indices(end)+1:i*numNeuronsSender;
        listConnections(indices,:)=[i*ones(numNeuronsSender,1) (1:numNeuronsSender)' vetorTemp(1:numNeuronsSender)'];
   
    end

    for i=neReceiver+1:numNeuronsReceiver  % Arriving to inhibitory

        vetorTemp=[pesos.EI*ones(1,neSender) pesos.II*ones(1,niSender)];
        vetorTemp(1,i)=diagonalValuesII; % Main diagonal

        % Exc-Ini
        vetorTemp(randsample(find(vetorTemp(1,1:neSender)~=0),qtdValuesEI))=0;

        % Ini_Ini
        vetorTemp(randsample(find(vetorTemp(1,neSender+1:numNeuronsSender)~=0),qtdValuesII)+neSender)=0;

        indices=indices(end)+1:i*numNeuronsSender;
        listConnections(indices,:)=[i*ones(numNeuronsSender,1) (1:numNeuronsSender)' vetorTemp(1:numNeuronsSender)'];
                
    end

end

 W=sparse(listConnections(:,1),listConnections(:,2),listConnections(:,3));   


