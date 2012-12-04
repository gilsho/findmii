
function [y,x,score] = getClickFromHistory(img,point_history)

sig = 200; %each match point votes for a point in a 50 pixel radius
[rows,cols,~] = size(img);                                           
                                           
numPoints = size(point_history,1);

N=2; %%must be even number
votes = zeros(rows,cols);
[Y,X] = meshgrid(-((N-1)*cols-1):(N-1)*cols,-((N-1)*rows-1):(N-1)*rows);
G = 1/(2*pi).*exp(-(X.^2 + Y.^2)./(2*sig));

t_last = point_history(1,5);

for i=1:numPoints
    
    px = point_history(i,1);
    py = point_history(i,2);
    or = point_history(i,3);
    d = point_history(i,4);
    t = point_history(i,5);
    
    if ((px == 0) && (py == 0))
        continue;
    end
    
    %calculate displacement due to time propogration
    displacement = d*(t_last - t);
    px = px + displacement.*cos(or);
    py = py + displacement.*sin(or);
    
    %calcaulte gaussian shift
    gxstart = round(cols-px);
    gxend =  round(N*cols - px-1);
    gystart = round(rows-py);
    gyend = round(N*rows-py-1);
    
    if ((px < 1) || (px > cols) || (py < 1) || (py > rows) ||...
        (px < 1) || (px > cols) || (py < 1) || (py > rows))
        continue;
    end
    
    votes = votes + G(gystart:gyend,gxstart:gxend);
    
end

[max_vote, maxrow] = max(votes,[],1);
[max_vote, maxcol] = max(max_vote);

y = maxrow(maxcol);
x = maxcol;
score = max_vote;

end

