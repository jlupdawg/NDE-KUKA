function data = Get_data_Indiv(init_points, inc, scan_dir, scan_plane, points)
%Get_data(init_points, vel, inc, scan_dir, scan_plane) 
%   Returns a list of point data for the Kuka to use
%   init_points is a 4x14 matrix consisting of four rows of E6POS data in the order of top_right, top_left, bottom_right, bottom_left
%   inc is the incrememnt between scans in the scan direction (scan_dir) in
%   mm. scan_dir can be X, Y, or Z direction. Scan_plane is a combination
%   of X, y, and Z that determines the direction that the points should be
%   made in. points is a boolean that determines if individual scanning
%   points will be generated between scanning columns. These points are
%   automatically made at an increment inc.

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

point_dir = erase(scan_plane, scan_dir);
if point_dir == "Z"
    point_direction = Z;
elseif point_dir == "Y"
    point_direction = Y;
elseif point_dir == "X"
    point_direction = X;
else 
    disp("Invalid Option. Using Y for points")
    point_direction = Y;
end
%% Creating Scan Points
rows = round(abs((right_start(scan_direction)-left_end(scan_direction))/inc),0) + 1;
cols = round(abs((right_start(point_direction)-left_end(point_direction))/inc),0) + 1;

if(~points)
    cols = 2;
end

data = zeros(rows, cols ,14);

%% Scan positions
for x = 1:rows %Create End points
   data(x, 1, :) = left_start;
   data(x, cols, :) = right_start;
    
   data(x, 1, scan_direction) = data(x, 1, scan_direction) - (x-1)*inc;
   data(x, cols, scan_direction) = data(x, cols, scan_direction) - (x-1)*inc;
    
   pc = x/rows; %portion complete

   %Adjust A, B, and C based on percent to bottom
   data(x, cols,A) = (right_start(A)-right_end(A))*(1-pc) + right_end(A);
   data(x, cols,B) = (right_start(B)-right_end(B))*(1-pc) + right_end(B);
   data(x, cols,C) = (right_start(C)-right_end(C))*(1-pc) + right_end(C);
   data(x, 1,A) = (left_start(A)-left_end(A))*(1-pc) + left_end(A);
   data(x, 1,B) = (left_start(B)-left_end(B))*(1-pc) + left_end(B);
   data(x, 1,C) = (left_start(C)-left_end(C))*(1-pc) + left_end(C);
end

if(points)
    for x = 1:rows %Create middle points points
        for y = 2:cols-1
            data(x, y, :) = data(x, 1, :);
            data(x, y, point_direction) = data(x, y, point_direction) - (y-1)*inc;

            pc = x/rows; %portion complete

            data(x, y,A) = (data(x,1, A)- data(x,cols, A))*(1-pc) + data(x,cols,A);
            data(x, y,B) = (data(x,1, B)- data(x,cols, B))*(1-pc) + data(x,cols,B);
            data(x, y,C) = (data(x,1, C)- data(x,cols, C))*(1-pc) + data(x,cols,C);
        end
    end
end
disp("Data Points Created Successfuly")

end

