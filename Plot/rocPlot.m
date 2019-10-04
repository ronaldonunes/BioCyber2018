%% rocPlot
% 
%  Plot roc curves
%
%% Syntax
%
%  rocPlot(modelo,nfreq,nChannels,ntrialGrupo,ntrialTotal,nsamps,peso,qtd,snr)
%
%% Arguments
%
%   Input:
%   
%   modelo         Model number
%   nfreq          Number of frequencies
%   nChannels      Number of networks (Channels)
%   ntrialGrupo    Number of trials in each group
%   ntrialTotal    Total number of trials that will be divided in groups
%   nsamps         Number of bootstrap samples
%   peso           Synaptic Weight * 10^3
%   qtd            Number of connections
%   snr            Signal-to-noise ratio in dB, snr= ''  -> no noise
%
%   Output: 
%
%   value          =1 when code performs OK
%
%% Description
%
%  Plot roc curves
%
% Autor: Ronaldo  Nunes (ronaldovnunes@gmail.com)


function value=rocPlot(modelo,nfreq,nChannels,ntrialGrupo,ntrialTotal,nsamps,peso,qtd,snr)
    
    path=strcat('/home/Modelo_',num2str(modelo),'/');

    if(~isempty(snr))
    load(strcat(path,'roc_',num2str(nsamps),'samples_',num2str(ntrialGrupo),'trialsGrupo_',num2str(ntrialTotal),'trialsTotal_',...
        num2str(peso),'peso_',num2str(qtd),'qtd_',num2str(modelo),'modelo_',num2str(nChannels),'nChannels_',num2str(nfreq),'nfreq',...
        num2str(snr),'SNR','.mat'));
    else
    load(strcat(path,'roc_',num2str(nsamps),'samples_',num2str(ntrialGrupo),'trialsGrupo_',num2str(ntrialTotal),'trialsTotal_',...
        num2str(peso),'peso_',num2str(qtd),'qtd_',num2str(modelo),'modelo_',num2str(nChannels),'nChannels_',num2str(nfreq),'nfreq.mat'));
    end
    
    plot(roc(7,:),roc(6,:));
    xlabel('FPR','FontSize',15)
    xlim([ 0 1])
    ylim([0 1])
    ylabel('TPR','FontSize',15)
    
    axis square;
    value=1
    
end