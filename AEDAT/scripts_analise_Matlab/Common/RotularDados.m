function [] = RotularDados(AEDAT, label, pathSaveData, timeStep )

    addpath('./Environment/');
    constantes = Constantes();
    qtdeImagens = constantes.tempoGravacao/(timeStep*10^-6);
    frames = GetFramesTimeSpaced(AEDAT,timeStep,'false');
    for i = 1:qtdeImagens
        data = struct('data',frames{i+1},'label',label);
        json.write(data, strcat(pathSaveData,label,'_', int2str(i),'.json'));
    end

end

