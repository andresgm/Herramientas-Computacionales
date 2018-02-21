function[vprom,vmax]=curva(m,mu,cgx,cgy,r,g,l)
fn=m*g; %Fuerza normal del vehículo
x=(cgx/100)*l; %Ubicación del CG en eje x desde línea Datum
frF=mu*fn*((l-x)/l); %Fuerza lateral soportada por el eje delantero
frR=mu*fn*(x/l); %Fuerza lateral soportada por el eje trasero
vprom=sqrt((r*(frF+frR))/m);
vmax=vprom*1.5;

L=3.28*l; %Longitud de eje (ft)
G=32.2;
Ca1=300; %Cornering Stiffness (lb)
K=(frF/Ca1)-(frR/Ca1); %Understeer Gradient (°/g)
vcrit1=sqrt(-57.3*L*G/K); %Velocidad crítica (ft)
vcrit=vcrit1/3.128;
if vprom>vcrit
    vprom=vcrit;
end
if vmax>vcrit
    vmax=vcrit;
end
end  


