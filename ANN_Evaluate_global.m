epath='z:/FY3E_global_check/';
flist=dir([epath,'*.mat']);
fpath='L:\FY3E_GPM_combine_global\';

g_pre=nan([8000,length(flist)]);
f_pre=nan([8000,length(flist)]);
s_pre=nan([8000,length(flist)]);
g_pre_mw=nan([8000,length(flist)]);
pre_p=nan([8000,length(flist)]);
s_lon=nan([8000,length(flist)]);
s_lat=nan([8000,length(flist)]);
scale=0.1;
[LON,LAT]=meshgrid(-180:scale:180,-90:scale:90);

for f=1:length(flist)
    fct(f)=datenum(flist(f).name(16:26),'yyyymmdd_HH');
end
flist_c=flist(fct>datenum('2022060101','yyyymmddHH'));

for f=1:length(flist_c)
    tic
    pre_r=load([epath,flist_c(f).name]);
    pre_r.stpre(pre_r.stpre>1000)=nan;
        stlist=pre_r.stlist;

    if length(stlist)==1
        st_err=1==1;
    else
        st_err=1==0;
    end
      try d_r=load([fpath,flist_c(f).name],'pre_all', 'pre_mw', 'pre_percent');
d_r_err=0==1;
      catch
          d_r_err=1==1;
      end
%     g_err_m=pre_r.gpm_st-pre_r.stpre;
%     f_err_m=pre_r.an_st-pre_r.stpre;
if d_r_err|st_err
else
 d_r.pre_all(d_r.pre_all<0)=nan;
 d_r.pre_mw(d_r.pre_mw<0)=nan;
 d_r.pre_percent(d_r.pre_percent<0)=nan;

       gpm_st=net2station(LON,LAT,double(d_r.pre_all),stlist(:,4),stlist(:,3));
       gpm_st_mw=net2station(LON,LAT,double(d_r.pre_mw),stlist(:,4),stlist(:,3));
       pre_p_mid=net2station(LON,LAT,double(d_r.pre_percent),stlist(:,4),stlist(:,3));
           nloc=~isnan(gpm_st)&~isnan(pre_r.stpre)&~isnan(pre_r.an_st);

    g_pre(1:sum(nloc),f)=gpm_st(nloc);
    g_pre_mw(1:sum(nloc),f)=gpm_st_mw(nloc);    
    pre_p(1:sum(nloc),f)=pre_p_mid(nloc);
    f_pre(1:sum(nloc),f)=pre_r.an_st(nloc);
    s_pre(1:sum(nloc),f)=pre_r.stpre(nloc);
        s_lon(1:sum(nloc),f)=stlist(nloc,4);    
        s_lat(1:sum(nloc),f)=stlist(nloc,3);     

end
% disp(flist(f).name)
%     g_err
%     f_err
disp(f)
toc
end


% clear fct
% for f=1:length(flist)
%     fct(f)=datenum(flist(f).name(16:26),'yyyymmdd_HH');
% end
 save('global_pre_new_f3010')

% f_pre(f_pre<=1)=0.4*f_pre(f_pre<=1)+0.6*g_pre(f_pre<=1);
% 
% f_pre(pre_p<50)=f_pre(pre_p<50)*7;
% f_pre(~isnan(g_pre_mw))=g_pre_mw(~isnan(g_pre_mw));

g_err=g_pre-s_pre;
f_err=f_pre-s_pre;
mw_err=g_pre_mw-s_pre;
% f_mw_err=f_pre-g_pre_mw;

nloc=pre_p>50;

 n0mask=nan(size(s_pre));
 nnmask=n0mask;
snow_thd=50;
 nnmask(pre_p>=snow_thd)=0;
n0mask(pre_p<snow_thd)=0;


nnloc=g_pre>0&s_pre>0;
rr=corrcoef(g_pre(nnloc),s_pre(nnloc));
cc(1,1)=rr(2,1);

nnloc=f_pre>0&s_pre>0;
rr=corrcoef(f_pre(nnloc),s_pre(nnloc));
cc(1,2)=rr(2,1);

nnloc=g_pre_mw>0&s_pre>0;
rr=corrcoef(g_pre_mw(nnloc),s_pre(nnloc));
cc(1,3)=rr(2,1);


fscale=fct>0;

grmse_rain(1,1)=nanmean(nanmean((g_err(:,fscale)+nnmask(:,fscale)).^2,2),1).^0.5;
frmse_rain(1,1)=nanmean(nanmean((f_err(:,fscale)+nnmask(:,fscale)).^2,2),1).^0.5;
mrmse_rain(1,1)=nanmean(nanmean((mw_err(:,fscale)+nnmask(:,fscale)).^2,2),1).^0.5;


grmse_rain(1,2)=nanmean(nanmean((g_err(:,fscale)+n0mask(:,fscale)).^2,2),1).^0.5;
frmse_rain(1,2)=nanmean(nanmean((f_err(:,fscale)+n0mask(:,fscale)).^2,2),1).^0.5;
mrmse_rain(1,2)=nanmean(nanmean((mw_err(:,fscale)+n0mask(:,fscale)).^2,2),1).^0.5;

gbias_rain(1,1)=nanmean(nanmean(g_err(:,fscale)+nnmask(:,fscale)));
fbias_rain(1,1)=nanmean(nanmean(f_err(:,fscale)+nnmask(:,fscale)));
mwbias_rain(1,1)=nanmean(nanmean(mw_err(:,fscale)+nnmask(:,fscale)));
gbias_rain(1,2)=nanmean(nanmean(g_err(:,fscale)+n0mask(:,fscale)));
fbias_rain(1,2)=nanmean(nanmean(f_err(:,fscale)+n0mask(:,fscale)));
mwbias_rain(1,2)=nanmean(nanmean(mw_err(:,fscale)+n0mask(:,fscale)));

   gbias(1)=nanmean(nanmean(g_err(:,fscale),2),1);
   fbias(1)=nanmean(nanmean(f_err(:,fscale),2),1);   
   grmse(1)= nanmean(nanmean(g_err(:,fscale).^2,2),1).^0.5;
   frmse(1)= nanmean(nanmean(f_err(:,fscale).^2,2),1).^0.5;
   mrmse(1)=nanmean(nanmean((mw_err(:,fscale)).^2,2),1).^0.5;

   fscale=fct<datenum('20220831','yyyymmdd');
   

   gbias(2)=nanmean(nanmean(g_err(:,fscale),2),1);
   fbias(2)=nanmean(nanmean(f_err(:,fscale),2),1);   
   grmse(2)= nanmean(nanmean(g_err(:,fscale).^2,2),1).^0.5;
   frmse(2)= nanmean(nanmean(f_err(:,fscale).^2,2),1).^0.5;
   mrmse(2)=nanmean(nanmean((mw_err(:,fscale)).^2,2),1).^0.5;
   
% violinChart(gca,1:3,[abs(g_err(1:100:end)),abs(f_err(1:100:end)),abs(mw_err(1:100:end))],[1 0 0],0.5)



   grmse_rain(2,1)=nanmean(nanmean((g_err(:,fscale)+nnmask(:,fscale)).^2,2),1).^0.5;
frmse_rain(2,1)=nanmean(nanmean((f_err(:,fscale)+nnmask(:,fscale)).^2,2),1).^0.5;
mrmse_rain(2,1)=nanmean(nanmean((mw_err(:,fscale)+nnmask(:,fscale)).^2,2),1).^0.5;

grmse_rain(2,2)=nanmean(nanmean((g_err(:,fscale)+n0mask(:,fscale)).^2,2),1).^0.5;
frmse_rain(2,2)=nanmean(nanmean((f_err(:,fscale)+n0mask(:,fscale)).^2,2),1).^0.5;
mrmse_rain(2,2)=nanmean(nanmean((mw_err(:,fscale)+n0mask(:,fscale)).^2,2),1).^0.5;
% gn(2,2)=sum(sum(~isnan(mw_err(:,fscale)+n0mask(:,fscale))));
   gbias_rain(2,1)=nanmean(nanmean(g_err(:,fscale)+nnmask(:,fscale)));
fbias_rain(2,1)=nanmean(nanmean(f_err(:,fscale)+nnmask(:,fscale)));
mwbias_rain(2,1)=nanmean(nanmean(mw_err(:,fscale)+nnmask(:,fscale)));

gbias_rain(2,2)=nanmean(nanmean(g_err(:,fscale)+n0mask(:,fscale)));
fbias_rain(2,2)=nanmean(nanmean(f_err(:,fscale)+n0mask(:,fscale)));
mwbias_rain(2,2)=nanmean(nanmean(mw_err(:,fscale)+n0mask(:,fscale)));

   fscale=fct>datenum('20220831','yyyymmdd');
   gbias(3)=nanmean(nanmean(g_err(:,fscale),2),1);
   fbias(3)=nanmean(nanmean(f_err(:,fscale),2),1);   
   grmse(3)= nanmean(nanmean(g_err(:,fscale).^2,2),1).^0.5;   
   frmse(3)= nanmean(nanmean(f_err(:,fscale).^2,2),1).^0.5;
   mrmse(3)=nanmean(nanmean((mw_err(:,fscale)).^2,2),1).^0.5;

   grmse_rain(3,1)=nanmean(nanmean((g_err(:,fscale)+nnmask(:,fscale)).^2,2),1).^0.5;
frmse_rain(3,1)=nanmean(nanmean((f_err(:,fscale)+nnmask(:,fscale)).^2,2),1).^0.5;
mrmse_rain(3,1)=nanmean(nanmean((mw_err(:,fscale)+nnmask(:,fscale)).^2,2),1).^0.5;
grmse_rain(3,2)=nanmean(nanmean((g_err(:,fscale)+n0mask(:,fscale)).^2,2),1).^0.5;
frmse_rain(3,2)=nanmean(nanmean((f_err(:,fscale)+n0mask(:,fscale)).^2,2),1).^0.5;
mrmse_rain(3,2)=nanmean(nanmean((mw_err(:,fscale)+n0mask(:,fscale)).^2,2),1).^0.5;

      gbias_rain(3,1)=nanmean(nanmean(g_err(:,fscale)+nnmask(:,fscale)));
fbias_rain(3,1)=nanmean(nanmean(f_err(:,fscale)+nnmask(:,fscale)));
mwbias_rain(3,1)=nanmean(nanmean(mw_err(:,fscale)+nnmask(:,fscale)));

gbias_rain(3,2)=nanmean(nanmean(g_err(:,fscale)+n0mask(:,fscale)));
fbias_rain(3,2)=nanmean(nanmean(f_err(:,fscale)+n0mask(:,fscale)));
mwbias_rain(3,2)=nanmean(nanmean(mw_err(:,fscale)+n0mask(:,fscale)));

xlswrite('RMSE_Table_global',kepv2([frmse_rain,grmse_rain,mrmse_rain],-3))
xlswrite('Bias_Table_global',kepv2([fbias_rain,gbias_rain,mwbias_rain],-3))
   
   bar(1:3,[grmse;frmse]')
      ylabel('RMSE (mm/hr')
   ylim([0 2])
   legend('GPM','FY3E')
   set(gca,'xticklabel',{'All','Summer','Winter'},'fontsize',14)
   
   picsave(1,'season_check_global',[0 4 20 10])
  
%    subplot(3,1,1)

%Evaluate against GPM DPR
xrange=[-2 2];
subplot(2,2,1)
x=f_pre(pre_p<50);
y=g_pre_mw(pre_p<50);
x=x(1:end);
y=y(1:end);
nsloc=x>0&y>0;
scatplot(log10(x(nsloc)),log10(y(nsloc)),'square',0.2,10,5,1,4)
% scatter(log10(x),log10(y),5,'fill')
r=corrcoef(x(nsloc),y(nsloc));
hold on 
plot(xrange,xrange,'k--','linewidth',2)
xlim(xrange)
ylim(xrange)
xlabel('Gauge(mm/hr)')
title('GPM Precipitation against Gauge')
box on
subplot(2,2,2)
scatter(s_pre(pre_p<50),f_pre(pre_p<50),5,'fill')
hold on 
plot(xrange,xrange,'k--','linewidth',2)
xlim(xrange)
ylim(xrange)
xlabel('Gauge(mm/hr)')
ylabel('FY3E(mm/hr)')
box on
title('FY3E Precipitation against Gauge')
subplot(2,1,2)
PDF_wrong


%Evaluate against station
xrange=[-2 2];
subplot(2,2,1)
x=g_pre_mw(pre_p<50);
y=s_pre(pre_p<50);
x=x(1:end);
y=y(1:end); 
nsloc=x>0&y>0;
scatplot(log10(x(nsloc)),log10(y(nsloc)),'square',0.2,10,5,1,4)
% scatter(log10(x),log10(y),5,'fill')
r=corrcoef(x(nsloc),y(nsloc));
hold on 
plot(xrange,xrange,'k--','linewidth',2)
xlim(xrange)
ylim(xrange)
xlabel('Gauge(mm/hr)')
title('GPM Precipitation against Gauge')
box on
subplot(2,2,2)
scatter(s_pre(pre_p<50),f_pre(pre_p<50),5,'fill')
hold on 
plot(xrange,xrange,'k--','linewidth',2)
xlim(xrange)
ylim(xrange)
xlabel('Gauge(mm/hr)')
ylabel('FY3E(mm/hr)')
box on
title('FY3E Precipitation against Gauge')
subplot(2,1,2)
PDF_wrong




