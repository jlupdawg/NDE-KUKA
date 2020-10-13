function Src_File(filename, num_points,vel, wait)
%Src_File(filename, point_data) 
%   This function creates an .src file for the KUKA. The file is named based
%   on filename and includes all of the points listed in point_data.

mySrc = fopen(char(filename)+".src", 'w');

fprintf(mySrc, '%s', Header(filename));
fprintf(mySrc, "\n\n");
fprintf(mySrc, '%s', Body(num_points, vel, wait));

fprintf(mySrc, "\n\nEND\n");
fclose('all');

disp(".src File Created Successfully")

end

function head_text = Header(filename)
%Header(filename)
%   This function takes the FileName argument and creates the header for
%   the .src file.

chunk_path = "./Src_Text_Bits/";

f = fopen(chunk_path+"src_header.txt", 'r');
head_text = fscanf(f, '%c', Inf);
fclose(f);

head_text = head_text + filename + '()';

end

function body_text = Body(num_points,vel, wait)
%Body(point_data)
%   This function takes the point_data argument and creates linear commands
%   for the data. This command should be modified if there are any
%   additional body commands.


chunk_path = "./Src_Text_Bits/";

f = fopen(chunk_path+"src_lin.txt", 'r');
lin_chunk = fscanf(f, '%c', Inf);
fclose(f);

f = fopen(chunk_path+"src_wait.txt", 'r');
wait_chunk = fscanf(f, '%c', Inf);
fclose(f);

f = fopen(chunk_path+"src_home.txt", 'r');
home_chunk = fscanf(f, '%c', Inf);
fclose(f);

body_text = "";

body_text = body_text + Home(home_chunk);


for x = 1:num_points
    
   body_text = body_text + Linear(lin_chunk, x,vel);
   
   if wait
       body_text = body_text + Wait(wait_chunk);
   end
   
end

body_text = body_text + Home(home_chunk);

end

function lin_text = Linear(chunk, num, vel)
%Linear(chunk, num_points,vel)
%   This function takes the num_points argument and creates linear commands
%   for the data. This command should be modified if there are any
%   additional body commands. Chunk is a text block for making a
%   standardized fold.

input = [num vel num num vel num num num vel num];
lin_text = sprintf(chunk,  input);

end

function home_text = Home(home_chunk)
%Home(home_chunk)
%   This function returns the command to go home. Fold template from home_chunk.
%   Later options will
%   include %speed

home_text = home_chunk;

end


function wait_text = Wait(wait_chunk)
%Wait(wait_chunk)
%   This function returns the command to go home. Later options will
%   include %speed
wait_text = wait_chunk;


end





