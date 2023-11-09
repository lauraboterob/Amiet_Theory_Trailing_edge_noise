function [Phi_pp_s,Phi_pp_p,delta_s] = surface_pressure_spectrum(omega,inputs,fluid,model)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

%% inputs from XFOIL
[delta_s_s,delta_s_p,theta_s,theta_p,cf_s,cf_p,x_c,Cp,Ue_s,Ue_p,dcpdx_s,dcpdx_p] = XFOIL_new_airfoil(inputs.perfil,inputs.AoA,inputs.Re,inputs.M,inputs.xtr_s,inputs.xtr_p,inputs.chord,inputs.Mic);

% figure()
% plot(x_c,Cp,'o')

%boundary layer parameter for each side of the airfoil
[delta_s,tau_w_s,u_t_s] = Boundary_layer_characteristics(delta_s_s,theta_s,cf_s,Ue_s,inputs,fluid);
[delta_p,tau_w_p,u_t_p] = Boundary_layer_characteristics(delta_s_p,theta_p,cf_p,Ue_p,inputs,fluid);

%for validation purposes - uncomment:
% Ue_s = 0.9186;
% Ue_p = 0.9186;
% delta_s = 0.4*0.0229;
% delta_p = 0.4*0.0229;
% delta_s_s = 0.4*0.0057;
% delta_s_p = 0.4*0.0057;
% theta_s = 0.4*0.0034;
% theta_p = 0.4*0.0034;
% u_t_s = inputs.U*0.0277;
% u_t_p = inputs.U*0.0277;
% tau_w_s = fluid.rho*u_t_s^2;
% tau_w_p = fluid.rho*u_t_p^2;
% cf_s = tau_w_s/(0.5*fluid.rho*inputs.U^2);
% cf_p = tau_w_p/(0.5*fluid.rho*inputs.U^2);
% beta_c = 5.2832;
% dcpdx_s = beta_c/(theta_s/tau_w_s)*(1/(0.5*fluid.rho*inputs.U^2/inputs.chord));
% dcpdx_p = dcpdx_s;

% %andreas simulations
% Ue_s = 0.9133;
% Ue_p = 0.9133;
% delta_s = 0.0086;
% delta_p = 0.0086;
% delta_s_s = 0.00302;
% delta_s_p = 0.00302;
% theta_s = 0.00163;
% theta_p = 0.00163;
% u_t_s = 0.9106;
% u_t_p = 0.9106;
% tau_w_s = fluid.rho*u_t_s^2;
% tau_w_p = fluid.rho*u_t_p^2;
% cf_s = tau_w_s/(0.5*fluid.rho*inputs.U^2);
% cf_p = tau_w_p/(0.5*fluid.rho*inputs.U^2);
% beta_c = 0.1969;
% dcpdx_s = (beta_c/(theta_s/tau_w_s))*(1/(0.5*fluid.rho*inputs.U^2/inputs.chord));
% dcpdx_p = dcpdx_s;
%% Several wall pressure models 
tf = strcmp(model,'Goody');
if tf == 1   
    [a_s,b_s,c_s,d_s,e_s,f_s,g_s,h_s,i_s,R_s,phi_s_s,omega_s] = Goody(omega,tau_w_s,delta_s,Ue_s,u_t_s,fluid,inputs);
    [Phi_pp_s] = phi_pp_oneside(a_s,b_s,c_s,d_s,e_s,f_s,g_s,h_s,i_s,R_s,phi_s_s,omega_s);
    [a_p,b_p,c_p,d_p,e_p,f_p,g_p,h_p,i_p,R_p,phi_s_p,omega_s] = Goody(omega,tau_w_p,delta_p,Ue_p,u_t_p,fluid,inputs);
    [Phi_pp_p] = phi_pp_oneside(a_p,b_p,c_p,d_p,e_p,f_p,g_p,h_p,i_p,R_p,phi_s_p,omega_s);
end
tf = strcmp(model,'Kamruzzaman');
if tf ==1
    [a_s,b_s,c_s,d_s,e_s,f_s,g_s,h_s,i_s,R_s,phi_s_s,omega_s] = Kamruzzaman(inputs,fluid,cf_s, theta_s, dcpdx_s,delta_s_s,Ue_s, omega,u_t_s);
    [Phi_pp_s] = phi_pp_oneside(a_s,b_s,c_s,d_s,e_s,f_s,g_s,h_s,i_s,R_s,phi_s_s,omega_s);
    [a_p,b_p,c_p,d_p,e_p,f_p,g_p,h_p,i_p,R_p,phi_s_p,omega_p] = Kamruzzaman(inputs,fluid,cf_p, theta_p, dcpdx_p,delta_s_p,Ue_p, omega,u_t_s);
    [Phi_pp_p] = phi_pp_oneside(a_p,b_p,c_p,d_p,e_p,f_p,g_p,h_p,i_p,R_p,phi_s_p,omega_p);    
end 
tf = strcmp(model,'TNO');
if tf ==1
    [Phi_pp_s] = 2*TNO(delta_s,u_t_s,fluid,inputs, dcpdx_s,tau_w_s,delta_s_s,omega);
    [Phi_pp_p] = 2*TNO(delta_p,u_t_p,fluid,inputs, dcpdx_p,tau_w_p,delta_s_p,omega);
end
tf = strcmp(model,'Amiet');
if tf == 1
    [Phi_pp_s] = Amiet_Sqq(inputs, fluid, omega, delta_s_s);
    [Phi_pp_p] = Amiet_Sqq(inputs, fluid, omega, delta_s_p);
end
tf = strcmp(model,'Lee');
if tf == 1
    [a_s,b_s,c_s,d_s,e_s,f_s,g_s,h_s,i_s,R_s,phi_s_s,omega_s] = Lee(inputs,fluid,cf_s, theta_s, dcpdx_s,delta_s_s,delta_s,Ue_s, omega, u_t_s);
    [Phi_pp_s] = phi_pp_oneside(a_s,b_s,c_s,d_s,e_s,f_s,g_s,h_s,i_s,R_s,phi_s_s,omega_s);
    [a_p,b_p,c_p,d_p,e_p,f_p,g_p,h_p,i_p,R_p,phi_s_p,omega_p] = Lee(inputs,fluid,cf_p, theta_p, dcpdx_p,delta_s_p,delta_p,Ue_p, omega, u_t_p);
    [Phi_pp_p] = phi_pp_oneside(a_p,b_p,c_p,d_p,e_p,f_p,g_p,h_p,i_p,R_p,phi_s_p,omega_p); 
end
end

