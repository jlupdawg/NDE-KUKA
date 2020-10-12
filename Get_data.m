function data = Get_data(init_points, inc, scan_dir)
%Get_data(init_points, vel, inc, scan_dir) returns a list of point data for for the Kuka to use
%   init_points is a 4x14 matrix consisting of four rows of E6POS data in the order of top_right, top_left, bottom_right, bottom_left
%   inc is the incrememnt between scans in the scan direction (scan_dir) in
%   mm. For right now, scan_dir is limited to the Y and Z directions with X
%   held constant.

Y = 2; Z = 3; A = 4; B = 5; C = 6;

top_right = init_points(1,:);
top_left = init_points(2,:);
bottom_right = init_points(3,:);
bottom_left = init_points(4,:);

if scan_dir == "Z"
    scan_direction = Z;

    right_start = top_right;
    right_end = bottom_right;

    left_start = top_left;
    left_end = bottom_left;
    
elseif scan_dir == "Y"
    scan_direction = Y;

    right_start = top_left;
    right_end = top_right;

    left_start = bottom_left;
    left_end = bottom_right;
else 
    disp("Invalid Option. Using Z for scan")
    scan_direction = Z;

    right_start = top_right;
    right_end = bottom_right;

    left_start = top_left;
    left_end = bottom_left;
end

rows = abs(right_start(scan_direction)-left_end(scan_direction))/inc + 1;

data = zeros(2*rows,14);

for x = 1:rows
   r_ref = (2*x)-1;
   l_ref = (2*x);
   
   pc = x/rows; %portion complete
   
   %Make vector equal to start
   data(r_ref,:) = right_start; 
   data(l_ref,:) = left_start;
   
   data(r_ref,scan_direction) = data(r_ref,scan_direction) - (x-1)*inc; %Adjust reference pos
   data(l_ref,scan_direction) = data(l_ref,scan_direction) - (x-1)*inc; %Adjust reference pos
   
   %Adjust A, B, and C based on percent to bottom
   data(r_ref,A) = (right_start(A)-right_end(A))*(1-pc) + right_end(A);
   data(r_ref,B) = (right_start(B)-right_end(B))*(1-pc) + right_end(B);
   data(r_ref,C) = (right_start(C)-right_end(C))*(1-pc) + right_end(C);
   data(l_ref,A) = (left_start(A)-left_end(A))*(1-pc) + left_end(A);
   data(l_ref,B) = (left_start(B)-left_end(B))*(1-pc) + left_end(B);
   data(l_ref,C) = (left_start(C)-left_end(C))*(1-pc) + left_end(C);
end



end

