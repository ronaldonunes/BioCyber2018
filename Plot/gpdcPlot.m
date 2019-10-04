%% gpdcPlot
% 
%  Plot GPDC vs Frequency 
%
%% Syntax
%
%  gpdcPlot(modelo,ntrial,nRedes,nsamples)
%
%% Arguments
%
%   Input:
%   
%   modelo                  Model number 
%   ntrial                  Number of trials
%   nRedes                  Number of networks (Channels)
%   nsamples                Number of bootstrap samples
%
%   Output: 
%
%   value          =1 when code performs OK
%
%% Description
%
%  This function plot  Gpdc vs Frequency. 
%
% Autor: Ronaldo  Nunes (ronaldovnunes@gmail.com)

function value=gpdcPlot(modelo,ntrial,nRedes,nsamples)

% Folder with data
path=strcat('/home/Modelo_',num2str(modelo),'/');

load(strcat(path,'GPDC_mixResidues_',num2str(nsamples),'samples_',num2str(ntrial),'_','trials.mat'));

% Create/find BigAx and make it invisible
cax=[];
sym = '.'; 
rows=nRedes;
cols=nRedes;

BigAx = newplot(cax);
fig = ancestor(BigAx,'figure');
set(BigAx,'Visible','off','color','none')

if any(sym=='.')
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
            hh(i,j,:) = plot(media.freq,smoothts(media.coerencia(i,j).full,'g',20),'color',[0,0,0]+0.5,'parent',ax(i,j));
            hold on
            boundedline(media.freq,media.gpdc(i,j).full,desvio.gpdc(i,j).full/sqrt(ntrial),'k')
            hold on
            plot(media.freq,reshape(significance2(i,j,:),[1 size(media.freq,2)]),'k--')
                       
            if(i==rows && j==1)
                set(ax(i,j),'ylim',[0 0.5],'xlim',[0 50],'xgrid','off','ygrid','off');
            else
                set(ax(i,j),'ylim',[0 0.5],'xlim',[0 50],'xgrid','off','ygrid','off','xticklabel','','yticklabel','')
            end
                                 
            xlim(i,j,:) = get(ax(i,j),'xlim');
            ylim(i,j,:) = get(ax(i,j),'ylim');
            
        end
    end
end

value=1
end