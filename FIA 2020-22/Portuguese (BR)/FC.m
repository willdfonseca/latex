%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Código para cálculo de fator de crista (FC) e PAPR, além de poder corrigir o FC.
% Prof. William D'Andrea Fonseca - Engenharia Acústica UFSM
% 26/11/2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cleaning Service
clear all; close all; clc

%% Geração de sinais
pk = ita_generate('pinknoise',1,44100,18);
wt = ita_generate('whitenoise',1,44100,18);

%% Carrega sinais e seleciona
% mus = 'Metallica'
mus = 'pk'
% mus = 'wt'

%%%% Calcula Vpk e Vrms
Vpk  = max(abs(eval(strcat(mus,'.timeData(:,1)'))));
Vrms = rms(eval(mus));

%%% Apresenta valores
V = [Vpk, mean(Vrms)]

%%%% Calcula FatC e PAPR
FatC = Vpk/mean(Vrms);
PAPR = 10*log10((Vpk/mean(Vrms))^2);

%%% Apresenta valores
fc = [FatC, PAPR]

%% Código experimental para corrigir o fator de crista de sinais
x = eval(strcat(mus,'.timeData(:,1)'));
Q = 6; Qx = FatC;

th = 0.1;      % Threshold ou limiar
Q = 10^(Q/20); % Converte de dB para linear
% Processamento
while  Q/Qx < 10^(-th/20) || Q/Qx > 10^(th/20) 
    x = x/max(abs(x));                 % Normalizar o sinal
    if Q/Qx > 10^(th/20)
        x = sign(x).*sqrt(sinh(x.^2));  % Aumento
    else
        x = sign(x).*sqrt(asinh(x.^2)); % Diminuição
    end
    Qx = max(abs(x))/rms(x);            % Novo valor de FC
end
x = x - mean(x);  x = x/max(abs(x));

PAPRx = 10*log10((max(abs(x))/rms(x))^2)
musNEW = itaAudio(x,44100,'time');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% EOF
