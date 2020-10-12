clc;clear;close all
%{
Joseph Lupton
10/11/2020
Kuka Main Code
%}

% Replace with real values
%Info in format of [X,Y,Z,A,B,C,S,T,E1,E2,E3,E4,E5,E6] Check T and S?
top_right = [400,100,200,20,25,30,8,42,0,0,0,0,0,0];
top_left = [400,0,200,5,10,15,6,27,0,0,0,0,0,0];

bottom_right = [400,100,100,0,5,10,8,42,0,0,0,0,0,0];
bottom_left = [400,0,100,45,25,30,6,27,0,0,0,0,0,0];

vel = 0.1; %m/s
inc = 5; %mm
scan_dir = "Z"; %Y or Z using X as fixed base


%% Data Creation

A = [top_right; top_left; bottom_right; bottom_left];
data_points = Get_data(A, inc, scan_dir);

