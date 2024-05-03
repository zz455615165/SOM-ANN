epath='wint_check2/';
flist=dir([epath,'*.mat']);

g_pre=nan([3000,length(flist)]);
f_pre=nan([3000,length(flist)]);
s_pre=nan([3000,length(flist)]);
gmw_pre=nan([3000,length(flist)]);
pre_p=nan([3000,length(flist)]);
for f=1:length(flist)
    pre_r=load([epath,flist(f).name]);
    pre_r.stpre(pre_r.stpre>1000)=nan;
%     g_err_m=pre_r.gpm_st-pre_r.stpre;
%     f_err_m=pre_r.an_st-pre_r.stpre;
    nloc=~isnan(pre_r.gpm_st)&~isnan(pre_r.stpre)&~isnan(pre_r.an_st);
    g_pre(1:sum(nloc),f)=pre_r.gpm_st(nloc);
    gmw_pre(1:sum(nloc),f)=pre_r.gpm_mw_st(nloc);
    f_pre(1:sum(nloc),f)=pre_r.an_st(nloc);
    s_pre(1:sum(nloc),f)=pre_r.stpre(nloc);
    pre_p_mid=griddata(pre_r.an_input_2(:,33),pre_r.an_input_2(:,34),...
        pre_r.an_input_2(:,39),pre_r.stlist(:,4),pre_r.stlist(:,3),'nearest');
    pre_p(1:sum(nloc),f)=pre_p_mid(nloc);
%     g_err
%     f_err
disp(f)
end

f_pre(f_pre<=1)=0.4*f_pre(f_pre<=1)+0.6*g_pre(f_pre<=1);
g_err=g_pre-s_pre;
f_err=f_pre-s_pre;
nloc=pre_p>50;
nnmask=nan(size(s_pre));
n0mask=nnmask;

nnmask(pre_p>=50)=0;
n0mask(pre_p<50)=0;


fscale=1:1863;

grmse_rain(1,1)=nanmean(nanmean((g_err(:,fscale)+nnmask(:,fscale)).^2,2),1).^0.5;
frmse_rain(1,1)=nanmean(nanmean((f_err(:,fscale)+nnmask(:,fscale)).^2,2),1).^0.5;
grmse_rain(1,2)=nanmean(nanmean((g_err(:,fscale)+n0mask(:,fscale)).^2,2),1).^0.5;
frmse_rain(1,2)=nanmean(nanmean((f_err(:,fscale)+n0mask(:,fscale)).^2,2),1).^0.5;


   gbias(1)=nanmean(nanmean(g_err(:,fscale),2),1);
   fbias(1)=nanmean(nanmean(f_err(:,fscale),2),1);   
   grmse(1)= nanmean(nanmean(g_err(:,fscale).^2,2),1).^0.5;
   frmse(1)= nanmean(nanmean(f_err(:,fscale).^2,2),1).^0.5;
   
   fscale=1:987;
   

   gbias(2)=nanmean(nanmean(g_err(:,fscale),2),1);
   fbias(2)=nanmean(nanmean(f_err(:,fscale),2),1);   
   grmse(2)= nanmean(nanmean(g_err(:,fscale).^2,2),1).^0.5;
   frmse(2)= nanmean(nanmean(f_err(:,fscale).^2,2),1).^0.5;
   grmse_rain(2,1)=nanmean(nanmean((g_err(:,fscale)+nnmask(:,fscale)).^2,2),1).^0.5;
frmse_rain(2,1)=nanmean(nanmean((f_err(:,fscale)+nnmask(:,fscale)).^2,2),1).^0.5;
grmse_rain(2,2)=nanmean(nanmean((g_err(:,fscale)+n0mask(:,fscale)).^2,2),1).^0.5;
frmse_rain(2,2)=nanmean(nanmean((f_err(:,fscale)+n0mask(:,fscale)).^2,2),1).^0.5;
   fscale=988:1863;
   
   gbias(3)=nanmean(nanmean(g_err(:,fscale),2),1);
   fbias(3)=nanmean(nanmean(f_err(:,fscale),2),1);   
   grmse(3)= nanmean(nanmean(g_err(:,fscale).^2,2),1).^0.5;   
   frmse(3)= nanmean(nanmean(f_err(:,fscale).^2,2),1).^0.5;   
   grmse_rain(3,1)=nanmean(nanmean((g_err(:,fscale)+nnmask(:,fscale)).^2,2),1).^0.5;
frmse_rain(3,1)=nanmean(nanmean((f_err(:,fscale)+nnmask(:,fscale)).^2,2),1).^0.5;
grmse_rain(3,2)=nanmean(nanmean((g_err(:,fscale)+n0mask(:,fscale)).^2,2),1).^0.5;
frmse_rain(3,2)=nanmean(nanmean((f_err(:,fscale)+n0mask(:,fscale)).^2,2),1).^0.5;
   
xlswrite('RMSE_Table',kepv2([frmse_rain,grmse_rain],-3))
   
   bar(1:3,[grmse;frmse]')
      ylabel('RMSE (mm/hr')
   ylim([0 2])
   legend('GPM','FY3E')
   set(gca,'xticklabel',{'All','Summer','Winter'},'fontsize',14)
   
   picsave(1,'season_check',[0 4 20 10])
   
f=105

   load([epath,flist(f).name]);

subplot(2,2,1)
  scatter(stlist(:,4),stlist(:,3),5,stpre,'fill')
  hold on
  chinamap
  ch=colorbar('position',[0.95 0.1 0.01 0.8]);
  hold off
         title('Gauge')

  subplot(2,2,2)
  scatter(an_input_2(:,33),an_input_2(:,34),5,an_output_2)
  hold on
  chinamap
%   title({['GPM RMSE:',num2str(kepv2(rmse2,-4))],['Bias:',num2str(kepv2(bias2,-4))]})
       caxis(get(ch,'ylim'))
       hold off
  subplot(2,2,3)
      scatter(an_input_2(:,33),an_input_2(:,34),5,an_out)
      hold on
      chinamap
      hold off
       caxis(get(ch,'ylim'))
       title('FY3E ANN Retrieval')
         subplot(2,2,4)
  scatter(stlist(:,4),stlist(:,3),5,an_st,'fill')
  hold on
      chinamap
%   title({['FY3E RMSE:',num2str(kepv2(rmse1,-4))],['Bias:',num2str(kepv2(bias1,-4))]})
hold off
       caxis(get(ch,'ylim'))
       disp([flist(f).name])

for f=1395:1573
   load([epath,flist(f).name]);

subplot(2,2,1)
  scatter(stlist(:,4),stlist(:,3),5,stpre,'fill')
  hold on
  chinamap
  caxis([0 0.3])
  ch=colorbar('position',[0.95 0.1 0.01 0.8]);
  hold off
         title('Gauge')

  subplot(2,2,2)
  scatter(an_input_2(:,33),an_input_2(:,34),5,an_output_2)
  hold on
  chinamap
%   title({['GPM RMSE:',num2str(kepv2(rmse2,-4))],['Bias:',num2str(kepv2(bias2,-4))]})
       caxis(get(ch,'ylim'))
       hold off
  subplot(2,2,3)
      scatter(an_input_2(:,33),an_input_2(:,34),5,an_out)
      hold on
      chinamap
      hold off
       caxis(get(ch,'ylim'))
       title('FY3E ANN Retrieval')
         subplot(2,2,4)
  scatter(stlist(:,4),stlist(:,3),5,an_st,'fill')
  hold on
      chinamap
%   title({['FY3E RMSE:',num2str(kepv2(rmse1,-4))],['Bias:',num2str(kepv2(bias1,-4))]})
hold off
       caxis(get(ch,'ylim'))
picsavef(1,['winter_pic/',flist(f).name(1:end-4)])
end