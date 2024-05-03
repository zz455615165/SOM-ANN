% [s1,s2,s3]=SOMANN(an_input);
som_input=an_input(1:7:end,35:38);
som_input2=an_input(:,35:38);
som_input(som_input(:,end)==255,end)=0;
som_input2(som_input2(:,end)==255,end)=0;
clear som_input_std som_input_std2
for s=1:4
som_input_std(:,s)=mapminmax(som_input(:,s)')';
som_input_std2(:,s)=mapminmax(som_input2(:,s)')';

end
%an_input MWHS 1-15, MWTS 16-32,33 and 34 long lat, 35 sun zenith,36 sat zenith
%37dem, 38landuse

rv=nan(9,39);
 rr=load('Land_R');
 rv(1,:)=nanstd(rr.input_r_wat,1);
% rr.input_r_ic;
% rr.input_r_
rr=load('DEM_R');
 rv(2,:)=nanstd(rr.input_r_wat,1);

rr=load('Sat_Z_R');
 rv(3,:)=nanstd(rr.input_r_wat,1);

rr=load('Sun_Z_R');
 rv(4,:)=nanstd(rr.input_r_wat,1);
 
 
%  rv2=nan(4,39);
 rr=load('Land_R');
 rv(5,:)=nanstd(rr.input_r_ic,1);
% rr.input_r_ic;
% rr.input_r_
rr=load('DEM_R');
 rv(6,:)=nanstd(rr.input_r_ic,1);

rr=load('Sat_Z_R');
 rv(7,:)=nanstd(rr.input_r_ic,1);

rr=load('Sun_Z_R');
 rv(8,:)=nanstd(rr.input_r_ic,1);
rv(9,:)=nanmean(rv(1:8,:),1);
 
 drawdata=rv(1:8,:);
 drawdata_p=drawdata
 drawdata_p=9999;
 coef_draw
%   set(gca,'ytick',1.5:1:18,'yticklabel',lname,'xtick',1.5:33,'xticklabel',[1:15 1:17])
set(gca,'ytick',1.5:1:length(input_r_wat_p(:,1)),'yticklabel',{'Landtype','Altitude','Satellite zenith','Solar zenith'})
ylim([1 length(drawdata(:,1))])
ylabel('Rain                                   Snow')
title('Rain Correlation Coefficient Table')

 
 
 
 
 
 
 

%以每一个通道相关性的方差来定义环境对该通道的影响，
%并用所有通道的平均方差来衡量SOM分类后每一类别中不同环境因素对所有通道的平均影响

[s1,s2,s3]=SOMANN(som_input_std2);


for s=1:9
    n=s;
for lv=1:39
    disp(['SOM',num2str(s),'-lv:',num2str(lv)])
    
    nloc=s1(:,s)==1&an_output>~isnan(an_input(:,lv));
    
    
[r,p]=corrcoef(an_input(nloc,lv),an_output(nloc));
input_r(n,lv)=r(2,1);
input_r_p(n,lv)=p(2,1);

   nloc=s1(:,s)==1&an_output>~isnan(an_input(:,lv))&an_input(:,39)<30;
[r,p]=corrcoef(an_input(nloc,lv),an_output(nloc));
input_r_ic(n,lv)=r(2,1);
input_r_ic_p(n,lv)=p(2,1);

   nloc=s1(:,s)==1&an_output>~isnan(an_input(:,lv))&an_input(:,39)>70;
[r,p]=corrcoef(an_input(nloc,lv),an_output(nloc));
input_r_wat(n,lv)=r(2,1);
input_r_wat_p(n,lv)=p(2,1);
end
end
save('SOM_R','input_r_wat','input_r_wat_p','input_r_ic','input_r_ic_p','input_r','input_r_p')
subplot(2,1,1)
drawdata=input_r_wat;
drawdata_p=input_r_wat_p;
coef_draw
%   set(gca,'ytick',1.5:1:18,'yticklabel',lname,'xtick',1.5:33,'xticklabel',[1:15 1:17])
set(gca,'ytick',1.5:1:length(input_r_wat_p(:,1)),'yticklabel',[0:200:8000])
ylim([1 length(input_r_wat_p(:,1))-1])
ylabel('SOM Classify')
title('Rain Correlation Coefficient Table')
%     picsave(1,'Sum_R')
 caxis([-0.4 0.4])
    
subplot(2,1,2)
drawdata=input_r_ic;
drawdata_p=input_r_ic_p;
coef_draw
title('Snow Correlation Coefficient Table')
 caxis([-0.9 0.9])
 colormap(cpad(4:end-3,:))
 set(gca,'ytick',1.5:1:length(input_r_wat_p(:,1)),'yticklabel',[0:200:8000])
ylim([1 length(input_r_wat_p(:,1))-1])
ylabel('SOM Classify')
picsave(1,'snow_rain_R_SOM',[0 4 18 25])
