%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the main script to calculate the trailing edge noise at different
% directivity angles based on the theory of Roger-Moreu 2005. 
% In this code, the back scattering effect is also taken into account. 
% Laura Botero Bolívar - University of Twente 
% l.boterobolivar@utwente.nl
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set the case
clear all
%hold all
[fluid,input] = inputs_definition();
R = input.z;
angle = 0:5:180;
x = R*cosd(angle);
z = R*sind(angle);
%% specifiy frequency
kc = 0.5;
k = kc/input.chord;
omega_d = k*fluid.c0;
for i = 1: length(x)
input.x = x(i);
input.z = z(i);
[f,omega,C(:,i),K_bar(:,i),mu_bar(:,i),S0(i),K_1_bar(:,i),alpha,U_c,K_2_bar(:,i),beta,kappa_bar(:,i)] = wavesnumbers(input,fluid);
[~,pos] = min(abs(omega_d-omega));
K_2_bar(:,i) = 1.5*beta*mu_bar(:,i);
%% Trailing edge noise prediction
[I(:,i),f1(:,i),f2(:,i),k_min_bar_prime(:,i),A1_prime(:,i)] = Radiation_integral_total(C(:,i),K_bar,mu_bar(:,i),S0(i),K_1_bar(:,i),K_2_bar(:,i),alpha,input,beta);
%% plot for the specific frequency
factor(i) = abs(kc*I(pos,i).*(input.z/S0(i)));
factor1(i) = abs(kc*f1(pos,i).*(input.z/S0(i)));
factor2(i) = abs(kc*f2(pos,i).*(input.z/S0(i)));
end 

figure(1)
polarplot(pi/180*angle,factor,'DisplayName','Total')
hold on
polarplot(pi/180*angle,factor1,'DisplayName','f1')
polarplot(pi/180*angle,factor2,'DisplayName','f2')
legend

figure(2)
semilogx(omega/fluid.c0*input.chord,10*log10(abs(f1(:,19)).^2))

figure(3)
semilogx(omega/fluid.c0*input.chord,10*log10(abs(f2(:,19)).^2))

% figure(4)
% semilogx(omega/fluid.c0*input.chord,k_min_bar_prime(:,19))
% 
% figure(5)
% semilogx(omega/fluid.c0*input.chord,imag(A1_prime(:,19)))
% 
% 
% figure(6)
% semilogx(omega/fluid.c0*input.chord,C(:,19))
% 
% figure(7)
% semilogx(omega/fluid.c0*input.chord,mu_bar(:,19))
% 
% figure(8)
% semilogx(omega/fluid.c0*input.chord,K_bar(:,19))
% 
% kc_vector = omega/fluid.c0*input.chord;
