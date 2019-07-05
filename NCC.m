function [pts3,pts4] = NCC (img1,img2,C1,C2,params)
[col1,row1]=find(C1==1);
[col2,row2]=find(C2==1);
W_NCC=params.W_NCC + 1;
half_W_NCC=round(W_NCC/2)-1;

for j=1:length(col2)
 for i=1: length(col1)
% Get local neighbors from corner and compare the gray level image
% around an neighbors
sub1=img1(col1(i)-half_W_NCC:col1(i)+half_W_NCC , row1(i)-half_W_NCC:row1(i)+half_W_NCC);
sub2=img2(col2(j)-half_W_NCC:col2(j)+half_W_NCC , row2(j)-half_W_NCC:row2(j)+half_W_NCC);

m1=mean(mean(sub1));
m2=mean(mean(sub2));

deviation1=sub1-m1;
deviation2=sub2-m2;

NCC_numer = sum(sum(deviation1.*deviation2));
NCC_denom = sqrt(sum(sum(deviation1.^2))*sum(sum(deviation2.^2)));
NCC_sub = NCC_numer/NCC_denom ;
NCC (j,i)= NCC_sub ;
end
end

% Want to find the index that NCC is close to 1
[value,idx]=min(abs(NCC -1));
T_NCC = params.p*mean( value );
% Thresholding using T_NCC
 newcol1 = col1 ; 
 newrow1 = row1 ;
newcol1 ( find( value > T_NCC )) = NaN;
newrow1 ( find( value > T_NCC )) = NaN;
newcol1 (isnan( newcol1 ) ,:) = [];
newrow1 (isnan( newrow1 ) ,:) = [];

% find index that corresponding thresholded points
idx ( find( value > T_NCC )) = NaN;
cnt = 1;
for i =1: length( idx )
if ~(isnan((idx (i))))
newrow2(cnt) = row2(idx(i));
newcol2(cnt) = col2(idx(i));
cnt = cnt +1;
end
end
% Get pts1 and pts2
pts3 =[newrow1,newcol1 ];
pts4=[newrow2',newcol2'];
