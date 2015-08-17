clc
clear
[h, mA, mB, mC] = setupNXT();
mA.SpeedRegulation = true;
mB.SpeedRegulation = true;
mC.SpeedRegulation = true;
disp('Put robot arm in desired position and press enter')
pause
mA.Stop('Brake');
mB.Stop('Brake');
mC.Stop('Brake');
disp('Press enter to start')
pause
M = importdata('coords.txt');
M(:,1:2) = M(:,1:2)*0.032;
M(:,3) = M(:,3)*0.020;
current = M(1,:,:);
alpha_error = 0;
beta_error = 0;
gamma_error = 0;
for i = 2:size(M,1)
    %moveEngine(mB,-10,20);
    fprintf('Point: %d\n',i);
    disp(M(i,:,:))
    desired = M(i,:,:);
    %Convert the point to angles for the motors
    [alpha, beta, gamma] = calcAngles(current, desired);
    fprintf('Angles (a,b,g) = (%d, %d, %d)\n',alpha,beta,gamma);
    current = desired;
    beta_error = moveEngine(mB,-20,-30*24/8 + beta_error);
    alpha_error = moveEngine(mA,-20,alpha + alpha_error);
    gamma_error = moveEngine(mC,-20,gamma + gamma_error);
    beta_error = moveEngine(mB,-20,beta + 30*24/8 + beta_error);
    mA.WaitFor();
    mB.WaitFor();
    mC.WaitFor();
    pause(0.1);
end
