
%for i=1:5:150 
%    bbox = [bbox; extractBBox(['frame/t3l3/' num2str(i) '.jpg'],1)]; 
%    close; 
%end

bbox = [34   188   380   428
    36   186   379   426
    40   193   382   426
    48   202   381   427
    49   202   380   424
    48   202   384   426
    55   210   381   428
    61   218   383   428
    61   218   380   429
    62   221   382   430
    70   230   384   430
    74   238   382   433
    74   238   381   433
    77   243   382   431
    86   251   383   433
    87   256   383   437
    88   256   382   438
    94   264   381   436
   103   278   381   435
   103   278   380   437
   103   278   381   438
   112   287   385   439
   119   299   385   440
   119   299   383   442
   121   304   385   443
   131   314   384   442
   139   323   381   442
   138   325   381   442
   142   332   385   446
   153   346   387   446];


heights = bbox(:,2) - bbox(:,1);
widths = bbox(:,4) - bbox(:,3);

ybot = bbox(:,2);
figure; subplot(2,2,1);
%plot(ybot,heights,'rx');
%subplot(2,2,2);
%plot(ybot,widths,'ro');

A = [ybot, ones(size(heights))];
b = heights;
hy = A \b;
%0.2655
%100.4514

b = widths;
hx = A \ b;
%0.1131
%23.2733

x = min(ybot):max(ybot);
xline = hx(2) + hx(1).*x;
yline = hy(2) + hy(1).*x;

subplot(2,2,3);
plot(ybot,heights,'ro');
hold on;
plot(x,yline,'b');
hold off;

subplot(2,2,4);
plot(ybot,widths,'ro');
hold on;
plot(x,xline,'b');
hold off;
