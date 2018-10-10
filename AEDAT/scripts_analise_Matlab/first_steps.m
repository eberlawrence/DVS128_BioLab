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
addpath('C:/Users/Samsung/Documents/DVS128_BioLab/assets/');
addpath('C:/Users/Samsung/Documents/DVS128_BioLab/DataSet2/');
addpath('FramesFunctions/');
addpath('TrackingFunctions/');
addpath('Common/');
addpath('+json/');
%% Carregar o vídeo

fileCelular = {};
fileCelular.importParams = {};
source = {'video_celular.aedat'...1
    ,'video_chave_fenda.aedat'...2
    ,'mao_invisivel_do_capitalismo.aedat'...3
    ,'TrackingCopo.aedat'...4
    ,'pendulo.aedat'...5
    ,'pendulo2.aedat'...6
    ,'Caixa.aedat'...7
    ,'Mouse.aedat'...8
    ,'Celular.aedat'...9
    ,'Lapiseira.aedat'...10
    ,'Estilete.aedat'...11
    ,'Grampeador.aedat'...12
    ,'Tesoura.aedat'...13
    ,'Caneca.aedat'};%14
fileCelular.importParams.filePath = source{12};
fileCelular.importParams.source = 'Dvs128';
AEDAT = ImportAedat(fileCelular);
%% Testes para platagem com funções prontas
%PlotAedat(AEDAT);
%PlotPolarityAroundATime(AEDAT);

%% Extração de dados (frames)
[ t,to,tf,deltaT ] = GetTimeInformation( AEDAT );

%timeStep = 62500; % 100000us / 100 ms
%timeStep = 100000; % 100000us / 100 ms
%timeStep = 200000; % 200000us / 200 ms
%timeStep = 2000; % 2000 us / 2 ms
%timeStep = 10000; % 10000us / 10 ms
timeStep = 50000; % 50000us / 50 ms

%%
%GetFramesTimeSpaced(AEDAT,timeStep,'true');
MedianTracker(AEDAT,timeStep);
%ParticleTracker(AEDAT,timeStep);
 i=1;