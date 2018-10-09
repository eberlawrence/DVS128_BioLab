function [] = RotularDados(AEDAT, label, pathSaveData, timeStep )

    qtdeImagens = 16/(timeStep*10^-6);
    frames = GetFramesTimeSpaced(AEDAT,timeStep,'false');
    for i = 1:qtdeImagens
        data = struct('data',frames{i},'label',label);
        json.write(data, strcat(pathSaveData,label,'_', int2str(i),'.json'));
    end

end

