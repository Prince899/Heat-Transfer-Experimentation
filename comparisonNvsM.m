% ==============================================
% Compare Natural vs. Forced Convection (Cooling)
% Data Format for both files: [Time, T_ambient, T2, T3, T4]
% ==============================================

clc;
clear;
close all;

% Load data from both files
natural_data = readtable('naturalconvectioncooling.txt', 'Format', '%{HH:mm:ss.SSS}D %f %f %f %f', 'Delimiter', '\t');
forced_data = readtable('mixedconvectioncooling.txt', 'Format', '%{HH:mm:ss.SSS}D %f %f %f %f', 'Delimiter', '\t');

% Process Natural Convection Data
time_natural = natural_data{:,1};
T_ambient_natural = natural_data{:,2};
T_sensors_natural = natural_data{:,3:5};
Ts_avg_natural = mean(T_sensors_natural, 2); % Average of T2,T3,T4
time_seconds_natural = seconds(time_natural - time_natural(1)); % Convert to seconds

% Process Forced Convection Data
time_forced = forced_data{:,1};
T_ambient_forced = forced_data{:,2};
T_sensors_forced = forced_data{:,3:5};
Ts_avg_forced = mean(T_sensors_forced, 2); % Average of T2,T3,T4
time_seconds_forced = seconds(time_forced - time_forced(1)); % Convert to seconds

% Plot Temperature vs. Time
figure;
hold on;

% Ambient Temperature (use first dataset's ambient)
plot(time_seconds_natural, T_ambient_natural, 'k--', 'LineWidth', 1.5, 'DisplayName', 'T_{ambient}');

% Natural Convection (Ts_avg)
plot(time_seconds_natural, Ts_avg_natural, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Natural Convection (Ts_{avg})');

% Forced Convection (Ts_avg)
plot(time_seconds_forced, Ts_avg_forced, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Mixed Convection (Ts_{avg})');

hold off;

% Customize plot
xlabel('Time (s)');
ylabel('Temperature (°C)');
title('Natural vs. Mixed Convection Cooling');
legend('Location', 'best');
grid on;