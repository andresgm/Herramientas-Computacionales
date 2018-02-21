# Datos Llantas tractivas 
rll=0.139 # Radio geométrico de las llantas en traseras (m)
refc=0.98*rll # Radio efectivo llantas traseras (m)
rin=0.0631 #radio interno del neumático (m)

%Datos Transmisión
dp=11; %Dientes del piñon
dpl=87; %Dientes del plato
ng=dp/dpl; %Relación de Transmisión
etaf=0.95; %Eficiencia de transmisión

%Datos eje llantas
reje=0.02; %Radio eje de las llantas (m)
meje=10; %Masa del eje (kg)

%Datos Kart general
m=42; %masa del Kart (kg)
g=9.81; %Gravedad (m/s)
w=m*g; %peso del Kart (N)

%Datos Fuerzas de la fórmula de aceleración
rho=1.1955; %densidad del aire (kg/m^3)
dll=0.975; %Distancia entre ejes de llantas delanteras (m)
alj=0.88; %Altura con el piloto sentado en el kart (estatura 1.68 m) (m)
af=(dll*alj)/2; %Área Frontal Kart (m^2)
cd=0.89; %Coeficiente de Arrastre Kart
vw=0; %velocidad del viento (m/s)
theta=0; %Ángulo carretera

%Inercias
ii=5; %Inercia motor de combustión 

mllt=1.43; %Masa llantas traseras (kg)
mlld=1.20; %Masa llantas delanteras (kg)
rlld=0.129; %Radio llantas delanteras (m)
rind=0.0631; %Radio rin llantas delanteras (m)
mbt=0.7*mllt; %El porcentaje de la masa total que pesa la parte "banda" de la llanta trasera
mdt=0.3*mllt; %El porcentaje de la masa total que pesa la parte "disco" de la llanta trasera
mbd=0.7*mlld; %El porcentaje de la masa total que pesa la parte "banda" de la llanta delantera
mdd=0.3*mlld; %El porcentaje de la masa total que pesa la parte "disco" de la llanta delantera
illd=(mbd*rlld)+(mdd*(rlld^2-rind^2))/2; %Inercia 1 llanta delantera (kg-m^2)
illt=(mbt*rll)+(mdt*(rll^2-rin^2))/2; %Inercia 1 llanta trasera (kg-m^2)

rpi=0.05; %Radio Piñon (m)
rpla=0.15; %Radio Plato (m)
rhoac=7850; %Densidad del Acero (kg/m^3)
bpi=0.01; %Ancho piñon (m)
bpla=0.02; %Ancho plato (m)
vpi= bpi*pi*rpi^2; %Volumen del piñon (m^3)
vpla=bpla*pi*rpla^2; %Volumen del plato (m^3)
mpi=rhoac*vpi; %Masa del piñon (kg)
mpla=rhoac*vpla; %Masa del plato (kg)
ig=((mpi*(rpi^2))/2)+((mpla*(rpla^2))/2); %Inercia de la transmisión (kg-m^2)

ieje=(meje*reje^2)/2; %Inercia del eje de las llantas (kg-m^2)

%Fuerzas Aceleración
%Resistencia a la rodadura
a=1; %Distancia del centro de gravedad al eje de la llanta trasera (m)
l=1.5; %Distancia de eje de las llantas traseras y delanteras (m)
h=0.5; %Altura del centro de gravedad del kart con respecto al piso (m)
wr=w*((a/l)-(ax/g*(h/l))); %fuerza vertical sobre las llantas tractivas
fr=0.01*(1+(v/100)); %Factor de rodadura la velocidad del kart debe estar en (km/h)
%fr=C*((mllt*g)/(rllt*2))*sqrt(ht/bllt);
%ht=0.0739; %Altura del neumático (m)
%bllt=0.209; %Ancho del neumático (m)
%C= %Constante del material de la llanta
Fr=wr*fr*cos(theta); % (N)

%Fuerza del ángulo de la carretera
Fg=w*sen(theta); %(N)

%Fuerza de arrastre
Fw=(1/2)*rho*af*cd*(v+vw)^2; %(N)

%Fuerza de tracción, Torque del Motor
%Ft=((ti*ng*etaf)/refc)-(((ii-ig)*ng^2)+ieje+illd*2+illt*2)*(ax/(refc^2)); %(N)
ti=(Ft+(((ii-ig)*ng^2)+ieje+illd*2+illt*2)*(ax/(refc^2)))*(refc/(ng*etaf)); %Torque del motor (Nm)

%Aceleración, Fuerza de tracción
%mr=(((ii-ig)*ng^2)+ieje+illd*2+illt*2)/(refc^2);
%ax=(((ti*ng*etaf)/refc)-Fg-Fw-Fr)/(m+mr); %(m/s)
Ft=m*ax+Fg+Fw+Fr; 

%Velocidad angular del motor
wi=(ng*v)/refc; %(rad/s)






