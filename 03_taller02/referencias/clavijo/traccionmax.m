function[FxMax]=traccionmax(mu,W,b,L,h)
FxMax=(mu*(W*b/L))/(1-((h/L)*mu));
end
