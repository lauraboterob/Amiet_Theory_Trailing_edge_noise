function  [y1, y2, y3] = Coordinates_definition(inputs,beta,Ra,Psi)

%% observer coordinates - in the plane XZ
X_obs = inputs.R0*sind(inputs.Theta);
Y_obs = 0;
Z_obs = inputs.R0*cosd(inputs.Theta);

%% move to the moving reference frame
x1_obs = inputs.R0*(sind(inputs.Theta)*cosd(inputs.beta+beta)*cosd(Psi)+cosd(inputs.Theta)*sind(inputs.beta+beta));
x2_obs = -inputs.R0*sind(inputs.Theta)*sind(Psi);
x3_obs = inputs.R0*(-sind(inputs.Theta)*sind(inputs.beta + beta)*cosd(Psi)+cosd(inputs.Theta)*cosd(inputs.beta + beta));

%% Location of the midel of the Trailing edge 
y1 = x1_obs - 0;
y2 = x2_obs - Ra;
y3 = x3_obs - 0;
end


