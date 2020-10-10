function Dat_File(FileName,PointData)
%Dat_File(FileName, PointData)
%   This function creates a .dat file for the KUKA. The file is named
%   based on FileName and includes points for PointData. FileName is a
%   string and PointData is an array containing point data. Individual
%   parts of the .dat file are pulled from text files in a seperate folder.

myDat = fopen(FileName+".dat", 'w');

fprintf(myDat, '%s', Header(FileName));

%Body(PointData);

fprintf(myDat, "'\n' ENDDAT '\n'");
fclose(myDat);
end

function header = Header(FileName)
%Header(Filename, Path)
%   This function takes the FileName argument and creates the header for
%   the .dat file and the path for text file chunks (bits of existing header file).

chunk_path = "./Dat_Text_Bits/";

f = fopen(chunk_path+"Header_Part1.txt", 'r');
header = fscanf(f, '%c', Inf);
fclose(f);

header = header + FileName;

f = fopen(chunk_path+"Header_Part2.txt", 'r');
header = header + fscanf(f, '%c', Inf);
fclose(f);

f = fopen(chunk_path+"Header_Part3.txt", 'r');
header = header + fscanf(f, '%c', Inf);
fclose(f);

end