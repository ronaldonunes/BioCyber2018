
%% meanFrequency
% 
%  Compute mean frequency
%
%% Syntax
%
%  function valor=meanFrequency(modelo,ntrial,nfreq,nRedes,peso,qtd)
%
%% Arguments
%
%   Input:
%   
%   modelo         Number of the model according to the paper (it is used just to
%                  save data in different folders for different models)
%   ntrial        Number of trials to compute GPDC/PDC mean
%   nfreq         Number of frequencies
%   nRedes        Number of networks (Channels)
%   peso           Synaptic Weight * 10^3
%   qtd            Number of connections
%
%   Output: 
%
%   valor          =1 when code performs OK
%
%% Description
%
%  This function compute PSD mean between trials
%
% Autor: Ronaldo  Nunes (ronaldovnunes@gmail.com)

function valor=meanFrequency(modelo,ntrial,nfreq,nRedes,peso,qtd)

    fs_old=2*10^4; % Original LFP sampling Rate 
    fs_new=200;    % LFP sampling rate after downsample

    for net=1:nRedes
        struct.rede(net).valoresPSD=zeros(ntrial,nfreq+1);
    end

    % Folder with data
    path=strcat('/home/Modelo_',num2str(modelo),'/');

    for trial=1:ntrial  
        name=strcat('file_',num2str(peso),'_',num2str(qtd),'_trial',num2str(trial),'_modelo',num2str(modelo));
        load(strcat(path,name,'.mat'),'LFP_current')
        LFP=setLFP(LFP_current,fs_old,fs_new);


        for net=1:nRedes
            % PSD
            % normalized
            % 1001 = transient
            [X,freq]=psdensity(LFP(1001:2000,net),fs_new,nfreq,true);
            struct.rede(net).valoresPSD(trial,:)=X;              
            struct.freq=freq;
        end
    end

    save(strcat(path,'meanFrequency',num2str(peso),'peso_',num2str(qtd),'qtd_','modelo',num2str(modelo),'.mat'),'struct');
    valor=1
end
