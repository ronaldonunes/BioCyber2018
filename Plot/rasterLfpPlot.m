%% rasterLfpPlot
% 
%  Plot raster plot and LFP signal
%
%% Syntax
%
%  rasterLfpPlot(N,modelo,peso,qtd,trial,numRedes,transiente)
%
%% Arguments
%
%   Input:
%  
%   N                       Number of neurons
%   modelo                  Model number 
%   peso                    Synaptic Weight * 10^3
%   qtd                     Number of connections
%   numRedes                Number of networks (Channels)
%   trial                   Trial number
%   transiente              transient time in steps
%
%   Output: 
%
%   value          =1 when code performs OK
%
%% Description
%
%  This function plot  raster plot and LFP for one trial. 
%
% Autor: Ronaldo  Nunes (ronaldovnunes@gmail.com)


function value=rasterLfpPlot(N,modelo,peso,qtd,trial,numRedes,transiente)
    
    dt=0.05;       % Integration time steps (miliseconds)
    Ne=0.8*N;      % 80% of neurons are excitatory 
    fs_old=2*10^4; % Original sampling rate of data 
    fs_new=200;    % Sampling rate after downsample
    trans_step=transiente/dt;
    path=strcat('/home/Modelo_',num2str(modelo),'/');
    name=strcat('file_',num2str(peso),'_',num2str(qtd),'_trial',num2str(trial),'_modelo',num2str(modelo));
    load(strcat(path,name,'.mat'),'firings','LFP_current')
    LFP=LFP_current; 
    
    range=(trans_step):100:length(LFP);    
    xRange=transiente:500:length(LFP)+1;    
    
    % Set LFP
    LFP=setLFP(LFP(trans_step:end,:),fs_old,fs_new);
    
    maxLFP=ceil(max(max(abs(max(LFP))),max(abs(min(LFP)))));
    yRangeLFP=-maxLFP:(maxLFP*2)/4:maxLFP;
    
    for i=1:numRedes

        % Spikes Plot
        indicesRedeEX=find(firings(:,1)==i & firings(:,2)>trans_step & firings(:,3)<=Ne);
        figure(1)
        subplot(numRedes,2,2*i-1)
        plot(firings(indicesRedeEX,2)*dt,firings(indicesRedeEX,3),'k.','MarkerSize',3,'MarkerEdgeColor',[0.3 0.3 0.3]);
        hold on
        indicesRedeEX=find(firings(:,1)==i & firings(:,2)>trans_step & firings(:,3)>Ne);
        plot(firings(indicesRedeEX,2)*dt,firings(indicesRedeEX,3),'k.','MarkerSize',3);
        yticks([0:(N/5):N])
        xticks(xRange)

        if(i==1)
            title('SPIKES');
        elseif(i==numRedes)
            ylabel('Neurons');
            xlabel('time (ms)');
        end

        hold off


        % LFP plot
        subplot(numRedes,2,2*i)
        plot((range)*dt,LFP(:,i),'k','LineWidth',0.5);
        ylim([-maxLFP maxLFP])
        yticks(yRangeLFP)
        xticks(xRange)
        if(i==1)
            title('LFP SIGNAL')
        elseif(i==numRedes)
            ylabel('LFP (mV)');
            xlabel('time (ms)');
        end 
    end 
    value=1
end