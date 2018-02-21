function[P,T]=potencia(v,vmaxtot)
omega=5000*v/vmaxtot;
if(omega>5000)
    omega=5000;
end
P=3.037*((-0.00000004564538677*omega^3)+(0.0001056995459*omega^2)+(1.53209191*omega)-1.895523696);
T=P/(omega*2*pi/60);
end