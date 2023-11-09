function [omega, S_pp, I, S0,f,delta_s] = TE_noise_Prediction(inputs,fluid)
%% Define waves number
[f,omega,C,K_bar,mu_bar,S0,K_1_bar,alpha,U_c,K_2_bar,beta,kappa_bar] = wavesnumbers(inputs,fluid);

%% Transfer functions for subcritical and supercritical ghusts
if inputs.Ky == 0
    inputs.Ky
        [I] = Radiation_integral_total(C,K_bar,mu_bar,S0,K_1_bar,K_2_bar,alpha,inputs,beta);
        %% Spanwise correlation length 
        [l_y] = spanwise_corlength(U_c,omega,K_2_bar,inputs);

        %% Wall pressure PSD
       [Phi_pp_s,Phi_pp_p,delta_s] = surface_pressure_spectrum(omega,inputs,fluid,inputs.model);

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
         [l_y(:,i)] = spanwise_corlength_K2(U_c,omega,K_2_bar(i),inputs);
            %% Stream-wise integrated wavenumber spectral density of wall-pressure fluctuations
         [Pi0_s(:,i),Pi0_p(:,i)] = Integrated_WPS(l_y(:,i)',Phi_pp_s,Phi_pp_p);   
        end   
       %I = I';
       %l_y = l_y';
        %% integrate for each frequency
        for j = 1:length(omega)
            arg = inputs.span/(inputs.chord)*(K_2_bar-kappa_bar(j)*inputs.y/S0);
            temp_s = Pi0_s(j,:).*(sin(arg)./arg).^2.*abs(I(j,:)).^2;
            temp_p = Pi0_p(j,:).*(sin(arg)./arg).^2.*abs(I(j,:)).^2;
            Int_overK2_p = trapz(K_2_bar,temp_p);
            Int_overK2_s= trapz(K_2_bar,temp_s);
            S_pp_s(j) = (omega(j)*inputs.z*inputs.chord/2./(2*pi*fluid.c0*S0^2))^2.*(1/inputs.semichord).*...
                ((Int_overK2_s));
             S_pp_p(j) = (omega(j)*inputs.z*inputs.chord/2./(2*pi*fluid.c0*S0^2))^2.*(1/inputs.semichord).*...
                ((Int_overK2_p));
        end 
        
end 
S_pp = S_pp_s + S_pp_p;
end

