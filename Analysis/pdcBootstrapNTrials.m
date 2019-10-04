%% pdcBootstrapNTrials
% 
%  Compute mean PDC/GPDC between trials
%
%% Syntax
%
%  function pdcBootstrapNTrials(modelo,ntrial,nsamps,peso,qtd)
%
%% Arguments
%
%   Input:
%   
%   modelo         Number of the model according to the paper (it is used just to
%                  save data in different folders for different models)
%   ntrials        Number of trials to compute GPDC/PDC mean
%   nsamps         Number of bootstrap samples
%   peso           Synaptic Weight * 10^3
%   qtd            Number of connections
%
%   Output: 
%
%   valor          =1 when code performs OK
%
%% Description
%
%  This function compute GPDC/PDC mean between trials. The number of trials
%  is ntrials.
%
% Autor: Ronaldo  Nunes (ronaldovnunes@gmail.com)


function valor=pdcBootstrapNTrials(modelo,ntrial,nsamps,peso,qtd)


    alpha=0.05; % Significance level
    nfreq=200;     % Number of frequencies
    fs_old=2*10^4; % Original sampling rate of data 
    fs_new=200;    % Sampling rate after downsample
    momax=10;     % Maximum order for AIC
    nChannels=5;   % Number of time-series

    % flags
    flgPDC='GPDC'; % 'PDC' or 'GPDC'
   
    % Folder with data  from simulations 
    path=strcat('/home/Modelo_',num2str(modelo),'/');


    % Struct
    for i=1:nChannels;
        for j=1:nChannels;
            if(i~=j);  
                valores.gpdc(i,j).full=zeros(ntrial,nfreq);
                media.gpdc(i,j).full=zeros(1,nfreq);
                desvio.gpdc(i,j).full=zeros(1,nfreq);
                media.gpdc(i,j).bootstrap=zeros(nsamps,nfreq);
                media.coerencia(i,j).full=zeros(1,nfreq);
                media.freq=0;
            end
        end
    end


    for trial=1:ntrial                

        % LFP
        name=strcat('file_',num2str(peso),'_',num2str(qtd),'_trial',num2str(trial),'_modelo',num2str(modelo));
        load(strcat(path,name,'.mat'),'LFP_current')

        % Last 5 seconds of time series
        % 100000 = transient
        dadosLFP=setLFP(LFP_current(100000:end,:),fs_old,fs_new); 


        % Compute do GPDC bootrstrap
        parameters=bootstrap_tsdata_to_pdc(dadosLFP',momax,nsamps,nfreq,fs_new);

        for i=1:nChannels
            for j=1:nChannels
                if(i~=j)    
                    % GPDC 
                    valores.gpdc(i,j).full(trial,:)=parameters.gpdc(i,j).full;

                    % GPDC Bootstrap
                    media.gpdc(i,j).bootstrap=media.gpdc(i,j).bootstrap+(parameters.gpdc(i,j).bootstrap/ntrial);

                    % Coerence
                    [Pxy,F]=mscohere(dadosLFP(:,i),dadosLFP(:,j),[],[],2*nfreq,fs_new);                
                    media.coerencia(i,j).full=media.coerencia(i,j).full+(Pxy(1:nfreq)'/ntrial);
                end    
            end
        end   

    end


    for i=1:nChannels
        for j=1:nChannels
            if(i~=j)    

                % GPDC 
                media.gpdc(i,j).full=mean(valores.gpdc(i,j).full,1);
                desvio.gpdc(i,j).full=std(valores.gpdc(i,j).full,0,1);            

            end    
        end
    end 


    media.freq=parameters.freq;

    % Significance threshold (confidence level = alpha)
    significance=significance_bootstrap(media,alpha,nChannels,nfreq,flgPDC);

    % Bonferroni significance threshold (confidence level = alpha/nfreq)
    significance2=significance_bootstrap(media,alpha/nfreq,nChannels,nfreq,flgPDC);

    save(strcat(path,'GPDC_mixResidues_',num2str(nsamps),'samples_',num2str(ntrial),'_trials','.mat'),'media','desvio','significance','significance2','-v7.3');
    valor = 1
end