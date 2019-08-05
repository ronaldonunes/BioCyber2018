%% significance_bootstrap
% 
% Compute the threshold of statistical significance for PDC or GPDC 
%
%% Syntax
%
%  significance=significance_bootstrap(parameters,alpha,n,nfreq)
%
%% Arguments
%
%  Input:
%  
%  parameters.freq                Vector with frequencies
%  parameters.pdc(i,j).full       PDC values from j to i 
%  parameters.gpdc(i,j).full      GPDC values from j to i
%  parameters.pdc(i,j).bootstrap  PDC bootstrap values from j to i 
%  parameters.gpdc(i,j).bootstrap GPDC bootstrap values from j to i
%  alpha                          significance level (alpha)
%  n                              number of time series
%  nfreq                          number of frequencies 
%  flgPDC                         strig 'PDC' or 'GPDC'  
%
%
%  Output: 
%
%  significance                  values of significance threshold    
%
%
%% Description
%
%   Compute the threshold of significance using the bootstrap values of 
%   GPDC or PDC previously obtained
%
%   Autor: Ronaldo Valter Nunes (ronaldovnunes@gmail.com)
%% References
%
% [1] J. R. Sato, D. Y. Takahashi, S. M. Arcuri, K. Sameshima, P. A.
% Morretin, L. A. Baccala.
% " Frequency domain connectivity identification: An application of partial
% directed coherence in fMRI"
% Human Brain Mapping 30:452-461,2009.
% 
%


function significance=significance_bootstrap(parameters,alpha,n,nfreq,flgPDC)

significance=zeros(n,n,nfreq);
if strcmp(flgPDC,'PDC')
    for i=1:n
        for j=1:n
            if(i~=j) 
            significance(i,j,:)=quantile(parameters.pdc(i,j).bootstrap,1-alpha,1);
            end
        end
    
    end
end

if strcmp(flgPDC,'GPDC')
    for i=1:n
        for j=1:n
            if(i~=j) 
            significance(i,j,:)=quantile(parameters.gpdc(i,j).bootstrap,1-alpha,1);
            end
        end
    
    end
end