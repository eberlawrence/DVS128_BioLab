%{ 
Universidade Federal de Uberlândia
Laboratório de Engenharia Biomédica - BioLab

Script responsável por importar os dados de um arquivo AEDAT gravado em uma
DVS128 


%}
addpath('C:/Users/Samsung/Documents/ObjectRecognition/AEDAT_Ferramentas/AedatTools/Matlab/');
%% Carregar o vídeo

fileCelular = {};
fileCelular.importParams = {};
source = {'C:/Users/Samsung/Documents/ObjectRecognition/assets/video_celular.aedat'...
    ,'C:/Users/Samsung/Documents/ObjectRecognition/assets/video_chave_fenda.aedat'...
    ,'C:/Users/Samsung/Documents/ObjectRecognition/assets/mao_invisivel_do_capitalismo.aedat'};
fileCelular.importParams.filePath = source{1};
fileCelular.importParams.source = 'Dvs128';
AEDAT = ImportAedat(fileCelular);
%% Testes para platagem com funções prontas
% PlotAedat(AEDAT);
% PlotPolarityAroundATime(AEDAT);

%% Extração de dados (frames) em janelas de 100us
t = AEDAT.data.polarity.timeStamp;
to = min(AEDAT.data.polarity.timeStamp); 
tf = max(AEDAT.data.polarity.timeStamp); 
deltaT = (tf - to); 
timeStep = 100000; %100000us
numFrames = deltaT/timeStep;
frameTimes = to + timeStep*0.5 : timeStep : tf;
frameBoundaryTimes = [to frameTimes + timeStep * 0.5];
numEvents = length(t);

frameProMediado = zeros([AEDAT.info.deviceAddressSpace(2) ...
        AEDAT.info.deviceAddressSpace(1) ...
        1], 'double');
    
frame = zeros([AEDAT.info.deviceAddressSpace(2) ...
            AEDAT.info.deviceAddressSpace(1) ...
            1]);
frame = frame + 0.5;

frames = {zeros(128,128),numFrames};
       
arrayOfPoints = zeros([AEDAT.info.deviceAddressSpace(2) ...
            AEDAT.info.deviceAddressSpace(1) ...
            1], ...
           'uint8');
       
auxArray = 0;

for frameIndex = 1:numFrames
    
    firstIndex = find(t >= frameBoundaryTimes(frameIndex), 1, 'first');
    lastIndex = find(t <= frameBoundaryTimes(frameIndex + 1), 1, 'last');

    selectedLogical = [false(firstIndex - 1, 1); ...
                        true(lastIndex - firstIndex + 1, 1); ...
                        false(numEvents - lastIndex, 1)];

    eventsForFrame = struct;
    eventsForFrame.x = AEDAT.data.polarity.x(selectedLogical);
    eventsForFrame.y = AEDAT.data.polarity.y(selectedLogical);
    eventsForFrame.polarity = AEDAT.data.polarity.polarity(selectedLogical);

    for i=1:length(eventsForFrame.x)
        frame(eventsForFrame.x(i,1)+1,eventsForFrame.y(i,1)+1) = frame(eventsForFrame.x(i,1)+1,eventsForFrame.y(i,1)+1) + eventsForFrame.polarity(i) - 0.5;  
    end
            
    figure();
    imshow(frame);
    
    frame = zeros([AEDAT.info.deviceAddressSpace(2) ...
            AEDAT.info.deviceAddressSpace(1) ...
            1]);
    frame = frame + 0.5;

     frames{:,frameIndex} = frame;
%     frames(:, :, frameIndex) = accumarray([eventsForFrame.y eventsForFrame.x] + 1, eventsForFrame.polarity*2-1);
%     if(frameIndex == 7)
%         break;
%     end
end 
contrast = 3;
frameAux = squeeze(frame);
figure();
hold all;
image(frameAux-1); 
hold on;
colormap(redgreencmap(contrast * 2 + 1));
hold on;
axis equal tight;

% frameMolde = {zeros(128,128),numFrames};
% for i = 1:48
%     frameMolde{:,i} = zeros(128,128);
% end
% for i = 1:length(frames)
%     for j =1:size(frames{i},1)
%         for k = 1:size(frames{i},2)
%             frameMolde{1,i}(j,k) = frameMolde{1,i}(j,k) + frames{1,i}(j,k);
%         end
%     end
% end
% 
% implay(frameMolde,5);
% 
%     
% contrast = 3;
% frame(frame > contrast) = contrast;
% frame(frame < - contrast) = -contrast;
% frame = uint8(frame + contrast + 1);
% 
% 
% 
 i=1;