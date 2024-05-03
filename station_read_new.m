

surfpath='data/';
    surfname=[datestr(ct,'yyyymmdd'),'.txt'];
ctvs=datevec(ct+1/24);
pre_r=dlmread([surfpath,surfname]);

tloc=pre_r(:,5)==ctvs(4);
stpre=pre_r(tloc,10);
stlist=[pre_r(tloc,1) pre_r(tloc,9) pre_r(tloc,7:8)];