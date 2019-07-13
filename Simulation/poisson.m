%% poisson
% 
%  Generate poisson spike train
%
%% Sintax
%
%    spikes = poisson(timeStepS, spikesPerS, durationS, numTrains)
%
%% Arguments
%
%    Input: 
%   
%    timeStepsS       integration step in seconds
%    spikesPerS       Number of spikes per second       
%    durationS        Duration of spike train      
%    numTrains        Nuber of spike trains     
%    
%    Output:
%
%    spikes           spikes with Poisson distribution
%    
%
%% Description
%
%   This function generates Poisson spike trains   
%
%
%   Autor: Ronaldo Nunes ronaldovnunes@gmail.com
%% References
%
% http://www.hms.harvard.edu/bss/neuro/bornlab/nb204/statistics/poissonTutorial.txt
%

function spikes = poisson(timeStepS, spikesPerS, durationS, numTrains)

times = (0:timeStepS:durationS);
spikes = zeros(numTrains, length(times));
    for train = 1:numTrains
        vt = rand(size(times));
        spikes(train, :) = (spikesPerS*timeStepS) > vt;
    end
end
