%% Definición parámetros, interfaz y adquisición de la información
m=147;%Masa total (kg)
mu=0.85;%Coeficiente de fricción de las llantas
cgx=66;%Porcentaje en eje longitudinal del CG (%)
b=cgx;
cgy=50;%Porcentaje en eje lateral del CG (%)
g=9.78;%Aceleración de la gravedad (m/s^2)
L=1.03;%Longitud total de kart (m)
vmaxtot=106/3.6;%Velocidad máxima alcanzable (m/s)
W=m*g; %Peso del kart (N)
h=0.5; %Altura del CG de Kart (m)
rho=0.95; %Densidad del aire en Bogotá (kg/m^3)

%% Definición de la Pista y Velocidades base
%Crea una matriz que contiene la posición, el radio, los grados y la
%longitud de cada segmento de la pista
seg=1:length(Radio);
V=zeros(length(seg),2);
for i=1:length(seg)
    A(1,i)=i;
    A(2,i)=Radio(i);
    A(3,i)=Grados(i);
    A(4,i)=Longitud(i);
    if(Radio(i)==0) %Asigna la velocidad base a las rectas
        V(i,1)=vmaxtot;
        V(i,2)=vmaxtot;
    end
    if(Radio(i)~=0) %Asigna la velocidad base a las curvas
        [vprom,vmax]=curva(m,mu,cgx,cgy,Radio(i),g,L);
        V(i,1)=vprom; %Velocidad promedio en la curva
        V(i,2)=vmax; %Velocidad máxima en salida y entrada de curva
    end
    if(V(i,1)>vmaxtot) %Establece la velocidad máxima para curvas
        V(i,1)=vmaxtot;
    end
    if(V(i,2)>vmaxtot) %Establece la velocidad máxima para curvas
        V(i,2)=vmaxtot;
    end
end

%% Descomposición de los sectores por elemenos finitos
n=100;
VR=zeros(length(seg),n); %Matriz de velocidades para cada segmento en cada partición
VR(1,:)=V(1,2); %Asigna la velocidad máxima al punto de mayor velocidad en la pista
for k=2:length(seg) 
    VR(k,1)=VR(k-1,n); %Asigna la velocidad de salida del segmento anterior al primer punto del segmento
    if V(k,1)<=VR(k-1,n)%Discrimina únicamente a los segmentos de curva
        brake=linspace(VR(k-1,n),V(k,1),28); 
        for s=2:29
            VR(k,s)=brake(s-1); %Asigna la velocidad en la zona de frenada
            [DA(k,s)]=drag(rho,VR(k,s-1)); %Calcula la fuerza de arrastre aerodinámico en la zona de frenado
            [RX(k,s)]=rolling(VR(k,s-1),W); %Calcula la fuerza de resistenica por rodadura en la zona de frenado
            Fx(k,s)=0; %Asigna la fuerza del motor en la zona de frenado
            ac(k,s)=(Fx(k,s)-RX(k,s)-DA(k,s))/(m); %Calcula la desaceleración del vehículo en la zona de frenado
        end
        for w=30:n
            [DA(k,w)]=drag(rho,VR(k,w-1)); %Calcula la fuerza de arrastre aerodinámico
            [RX(k,w)]=rolling(VR(k,w-1),W); %Calcula la fuerza de resistenica por rodadura
            [Fx(k,w),P(k,w),T(k,w)]=traccion(mu,W,b,L,h,g,VR(k,w-1),vmaxtot); %Calcula la fuerza del motor
            ac(k,w)=(Fx(k,w)-RX(k,w)-DA(k,w))/(m); %Calcula la aceleración del vehículo
            VR(k,w)=sqrt(((VR(k,w-1))^2)+(2*ac(k,w)*(Longitud(k)/n))); %Asigna la velocidad del vehículo
            if VR(k,w)>V(k,1)
                VR(k,w)=V(k,1); %Limita la velocidad máxima en curva
            end
        end
    end
    if V(k,1)>VR(k-1,n) %Discrimina únicamente a los sectores de recta
        for q=2:n
            [DA(k,q)]=drag(rho,VR(k,q-1)); %Calcula la fuerza de arrastre aerodinámico
            [RX(k,q)]=rolling(VR(k,q-1),W); %Calcula la fuerza de resistenica por rodadura
            [Fx(k,q),P(k,q),T(k,q)]=traccion(mu,W,b,L,h,g,VR(k,q-1),vmaxtot); %Calcula la fuerza del motor
            ac(k,q)=(Fx(k,q)-RX(k,q)-DA(k,q))/(m); %Calcula la aceleración del vehículo
            VR(k,q)=sqrt(((VR(k,q-1))^2)+(2*ac(k,q)*(Longitud(k)/n))); %Asigna la velocidad del vehículo
            if VR(k,q)>V(k,1) %Limita la velocidad máxima en recta
               VR(k,q)=V(k,1);
            end
        end
    end
end
%%Adaptación de los datos iniciales asumidos a los encontrados en los
%%sectores finales
VR(1,:)=VR(length(seg),n);
frenada=linspace(VR(length(seg),n),VR(3,1),28);
for qq=1:28
    VR(2,qq)=frenada(qq); %Modifica la velocidad en la primera frenada del circuito
end
for uu= 1:2
    for tt= 1:n
        [DA(uu,tt)]=drag(rho,VR(uu,tt)); %Modifica la fuerza de arrastre aerodinámica en la primera parte del circuito
        [RX(uu,tt)]=rolling(VR(uu,tt),W); %Modifica la fuerza de resistencia por rodadura en la primera parte del circuito
    end
end
P(1,:)=P(length(seg),n);
T(1,:)=T(length(seg),n);

for u=2:length(seg) %Asigna los nuevos valores finales de segmentos a los primeros puntos de los segmentos siguientes
    DA(u,1)=DA(u-1,n);
    RX(u,1)=RX(u-1,n);
    P(u,1)=P(u-1,n);
    T(u,1)=T(u-1,n);
end
VTOT=sum(VR')/n;
for m=1:length(seg)
    t(m)=Longitud(m)/VTOT(m); %Encuentra tiempos parciales por segmentos
end
Tiempo=sum(t) %Encuentra tiempo total
for e=1:k
    for o=1:n %Crea un sólo vector para cada variable con los valores totales de la vuelta
        Velocidad((((e-1)*100)+o))=VR(e,o);
        Potencia((((e-1)*100)+o))=P(e,o);
        Torque((((e-1)*100)+o))=T(e,o);
        Drag((((e-1)*100)+o))=DA(e,o);
        Rolling((((e-1)*100)+o))=RX(e,o);
        Tinf((((e-1)*100)+o))=t(e)/n;
    end
end
for e=2:k
    for o=1:n
        Aceleracion(((e-1)*100)+o)=(Velocidad(((e-1)*100)+o)-Velocidad((((e-1)*100)+o)-1))/(Tinf((((e-1)*100)+o))); %Crea un sólo vector de aceleración
    end
end

for e=1:k
    for o=1:n
        X((((e-1)*100)+o))=Longitud(e)/n; %Crea un sólo vector de distancias
    end
end
for b=2:length(X)
    X(b)=X(b)+X(b-1);
end

%% Gráficas

figure;
plot(X,(Velocidad*3.6));
grid
xlabel('Distancia [m]');
ylim([0,105]);
ylabel('Velocidad [km/h]');

% figure;
% plot(X,Potencia);
% grid
% xlabel('Distancia [m]');
% ylabel('Potencia [W]');
% 
% 
% figure;
% plot(X,Torque);
% grid
% xlabel('Distancia [m]');
% ylabel('Torque [Nm]');
% 
% figure;
% plot(X,Drag);
% grid
% xlabel('Distancia [m]');
% ylabel('Drag [N]');
% 
% figure;
% plot(X,Rolling);
% grid
% xlabel('Distancia [m]');
% ylabel('Fuerza de rodadura [N]');
% 
% figure
% plot(X,Aceleracion);
% grid
% xlabel('Distancia [m]');
% ylabel('Aceleración [m/s^2]');
