%{ 
Universidade Federal de Uberlândia
Laboratório de Engenharia Biomédica - BioLab

Script responsável por rotular os dados de um arquivo AEDAT gravado em uma
DVS128 e gerar uma base de dados
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
pathSaveData = 'C:/Users/Samsung/Documents/DVS128_BioLab/NeuromorphicObjectDataSet/caixa/';
%% Carregar o vídeo

file = {};
file.importParams = {};
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
file.importParams.filePath = source{7};
file.importParams.source = 'Dvs128';
AEDAT = ImportAedat(file);
%% Extração de dados (frames)
[ t,to,tf,deltaT ] = GetTimeInformation( AEDAT );

timeStep = 50000; % 50000us / 50 ms
%% Rotular dados

RotularDados(AEDAT,'caixa',pathSaveData,timeStep);

%% Validar Rotulação

RotulacaoValidator(timeStep,'caixa',pathSaveData);

