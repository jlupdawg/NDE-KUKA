function data = Get_data(init_points, inc, scan_dir, scan_plane, angle_override, invert_normal)
%Get_data(init_points, vel, inc, scan_dir, scan_plane, angle_override, invert_normal) 
%   Returns a list of point data for for the Kuka to use
%   init_points is a 4x14 matrix consisting of four rows of E6POS data in the order of top_right, top_left, bottom_right, bottom_left
%   inc is the incrememnt between scans in the scan direction (scan_dir) in
%   mm. scan_dir can be X, Y, or Z direction. Scan_plane, angle_override,
%   and invert_normal are all used for overriding angles based on the scan
%   plane.

%% Variable Declaration
X = 1; Y = 2; Z = 3; A = 4; B = 5; C = 6;
right_start = init_points(1,:);
left_start = init_points(2,:);
right_end = init_points(3,:);
left_end = init_points(4,:);



%% Setting Scan Direction
if scan_dir == "Z"
    scan_direction = Z;
elseif scan_dir == "Y"
    scan_direction = Y;
elseif scan_dir == "X"
    scan_direction = X;
else 
    disp("Invalid Option. Using Z for scan")
    scan_direction = Z;
end

%% Dealing with angles
if angle_override
    disp("PLEASE RUN IN T1 MODE TO ENSURE MOTOR OVERRIDES DO NOT CAUSE A COLLISION")
   if scan_plane == "XY"
       if not(invert_normal)
        ABC = [180, 0, 180];
       else
        disp("Invert is not possible for XZ plane. Using normal XY scan")      
       end
   elseif scan_plane == "XZ"
       if not(invert_normal)
        ABC = [75, 90, 160];
       else
        ABC = [-75, 90, -160];      
       end
   elseif scan_plane == "YZ"
      if not(invert_normal)
        ABC = [-180, 90, 180];
      else
        disp("Invert is not possible for YZ plane. Using normal YZ scan")
        ABC = [-180, 90, 180];
      end
   else
    disp("Invalid Option. Using YZ for scan plane")
    ABC = [-180, 90, 180];
   end
end

%% Creating Scan Points
rows = round(abs((right_start(scan_direction)-left_end(scan_direction))/inc),0) + 1;
data = zeros(2*rows,14);

%% Scan positions
for x = 1:rows %Create point positions
   r_ref = (2*x)-1;
   l_ref = (2*x);
   
   %Make vector equal to start
   data(r_ref,:) = right_start; 
   data(l_ref,:) = left_start;
   
   data(r_ref,scan_direction) = data(r_ref,scan_direction) - (x-1)*inc; %Adjust reference pos
   data(l_ref,scan_direction) = data(l_ref,scan_direction) - (x-1)*inc; %Adjust reference pos
end

%%Scan Angles
if not(angle_override)
    for x = 1:rows %Create point positions
       r_ref = (2*x)-1;
       l_ref = (2*x);

       pc = x/rows; %portion complete

       %Adjust A, B, and C based on percent to bottom
       data(r_ref,A) = (right_start(A)-right_end(A))*(1-pc) + right_end(A);
       data(r_ref,B) = (right_start(B)-right_end(B))*(1-pc) + right_end(B);
       data(r_ref,C) = (right_start(C)-right_end(C))*(1-pc) + right_end(C);
       data(l_ref,A) = (left_start(A)-left_end(A))*(1-pc) + left_end(A);
       data(l_ref,B) = (left_start(B)-left_end(B))*(1-pc) + left_end(B);
       data(l_ref,C) = (left_start(C)-left_end(C))*(1-pc) + left_end(C);
    end
else
    for x = 1:rows %Create point positions
       r_ref = (2*x)-1;
       l_ref = (2*x);
       
       %Adjust A, B, and C based on angle overrides
       data(r_ref,A) = ABC(1);
       data(r_ref,B) = ABC(2);
       data(r_ref,C) = ABC(3);
       data(l_ref,A) = ABC(1);
       data(l_ref,B) = ABC(2);
       data(l_ref,C) = ABC(3);
    end
end

%% Converting to raster pattern
for x = 3:4:rows*2  %Convert to raster scan pattern
    temp = data(x,:);
    data(x,:) = data(x+1,:);
    data(x+1,:) = temp;
end

disp("Data Points Created Successfuly")

end

