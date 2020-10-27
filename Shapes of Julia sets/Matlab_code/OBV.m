x1 = linspace(-4,4,2000);
y1 = linspace(-4,4,2000);
[newx newy] = meshgrid(x1,y1);
newz = complex(newx,newy);
newz1 = newz;

p = @(z) 1.0*z.^3 + z.*8.0i

for j = 1: 15
    newz = p(newz);
end

%  Zero-out values that greater than or equal to 10
newz1(abs(newz) >= 10) = 0;

h = plot(newz1,'.');