% ==============================================
% Calculate h from ln[(T(t)-Tamb)/(T0-Tamb)] vs. t
% also give plot of temperature vs time depends on given file 
% Data Format: [Timestamp (HH:MM:SS.FFF), T_amb, T2, T3, T4]
% ==============================================

clc;
clear;
close all;

% Load data as a table (handle timestamp strings)
data = readtable('naturalconvectioncooling.txt', 'Format', '%{HH:mm:ss.SSS}D %f %f %f %f', 'Delimiter', '\t');
% in abovel line file name can be changed to mixedconvectioncooline for
% mixed convections graph
% Extract time, ambient, and sensor data
time = data{:,1};          % Timestamp as datetime
T_amb = data{:,2};         % Ambient temperature (T_amb)
T_sensors = data{:,3:5};   % Sensor readings (T2, T3, T4)

% Convert timestamps to seconds since first data point
time_seconds = seconds(time - time(1));

% Average sensor temperatures (T2, T3, T4)
T_avg = mean(T_sensors, 2);

% Define T0 (initial temperature at t=0)
T0 = T_avg(1); % First sensor average

% Compute normalized temperature ratio: (T(t) - T_amb) / (T0 - T_amb)
% Assume T_amb is constant (use first value)
T_amb_constant = T_amb(1); 
ratio = (T_avg - T_amb_constant) / (T0 - T_amb_constant);

% Filter valid data points (ratio > 0)
valid_indices = ratio > 0;
time_valid = time_seconds(valid_indices);
ratio_valid = ratio(valid_indices);

% Take natural logarithm
ln_ratio = log(ratio_valid);

% Perform linear regression
p = polyfit(time_valid, ln_ratio, 1);
slope = p(1);
intercept = p(2);

% Calculate experimental h
% ---------------------------
% USER INPUTS (update for your setup)
D_outer = 0.03986;     % Outer diameter (m)
D_inner = 0.03426;     % Inner diameter (m)
length = 0.2;           % Length (m)
rho = 8960;             % Copper density (kg/m³)
Cp = 385;               % Specific heat (J/kg·K)

% Compute surface area (A) and volume (V)
A = pi * D_outer * length; % Surface area (m²)
V = (pi/4) * (D_outer^2 - D_inner^2) * length; % Volume (m³)

h_exp = -slope * (rho * V * Cp) / A;

% Display results
fprintf('Slope (m) = %.4f\n', slope);
fprintf('Experimental h = %.2f W/m²·K\n', h_exp);

% Plot ln[(T(t)-Tamb)/(T0-Tamb)] vs. time
figure;
plot(time_valid, ln_ratio, 'bo', 'MarkerSize', 8, 'DisplayName', 'Data');
hold on;
plot(time_valid, polyval(p, time_valid), 'r-', 'LineWidth', 2, 'DisplayName', 'Linear Fit');
xlabel('Time (s)');
ylabel('ln[(T(t)-T_{amb})/(T_0-T_{amb})]');
title('Lumped Capacitance Method Fit');
legend('Location', 'best');
grid on;

figure(2);
plot(time_seconds, T_amb, 'k--', 'LineWidth', 1.5, 'DisplayName', 'T_{ambient}');
hold on;
plot(time_seconds, T_sensors(:,1), 'r-', 'LineWidth', 1.5, 'DisplayName', 'T2 (Top)');
plot(time_seconds, T_sensors(:,2), 'g-', 'LineWidth', 1.5, 'DisplayName', 'T3');
plot(time_seconds, T_sensors(:,3), 'b-', 'LineWidth', 1.5, 'DisplayName', 'T4 (Bottom)');
hold off;
xlabel('Time (s)');
ylabel('Temperature (°C)');
title('Temperature vs. Time for forced convection cooling');
legend('Location', 'best');
grid on;