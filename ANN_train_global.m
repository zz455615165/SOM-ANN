
% gpath='Z:\GPM_Late\';
fpath='L:\FY3E_GPM_combine_global\';

% fpath='L:\FY3E_read\';
flist=dir([fpath,'FY3E_MWHS*.mat']);

scale=0.1;
[LON,LAT]=meshgrid(-180:scale:180,-90:scale:90);
an_input=[];
an_output=[];
% for f=1:5:900%length(flist)    
for f=1:23:length(flist)    
    disp(flist(f).name)
    tic
    d_r=load([fpath,flist(f).name],'lbt_w','lbt_t','l_lon','l_lat','l_sun',...
     'l_zen','l_alt','l_lnd','l_percent','l_pre1');
%  randiloc=randi([1,5],size(d_r.l_lat))==1;
    ct=datenum(flist(f).name(16:28),'yyyymmdd_HHMM');    
    disp(datestr(ct))
    ctv=datevec(ct);
    j_d=floor(ct)-datenum([num2str(ctv(1)),'0101'],'yyyymmdd');
        l_jd=j_d*(ones([length(d_r.l_lat) ,1]));
       l_percent=double(d_r.l_percent);
 input_mid=[d_r.lbt_w,d_r.lbt_t/100,d_r.l_lon,d_r.l_lat,d_r.l_sun,...
     d_r.l_zen,d_r.l_alt,d_r.l_lnd,l_percent];
an_input=[an_input;input_mid(1:23:end,:)];
an_output=[an_output;double(d_r.l_pre1(1:23:end))];
% an_output_mw=[an_output_mw;double(d_r.l_pre1(1:50:end))];
toc 

end
% save('train_sample')
% net(1,2,3)
%     scatter(lon(cloc),lat(cloc),5,zen(cloc))
% input_list=[1:32 34:37 39];
input_list=[1:39];

nloc1=sum(~isnan(an_input(:,input_list)),2)==length(an_input(1,input_list))&an_input(:,38)<20;
nloc2=an_output>=0&an_output<100;
% an_input(an_input(:,38)>20)=0;
nloc=nloc1&nloc2;
an_input=an_input(nloc,:);
an_output=an_output(nloc);
net0=newff(an_input(:,input_list)',an_output',[10,5]);
net_a=train(net0,an_input(1:7:end,input_list)',an_output(1:7:end)');
save('net_a','net_a')
for land_kind=1:17
land_loc=an_input(:,38)==land_kind-1;

%  rain_loc=an_input(:,39)>50;
% 
% an_input=an_input(1:floor(length(an_input(:,1))/2),:);
an_input_l=an_input(land_loc,:)';
an_output_l=an_output(land_loc,:)';
% an_output=an_output(1:floor(length(an_output(:,1))/2),:);
net0=newff(an_input_l(input_list,:),an_output_l,[10,5]);
eval(['net',num2str(land_kind),'=train(net0,an_input_l(input_list,:),an_output_l);']);

end

for f=1:length(flist)
    fct(f)=datenum(flist(f).name(16:26),'yyyymmdd_HH');
end
flist_c=flist(fct>datenum('2022060101','yyyymmddHH'));

% for f=1:length(flist_c)-4000
for f=3417:length(flist_c)-4000
    tic
    d_r=load([fpath,flist_c(f).name]);
    ct=datenum(flist_c(f).name(16:28),'yyyymmdd_HHMM');    
    ctv=datevec(ct);
    j_d=floor(ct)-datenum([num2str(ctv(1)),'0101'],'yyyymmdd')+1;
    
        l_jd=j_d*(ones([length(d_r.l_lat) ,1]));
    input_mid=[d_r.lbt_w,d_r.lbt_t/100,d_r.l_lon,d_r.l_lat,d_r.l_sun,...
        d_r.l_zen,d_r.l_alt,d_r.l_lnd,double(d_r.l_percent)];
%     an_input_2=[an_input_2;input_mid];
% an_output_2=[an_output_2;double(d_r.l_pre1)];
an_input_2=input_mid;
an_output_2=double(d_r.l_pre1);

nloc1=sum(~isnan(an_input_2(:,input_list)),2)==length(an_input_2(1,input_list));
nloc2=an_output_2>=0&an_output_2<100;
nloc=nloc1&nloc2;
an_input_2=an_input_2(nloc,:);
an_output_2=an_output_2(nloc);
an_input_2(an_input_2(:,38)>20,38)=nan;
   an_out=net_a(an_input_2(:,input_list)');
   
% %   Station_append----------------------- 
       station_read_new
%       catch
%        station_read_new_skip2line
%       end
       if ct<datenum('2023010100','yyyymmddHH')
       GSOD_read2022
       else
           
       GSOD_read2023 
       end

% %   Staiton_map_Draw   -------------------------------------
% gslist(gslist(:,4)>180&gslist(:,3)>180,:)=nan;
% m_proj('robinson')
% h1=m_scatter(gslist(:,4),gslist(:,3),5,'b','fill');
% hold on
% h2=m_scatter(stlist(:,4),stlist(:,3),5,'r','fill');
% hold on
% m_plot(cc.long,cc.lat)
% title('GSOD Station')
% m_grid
% legend([h1,h2],'GSOD-ISD','CMA')
% set(gca,'fontsize',14)
% picsave(1,'station_pos')
%--------------------------------------------------------------

% stpre=[stpre;gspre];
% stlist=[stlist;gslist];

       
        an_out(an_out<0)=0;
       an_net=netlize_fast(LON,LAT,an_input_2(:,33),an_input_2(:,34),an_out,0.1);
       an_net=smooth2d_fast(an_net);
       
              d_r.pre_all(d_r.pre_all<0)=nan;
% %Station Append--------------------------------------------------
stlist(stlist(:,4)>180&stlist(:,3)>180,:)=nan;
%        stpre(stpre>100)=nan;
       gmp_st=net2station(LON,LAT,double(d_r.pre_all),stlist(:,4),stlist(:,3));
       an_st=net2station(LON,LAT,an_net,stlist(:,4),stlist(:,3));       
       an_st(an_st<0)=0;
% an_st=0;
% stlist=0;
% stpre=0;
  save(['z:/FY3E_global_check/',flist_c(f).name(1:end-4),''],'stpre','an_input_2',...
    'an_output_2','an_out','an_st','stlist')   
disp([flist_c(f).name])
toc
%        
%        err1=an_st-stpre;
%        rmse1=nanmean(err1.^2).^0.5;
%        bias1=nanmean(err1);
%        err2=gmp_st-stpre;
%        err2(isnan(err1))=nan;
%        rmse2=nanmean(err2.^2).^0.5;
%        bias2=nanmean(err2);
%   figure(2)
% subplot(2,2,1)
%   scatter(stlist(:,4),stlist(:,3),5,stpre,'fill')
%   hold on
%   globalmap
%   ch=colorbar('position',[0.95 0.1 0.01 0.8]);
%   hold off
%          title('Gauge')
% 
%   subplot(2,2,2)
%   scatter(an_input_2(:,33),an_input_2(:,34),5,an_output_2)
%   hold on
%   globalmap
%   title({['GPM RMSE:',num2str(kepv2(rmse2,-4))],['Bias:',num2str(kepv2(bias2,-4))]})
%        caxis(get(ch,'ylim'))
%        hold off
%   subplot(2,2,3)
%       scatter(an_input_2(:,33),an_input_2(:,34),5,an_out)
%       hold on
%       globalmap
%       hold off
%        caxis(get(ch,'ylim'))
%        title('FY3E ANN Retrieval')
%          subplot(2,2,4)
%   scatter(stlist(:,4),stlist(:,3),5,an_st,'fill')
%   hold on
%       globalmap
%   title({['FY3E RMSE:',num2str(kepv2(rmse1,-4))],['Bias:',num2str(kepv2(bias1,-4))]})
% hold off
%        caxis(get(ch,'ylim'))
%        

% picsavef(2,['global_pic/',flist_c(f).name(1:end-4),'_check'])

  
end
    