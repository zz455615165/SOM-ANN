
 surfpath='GSOD/';
   if exist('g_r2022')
   else
g_r2022=load([surfpath,'GSOD_2022.mat']);
% g_info=
   end
   
   
% pre_r=dlmread([surfpath,surfname]);

% tloc=pre_r(:,5)==ctvs(4);
% stpre=pre_r(tloc,10);
% stlist=[pre_r(tloc,1) pre_r(tloc,9) pre_r(tloc,7:8)];

gspre=g_r2022.gsod_pre(:,ctv(4)+1,j_d);
% gdur=g_r2022.gsod_dur(:,ctv(4)+1,j_d);
% gspre(gdur~=1)=nan;
gloc=~isnan(gspre)&gspre<9000;
gspre=gspre(gloc)/10;
% gslist=
gslist=[g_r2022.gstation(gloc,1),g_r2022.gstation(gloc,4),g_r2022.gstation(gloc,2:3)];
