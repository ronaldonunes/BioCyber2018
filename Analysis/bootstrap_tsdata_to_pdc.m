%% bootstrap_tsdata_to_pdc
%
% Compute PDC and GPDC in alternative hypothesis and perform the bootstrap
% to compute PDC and GPDC in null hypothesis (no causality)
%
%
%% Syntax
%
%  parameters = bootstrap_tsdata_to_pdc(U,momax,nsamps,nfreq,fs)  
%
%% Arguments
%
%
%  Input   
%
%  U          Time Series
%  momax      Maximal order of the model
%  nsamps     Number of bootstrap time series
%  nfreq      Number of frequencies
%  fs         Sampling rate of time series  
%  
%
%  Output
%
%  parameters.freq                Vector with frequencies
%  parameters.pdc(i,j).full       PDC values from j to i 
%  parameters.gpdc(i,j).full      GPDC values from j to i
%  parameters.pdc(i,j).bootstrap  PDC values from j to i using bootstrap
%  parameters.gpdc(i,j).bootstrap GPDC values from j to i using bootstrap
%
%% Description
%
%  In this function PDC and GPDC values are computed in alternative
%  hypothesis and using bootstrap. PDC and GPDC Bootstrap are computed in
%  order to define the threshold of statistical significance.
%
%  The algorithm of bootstrap was previously used in [1].
%
%  Function mvar was took from [2] and genvar from [3].
%
  %  Autor: Ronaldo Valter Nunes (ronaldovnunes@gmail.com)
%  
%% References
%
% [1] J. R. Sato, D. Y. Takahashi, S. M. Arcuri, K. Sameshima, P. A.
% Morretin, L. A. Baccala.
% " Frequency domain connectivity identification: An application of partial
% directed coherence in fMRI"
% Human Brain Mapping 30:452-461,2009.
% 
% [2] http://www.lcs.poli.usp.br/~baccala/pdc/asymp_package_v3.zip
%
% [3] https://users.sussex.ac.uk/~lionelb/MVGC/html/mvgchelp.html
%

function parameters = bootstrap_tsdata_to_pdc(U,momax,nsamps,nfreq,fs)
% Shape of U
[n,m] = size(U);

% Model Order, Var Coefficients and residuals
[IP,pf,A,~,~,ef,~,~,~] = mvar(U,momax,2,1);

% Compute PDC and GPDC in alternative hypothesis
[PDC_full, GPDC_full, parameters.freq]=pdc_function(A,pf,nfreq,fs);

GPDC_full=abs(GPDC_full).^2;
PDC_full=abs(PDC_full).^2;

%% Bootstrap
M=size(A,1);
for i=1:M
    for j=1:M
        
        % Create matrices to receive values
        EB = zeros(n,m);
        GPDC_bootstrap=zeros(nsamps,nfreq);
        PDC_bootstrap=zeros(nsamps,nfreq);      
        
        % It makes Var Coefficients ij equal to zero for all orders
        Aij_h0=A;
        Aij_h0(i,j,:)=0;
        
        % We do not want to compute bootstrap for PDC or GPDC from i to i
        if(i~=j)    
            
           % Reshape PDC and GPDC in alternative hypothesis 
           parameters.gpdc(i,j).full=reshape(GPDC_full(i,j,:),[1 nfreq]);
           parameters.pdc(i,j).full=reshape(PDC_full(i,j,:),[1 nfreq]);
           
           for s = 1:nsamps
                fprintf('PDC: bootstrap sample %d of %d',s,nsamps);

                % resample residuals
                for k=1:n
                    EB(k,:)=randsample(ef(k,:),m,true);
                end
                
                % generate bootstrap time series (H0 j->i)
                [Utemp,~] = genvar(Aij_h0,EB);
                
                % OLS
                [~,pftemp,Atemp,~,~,~,~,~,~] = mvar(Utemp,IP,2,5);
                
                % Compute PDC and GPDC in null hypothesis 
                [PDCtemp, GPDCtemp, ~]=pdc_function(Atemp,pftemp,nfreq,fs);
                
                GPDC_bootstrap(s,:)=abs(GPDCtemp(i,j,:)).^2;
                PDC_bootstrap(s,:)=abs(PDCtemp(i,j,:)).^2;
                
                fprintf('\n');
           end
            
            parameters.pdc(i,j).bootstrap=PDC_bootstrap;
            parameters.gpdc(i,j).bootstrap=GPDC_bootstrap;
            
        end
    end
end
end
