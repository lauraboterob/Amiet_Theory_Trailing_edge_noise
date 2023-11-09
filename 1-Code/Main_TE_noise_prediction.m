%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the main script to calculate the trailing edge noise based on
% the theory of Roger-Moreu 2005. 
% In this code, the back scattering effect is also taken into account. 
% Laura Botero Bolívar - University of Twente 
% l.boterobolivar@utwente.nl
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clear all
hold all

%% inputs
[fluid,inputs] = inputs_definition();

%% Define waves number
[f,omega,C,K_bar,mu_bar,S0,K_1_bar,alpha,U_c,K_2_bar,beta,kappa_bar] = wavesnumbers(inputs,fluid);

%% Transfer functions for subcritical and supercritical ghusts
if inputs.Ky == 0
    inputs.Ky
        [I] = Radiation_integral_total(C,K_bar,mu_bar,S0,K_1_bar,K_2_bar,alpha,inputs,beta);
        %% Spanwise correlation length 
        [l_y] = spanwise_corlength(U_c,omega,K_2_bar,inputs);

        %% Wall pressure PSD
        [Phi_pp_s,Phi_pp_p] = surface_pressure_spectrum(omega,inputs,fluid,inputs.model);

        %% Stream-wise integrated wavenumber spectral density of wall-pressure fluctuations
        [Pi0_s,Pi0_p] = Integrated_WPS(l_y,Phi_pp_s,Phi_pp_p);

        %% far-field noise
        [S_pp_s,S_pp_p] = farfield_noise(inputs,fluid,omega,S0,I,Pi0_s,Pi0_p);
else 
        %% Wall pressure PSD
        [Phi_pp_s,Phi_pp_p] = surface_pressure_spectrum(omega,inputs,fluid,inputs.model);
        for i = 1:length(K_2_bar)
            [I(:,i)] = Radiation_integral_total(C,K_bar,mu_bar,S0,K_1_bar,K_2_bar(i),alpha,inputs,beta)';
            %% Spanwise correlation length 
            [l_y(:,i)] = spanwise_corThe length_K2(U_c,omega,K_2_bar(i),inputs);
            %% Stream-wise integrated wavenumber spectral density of wall-pressure fluctuations
            [Pi0_s(:,i),Pi0_p(:,i)] = Integrated_WPS(l_y(:,i)',Phi_pp_s,Phi_pp_p);   
        end   
       %I = I';
       %l_y = l_y';
        %% integrate for each frequency
        for j = 1:length(omega)
            center = K_2_bar+kappa_bar(j)*inputs.y/S0;
            arg = inputs.span/(inputs.chord)*(center-kappa_bar(j)*inputs.y/S0);
            temp_s = Pi0_s(j,:).*(sin(arg)./arg).^2.*abs(I(j,:)).^2;
            temp_p = Pi0_p(j,:).*(sin(arg)./arg).^2.*abs(I(j,:)).^2;
            Int_overK2_p = trapz(center,temp_p);
            Int_overK2_s= trapz(center,temp_s);
            S_pp_s(j) = (1/4)*(omega(j)*inputs.z*inputs.span*inputs.semichord./(2*pi*fluid.c0*S0^2)).^2.*(1/inputs.semichord).*...
                ((Int_overK2_s));
             S_pp_p(j) = (1/4)*(omega(j)*inputs.z*inputs.span*inputs.semichord./(2*pi*fluid.c0*S0^2)).^2.*(1/inputs.semichord).*...
                ((Int_overK2_p));
            if mod(j,100) == 0
               figure(4)
               hold on
               plot(center,temp_p)
            end
        end 
        
end 
S_pp = S_pp_s + S_pp_p;
%% convert to 1/3 octave
[sortedData,Fc,Flow,Fhigh] = NarrowToNthOctave(f,10*log10(S_pp_s),3);
sortedData_Pa2_db=10*log10(8*pi*10.^(sortedData/10)/(20*10^-6)^2);

%% plots
plots(f,I,Phi_pp_s,Phi_pp_p,S_pp,S_pp_s,S_pp_p)

send = 10*log10(4*pi*S_pp/(20*10^-6)^2)';
send2 = f';
send3= 10*log10(2*pi*Phi_pp_s/(20*10^-6)^2)';
send4= 10*log10(2*pi*Phi_pp_p/(20*10^-6)^2)';


