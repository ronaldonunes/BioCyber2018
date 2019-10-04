%% roc_analise
% 
%  Compute ROC curve for mean GPDC computed using group of trials.
%
%% Syntax
%
%  roc_analise(modelo,nfreq,nChannels,ntrialGrupo,ntrialTotal,nsamps,peso,qtd)
%
%% Arguments
%
%   Input:
%   
%   modelo         model according to the paper (1,2 or 3)
%   nfreq          number of frequencies to compute GPDC/PDC 
%   nChannels      number of LFP signals
%   ntrialGrupo    number of trials in each group 
%   ntrialTotal    number total of trials that will be divided in groups
%   nsamps         number of bootstrap samples
%   peso           synaptic weight of long-range connections
%   qtd            number of connections for long-range connections
%   snr            Signal-to-noise ratio in dB, snr= ''  -> no noise
%
%   Output: 
%
%   valor          =1 if code peroforms OK
%
%
%% Description
%
%   This function compute roc curve for GPDC/PDC mean using group of trials
%   computed by function pdc_save_averages
%
%   Autor: Ronaldo  Nunes (ronaldovnunes@gmail.com)
%
%
function valor=roc_analise(modelo,nfreq,nChannels,ntrialGrupo,ntrialTotal,nsamps,peso,qtd,snr)

% Path to save data
path=strcat('/home/Modelo_',num2str(modelo),'/');


% Model
switch modelo
    case 1
        % Model 1
        original_matrix=[0 0 0 0 0
                         1 0 0 0 0
                         1 0 0 0 0 
                         1 0 0 0 1
                         0 0 0 1 0];
    case 2
        % Model 2
        original_matrix=[0 0 0 0 1
                         1 0 0 0 0
                         0 1 0 0 0 
                         0 0 1 0 1
                         0 0 0 1 0]; 
                     
    case 3
        % Model 3
        original_matrix=[0 0 0 0 0
                         1 0 0 0 0
                         1 1 0 0 0 
                         0 0 1 0 1
                         0 0 0 1 0];            
end

% alpha range (level of significance)
alpha_range=[0:0.01:25];

% Roc vector
roc=zeros(7,size(alpha_range,2));

% Fill out first line with alpha values
roc(1,:)=alpha_range;

for trial_ini=1:ntrialGrupo:ntrialTotal

   
   display(trial_ini)		

    % grupo de trials
    trial=trial_ini+(ntrialGrupo-1);                
    
     if ~isempty(snr)
        load(strcat(path,'gpdc_',num2str(nsamps),'samples_',num2str(trial_ini),'trial_inicial_',num2str(trial),'trial_final_',...
            num2str(peso),'peso_',num2str(qtd),'qtd_',num2str(modelo),'modelo_',num2str(snr),'SNR','.mat'));
    else    
        load(strcat(path,'gpdc_',num2str(nsamps),'samples_',num2str(trial_ini),'trial_inicial_',num2str(trial),'trial_final_',...
            num2str(peso),'peso_',num2str(qtd),'qtd_',num2str(modelo),'modelo','.mat'));
    end
    
 
    %% ROC Curve

    for alpha=alpha_range      

        TP=0; % True positives
        FP=0; % False positves
        TN=0; % True negatives
        FN=0; % False negatives
        
        % Confidence level adjusted using Bonferroni correction
        significance=significance_bootstrap(media,alpha/nfreq,nChannels,nfreq,'GPDC');

         for i=1:nChannels;
            for j=1:nChannels;
                if(i~=j);  
                    prediction=0;
                   
                    % mean gpdc
                    media_compare=media.gpdc(i,j).full;

                    % standart deviation of mean
                    dvp_m=desvio.gpdc(i,j).full/ntrialGrupo; 

                    % if low limit > significance
                    if(sum((media_compare-dvp_m)>reshape(significance(i,j,:),[1 nfreq]))>=1)  
                        prediction=1;
                    end
                    
                    
                    if (original_matrix(i,j)==1)
                        if(prediction==1)
                           TP=TP+1;                      
                        else
                           FN=FN+1;	
                        end
                    else
                        if(prediction==1)
                           FP=FP+1;                           
                        else
                           TN=TN+1;	
                        end
                    end
                end
            end
         end
      

     
         roc(:,roc(1,:)==alpha)=[alpha,...
                                roc(2,roc(1,:)==alpha)+TN,...
                                roc(3,roc(1,:)==alpha)+TP,...
                                roc(4,roc(1,:)==alpha)+FN,...
                                roc(5,roc(1,:)==alpha)+FP,0,0];
    end

toc
end
                % True positive rate           % False positive rate
    roc(6:7,:)=[roc(3,:)./(roc(3,:)+roc(4,:)); roc(5,:)./(roc(5,:)+roc(2,:))];



 if ~isempty(snr)
        save(strcat(path,'roc_',num2str(nsamps),'samples_',num2str(ntrialGrupo),'trialsGrupo_',num2str(ntrialTotal),'trialsTotal_',num2str(peso),...
            'peso_',num2str(qtd),'qtd_',num2str(modelo),'modelo_',num2str(nChannels),'nChannels_',num2str(nfreq),'nfreq_',num2str(snr),'SNR.mat'),'roc');
 else    
        save(strcat(path,'roc_',num2str(nsamps),'samples_',num2str(ntrialGrupo),'trialsGrupo_',num2str(ntrialTotal),'trialsTotal_',num2str(peso),...
            'peso_',num2str(qtd),'qtd_',num2str(modelo),'modelo_',num2str(nChannels),'nChannels_',num2str(nfreq),'nfreq.mat'),'roc');
 end

  
valor=1;
end
