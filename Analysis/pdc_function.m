%% pdc_function
% 
%  Compute PDC and GPDC 
%
%% Syntax
%
%  [PDC GPDC f]=pdc_function(A,SIG,N,Fs)
%
%% Arguments
%
%   Input:
%   
%   A              Matrix of VAR model coefficients
%   SIG            Covariance Matrix of residuals 
%   N              Number of points (frequencies) to compute (nfft)
%   Fs             Sampling rate
%
%   Output: 
%
%   PDC            Matrix of PDC 
%   GPDC           Matrix of GPDC
%   f              Vector of frequencies
%
%
%% Description
%
%   This function compute PDC[1] and GPDC[2] for each frequency until
%   half of the sampling rate (Nyquist Frequency)c
%
%   Data are generate as follow:
%
%   PDC and GPDC have dimensions of  (# time-series, # time-series, #frequencies)
%
%   This code was adapted from the library eMVar [3]
%
%% References  
%
%  [1]  L. A. Baccala, K. Sameshima, 
%  "Partial directed coherence: a new concept in neural structure 
%  determination",
%  Biological Cybernetics 84, 463-474, 2001.
%
%  [2] L. A. Baccala, K. Sameshima,
%  "Generalzed partial directed coherence"
%  2007 15th International Conference on Digital Signal Processing,
%  DSP 2007 3, 163-166, 2007.
%  
%  [3]  http://www.lucafaes.net/emvar.html
%
%

function [PDC, GPDC, f]=pdc_function(A,SIG,N,Fs)

pmax=size(A,3);

Am=[];
for kk=1:pmax
    Am=[Am A(:,:,kk)];
end

M= size(Am,1); % Am has dim M*pM
p = size(Am,2)/M; % p is the order of the MVAR model

tmp3=zeros(M,1)'; %denominators for PDC (row!)
tmp4=zeros(M,1)'; %denominators for GPDC (row!)

Cd=diag(diag(SIG)); % Cd is useful for calculation of DC
invCd=inv(Cd);% invCd is useful for calculation of GPDC

f = (0:N-1)*(Fs/(2*N));
z = 1i*2*pi/Fs;

A = [eye(M) -Am]; % matrix from which M*M blocks are selected to calculate spectral functions

    for n=1:N % at each frequency

        %%% Coefficient matrix in the frequency domain
        As = zeros(M,M); % matrix As(z)=I-sum(A(k))
        for k = 1:p+1
            As = As + A(:,k*M+(1-M:0))*exp(-z*(k-1)*f(n));  %indicization (:,k*M+(1-M:0)) extracts the k-th M*M block from the matrix B (A(1) is in the second block, and so on)
        end;
        
        %%% denominators of DC, PDC, GPDC for each m=1,...,num. channels
        for m = 1:M
            tmpp1 = squeeze(As(:,m)); % this takes the m-th column of As...
            tmp3(m) = sqrt(tmpp1'*tmpp1); % for the PDC - don't use covariance information
            tmp4(m) = sqrt(tmpp1'*invCd*tmpp1); % for the GPDC - uses diagonal covariance information
        end
       
        % Partial directed coherence
        PDC(:,:,n)  = As./tmp3(ones(1,M),:);
        
        %%% Generalized Partial Directed Coherence 
        GPDC(:,:,n) = (sqrt(invCd)*As) ./ tmp4(ones(1,M),:);
 
    end
end
