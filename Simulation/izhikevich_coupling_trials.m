%% izhikevich_coupling_trials
% 
%  Run simulation
%
%% Syntax
%
%  izhikevich_coupling_trials(modelo,qtd_ex,W_ex,trial_ini,trial_end)
%
%% Arguments
%
%    Input:
%
%    modelo        model of neuronal networks [1]
%    qtd_ex        Number of long-range excitatory connections E->E 
%    W_ex          Synpatic weights long-range excitatory connections E->E (input should be synaptic weight * 10^3)
%    trial_ini     Number of the first trial
%    trial_end     Number of the last trial (trial_end > trial_ini)
%
%    Output: 
%   
%    valor   "1" if simulations runs
%
%
%% Description
%
%  This function run trials of simulation
%
%   Autor: Ronaldo Nunes (ronaldovnunes@gmail.com)
%% References
%
% [1] Nunes, Ronaldo V., Marcelo B. Reyes, and Raphael Y. De Camargo. "Evaluation of connectivity estimates using spiking neuronal 
%     network models." Biological cybernetics 113.3 (2019): 309-320.

function valor=izhikevich_coupling_trials(modelo,qtd_ex,W_ex,trial_ini,trial_end)

    % Path to save data
    path=strcat('/home/Modelo_',num2str(modelo),'/');

    display(modelo);
        
    for trial=trial_ini:trial_end 
         	
             switch modelo
                case 0
                    [N,Ne,Ni,pesos,qtd,D,inputExt,parameters]=Izhikevich_parameters_modelo0(qtd_ex,W_ex/1000.0);
                case 1
                    [N,Ne,Ni,pesos,qtd,D,inputExt,parameters]=Izhikevich_parameters_modelo1(qtd_ex,W_ex/1000.0);
                case 2
                    [N,Ne,Ni,pesos,qtd,D,inputExt,parameters]=Izhikevich_parameters_modelo2(qtd_ex,W_ex/1000.0);
                case 3
                    [N,Ne,Ni,pesos,qtd,D,inputExt,parameters]=Izhikevich_parameters_modelo3(qtd_ex,W_ex/1000.0);
             end

            % Simulation
            display(trial)
            [v, u, LFP_current, firings]=izhikevich_simulation(N,Ne,Ni,pesos,qtd,D,inputExt,parameters);
            name=strcat('file_',num2str(W_ex),'_',num2str(qtd_ex),'_trial',num2str(trial),'_modelo',num2str(modelo));
	        writeFile(name,Ne,Ni,D,parameters,pesos,inputExt,qtd,path)

            save(strcat(path,name,'.mat'),'LFP_current','firings');

    end
    valor=1;

end


