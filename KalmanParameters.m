function [sys,x0,str,ts] = KalmanParameters(t,x,u,flag,Fs,f,sigman,sigmav,M,lambda)

global T P U B;
T = 1/Fs;
wT = 2*pi*f*T;
P = [cos(wT) -sin(wT) 0;sin(wT) cos(wT) 0;0 0 exp(-lambda*T)];
% M = [m^2 0 0;0 m^2 0;0 0 m^2];
U = [sigmav^2 0 0;0 sigmav^2 0;0 0 sigmav^2];
B = [sigman^2];% B = [sigman2 0 0;0 sigman2 0;0 0 sigman2];
switch flag,
    case 0
        [sys,x0,str,ts] = mdlInitializeSizes(Fs,f,sigman,sigmav,M,lambda,T,P,U,B,wT); % Initialization
    case 3
        sys = mdlOutputs(t,x,u); % Calculate outputs
    case { 1, 2, 4, 9 }
        s = []; % Unused flags
    otherwise
        error(['Unhandled flag = ',num2str(flag)]); % Error handling
end;
% End of KalmanParameters function.


function [sys,x0,str,ts] = mdlInitializeSizes(Fs,f,sigman,sigmav,M,lambda,T,P,U,B,wT)
% Call function simsizes to create the sizes structure.
warning off;
sizes = simsizes;
% Load the sizes structure with the initialization information.
sizes.NumContStates= 0;
sizes.NumDiscStates= 0;
sizes.NumOutputs= 0;
sizes.NumInputs= 0;
sizes.DirFeedthrough=1;
sizes.NumSampleTimes=1;
% Load the sys vector with the sizes information.
sys = simsizes(sizes);
%
x0 = []; % No continuous states
%
str = []; % No state ordering
%
ts = [T 0]; % Inherited sample time
% End of mdlInitializeSizes.
%==============================================================
% Function mdlOutputs performs the calculations.
%==============================================================
function sys = mdlOutputs(t,x,u)
% global T P U B;
sys = [];