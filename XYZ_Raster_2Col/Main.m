clc;clear;close all
%{
Joseph Lupton
10/11/2020
Kuka Main Code
%}

%Replace with real values
%Info in format of [X,Y,Z,A,B,C,S,T,E1,E2,E3,E4,E5,E6] Check T and S?
top_right = [484,191,376.56,7.14,83.84,95.65,6,27,0,0,0,0,0,0];
top_left = [610.17,191,376.56,7.15, 83.83, 95.66,6,27,0,0,0,0,0,0];

bottom_right = [484,191,207.79,7.19,83.83,95.71,6,27,0,0,0,0,0,0];
bottom_left = [610.18,191,207.77,7.17, 83.83, 95.69,6,25,0,0,0,0,0,0];

velocity = 0.1; %m/s
increment = 5; %mm
scan_dir = "Z"; %X, Y, Z
scan_plane = "XZ"; %XY, XZ, YZ
angle_override = false; %true for non-sweeping points at 90 degree angles to plane
invert_normal = false; %flips scan angle
delay = true; %delay between scan lines
point_delay = true;
delay_time = 0.3; % in seconds
program_name = "KukaScan";

%% Data Creation

A = [top_right; top_left; bottom_right; bottom_left];

data_points = Get_data_Indiv(A, increment, scan_dir, scan_plane);
%% Dat File Creation

Dat_File_Indiv(program_name, data_points)

%% Src File Creation

Src_File_Indiv(program_name, (size(data_points,1)*size(data_points,2)), velocity, delay, delay_time);
