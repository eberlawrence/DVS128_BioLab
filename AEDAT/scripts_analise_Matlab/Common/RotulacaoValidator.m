function [] = RotulacaoValidator( timeStep,label,pathSaveData)

    addpath('./Environment/');
    constantes = Constantes();
    qtdeImagens = constantes.tempoGravacao/(timeStep*10^-6);
    
    for i = 1:qtdeImagens
       image = json.read(strcat(pathSaveData,label,'_', int2str(i),'.json'));
       imwrite(image.data,strcat(image.label,int2str(i),'.png'));
    end
    
    
    
end

