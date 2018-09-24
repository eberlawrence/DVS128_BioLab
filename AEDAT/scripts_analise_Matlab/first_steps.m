%{ 
Universidade Federal de Uberlândia
Laboratório de Engenharia Biomédica - BioLab

Script responsável por importar os dados de um arquivo AEDAT gravado em uma
DVS128 
%}
clc;
clear all;
close all;
addpath('C:/Users/Samsung/Documents/toolsAEDAT/AedatTools/Matlab/');
addpath('FramesFunctions/');
addpath('TrackingFunctions/');
%% Carregar o vídeo

fileCelular = {};
fileCelular.importParams = {};
source = {'C:/Users/Samsung/Documents/DVS128_BioLab/assets/video_celular.aedat'...
    ,'C:/Users/Samsung/Documents/DVS128_BioLab/assets/video_chave_fenda.aedat'...
    ,'C:/Users/Samsung/Documents/DVS128_BioLab/assets/mao_invisivel_do_capitalismo.aedat'...
    ,'C:/Users/Samsung/Documents/DVS128_BioLab/assets/TrackingCopo.aedat'...
    ,'C:/Users/Samsung/Documents/DVS128_BioLab/assets/pendulo.aedat'...
    ,'C:/Users/Samsung/Documents/DVS128_BioLab/assets/pendulo2.aedat'};
fileCelular.importParams.filePath = source{6};
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
timeStep = 100000; % 100000us / 100 ms
%timeStep = 2000; % 2000 us / 2 ms
%%
% frames = GetFramesTimeSpacedModifiedTestVersionm(AEDAT,timeStep);
MedianTracker(AEDAT,timeStep);
%ParticleTracker(AEDAT,timeStep);
 i=1;