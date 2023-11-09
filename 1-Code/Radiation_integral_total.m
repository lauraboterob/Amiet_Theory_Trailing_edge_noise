function [I,f1,f2,k_min_bar_prime,A1_prime] = Radiation_integral_total(C,K_bar,mu_bar,S0,K_1_bar,K_2_bar,alpha,inputs,beta)
if inputs.Ky ~= 0
    K_2_bar = repmat(K_2_bar,1,length(K_1_bar));
 end 
for i=1:length(K_1_bar)
if K_2_bar(i)^2 < (K_1_bar(i)*inputs.M/(alpha*beta))^2
     k_min_bar = sqrt(abs(mu_bar(i)^2-K_2_bar(i)^2/beta^2));
      % np.sqrt(abs(self.mu(Kx)**2 - Ky**2/self.beta_square))
     B         = K_1_bar(i) + inputs.M.*mu_bar(i) + k_min_bar;    %temporal variable
      %  Kx/self.chi + self.M*self.mu(Kx) + self.kappa(Kx,Ky)
    
    %variable(i) = K_1_bar(i)/(340)*2*inputs.U/alpha;

    %% transfer function f1 (identical to Amiet)
    [f1(i)] = Radiation_integral1(B,C(i));

    %% Transfer function f2 (for the Back-scattering effect)
    [f2(i)] = Raditation_integral2(B,K_bar(i),k_min_bar,mu_bar(i),S0,K_1_bar(i),alpha,inputs);

    %% Radiation integral total
    [I(i)] = Radiation_integral(f1(i),f2(i));
    
 elseif K_2_bar(i)^2 > (K_1_bar(i)*inputs.M/(alpha*beta))^2
    % disp(i)
    [k_min_bar_prime(i),A1_prime(i),A_prime(i),Theta_prime(i)] = Wavenumbers_subcrit(inputs,mu_bar(i),K_1_bar(i),K_2_bar(i),K_bar(i),beta);
    %% transfer function f1
    [f1(i)] = Radiation_integral1_subcrict(C(i),A1_prime(i),mu_bar(i),inputs,S0,k_min_bar_prime(i));
    
    %% transfer function f2
    [f2(i)] = Radiation_integral2_subcrict(A_prime(i),A1_prime(i),mu_bar(i),inputs,S0,k_min_bar_prime(i),alpha,K_bar(i),Theta_prime(i));
    
     %% Radiation integral total
    [I(i)] = Radiation_integral(f1(i),f2(i));
 end 
end

