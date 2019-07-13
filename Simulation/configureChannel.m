%% configureChannel
% 
%  Configure the synaptic channels
%
%% Sintax
%
%  configureChannel (synchan, nNeurons, numRedes,dt)
%
%% Arguments
%
%    Input: 
%   
%    synchan        Struct with tau and gmax
%    nNeurons       Number of neurons 
%    nRedes         Numeber of networks
%    dt             step for numerical integration
%
%    Saida 
%    
%    synchan        Struct with the  parameters for synaptic channels
%
%% Description
%
%  This function compute the parameters for synaptic channels [1]
%
% Autor: Ronaldo Nunes (ronaldovnunes@gmail.com)
%
%% References
%
%  [1] Koch, Christof, and Idan Segev, eds. Methods in neuronal modeling: from ions to networks. MIT press, 1998.
%

function synchan = configureChannel (synchan, nNeurons, numRedes,dt)

  tau1 = synchan.tau1;
  tau2 = synchan.tau2;
  imax = synchan.imax;

  synchan.Xs   = zeros(nNeurons, numRedes);
  synchan.Ys   = zeros(nNeurons, numRedes);
  synchan.X1   = tau1 .* ( 1.0 - exp( -dt ./ tau1 ) );
  synchan.X2   = exp( -dt ./ tau1 );
  synchan.Y1   = tau2 .* ( 1.0 - exp( -dt ./ tau2 ) );
  synchan.Y2   = exp( -dt ./ tau2 );

  synchan.mod  = 1;
  synchan.norm = 1;
  
  for i=1:numRedes
  
      if tau1(i) == tau2(i)
        synchan.norm(1,i) = imax * exp(1.0) / tau1(i); 
      else 
        tpeak = tau1(i) * tau2(i) * log( tau1(i)/tau2(i) ) / ( tau1(i)-tau2(i) );
        div   = tau1(i) * tau2(i) .* ( exp( -tpeak / tau1(i) ) - exp( -tpeak / tau2(i) ) ) ;
        synchan.norm(1,i) = imax * ( tau1(i) - tau2(i) ) / div;
      end;

  end
  
  synchan.X1=repmat(synchan.X1,nNeurons,1);
  synchan.X2=repmat(synchan.X2,nNeurons,1);
  synchan.Y1=repmat(synchan.Y1,nNeurons,1);
  synchan.Y2=repmat(synchan.Y2,nNeurons,1);
  synchan.norm=repmat(synchan.norm,nNeurons,1);
end
%----------------------------------------------------------------
