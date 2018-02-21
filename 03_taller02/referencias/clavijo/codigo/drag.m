function[DA]=drag(rho,v)
CD=0.804; %Coeficiente de Drag
A=0.575; %Area frontal proyectada [m^2]
DA=0.5*rho*(v^2)*CD*A;
end