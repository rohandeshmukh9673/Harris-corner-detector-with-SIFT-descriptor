function [pts1,pts2]=SSD(img1,img2,C1,C2,params)

[col1, row1]=find(C1==1);
[col2, row2]=find(C2==1);
pts1=NaN(length(col1),2);
pts2=NaN(length(col2),2);
W_SSD=params.W_SSD+1;
Half_W_SSD=round(W_SSD/2)-1;

for j=1:length(col2)
    for i=1:length(col1)
        %get local neighbours of corner
        sub1=img1(col1(i)-Half_W_SSD:col1(i)+Half_W_SSD,row1(i)-Half_W_SSD:row1(i)+Half_W_SSD);
        sub2=img2(col2(j)-Half_W_SSD:col2(j)+Half_W_SSD,row2(j)-Half_W_SSD:row2(j)+Half_W_SSD);
        
        SSD_sub=(abs(sub1-sub2)).^2;
        SSD(j,i)=sum(sum(SSD_sub));
    end
end

%find index of minimum difference
[value,idx]=min(SSD);
T_SSD=params.p*mean(value);
%thresholding
newcol1=col1;
newrow1=row1;
newcol1(find(value>T_SSD))=NaN;
newrow1(find(value>T_SSD))=NaN;
newcol1(isnan(newcol1),:)=[];
newrow1(isnan(newrow1),:)=[];

%index check
idx(find(value>T_SSD))=NaN;

newrow2=[];
newcol2=[];
count=1;
for i=1:length(idx)
       if ~(isnan((idx(i))))
           newrow2(count)=row2(idx(i));
           newcol2(count)=col2(idx(i));
           count=count+1;
       end
end

%get points
pts1=[newrow1,newcol1];
pts2=[newrow2',newcol2'];
        
