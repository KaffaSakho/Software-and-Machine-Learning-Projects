function name = handwriting(string)

%Step 1: Transforming the string into an array
word= split(string,"");
word= word(2:(length(word)-1));

%Step 2: For each character in the array: read, binarize, find boundaries
for i= 1:length(word)
    character= word(i);
    if strcmp(character,' ') %if the string contains more than one word it skips the space
        continue;
    end
    character= imread(strcat(char(character),'.JPG'));
    character= imbinarize(rgb2gray(character));
    boundaries_character= bwboundaries(1 - character);
    I = round(linspace(1,length(boundaries_character{1}),30));
    
    %Step 3: For each character, plot the interpolated curve including all
    %the boundaries
    
    for j = 1:length(boundaries_character)
        if size(boundaries_character{j},1)<100
            boundaries_character{j}=[];
        end
    end
    boundaries_character= boundaries_character(~cellfun('isempty', boundaries_character));
    
    %Step 4: repeat step 3 for the remaining boundaries
    for k= 1:length(boundaries_character)
        I = round(linspace(1,size(boundaries_character{k},1),30)); %30 uniform points of the first component
        boundaries_character{k}(I,:);
        xq1= 1:length (boundaries_character{k});
        xx= pchip(I,boundaries_character{k}(I,1),xq1);
        yy= pchip(I,boundaries_character{k}(I,2),xq1); 
        hold on;
        plot(xx,yy);
        axis off;
    end 
    
    %Step 4: conversion to image, display and save
    frame= getframe(gcf);
    if i == 1 %debugs to avoid overlapping of images
        image = frame.cdata;   
        clf
    else
        image= cat(2, image, frame.cdata);
        clf;
    end
end
imwrite(image, strcat(string, '.png')); close;  
end 