%% gpdc_coupling
% 
%  Compute linear regression for gpdc vs coupling
%
%% Syntax
%
%  value=gpdc_coupling(modelo,nsamps,couplingVectorQtd,couplingVectorPeso,numRedes,ntrialGrupo,ntrialTotal)
%
%% Arguments
%
%   Input:
%   
%   modelo                  Number of the model according to the paper (it is used just to
%                           save data in different folders for different models)
%   nsamps                  Number of bootstrap samples
%   couplingVectorQtd       Vector with values of number of synapses
%   couplingVectorPeso      Vector with synpatic weights 
%   nRedes                  Number of networks (Channels)
%   ntrialGrupo             Number of trials in each group of experiment
%   ntrialTotal             Total number of trials
%
%   Output: 
%
%   valor          =1 when code performs OK
%
%% Description
%
%  This function compute linear regression for max(gpdc) vs coupling. The
%  maximum GPDC is the maximum of average GPDC between ntrialGrupo trials.
%  If couplingVectorQtd is a array couplingVectorPeso must be a scalar or
%  vice-versa.
%
% Autor: Ronaldo  Nunes (ronaldovnunes@gmail.com)

function value=gpdc_coupling(modelo,nsamps,couplingVectorQtd,couplingVectorPeso,numRedes,ntrialGrupo,ntrialTotal)

    if(length(couplingVectorPeso)>length(couplingVectorQtd))
        couplingVector=couplingVectorPeso;
    else
        couplingVector=couplingVectorQtd;
    end


    yfit=zeros(numRedes,numRedes,length(couplingVector));
    matrixValores=zeros(numRedes,numRedes,length(couplingVector),ntrialTotal/ntrialGrupo); 

    x_vector=[];
    for k=1:length(couplingVector)
        x_vector=[x_vector; couplingVector(k)*ones(ntrialTotal/ntrialGrupo,1)];
    end

    path=strcat('/home/Modelo_',num2str(modelo),'/');


    coupling=0;

    for peso=couplingVectorPeso 
        for qtd=couplingVectorQtd     
            coupling=coupling+1;
            trial_count=0;
            trial=0;

            for trial_ini=1:ntrialGrupo:ntrialTotal

                trial_count=trial_count+1;

                
                trial=trial_ini+(ntrialGrupo-1);                
                load(strcat(path,'gpdc_',num2str(nsamps),'samples_',num2str(trial_ini),'trial_inicial_',num2str(trial),...
                    'trial_final_',num2str(peso),'peso_',num2str(qtd),'qtd_','modelo',num2str(modelo),'.mat'));


                for i=1:numRedes
                    for j=1:numRedes
                       if(i~=j)
                        matrixValores(coupling,i,j,trial_count)= max(media.gpdc(i,j).full);
                       end
                    end
                end

            end
        end
    end


    for i=numRedes:-1:1
        for j=numRedes:-1:1
            if(i~=j)

                y_temp=squeeze(matrixValores(:,i,j,:))';
                y_vector=y_temp(:);

                mdl = fitlm(x_vector,y_vector);
                 yfit(i,j,:) = mdl.Coefficients.Estimate(2)*couplingVector+mdl.Coefficients.Estimate(1);

                 % Statistics
                 R2(i,j)=mdl.Rsquared.Ordinary;
                 pvalue1(i,j)=mdl.Coefficients.pValue(1);
                 pvalue2(i,j)=mdl.Coefficients.pValue(2);

            end
        end
    end
    
    if(length(couplingVectorPeso)>length(couplingVectorQtd))
        save(strcat(path,'gpdcCouplingPeso_',num2str(nsamps),'samples_',num2str(ntrialGrupo),'_trialGrupo',num2str(ntrialTotal),'_trialTotal',num2str(modelo),'_modelo','.mat'),...
            'couplingVectorPeso','matrixValores','yfit','R2','pvalue1','pvalue2','-v7.3');
    else
        save(strcat(path,'gpdcCouplingQtd_',num2str(nsamps),'samples_',num2str(ntrialGrupo),'_trialGrupo',num2str(ntrialTotal),'_trialTotal',num2str(modelo),'_modelo','.mat'),...
            'couplingVectorQtd','matrixValores','yfit','R2','pvalue1','pvalue2','-v7.3');
    end
    
    value=1

end

