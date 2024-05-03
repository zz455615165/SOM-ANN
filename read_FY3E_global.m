fpath='L:\FY3E\';
outpath='L:\FY3E_read_global\';
flist=dir([fpath,'*.HDF']);

scale=0.1;
[LON,LAT]=meshgrid(-180:scale:180,-90:scale:90);
cc=load('coast');
for f=1:length(flist)
            ct=datenum(flist(f).name(20:32),'yyyymmdd_HHMM');
tic
    if exist([outpath,flist(f).name(1:15),datestr(ct,'yyyymmdd_HHMM'),'.mat'])
        disp([outpath,flist(f).name(1:15),datestr(ct,'yyyymmdd_HHMM'),' is exist'])
    else
        try
        d_r=h5read_z([fpath,flist(f).name]);
        
        bt=d_r.Data_Earth_Obs_BT;
        alt=d_r.Geolocation_Altitude;
        land=d_r.Geolocation_LandCover;
        %     d_r.Geolocation_LandSeaMask,
        lat=d_r.Geolocation_Latitude;
        lon=d_r.Geolocation_Longitude;
        %     d_r.Geolocation_Scnlin_daycnt,
        %     d_r.Geolocation_Scnlin_mscnt,
        %     d_r.Geolocation_SensorAzimuth,
%         dd=bt(:,:,1);
%         scatter(lon(:),lat(:),5,dd(:),'fill')
        zen=d_r.Geolocation_SensorZenith;
        %     d_r.Geolocation_SolarAzimuth,
        sun=d_r.Geolocation_SolarZenith;
        FY_err=1==0;
        catch
            FY_err=1==1;
        end
        if FY_err==0
                    disp(datestr(ct))
                            cloc=lon<360&lon>-180&lat>-90&lat<90;


            bt_net=nan([size(LON),length(bt(1,1,:))]);
            sun_net=netlize_fast(LON,LAT,lon(cloc),lat(cloc),sun(cloc),scale);
            zen_net=netlize_fast(LON,LAT,lon(cloc),lat(cloc),zen(cloc),scale);
            alt_net=netlize_fast(LON,LAT,lon(cloc),lat(cloc),alt(cloc),scale);
            lnd_net=netlize_fast(LON,LAT,lon(cloc),lat(cloc),land(cloc),scale);
            for lv=1:length(bt(1,1,:))
                
                bt_lv=bt(:,:,lv);
                nloc=bt_lv>0&bt_lv<50000;
                nloc=nloc&cloc;
                % nloc=cloc;
                bt_net(:,:,lv)=netlize_fast(LON,LAT,lon(nloc),lat(nloc),bt_lv(nloc),scale);
            end
            
            % %
%              randi([1 15],1)
           
            testf=randi([1 100],1)==1;
          if testf
              
              channel_r=randi([1 15],1);
             drawdata=bt_net(:,:,channel_r);
            bt_lv=bt(:,:,channel_r);
            nloc=bt_lv>0&bt_lv<50000;
            nloc=nloc&cloc;
          
            subplot(2,1,1)
            scatter(lon(nloc),lat(nloc),5,bt_lv(nloc),'fill')
            hold on
               plot(cc.long,cc.lat,'k')
                ch=colorbar;
                title(['Channel  ',num2str(channel_r)])
            
                hold off
            
            subplot(2,1,2)
                 pcolor(LON,LAT,drawdata)
                hold on
                plot(cc.long,cc.lat,'k')
                colorbar
                title('Netlize')
            caxis(get(ch,'ylim'))
                hold off
                shading flat
            picsavef(1,[outpath,flist(f).name(1:15),datestr(ct,'yyyymmdd_HHMM')])
          end
            
            save([outpath,flist(f).name(1:15),datestr(ct,'yyyymmdd_HHMM')],'bt_net','zen_net',...
                'sun_net','alt_net','lnd_net')
                              disp(flist(f).name)

        else
                              disp([flist(f).name,' ERR'])

        end
    end
    %     scatter(lon(cloc),lat(cloc),5,zen(cloc))
    
   toc 
end



