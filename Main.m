clc;
clear all;
close all;

idx=4;
%path='C:/Users/rohan/Desktop/images/';

bools.Plot=true;
bools.Save=true;
img1_orig=imread('G:\Project\HC\FinalProjectCodes\dotatechies.jpg');
%img2_orig=imread('G:\Project\HC\FinalProjectCodes\dotatechies.jpg');
 img2_orig=imrotate(img1_orig,-60,'bilinear','crop');

img1=double(rgb2gray(img1_orig));
img2=double(rgb2gray(img2_orig));

params.scale=4;
params.sigma=1.2;
params.k=0.04;
params.W_nms=29;  %window size for nms
params.W_SSD=20;  %sum of squared differences
params.W_NCC=20;  %normalized cross correlation
params.p=0.6;    % threshold

%HarrisCorner(img1_orig,img2_orig,params,bools);
%SIFTDescriptor(img1_orig,img2_orig,params,idx,path,bools);

img1=double(rgb2gray(img1_orig));
img2=double(rgb2gray(img2_orig));

R1= zeros(size(img1));
R2= zeros(size(img2));
C1= zeros(size(img1));
C2= zeros(size(img2));

[height,width]=size(img1);
sigma=params.scale*params.sigma;
scale=params.scale;

tic


% dx = [-1 0 1; -2 0 2; -1 0 1];
% dy = dx';
% W1 = round(ceil(4*sigma)/2)*2;
% Haarx = [ -ones(W1,W1/2),ones(W1,W1/2)];
% Haary = [ ones(W1/2,W1);-ones(W1/2,W1)];
g=fspecial('gaussian',15,sigma);
Ix1 = conv2( img1 , g , 'same');
Iy1 = conv2 ( img1 , g , 'same' );
Ix2 = conv2 ( img2 , g , 'same');
 Iy2 = conv2 ( img2 , g , 'same');
% Ix1 = conv2(img1, dx, 'same');   
% Iy1 = conv2(img1, dy, 'same'); 
% Ix2 = conv2(img2, dx, 'same');   
% Iy2 = conv2(img2, dy, 'same'); 

%select window
W=round(ceil(5*sigma)/2)*2+1;
Half_W=round(W/2)-1;

for i=Half_W+1:width-Half_W-1
    for j=Half_W+1:height-Half_W-1
        
        %image1
        Ix1_sub=Ix1(j-Half_W:j+Half_W,i-Half_W:i+Half_W);
        Iy1_sub=Iy1(j-Half_W:j+Half_W,i-Half_W:i+Half_W);
        %get M matrix
        M1(1,1)=sum(sum(Ix1_sub.^2));
        M1(1,2)=sum(sum(Ix1_sub.*Iy1_sub));
        M1(2,2)=sum(sum(Iy1_sub.^2));
        % corner response
        R1(j,i)=det(M1)-params.k*trace(M1)^2;
        
        
        %image2
        Ix2_sub=Ix2(j-Half_W:j+Half_W,i-Half_W:i+Half_W);
        Iy2_sub=Iy2(j-Half_W:j+Half_W,i-Half_W:i+Half_W);
        %get M matrix
        M2(1,1)=sum(sum(Ix2_sub.^2));
        M2(1,2)=sum(sum(Ix2_sub.*Iy1_sub));
        M2(2,2)=sum(sum(Iy2_sub.^2));
        % corner response
        R2(j,i)=det(M2)-params.k*trace(M2)^2;
        
    end
end


%non maximum suppression

W_nms=params.W_nms;
Half_W_nms=round(W_nms/2)-1;

for i=Half_W_nms+1:width-Half_W_nms-1
    for j=Half_W_nms+1:height-Half_W_nms-1
        %get local window from corner response R1
        R1_sub= R1(j-Half_W_nms:j+Half_W_nms,i-Half_W_nms:i+Half_W_nms);
          if (R1(j,i)==max(max(R1_sub))&&R1(j,i)>mean(mean(abs(R1))))
              C1(j,i)=1;
          end
        %get local window from corner response R2
        R2_sub= R2(j-Half_W_nms:j+Half_W_nms,i-Half_W_nms:i+Half_W_nms);
          if (R2(j,i)==max(max(R2_sub))&&R2(j,i)>mean(mean(abs(R1))))
              C2(j,i)=1;
          end   
    end
end
t=toc

[col1,row1]=find(C1==1);
[col2,row2]=find(C2==1);

%match corresponding corners
[pts1,pts2]=SSD(img1,img2,C1,C2,params);

if bools.Plot
    hfig1=figure;
    imshow([img1_orig,img2_orig]);
    set(gca,'Position',[0 0 1 1]);
    set(gcf,'Position',[0 0 2*width+1 height+1]);
    set(gcf,'PaperPositionMode','auto');
    truesize(hfig1,[height 2*width]);
    hold on;
    
    %for saving
    F=getframe(hfig1);
    plot(row1,col1,'rx','Linewidth',2);
    plot(row2+width,col2,'rx','Linewidth',2);
    
    
    
    for j=1:min(length(pts1),length(pts2))
        for i=1:min(length(pts1),length(pts2))
            
        if((pts1(j,1)==pts2(i,1))||(pts1(j,2)==pts2(i,2)))
        plot([pts1(j,1),pts2(i,1)+width],[pts1(j,2),pts2(i,2)],'-y');
        title('SSD');
        end
        end
    end
    axis off;
    hold off;
end
% if bools.Save
%     imwrite(['C:\Users\rohan\Desktop\images\output\1and2_matched_ssd.jpg'],'jpeg','Quality',100);
% end

%NCC
%match corresponding corners
[pts3,pts4]=NCC(img1,img2,C1,C2,params);

if bools.Plot
    hfig2=figure;
    imshow([img1_orig,img2_orig]);
    set(gca,'Position',[0 0 1 1]);
    set(gcf,'Position',[0 0 2*width+1 height+1]);
    set(gcf,'PaperPositionMode','auto');
    truesize(hfig2,[height 2*width]);
    hold on;
    
    %for saving
    F=getframe(hfig2);
    plot(row1,col1,'rx','Linewidth',2);
    plot(row2+width,col2,'rx','Linewidth',2);
    j=1;
    for j=1:min(length(pts3),length(pts4))
        for i=1:min(length(pts3),length(pts4))
            
        if((pts3(j,1)==pts4(i,1))||(pts3(j,2)==pts4(i,2)))
        plot([pts3(j,1),pts4(i,1)+width],[pts3(j,2),pts4(i,2)],'-c');
        title('NCC');
        end
        end
    end
    
    axis off;
    hold off;
end
% if bools.Save
%     imwrite(['C:\Users\rohan\Desktop\images\output\1and2_matched_ncc.jpg'],'jpeg','Quality',100);
% end
    
