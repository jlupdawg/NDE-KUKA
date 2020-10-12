clc;clear;close all
%{
Joseph Lupton
10/11/2020
Kuka Main Code
%}

%Info in format of [X,Y,Z,A,B,C,S,T,E1,E2,E3,E4,E5,E6] Check T and S?

% Replace with real values
top_right = [400,100,200,-15,78,-39,6,27,0,0,0,0,0,0];
bottom_left = [100,100,100,-15,78,-39,6,27,0,0,0,0,0,0];
vel = 0.1; %m/s
z_inc = 1; %mm

%% Data Creation

rows = (top_right(3)-bottom_left(3))/z_inc +1;
data = zeros(2*rows,14);

%right_column
for x = 1:rows
    ref = (2*x)-1;
   data(ref,:) = top_right;
   data(ref,3) = data(ref,3) - (x-1)*z_inc;
end

%left_column
for x = 1:rows
    ref = (2*x);
   data(ref,:) = data(ref-1,:);
   data(ref,1) = bottom_left(1);
end

%% 
