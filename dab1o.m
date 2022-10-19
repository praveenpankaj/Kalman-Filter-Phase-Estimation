w=2*pi*freq;
if resdis==0,
   %setting of the vertical resolution for the A/D converter
   switch vertres,
   case 1,
      resol=8;
   case 2,
      resol=12;
   case 3,
      resol=14;
   case 4,
      resol=16;
   otherwise,
      resol=1;
   end;
   dx=xmax/(2^resol-1);
else
   dx=0;
end;
if filter==0,
   %Determination of the transfer function for the filter
   switch approx,
   case 1,
      %Bessel approximation
      switch order,
      case 1,
         %second order
         num=[3*w^2];
         den=[1 3*w 3*w^2];
      case 2,
         %third order
         num=[15*w^3];
         den=[1 6*w 15*w^2 15*w^3];
      case 3,
         %fourth order
         num=[105*w^4];
         den=[1.0000 10.0100*w 45.0638*w^2 105.0979*w^3 105.0186*w^4];      
      end;
   case 2,
      %Tschebyscheff approximation
      switch order,
      case 1,
         %second order
         num=[1.43*w^2];
         den=[1 1.42*w 1.52*w^2];
      case 2,
         %third order
         num=[0.716*w^3];
         den=[1 1.25*w 1.53*w^2 0.716*w^3];
      case 3,
         %fourth order
         num=[0.358*w^4];
         den=[1.0000 1.1900*w 1.7140*w^2 1.0164*w^3 0.3816*w^4];      
      end;
   case 3,
      %Butterworth approximation
      switch order,
      case 1,
         %second order
         num=[w^2];
         den=[1 sqrt(2)*w w^2];
      case 2,
         %third order
         num=[w^3];
         den=[1 2*w 2*w^2 w^3];
      case 3,
         %fourth order
         num=[w^4];
         den=[1.0000 2.6100*w 3.4060*w^2 2.6100*w^3 1.0000*w^4];      
      end;
   case 4,
      %free expression
      num=numerator;
      den=denominator;
   otherwise,
      num=[1];
      den=[1];
   end;    
else
   %disable of analog filter
   num=[1];
   den=[1];
end;
      
      
   
   

   