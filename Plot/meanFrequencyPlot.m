%% meanFrequencyPlot
% 
%  Plot mean PSD (Power Spectral Density) vs Frequency 
%
%% Syntax
%
%  meanFrequencyPlot(modelo,ntrial,nRedes,peso,qtd)
%
%% Arguments
%
%   Input:
%   
%   modelo                  Model number 
%   ntrial                  Number of trials
%   nRedes                  Number of networks (Channels)
%   peso                    Synaptic Weight * 10^3
%   qtd                     Number of connections
%
%   Output: 
%
%   value          =1 when code performs OK
%
%% Description
%
%  This function plot  mean PSD over trials vs Frequency. 
%
% Autor: Ronaldo  Nunes (ronaldovnunes@gmail.com)

function value=meanFrequencyPlot(modelo,ntrial,nRedes,peso,qtd)

% Folder with data
path=strcat('/home/Modelo_',num2str(modelo),'/');

dados=load(strcat(path,'meanFrequency',num2str(peso),'peso_',num2str(qtd),'qtd_','modelo',num2str(modelo),'.mat'));

% Create/find BigAx and make it invisible
cax=[];
sym = '.'; 
rows=nRedes;
cols=1;

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
for i=rows:-1:1

    for j=cols:-1:1
              axPos = [pos(1)+(j-1)*width pos(2)+(rows-i)*height ...
                width*(1-space) height*(1-space)];
            findax = findaxpos(paxes, axPos);
            if isempty(findax),
                ax(i,j) = axes('Position',axPos,'HandleVisibility',BigAxHV,'parent',BigAxParent);
                set(ax(i,j),'visible','on');
            else
                ax(i,j) = findax(1);
            end
            
            mediaPSD(i,:)=mean(dados.struct.rede(i).valoresPSD,1);
            
            % devio padrao da media
            desvioPSD(i,:)=std(dados.struct.rede(i).valoresPSD,0,1)/sqrt(ntrial);
            
             pxx_max=max(mediaPSD(i,:));
             pxx=mediaPSD(i,:)/pxx_max;
             desvioNorm=desvioPSD(i,:)/pxx_max;
             
             
             plot(dados.struct.freq,pxx,'k');
             hold on
             boundedline(dados.struct.freq,pxx,desvioNorm,'k')
             set(gca,'YTick',[0 0.5 1 1.5],'XTick',[0 10 20 30 40 50])
                       
            if(i==rows && j==1)
                set(ax(i,j),'xlim',[0 50],'ylim',[0 1.5],'xgrid','off','ygrid','off');
                ylabel('PSD','FontSize',15);
                xlabel('Frequency (Hz)','FontSize',15);
            else
                set(ax(i,j),'xlim',[0 50],'ylim',[0 1.5],'xgrid','off','ygrid','off','xticklabel',[],'yticklabel',[])
            end
             
            xlim(i,j,:) = get(ax(i,j),'xlim');
            ylim(i,j,:) = get(ax(i,j),'ylim');
    end
end

value=1
end