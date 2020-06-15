function y = crossproducts(x)
% For a n-by-m matrix x, create new matrix y where every column consists
% of all entries of this column in x and all products of these entries
% Example: For scalar values u and v, the output is (u,v,u^2,v^2,u*v)
[n,m] = size(x);
y = [];
c = 1;
for j = 1:n
    for k = j:n
        y(c,:) = x(j,:).*x(k,:);
        c = c+1;
    end
end
y = [x;y];