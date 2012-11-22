%%-----------------------------------------------------------------------%%
%                                                                         
% CS231A Project: Find Mii
%                              
% This function is for you to visualize your results.
%
% Huayan Wang huayanw@cs.stanford.edu
%
%%-----------------------------------------------------------------------%%

% You do NOT have to modify this file.

% Usage: see the comments in FindMiiMain.m for details.

function ClickMii(avifile, gtfile, click)
boxes = load(gtfile);
mov_input = mmreader(avifile);
for i=1:size(click,1)
    %mov = aviread(avifile,click(i,1));
    mov = read(mov_input,click(i,1)); 
    sz = size(mov(:,:,1));
    X = repmat(1:sz(2), [sz(1) 1]);
    Y = repmat((1:sz(1))', [1, sz(2)]);
    g = uint8(cat(3, zeros(sz), 255*ones(sz), zeros(sz)));
    r = uint8(cat(3, 255*ones(sz), zeros(sz), zeros(sz)));
    dist = (X-click(i,2)).^2 + (Y-click(i,3)).^2;
    for j=1:size(boxes,2)/4
        x = boxes(click(i,1),(j-1)*4+1);
        y = boxes(click(i,1),(j-1)*4+2);
        w = boxes(click(i,1),(j-1)*4+3);
        h = boxes(click(i,1),(j-1)*4+4);
         box = uint8((((X==x)+(X==x+w)).*(Y>=y).*(Y<=y+h)) + ...
                    (((Y==y)+(Y==y+h)).*(X>=x).*(X<=x+w))>0);
        mov=repmat(1-box,[1 1 3]).*mov+repmat(box,[1 1 3]).*g;
    end
    circle = repmat(uint8((dist>=49).*(dist<=100)),[1 1 3]);
    imwrite(mov.*(1-circle)+r.*circle, ...
        sprintf('click-frame%d.png',click(i,1)));
end