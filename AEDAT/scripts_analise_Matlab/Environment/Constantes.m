classdef Constantes
    
    properties
       tempoGravacao;
    end
    
    methods
       function obj = Constantes()
         obj.tempoGravacao = 16; %tempo total da grava��o
       end
    end
    
    methods(Static)
        function tempo = getTempoGravacao()
           tempo = obj.tempoGravacao;
        end
    end
    
end

