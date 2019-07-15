%% matrixConnections
% 
%  Generates all the connection matrices in the system 
%
%% Syntax
%
%  connections=matrixConnections(N,Ne,Ni,numRedes,pesos,qtd)
%
%% Argumentos
%
%    Input: 
%
%    N         Number of neurons in each network
%    Ne        Number of excitatory neurons in each network
%    Ni        Number of inhibitory neurons in each network
%    numRedes  Number of networks
%    pesos     Struct with synaptic weights
%    qtd       Struct with number of connections 
%   
%    Output:
%
%    connection            Struct with all connection matrices 
%
%% Description
%
%   This function generates all connection matrices. In order to do that it calls the function that creates each matrix.
%
%   Autor: Ronaldo Nunes (ronaldovnunes@gmail.com)
%

function connections=matrixConnections(N,Ne,Ni,numRedes,pesos,qtd)

maxRede=max(N.Rede);

    for i=1:numRedes
        for j=1:numRedes

            % Create Matrix
            connections.W(i,j).matriz=sparse(maxRede,maxRede);

            % Sum the number of connections
            sumQtd=sum([qtd.Rede(i,j).EE qtd.Rede(i,j).EI qtd.Rede(i,j).IE qtd.Rede(i,j).II]);

            % Coneection matrix
            if(sumQtd>0)

                % Main diagonal
                if i==j;
                    diag=1;    % Recurrent connections. i should be different of j
                else
                    diag=0;    % Long range connections. i could be equal to j.
                end

               % Connection matrix  Net j -> Net i  
               connections.W(i,j).matriz=Connections(Ne.Rede(i),Ni.Rede(i),Ne.Rede(j),Ni.Rede(j),pesos.Rede(i,j),qtd.Rede(i,j),diag); 

            end
        end
    end
end