function [sys,x0,str,ts] = oc1(t,x,u,flag,tfilt,rfilt,ifilt,tlen,N1)
%   oc1.m
%   version 0.1
%   04/18/98
%   The template of this s-function is sfundsc1.m

%SFUNDSC1 Example memory M-file S-function with inherited sample time
%   This M-file S-function is an example of how to implement an
%   inherited sample time S-function which has state. The actual sample
%   time will be determined by what is driving this S-function. It may
%   be continuous or discrete. This S-function uses one discrete state 
%   element as storage such that the previous input is provided at the 
%   output.
%   

switch flag,

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0,
   [sys,x0,str,ts]=mdlInitializeSizes(tfilt,rfilt,ifilt,tlen,N1);
  
  %%%%%%%%%%
  % Output %
  %%%%%%%%%%
  case 3,                                               
    sys = mdlOutputs(t,x,u,N1);    

  %%%%%%%%%%%%%
  % Terminate %
  %%%%%%%%%%%%%
  case {1,2,4,9},                                               
    sys = [];

  otherwise
    error(['unhandled flag = ',num2str(flag)]);
end

%end sfunoc

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts]=mdlInitializeSizes(tfilt,rfilt,ifilt,tlen,N1)

sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = 2*N1;
sizes.NumOutputs     = 2;
sizes.NumInputs      = N1;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);
switch tfilt
case 1,			% Fouier filter  
   switch tlen	% window width of filter
   case 1,   
      ncycle = N1/2;
   case 2,   
      ncycle = N1;
   end;   
   ncycle = floor(ncycle);

   theta = 2*pi*(ncycle-1)/N1:-2*pi/N1:0; 
   ifilt = 2/ncycle * sin(theta);
   rfilt = 2/ncycle * cos(theta);
case 2,			% Walsh filter
	temp2 = floor(N1/2);
   temp4 = floor(N1/4);
   switch tlen	% window width of filter
   case 1,     
      temppos = ones(1,temp4);
      tempneg = ones(1,temp2-temp4);
      ifilt = pi/N1* ones(1,temp2);      
      rfilt = pi/N1* [-tempneg temppos];
	case 2,      
      temppos = ones(1,temp2);
      temppos1 = ones(1,temp4);
      temppos2 = ones(1,N1-temp2-temp4);
      tempneg = ones(1,N1-temp2);
      ifilt = pi/(2*N1) * [-tempneg temppos];
      rfilt = pi/(2*N1) * [temppos1 -temppos temppos2];      
	end;      
case 3,
   ncycle = N1;
   rfilt = (2/ncycle)*rfilt;
   ifilt = (2/ncycle)*ifilt;
end;   % modify the lenth of the filter

len = length(rfilt);
if len >= N1   
   rfilt = rfilt(1:N1);
else   
   temp = zeros(1,N1-len);  
   rfilt = [rfilt temp];
end;
len = length(ifilt);
if len >= N1   
   ifilt = ifilt(1:N1);
else   
   temp = zeros(1,N1-len); 
   ifilt = [ifilt temp];
end;

% state variable x% number of data which have been fed into
%			the post-process filter
x0 = [rfilt ifilt];
str = [];
ts  = [-1 0]; % Inherited sample time

% end mdlInitializeSizes

%
%=======================================================================
% mdlOutputs
% Return the output vector for the S-function
%=======================================================================
%
function sys = mdlOutputs(t,x,u,N1)

rfilt = (x(1:N1))'; 
ifilt = (x(N1+1:2*N1))'; 
temp= rfilt * u+i*ifilt * u;
sys(1) = abs(temp);
sys(2) = 180/pi*angle(temp);
%sys(1) = rfilt * u;
%sys(2) = ifilt * u;
%end mdlOutputs
