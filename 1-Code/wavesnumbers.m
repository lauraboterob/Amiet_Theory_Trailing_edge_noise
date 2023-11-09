function [f,omega,C,K_bar,mu_bar,S0,K_1_bar,alpha,U_c,K_2_bar,beta,kappa_bar] = wavesnumbers(inputs,fluid)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%% frequenct definition
kc = [0.05:0.005:15];
f       = linspace(400,20000,1000); %kc*340/(2*pi*inputs.chord);[fluid.c0/(2*pi*inputs.chord) 100*fluid.c0/(2*pi*inputs.chord)];%linspace(100,20000,1000); %100:20000; 
omega   = 2*pi*f;
kappa   = omega/fluid.c0; %acoustic wavenumber
beta    = sqrt(1-inputs.M^2);
K       = omega/inputs.U; % aerodynamic wavenumber
S0      = sqrt(inputs.x^2 + beta^2*(inputs.y^2+inputs.z^2));

%% Normalization by semichord
b       = inputs.semichord;
X       = inputs.x/b;
Y       = inputs.y/b;
Z       = inputs.z*beta/b;
K_bar   = K*b; 
kappa_bar = kappa*b;

%% Additional parametes to the transfer function
mu_bar  = K_bar*inputs.M/beta^2;
%Kx*self.M/self.beta_square
U_c     = 0.7*inputs.U; %convection velocity. MR did not give an specific value
alpha   = inputs.U/U_c;
K_1_bar = alpha*K_bar;
C       = K_1_bar-mu_bar*(inputs.x/S0 - inputs.M); %temporal variables 
%Kx/self.chi - self.mu(Kx)*(self.X[0]/self.sigma0 - self.M)

if inputs.Ky == 0 
K_2_bar = kappa_bar*inputs.y/S0; %in the case we have not define ky.
else 
K_2_bar = linspace(-inputs.Ky, inputs.Ky, 100);
end 
end

