% Generating LUT for DDS
% ==============================
clear all, close all, clc;

% PARAMETERS
% ===================
N_LUT = 8;             % number of bits to address LUT
LUT_LENGTH = 2^N_LUT;  % length of LUT
N_RESOL = 13;          % resolution of values stored in LUT (2'complement)


% VARIABLES
% ===================
aux = 0:1:(LUT_LENGTH-1);
phi_step = 2*pi/LUT_LENGTH;
phi_vec = phi_step*aux;

%LUT = sin(phi_vec);
LUT = round((2^(N_RESOL-1))*sin(phi_vec));
save('dds_LUT.mat','LUT');
sprintf('%g, ',LUT)     % optional, print out values comma-separated

% FIGURES
% ===================
figure(1)
plot(phi_vec,LUT,'b--','LineWidth',2),grid on, hold on
stem(phi_vec,LUT,'r')
set(gca,'XTick',0:pi/2:2*pi)
set(gca,'XTickLabel',{'0','pi/2','pi','3/2*pi','2*pi'})
set(gca,'YTick',-5000:1000:5000)
set(gca,'YTickLabel',{'-5000','-4000','-3000','-2000','-1000',...
                      '0','1000','2000','3000','4000','5000'})


title('LUT for Sine-Wave');
xlabel('Radians');
ylabel('Sine-Value (13 bits quantisation)');


% Calculate M-values for mid-octave
% -- Piano Mid-Octave (white keys)
% --------------------------------------------	
% -- DO-C4  tone ~261.63Hz
% -- RE_D4  tone ~293.66Hz
% -- MI_E4  tone ~329.63Hz
% -- FA_F4  tone ~349.23Hz
% -- SOL_G4 tone ~392.00Hz
% -- LA_A4  tone ~440.00Hz
% -- SI_B4  tone ~493.88Hz
% -- DO_C5  tone ~523.25Hz
% 
% -- Piano Mid-Octave (black keys)	
% --------------------------------------------
% -- DOS_C4S  tone ~277.18Hz
% -- RES_D4S  tone ~311.13Hz
% -- FAS_F4S  tone ~369.99Hz
% -- SOLS_G4S tone ~415.30Hz
% -- LAS_A4S  tone ~466.16Hz

N_CUM = 19;
Fs = 48e3;

fsig = [261.63 293.66 329.63 349.23 392 440 493.88 523.25 ...
        277.18 311.13 369.99 415.30 466.16 ];
M = 2^N_CUM * fsig / Fs;
M_round = round(M)
sprintf('%g, ',M_round)

% check closest rounding for lower octave
2*round(M/2)