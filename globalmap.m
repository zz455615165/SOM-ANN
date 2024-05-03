if exist('cc')
else
    cc=load('coast')
end
plot(cc.long,cc.lat,'k','linewidth',1)