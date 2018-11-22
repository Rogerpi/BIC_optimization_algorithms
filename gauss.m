function z = gauss(x,y)
    sigma = 1000;
    xc = 0; yc = 0;
    exponent = ((x-xc).^2 + (y-yc).^2)./(2*sigma^2);
    amplitude = 1 / (sigma * sqrt(2*pi));  
    z = amplitude  * exp(-exponent);
end