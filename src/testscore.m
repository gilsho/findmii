% score the project
function testscore(t,l)
fid2 = fopen(strcat('score.report.', 'TEST_t', num2str(t), 'l', num2str(l)) ,'w');
nclick = [1 1 1; 2 2 2; 2 3 1; 1 1 1];
scores = zeros(1, 12);
%!make
run('startup');
%for t=1:4
%for l=1:3
    if ~isempty(dir(sprintf('FindMiiTask%dLevel%d.m',t,l)));
        %path = '/afs/ir/class/cs231a/findmii/data/';
        path = '../data/';
        % run the program
        if(t==1 && l==1)
            click = FindMiiTask1Level1(path);
        elseif (t==1 && l==2)
            click = FindMiiTask1Level2(path);
        elseif (t==1 && l==3)
            click = FindMiiTask1Level3(path);
        elseif (t==2 && l==1)
            click = FindMiiTask2Level1(path);
        elseif (t==2 && l==2)
            click = FindMiiTask2Level2(path);
        elseif (t==2 && l==3)
            click = FindMiiTask2Level3(path);
        elseif (t==3 && l==1)
            click = FindMiiTask3Level1(path);
        elseif (t==3 && l==2)
            click = FindMiiTask3Level2(path);
        elseif (t==3 && l==3)
            click = FindMiiTask3Level3(path);
        elseif (t==4 && l==1)
            click = FindMiiTask4Level1(path);
        elseif (t==4 && l==2)
            click = FindMiiTask4Level2(path);
        elseif (t==4 && l==3)
            click = FindMiiTask4Level3(path);
        end

        % load ground-truth
        gt = load (sprintf('/afs/ir/class/cs231a/findmii/gt/t%dl%d.gt',t,l));

        % score it
        if size(click,1) == nclick(t,l)
            for c=1:size(click,1) % for each click made by the player
                if (click(c,1) >= 1 && click(c,1) <= size(gt,1)) % if in the valid frame range
                    for ct = 1:size(click,1) % look at all boxes for this frame
                        if(click(c,2) >= gt(click(c,1),1+(ct-1)*4) && ...
                                click(c,2) <= gt(click(c,1),1+(ct-1)*4)+gt(click(c,1),3+(ct-1)*4) && ...
                                click(c,3) >= gt(click(c,1),2+(ct-1)*4) && ...
                                click(c,3) <= gt(click(c,1),2+(ct-1)*4)+ gt(click(c,1),4+(ct-1)*4))
                            % add the score for correct click
                            scores(1,(t-1)*3+l) = scores(1,(t-1)*3+l) + 0.99^(click(c,1)-1);
                            % remove the box that has already been clicked
                            gt(click(c,1),1+(ct-1)*4 : 4+(ct-1)*4) = -100*ones(1,4); 
                        end
                    end
                end
            end
            scores(1,(t-1)*3+l) = scores(1,(t-1)*3+l)/size(click,1);
        else
            scores(1,(t-1)*3+l) = 0; % wrong number of clicks
        end

        fprintf(fid2, '%1.4f, ', scores(1,(t-1)*3+l));
    else
        fprintf('Skipping Task %d Level %d\n',t,l);
        % didn't do this task&level, the -1 is just a mark, won't penalize
        % final score,
        scores(1,(t-1)*3+l) = -1;
        fprintf(fid2, 'NA, ', scores(1,(t-1)*3+l));
    end
    
    fprintf('Score for Task %d Level %d is [%d]\n',t,l,scores(1,(t-1)*3+l));
%end
%end

fclose(fid2);

end