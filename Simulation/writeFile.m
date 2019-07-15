%% writeFile
% 
%  Generates a text ile with the parameters
%
%% Syntax
%
%    writeFile(fileName,Ne,Ni,D,parameters,pesos,qtd,path)
%
%% Arguments
%
%    Input: 
%   
%    fileName       File name
%    Ne             Number of excitatory neurons in each network     
%    Ni             Number of inhibitory neurons in each network 
%    D              Struct with delays
%    parameters     Struct with netowork parameters
%    pesos          Struct with synaptic weights
%    qtd            Struct with number of connections 
%    path           Folder path to save the file
%
%% Description
%
%   This function generates a text file with the main parameters used in the simulation
% 
%
%  Autor: Ronaldo Nunes (ronaldovnunes@gmail.com)
%


function writeFile(fileName,Ne,Ni,D,parameters,pesos,inputExt,qtd,path)


[fid, msg] = fopen(strcat(path,fileName), 'w');


fprintf(fid, strcat(fileName,'\t',date, '\tRonaldo Valter Nunes\n'));
fprintf(fid,strcat('\n',repmat('*',1,10),'  General Data  ',repmat('*',1,10),'\n'));
fprintf(fid, strcat('T','=',num2str(parameters.T),'\n'));
fprintf(fid, strcat('dt','=',num2str(parameters.dt),'\n'));
fprintf(fid, strcat('numRedes','=',num2str(parameters.numRedes),'\n'));

for i=1:parameters.numRedes;
    fprintf(fid, strcat('Ne','Rede(',num2str(i),')','=',num2str(Ne.Rede(i)),'\n'));
    fprintf(fid, strcat('Ni','Rede(',num2str(i),')','=',num2str(Ni.Rede(i)),'\n\n'));
    fprintf(fid, strcat('inputExt.XE.','Rede(',num2str(i),')','=',num2str(inputExt.XE.Rede(i)),'\n'));
    fprintf(fid, strcat('inputExt.XI.','Rede(',num2str(i),')','=',num2str(inputExt.XI.Rede(i)),'\n\n'));
end

fprintf(fid, 'Delays\n');

for i=1:parameters.numRedes;
    for j=1:parameters.numRedes;
        fprintf(fid, strcat('D','Rede(',num2str(i),',',num2str(j),')','.Dmin.EE','=',num2str(D.Rede(i,j).Dmin.EE),'\n'));
        fprintf(fid, strcat('D','Rede(',num2str(i),',',num2str(j),')','.Dmax.EE','=',num2str(D.Rede(i,j).Dmax.EE),'\n'));
        fprintf(fid, strcat('D','Rede(',num2str(i),',',num2str(j),')','.Dmin.EI','=',num2str(D.Rede(i,j).Dmin.EI),'\n'));
        fprintf(fid, strcat('D','Rede(',num2str(i),',',num2str(j),')','.Dmax.EI','=',num2str(D.Rede(i,j).Dmax.EI),'\n'));
        fprintf(fid, strcat('D','Rede(',num2str(i),',',num2str(j),')','.Dmin.IE','=',num2str(D.Rede(i,j).Dmin.IE),'\n'));
        fprintf(fid, strcat('D','Rede(',num2str(i),',',num2str(j),')','.Dmax.IE','=',num2str(D.Rede(i,j).Dmax.IE),'\n'));
        fprintf(fid, strcat('D','Rede(',num2str(i),',',num2str(j),')','.Dmin.II','=',num2str(D.Rede(i,j).Dmin.II),'\n'));
        fprintf(fid, strcat('D','Rede(',num2str(i),',',num2str(j),')','.Dmax.II','=',num2str(D.Rede(i,j).Dmax.II),'\n\n'));
    end
end

fprintf(fid, 'Potentials\n');
fprintf(fid, strcat('neuron.Ein','=',num2str(parameters.E_in),'\n'));
fprintf(fid, strcat('neuron.Eex','=',num2str(parameters.E_ex),'\n\n'));

fprintf(fid, 'External input channel\n');
fprintf(fid, strcat('neuron.ext.tau1','=',num2str(parameters.tau_ext1),'\n'));
fprintf(fid, strcat('neuron.ext.tau2','=',num2str(parameters.tau_ext2),'\n'));

fprintf(fid, 'AMPA channel\n');
fprintf(fid, strcat('neuron.ampa.tau1','=',num2str(parameters.tau_ampa1),'\n'));
fprintf(fid, strcat('neuron.ampa.tau2','=',num2str(parameters.tau_ampa2),'\n'));

fprintf(fid, 'GABA channel\n');
fprintf(fid, strcat('neuron.gaba.tau1','=',num2str(parameters.tau_gaba1),'\n'));
fprintf(fid, strcat('neuron.gaba.tau2','=',num2str(parameters.tau_gaba2),'\n'));

fprintf(fid, 'Spike Threshold\n');
fprintf(fid, strcat('v','>=',num2str(parameters.v_crit),'\n\n'));

for i=1:parameters.numRedes;
    for j=1:parameters.numRedes;
        fprintf(fid,strcat('\n',repmat('*',1,10),'Connexions',' ',num2str(j),'->',num2str(i),repmat('*',1,10),'\n'));
        fprintf(fid, strcat('pesos.Rede(',num2str(i),',',num2str(j),')','.EE','=',num2str(pesos.Rede(i,j).EE),'\n'));
        fprintf(fid, strcat('pesos.Rede(',num2str(i),',',num2str(j),')','.EI','=',num2str(pesos.Rede(i,j).EI),'\n'));
        fprintf(fid, strcat('pesos.Rede(',num2str(i),',',num2str(j),')','.IE','=',num2str(pesos.Rede(i,j).IE),'\n'));
        fprintf(fid, strcat('pesos.Rede(',num2str(i),',',num2str(j),')','.II','=',num2str(pesos.Rede(i,j).II),'\n'));
        fprintf(fid, strcat('qtd.Rede(',num2str(i),',',num2str(j),')','.EE','=',num2str(qtd.Rede(i,j).EE),'\n'));
        fprintf(fid, strcat('qtd.Rede(',num2str(i),',',num2str(j),')','.EI','=',num2str(qtd.Rede(i,j).EI),'\n'));
        fprintf(fid, strcat('qtd.Rede(',num2str(i),',',num2str(j),')','.IE','=',num2str(qtd.Rede(i,j).IE),'\n'));
        fprintf(fid, strcat('qtd.Rede(',num2str(i),',',num2str(j),')','.II','=',num2str(qtd.Rede(i,j).II),'\n'));
    end
end



fclose(fid);
