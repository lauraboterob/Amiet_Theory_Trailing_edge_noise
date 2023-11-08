function [fluid,input] = inputs_definition()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here



%% fluid properties 
fluid           = struct; 
fluid.T         = 22;
fluid.Tk        = fluid.T+273.15;
fluid.P         = 100000;
fluid.ni        = 1.5e-5;
fluid.gamma     = 1.4;
fluid.R         = 287;
fluid.c0        = 340; %sqrt(fluid.gamma*fluid.R*fluid.Tk);
fluid.rho       = 1.181;
%fluid.rho       = fluid.P/(fluid.R*fluid.Tk);

%% test case parameters
%default ans:
input           = struct;
input.perfil    = 'Naca63018';
input.chord     = 0.3;
input.span      = 0.42;
input.U         = 30;
input.x         = -0.2677;
input.y         = 0;
input.z         = 1.495;
input.AoA       = 3;
input.xtr_s     = 0.05;
input.xtr_p     = 0.05;
input.Mic       = 0.97;
input.Ky        = 0;

prompt         = {'Airfoil:', 'Chord [m]:', 'Span [m]:','U_inf [m/s]:'...
, 'Angle of Attack [degree]:', 'Transition suction side [x/c] (1 for NT):', 'Transition presusre side [x/c] (1 for NT):',...
'Position for taking boundary layer parameters [x/c]:' 'Mic position x [m]:', 'Mic position y [m]:',...
'Mic position z [m]:','K_y_{max} (0 if far-field formulation)'};
dlg_title      = 'Input';
num_lines      = 1;
defaultans     = {num2str(input.perfil),num2str(input.chord),num2str(input.span)...
 ,num2str(input.U),num2str(input.AoA),num2str(input.xtr_s),num2str(input.xtr_p),...
 num2str(input.Mic),num2str(input.x),num2str(input.y),num2str(input.z),num2str(input.Ky)};
data           = inputdlg(prompt,dlg_title,num_lines,defaultans);

input.perfil   = data{1};
input.chord    = str2double(data{2});
input.span     = str2double(data{3});
input.semichord = input.chord/2;
input.U        = str2double(data{4});
input.AoA      = str2double(data{5});
input.xtr_s    = str2double(data{6});
input.xtr_p    = str2double(data{7});
input.Mic      = str2double(data{8});
input.x        = str2double(data{9});
input.y        = str2double(data{10});
input.z        = str2double(data{11});
input.Ky       = str2double(data{12});
input.M        = input.U/fluid.c0;
input.Re       = input.chord*input.U/fluid.ni;
list = {'Goody','Kamruzzaman','Amiet','TNO','Lee'};
[indx] = listdlg('ListString', list, 'Name', 'Surface pressure model');
input.model = list(indx);
end

