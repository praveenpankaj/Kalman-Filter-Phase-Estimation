function [sys,x0,str,ts] = kfamp(t,x,u,flag,X0,C,M)
global T P U B K;
switch flag,
    %%%%%%%%%%%%%%%%%%
    % Initialization %
    %%%%%%%%%%%%%%%%%%
    case 0,
        [sys,x0,str,ts] = mdlInitializeSizes(X0,C,M,T,P,U,B,K); % Initialization
        
        %%%%%%%%%%
        % Update %
        %%%%%%%%%%
    case 2,
        sys = mdlUpdate(t,x,u,C,M);
        
        %%%%%%%%%%%
        % Outputs %
        %%%%%%%%%%%    
    case 3,
        sys = mdlOutputs(t,x,u); % Calculate outputs
        
    case 9, 
        sys = []; % Do nothing
        
        %%%%%%%%%%%%%%%%%%%%
        % Unexpected flags %
        %%%%%%%%%%%%%%%%%%%%
    otherwise
        error(['Unhandled flag = ',num2str(flag)]); % Error handling
end

%END of kfamp function

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts] = mdlInitializeSizes(X0,C,M,T,P,U,B,K)

%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
% Note that in this example, the values are hard coded.  This is not a
% recommended practice as the characteristics of the block are typically
% defined by the S-function parameters.
%
% global T P K;
sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = 15;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);

%
% initialize the initial conditions
%
if isempty(K),
    x0  = [X0;0;0;0;reshape(M,9,1)];
else
    x0  = [X0;K;reshape(M,9,1)];
end
%
% Set str to an empty matrix.
%
str = [];

%
% initialize the array of sample times
%
ts  = [T 0];% sample time: [period, offset]

% END mdlInitializeSizes

%
%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================
%
function sys = mdlUpdate(t,x,u,C,M)

global P B U K;
Q = P;
s = length(x);
if s>3,
    X = x(1:3,1);
    K = x(4:6,1);
    M = reshape(x(7:15,1),3,3);
else
    X = x;
end
PX = P*X;
CPX = C*PX;
K = (M*C')*inv(((C*M*C')+B));
Z = (M-(K*C*M));
M = (P*Z*P')+(Q*U*Q');
sys = [PX+(K*(u-CPX));K;reshape(M,9,1)];
% end mdlUpdate

%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys = mdlOutputs(t,x,u)

s = length(x);
if s>3,
    sys = x(1:3,1);
else
    sys = x;
end
% end mdlOutputs
