%% gpdcCouplingPlot
% 
%  Plot linear regression for gpdc and peak of gpdc  vs coupling
%
%% Syntax
%
%  gpdcCouplingPlot(modelo,nsamps,couplingVectorQtd,couplingVectorPeso,numRedes,ntrialGrupo,ntrialTotal)
%
%% Arguments
%
%   Input:
%   
%   modelo                  Model number 
%   nsamps                  Number of bootstrap samples
%   couplingVectorQtd       Vector with values of number of synapses
%   couplingVectorPeso      Vector with synpatic weights 
%   nRedes                  Number of networks (Channels)
%   ntrialGrupo             Number of trials in each group of experiment
%   ntrialTotal             Total number of trials
%
%   Output: 
%
%   value          =1 when code performs OK
%
%% Description
%
%  This function plot  linear regression for max(gpdc) and maximum gpdc vs coupling. The
%  maximum GPDC is the maximum of average GPDC between ntrialGrupo trials.
%  If couplingVectorQtd is a array couplingVectorPeso must be a scalar or
%  vice-versa.
%
% Autor: Ronaldo  Nunes (ronaldovnunes@gmail.com)

function value=gpdcCouplingPlot(modelo,nsamps,couplingVectorQtd,couplingVectorPeso,numRedes,ntrialGrupo,ntrialTotal)

path=strcat('/home/Modelo_',num2str(modelo),'/');

if(length(couplingVectorPeso)>length(couplingVectorQtd))
    load(strcat(path,'gpdcCouplingPeso_',num2str(nsamps),'samples_',num2str(ntrialGrupo),'_trialGrupo',...
        num2str(ntrialTotal),'_trialTotal',num2str(modelo),'_modelo','.mat'));
    couplingVector=couplingVectorPeso;
else
    load(strcat(path,'gpdcCouplingQtd_',num2str(nsamps),'samples_',num2str(ntrialGrupo),'_trialGrupo',...
        num2str(ntrialTotal),'_trialTotal',num2str(modelo),'_modelo','.mat'));
    couplingVector=couplingVectorQtd;
end

% Create/find BigAx and make it invisible
cax=[];
sym = '.'; 
rows=numRedes;
cols=numRedes;

BigAx = newplot(cax);
fig = ancestor(BigAx,'figure');
set(BigAx,'Visible','off','color','none')

if any(sym=='.'),
    units = get(BigAx,'units');
    set(BigAx,'units','pixels');
    pos = get(BigAx,'Position');
    set(BigAx,'units',units);
end

% Create and plot into axes
ax = zeros(rows,cols);
pos = get(BigAx,'Position');
width = pos(3)/cols;
height = pos(4)/rows;
space = .1; % 2 percent space between axes
pos(1:2) = pos(1:2) + space*[width height];
xlim = zeros([rows cols 2]);
ylim = zeros([rows cols 2]);
BigAxHV = get(BigAx,'HandleVisibility');
BigAxParent = get(BigAx,'Parent');
paxes = findobj(fig,'Type','axes','tag','PlotMatrixScatterAx');

for i=rows:-1:1,
    for j=cols:-1:1,
        if(i~=j)
            axPos = [pos(1)+(j-1)*width pos(2)+(rows-i)*height ...
                width*(1-space) height*(1-space)];
            findax = findaxpos(paxes, axPos);
            if isempty(findax),
                ax(i,j) = axes('Position',axPos,'HandleVisibility',BigAxHV,'parent',BigAxParent);
                set(ax(i,j),'visible','on');
            else
                ax(i,j) = findax(1);
            end
 
           for n=1:numRedes
               for m=1:(ntrialTotal/ntrialGrupo)
                    plot(couplingVector(n),matrixValores(n,i,j,m),'k.','MarkerSize',8)
                    hold on
               end
           end
           
         plot(couplingVector,reshape(yfit(i,j,:),[1 5]),'k-');
         txt1 = strcat('R2 = ',num2str(R2(i,j)));
         text(1,0.18,txt1)

                       
            if(i==rows && j==1)
                set(ax(i,j),'ylim',[0 0.2],'xlim',[0 max(couplingVector)],'xtick',couplingVector);
            else
                set(ax(i,j),'ylim',[0 0.2],'xlim',[0 max(couplingVector)],'xgrid','off','ygrid','off','xticklabel','','yticklabel','')
            end
            
            xlim(i,j,:) = get(ax(i,j),'xlim');
            ylim(i,j,:) = get(ax(i,j),'ylim');
            
        end
    end
end
value=1
end