%% pdc_save_averages
% 
%  Compute mean PDC/GPDC between group of trials 
%
%% Syntax
%
%  pdc_save_averages(modelo,ntrialIni,ntrialGrupo,ntrialTotal,nsamps,peso,qtd)
%
%% Arguments
%
%   Input:
%   
%   modelo         Number of the model according to the paper (it is used just to
%                  save data in different folders for different models)
%   ntrialIni      number of the first trial used in the code
%   ntrialGrupo    number of trials in each group
%   ntrialTotal    number total of trials that will be divided in groups
%
%   Output: 
%
%   valor          =1 when code performs OK
%
%% Description
%
%  This function select ntrialGrupo trials starting from trial ntrialIni
%  and compute GPDC/PDC mean between trials. The maximum number of trials
%  is ntrialTotal.
%
% Autor: Ronaldo  Nunes (ronaldovnunes@gmail.com)


function valor=pdc_save_averages(modelo,ntrialIni,ntrialGrupo,ntrialTotal,nsamps,peso,qtd)

% Path to save data
% Folders should be created before run the code 
path=strcat('/home/ronaldo/Novos_Dados/LFP/Modelo_',num2str(modelo),'/');
  
nfreq=25;  % Number of frequencies
fs_old=2*10^4; % Original LFP sampling Rate 
fs_new=200;    % LFP sampling rate after downsample
momax=10;     % Maximum model order
nChannels=5;   % number of time series in each group

    for trial_ini=ntrialIni:ntrialGrupo:ntrialTotal
    
    display(trial_ini)
    
    % Struct
    for i=1:nChannels;
        for j=1:nChannels;
            if(i~=j);  
                valores.gpdc(i,j).full=zeros(ntrialGrupo,nfreq);
                media.gpdc(i,j).full=zeros(1,nfreq);
                desvio.gpdc(i,j).full=zeros(1,nfreq);
                media.gpdc(i,j).bootstrap=zeros(nsamps,nfreq);
                media.freq=0;           
            end
        end
    end
   
    % group of trials
    indiceTrial=0;
    for trial=(trial_ini:trial_ini+(ntrialGrupo-1));                
       
        % LFP
        name=strcat('file_',num2str(peso),'_',num2str(qtd),'_trial',num2str(trial),...
            '_modelo',num2str(modelo));

        load(strcat(path,name,'.mat'),'LFP_current')
        LFP=LFP_current;
        dadosLFP=setLFP(LFP(100000:end,:),fs_old,fs_new); % last 5 seconds in time series

        % Compute GPDC Bootstrap
        parameters=bootstrap_tsdata_to_pdc(dadosLFP',momax,nsamps,nfreq,fs_new);

        indiceTrial=indiceTrial+1; 
        
        
        for i=1:nChannels
            for j=1:nChannels
                if(i~=j);    
                    % GPDC in alternative hypothesis                  
                    valores.gpdc(i,j).full(indiceTrial,:)=parameters.gpdc(i,j).full;
                    % GPDC bootstrap
                    media.gpdc(i,j).bootstrap=media.gpdc(i,j).bootstrap+...
                        (parameters.gpdc(i,j).bootstrap/ntrialGrupo);
                end    
            end
        end   
    end
 
    for i=1:nChannels
        for j=1:nChannels
            if(i~=j)   

                media.gpdc(i,j).full=mean(valores.gpdc(i,j).full,1);
                desvio.gpdc(i,j).full=std(valores.gpdc(i,j).full,0,1);   
            end    
       end
    end
    
    media.freq=parameters.freq;

    save(strcat(path,'gpdc_',num2str(nsamps),'samples_',num2str(trial_ini),'trial_inicial_',num2str(trial),'trial_final_',num2str(peso),'peso_',num2str(qtd),'qtd_','modelo',num2str(modelo),'.mat'),'media','desvio');
   
    end
valor=1;

end

