d=[TabDat.hdr;TabDat.dat];
stats=table(d);
writetable(stats, 'stats.xls');