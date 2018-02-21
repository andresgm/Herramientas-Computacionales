function[Fx,P,T]=traccion(mu,W,b,L,h,g,v,vmaxtot)
[P,T]=potencia(v,vmaxtot);
Fx=P/(v);
Fxmax=traccionmax(mu,W,b,L,h);
if(Fx>Fxmax)
    Fx=Fxmax;
end
