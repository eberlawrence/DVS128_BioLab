%{ 
Universidade Federal de Uberl�ndia
Laborat�rio de Engenharia Biom�dica - BioLab

Script respons�vel por importar os dados de um arquivo AEDAT gravado em uma
DVS128 


%}
clc;
clear all;
close all;
addpath('C:/Users/Samsung/Documents/toolsAEDAT/AedatTools/Matlab/');
addpath('FramesFunctions/');
%% Carregar o v�deo

fileCelular = {};
fileCelular.importParams = {};
source = {'C:/Users/Samsung/Documents/ObjectRecognition/assets/video_celular.aedat'...
    ,'C:/Users/Samsung/Documents/ObjectRecognition/assets/video_chave_fenda.aedat'...
    ,'C:/Users/Samsung/Documents/ObjectRecognition/assets/mao_invisivel_do_capitalismo.aedat'};
fileCelular.importParams.filePath = source{1};
fileCelular.importParams.source = 'Dvs128';
AEDAT = ImportAedat(fileCelular);
%% Testes para platagem com fun��es prontas
% PlotAedat(AEDAT);
% PlotPolarityAroundATime(AEDAT);

%% Extra��o de dados (frames) em janelas de 100us
t = AEDAT.data.polarity.timeStamp;
to = min(AEDAT.data.polarity.timeStamp); 
tf = max(AEDAT.data.polarity.timeStamp); 
deltaT = (tf - to); 
timeStep = 100000; %100000us

frames = GetFramesTimeSpacedModifiedTestVersionm(AEDAT,timeStep);
%frames = GetFramesTimeSpaced(AEDAT,timeStep);
 i=1;