function [ alpha, beta, gamma ] = calcAngles(start, desired)
%calcAngles Summary of this function goes here
% Lego unit conversion 4 dots = one big square
LEGO = 0.032;
%Motor gearing
mA_gear = 56/8;
mB_gear = -24/8;
mC_gear = 36/12;
% Position parameters of base
base = [5.5*LEGO, -2.125*LEGO, 0];
%Lengths of robot
base2a = 0.162;
a2b = 0.156;
b2c = 0.212;
% Position of joint A
joint_A = [5.5*LEGO, -2.125*LEGO, base2a];
% T length
a2c_new = norm(desired - joint_A);
a2c_old = norm(start - joint_A);
% Calculations
% Alpha = first joint
alpha = int32(rad2deg(atan2(desired(1)-base(1),desired(2)-base(2)) - atan2(start(1)-base(1),start(2)-base(2)))*mA_gear);
% Beta = second joint
phi_e = @(T) acos((a2b^2+T^2-b2c^2)/(2*a2b*T));
phi_f = @(T,z_p) acos((base2a-z_p)/T);
beta  = int32(rad2deg((phi_e(a2c_new) + phi_f(a2c_new,desired(3))) - (phi_e(a2c_old) + phi_f(a2c_old,start(3))))*mB_gear);
% Gamma = third joint
phi_d = @(T) acos((b2c^2 + a2b^2 - T^2)/(2*b2c*a2b));
gamma = int32(rad2deg(phi_d(a2c_new)-phi_d(a2c_old))*mC_gear);
end