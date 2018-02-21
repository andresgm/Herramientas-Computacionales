function[RX]=rolling(v,W)
fo=0.01; %Basic Coefficient
fs=0.005; %Speed effect Coefficient
fr=fo+(3.24*fs*(0.44704*v/100)^2.5); %Coeficiente de resistencia a la rodadura
RX=fr*W;
end