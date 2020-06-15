function y = piecewisecrossproducts(x,distvector)

% Creates a vector y from a vector x in the following way: For entries
% 1:distvector(1), crossproducts are built (i.e., crospproducts(u,v) =
% u,v,u^2,v^2,u*v). Then for entries distvector(1)+1:distvector(2) and
% analogously onwards
 
if(length(distvector) < 2)
    y = crossproducts(x);
else

y = [];
distvector = [0,distvector];
for i = 1:length(distvector)-1
    y = [y; crossproducts(x(distvector(i)+1:distvector(i+1),:))];
end

end