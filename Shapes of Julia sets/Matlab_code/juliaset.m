%%
clear all; close all; clc;


% % square
% x = linspace(-2,2,1000);
% y = linspace(-2,2,1000);
% zz = [complex(x,2) complex(x,-2) complex(2,y), complex(-2,y)];


im = rgb2gray(imread('/Users/heimine/Documents/heyhey.png'));

eg = edge(im);
edgepoints = find(eg == 1);
d = ones(size(im));
d(edgepoints) = 0;
coord = pic2points(d);


% coord = pic2points(im);
[row col] = size(im);
zz = complex((coord(:,1) - mean(coord(:,1)) )./row,(coord(:,2) - mean(coord(:,2)))./col);
z(1) = zz(1);

% number of leje points
n = 500;
s = 1/n;
zprod = (abs(zz-z(1))).^ s;


for j = 1:n-1
    [maxval,ind] = max(zprod);
    z(j+1) = zz(ind);
    zprod = zprod .* ((abs(zz-z(j+1)))).^ s;  
end

cap = maxval;


x1 = linspace(-2*col/1000,2*col/1000,1000);
y1 = linspace(-2*row/1000,2*row/1000,1000);
% x1 = linspace(-1.66, -1.64, 2000)
% y1 = linspace(-0.067, -0.065, 2000)
l1 = length(x1);
l2= length(y1);
[newx newy] = meshgrid(x1,y1);
newz = complex(newx,newy);
newz1 = newz;
zp = (newz - z(1)) / cap;

for j = 2:n
    zp = zp .* (newz - z(j))/cap;
end

p = @(z) z .* exp(-n*s/2) .* zp;

for j = 1: 15
    newz = p(newz);
end

%  Zero-out values that greater than or equal to 10
newz1(abs(newz) >= 10) = 0;

A=[ones(1,n);real(z);imag(z)];
fileID = fopen('data.txt','w');
fprintf(fileID,'%3.15f*(z-(%3.15f+%3.15fi))*',A);
fclose(fileID);


%%
% tic
% syms z
% f = data;
% f = sym(f);
% f = expand(f);
% fprime = diff(f);
% coef = fliplr(coeffs(fprime));
% 
% % critical points
% 
% cp = roots(coef);
%%
% ff = matlabFunction(fprime);
% for j = 1: length(cp)
%     if abs(ff(cp(j))) > 1.0e-115
%         cp(j) = 0;
%     end
% end
% 
% % number of critical points
% num_cp = length(find(abs(cp) > 0));
% toc
%%

h = plot(newz1,'.');
set(h, 'Color', [116/255 66/255 200/255]);
hold on
% 
%plot(zz,'k.','LineWidth',2)
title(['n = ' num2str(n) '   s = ' num2str(s)   '    resolution = ' num2str(l1) ' x ' num2str(l2)])
axis off

% plot(cp,'r.','LineWidth',2)

% for j = 1:length(cp)
%     plot(real(cp(j)),imag(cp(j)),'.');
%     hold on
%      text(real(cp(j)),imag(cp(j)),num2str(j)); 
% end



