function Dat_File_Indiv(filename,point_data)
%Dat_File(FileName, PointData)
%   This function creates a .dat file for the KUKA. The file is named
%   based on FileName and includes points for PointData. The FileName is a
%   string and PointData is an array containing point data. Individual
%   parts of the .dat file are pulled from text files in a seperate folder.

myDat = fopen(char(filename)+".dat", 'w');

fprintf(myDat, '%s', Header(filename));
fprintf(myDat, "\n\n");
fprintf(myDat, '%s', Body(point_data));

fprintf(myDat, "\n\nENDDAT\n");
fclose('all');

disp(".dat File Created Successfully")
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


function body_text = Body(point_data)
    %Body(point_data)
    %   This function takes the point data and velocity and turns it into a
    %   .dat fold.Based on E6POS data.

    chunk_path = "./Dat_Text_Bits/";
    f = fopen(chunk_path+"Body_Full.txt", 'r');
    raw_body_text = fscanf(f, '%c', Inf);
    fclose(f);

    body_text = "";

    row = size(point_data,1);
    col = size(point_data,2);

    for x = 2:2:row %Prepare for raster scan by flipping every other row
        point_data(x, :, :) = fliplr(point_data(x, :, :));
    end
    
    count = 1;
    for x = 1:row
        for y = 1:col
            body_text = body_text + sprintf(raw_body_text, count, point_data(x,y,:), count, count);
            count = count + 1;
        end
    end

end


