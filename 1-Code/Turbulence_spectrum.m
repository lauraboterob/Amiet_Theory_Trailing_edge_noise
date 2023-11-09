function [phi_ww] = Turbulence_spectrum(Kx,Ky,inputs)
k_e = sqrt(pi)/L * gamma(5/6)/gamma(1/3);
k_x_hat = Kx/k_e;
k_y_hat = Ky/k_e;

if inputs.model == 'von Karman'  
phi_ww = (4/(9*pi)) * (u_rms^2/(k_e^2)) * (k_x_hat.^2 + k_y_hat.^2)./((1+k_x_hat.^2+k_y_hat.^2).^(7/3));   
elseif inputs.model == 'Liepmann'
phi_ww = (3*u_rms^2*L^2)/(4*pi) * (L^2*(Kx^2+Ky.^2))./((1+L^2*(Kx^2+Ky.^2)).^(5/2));       
elseif inputs.model == 'TUD'
phi_ww = (91/(36*pi)) * (u_rms^2/(k_e^2)) * (k_x_hat^2 + k_y_hat.^2)./((1+k_x_hat^2+k_y_hat.^2).^(19/6)); 
end 

end

