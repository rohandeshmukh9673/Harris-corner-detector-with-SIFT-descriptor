[col1,row1]=find(C1==1);
[col2,row2]=find(C2==1);
descriptor=zeros(1,4*4*8);
kpmag=[];
kpori=[];
kpmag2=[];
kpori2=[];
newrow3=[];
newrow4=[];
newcol3=[];
newcol4=[];



 for i=1:length(col1)
   window=img1(col1(i)-8:col1(i)+8,row1(i)-8:row1(i)+8);
 % window=fspecial('gaussian',7,sigma);
   [x y]=size(window);
     
   for j=1:x-1
    for k=1:y-1
         mag(j,k)=sqrt(((window(j+1,k)-window(j,k))^2)+((window(j,k+1)-window(j,k))^2));
         oric(j,k)=atan2(((window(j+1,k)-window(j,k))),(window(j,k+1)-window(j,k)))*(180/pi);
    end
   end
 
 % Finding orientation and magnitude for the key point
[m1,n1]=size(window);
magcounts=[];
for x=0:10:359
    magcount=0;
for i=1:m1-1
    for j=1:n1-1
        ch1=-180+x;
        ch2=-171+x;
        if ch1<0  ||  ch2<0
        if abs(oric(i,j))<abs(ch1) && abs(oric(i,j))>=abs(ch2)
            ori(i,j)=(ch1+ch2+1)/2;
            magcount=magcount+mag(i,j);
        end
        else
        if abs(oric(i,j))>abs(ch1) && abs(oric(i,j))<=abs(ch2)
            ori(i,j)=(ch1+ch2+1)/2;
            magcount=magcount+mag(i,j);
        end
        end
    end
end
magcounts=[magcounts magcount];
end
[maxvm maxvp]=max(magcounts);
kmag=maxvm;
kori=(((maxvp*10)+((maxvp-1)*10))/2)-180;
kpmag=[kpmag kmag];
kpori=[kpori kori];
 end
 
 
 
 
 for i=1:length(col2)
 window2=img2(col2(i)-8:col2(i)+8,row2(i)-8:row2(i)+8);
%window2=fspecial('gaussian',7,sigma);
   [x y]=size(window2);
     
   for j=1:x-1
    for k=1:y-1
         mag2(j,k)=sqrt(((window2(j+1,k)-window2(j,k))^2)+((window2(j,k+1)-window2(j,k))^2));
         oric2(j,k)=atan2(((window2(j+1,k)-window2(j,k))),(window2(j,k+1)-window2(j,k)))*(180/pi);
    end
   end
 
 % Finding orientation and magnitude for the key point
[m2,n2]=size(window2);
magcounts2=[];
for x=0:10:359
    magcount2=0;
for i=1:m2-1
    for j=1:n2-1
        ch1=-180+x;
        ch2=-171+x;
        if ch1<0  ||  ch2<0
        if abs(oric2(i,j))<abs(ch1) && abs(oric2(i,j))>=abs(ch2)
            ori2(i,j)=(ch1+ch2+1)/2;
            magcount2=magcount2+mag2(i,j);
        end
        else
        if abs(oric2(i,j))>abs(ch1) && abs(oric2(i,j))<=abs(ch2)
            ori2(i,j)=(ch1+ch2+1)/2;
            magcount2=magcount2+mag2(i,j);
        end
        end
    end
end
magcounts2=[magcounts2 magcount2];
end
[maxvm2 maxvp2]=max(magcounts2);
kmag2=maxvm2;
kori2=(((maxvp2*10)+((maxvp2-1)*10))/2)-180;
kpmag2=[kpmag2 kmag2];
kpori2=[kpori2 kori2];
 end
 
 
 idx=0;

     for j=1:min(length(kpori),length(kpori2))
        for i=1:min(length(kpori),length(kpori2))
            
        if((kpori(1,i))==(kpori2(1,j)))
         idx=[idx j];
        end
        end
    end

         
         
         
         count=1;
         for i=2:length(idx)
       if ~(isnan((idx(i))))
           newrow3(count)=row1(idx(i));
           newcol3(count)=col1(idx(i));
           newrow4(count)=row2(idx(i));
           newcol4(count)=col2(idx(i));
           
           count=count+1;
       end
end

%get points
pts5=[newrow3',newcol3'];
pts6=[newrow4',newcol4'];
 


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
    
    

        for i=1:min(length(pts5),length(pts6))
            
        
        plot([pts5(i,1),pts6(i,1)+width],[pts5(i,2),pts6(i,2)],'-r');
        title('Descriptor (orientation)');
        end
  
    axis off;
    hold off;
