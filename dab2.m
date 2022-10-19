function [sys,x0,str,ts] = buffer(t,x,u,flag,winsize,fs,dx,resdis)
switch flag,

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes(winsize,fs);

  %%%%%%%%%%%%%%%
  % Derivatives %
  %%%%%%%%%%%%%%%
  case 1,
    sys=mdlDerivatives(t,x,u);

  %%%%%%%%%%
  % Update %
  %%%%%%%%%%
  case 2,
    sys=mdlUpdate(t,x,u,winsize,dx,resdis);

  %%%%%%%%%%%
  % Outputs %
  %%%%%%%%%%%
  case 3,
    sys=mdlOutputs(t,x,u,winsize,dx,resdis);

  %%%%%%%%%%%%%%%%%%%%%%%
  % GetTimeOfNextVarHit %
  %%%%%%%%%%%%%%%%%%%%%%%
  case 4,
    sys=mdlGetTimeOfNextVarHit(t,x,u);

  %%%%%%%%%%%%%
  % Terminate %
  %%%%%%%%%%%%%
  case 9,
    sys=mdlTerminate(t,x,u);

  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  otherwise
    error(['Unhandled flag = ',num2str(flag)]);

end

% end sfuntmpl

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts]=mdlInitializeSizes(winsize,fs)

sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = winsize;
sizes.NumOutputs     = winsize;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   
sys = simsizes(sizes);
%
% initialize the initial conditions
%
x0  = zeros(winsize,1);
str = [];
%
% initialize the array of sample times
%
ts  = [1/fs 0];
% end mdlInitializeSizes
%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%
function sys=mdlDerivatives(t,x,u)

sys = [];

% end mdlDerivatives

%
%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================
%
function sys=mdlUpdate(t,x,u,winsize,dx,resdis)

if resdis==0
   if winsize==1
      sys=0;
   elseif winsize==2
      sys=[0;round(u/dx)*dx];
   else    
      sys = [0;round(u/dx)*dx;x(2:winsize-1)];
   end;
else
   if winsize==1
      sys=0;
   elseif winsize==2
      sys = [0;u];
   else
      sys = [0;u;x(2:winsize-1)];
   end;   
end;
% end mdlUpdate
%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x,u,winsize,dx,resdis)

if resdis ==0
   x(1)=round(u/dx)*dx;
else
   x(1)=u;
end;
sys =x;

% end mdlOutputs

function sys=mdlGetTimeOfNextVarHit(t,x,u)

sys = [];

% end mdlGetTimeOfNextVarHit

%
%=============================================================================
% mdlTerminate
% Perform any end of simulation tasks.
%=============================================================================
%
function sys=mdlTerminate(t,x,u)

sys = [];

% end mdlTerminate
