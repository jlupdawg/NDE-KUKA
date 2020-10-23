clc;clear;close all
%{
Joseph Lupton
10/11/2020
Kuka Main Code
%}

% Replace with real values
%Info in format of [X,Y,Z,A,B,C,S,T,E1,E2,E3,E4,E5,E6] Check T and S?
top_right = [325,139.69,556.683,179.197,88.833,-179.989,6,27,0,0,0,0,0,0];
top_left = [325,-135.437,556.683,179.424,88.84,-179.75,6,50,0,0,0,0,0,0];

bottom_right = [325,139.69,289.31,179.95,88.85,-179.13,6,27,0,0,0,0,0,0];
bottom_left = [325,-135.482,289.31,179.95,88.85,-179.13,6,50,0,0,0,0,0,0];

velocity = 1; %m/s
increment = 5; %mm
scan_dir = "Z"; %X, Y, Z
scan_plane = "YZ"; %XY, XZ, YZ
angle_override = true; %true for non-sweeping points at 90 degree angles to plane
invert_normal = false; %flips scan angle
delay = true; %delay between scan lines
delay_time = 0.3; % in seconds
program_name = "KukaScan";

%% Data Creation

A = [top_right; top_left; bottom_right; bottom_left];
data_points = Get_data(A, increment, scan_dir, scan_plane, angle_override, invert_normal);

%% Dat File Creation

Dat_File(program_name, data_points)

%% Src File Creation

Src_File(program_name, size(data_points,1), velocity, delay, delay_time)
