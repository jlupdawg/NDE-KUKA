function Dat_File(filename,point_data, vel)
%Dat_File(FileName, PointData)
%   This function creates a .dat file for the KUKA. The file is named
%   based on FileName and includes points for PointData. FileName is a
%   string and PointData is an array containing point data. Individual
%   parts of the .dat file are pulled from text files in a seperate folder.

myDat = fopen(filename+".dat", 'w');

fprintf(myDat, '%s', Header(filename));
fprintf(myDat, "\n\n");
fprintf(myDat, '%s', Body(point_data,vel));

fprintf(myDat, "\n\nENDDAT\n");
fclose('all');
end

function head_text = Header(filename)
%Header(filename)
%   This function takes the FileName argument and creates the header for
%   the .dat file.

chunk_path = "./Dat_Text_Bits/";

f = fopen(chunk_path+"Header_Part1.txt", 'r');
head_text = fscanf(f, '%c', Inf);
fclose(f);

head_text = head_text + filename;

f = fopen(chunk_path+"Header_Part2.txt", 'r');
head_text = head_text + fscanf(f, '%c', Inf);
fclose(f);

end


function body_text = Body(point_data, vel)
%Body(point_data, vel)
%   This function takes the point data and velocity and turns it into a
%   .dat fold.Based on E6POS data.

chunk_path = "./Dat_Text_Bits/";
f = fopen(chunk_path+"Body_Full.txt", 'r');
raw_body_text = fscanf(f, '%c', Inf);
fclose(f);

for x = 1:size(point_data,1)
    body_text = sprintf(raw_body_text, x, point_data(x,:), x, x, vel);
end

end


