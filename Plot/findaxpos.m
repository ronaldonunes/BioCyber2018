% Auxiliary function 
function findax = findaxpos(ax, axpos)
    tol = eps;
    findax = [];
    for i = 1:length(ax)
        axipos = get(ax(i),'Position');
        diffpos = axipos - axpos;
        if (max(max(abs(diffpos))) < tol)
            findax = ax(i);
            break;
        end
    end
end