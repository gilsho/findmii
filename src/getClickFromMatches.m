function [yclick xclick] = getClickFromMatches(img,ref_frame,frame,...
                                               matches,threshold)

radius = 50; %each match point votes for a point in a 50 pixel radius
[rows,cols,~] = size(img);                                           
                                           
numMatches = size(matches,2);

match_votes = zeros(rows,cols);
[Y,X] = meshgrid(-(cols-1):cols,-(rows-1):rows);
sig = 50;
G = 1/(2*pi).*exp(-(X.^2 + Y.^2)./(2*sig));
for i=1:numMatches
    numframe = matches(2,i);
    matchpoint = frame(1:2,numframe);
    xpoint = round(matchpoint(1));
    ypoint = round(matchpoint(2));
    gxstart = cols-xpoint;
    gxend =  2*cols - xpoint-1;
    gystart = rows-ypoint;
    gyend = 2*rows-ypoint-1;
    votes = G(gystart:gyend,gxstart:gxend);
    
    match_votes = match_votes + votes;
end

figure; imagesc(match_votes);


[max_vote, maxrow] = max(match_votes,[],1);
[max_vote, maxcol] = max(max_vote);

if (max_vote > threshold)
   xclick = maxcol;
   yclick = maxrow(maxcol);
else
   xclick = -1;
   yclick = -1;
end

                                      
end

