%%%%%%%%%
% This is for the initialization commands line of Orthogonal Components block.
%%%%%%%%%
if tfilt==1 %Fourier_sine;
   DIFI=sprintf('Fourier\nFilter');
end;
if tfilt==2 %Fourier_cosine;
   DIFI=sprintf('Walsh\nFilter');   
end;
if tfilt==3 %Walsh1;
   DIFI=sprintf('User\nDefined\nFilter');  
end;
