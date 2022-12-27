%let cmplib_name = test7_DLFunction;

filename _src "../fcmp_source/&cmplib_name";
filename _cmn "../fcmp_source/_common_fcmp";

proc fcmp outlib = work.fun.test;
%*include _cmn(subhh_grp);
%*include _src(_auxiliary);
%*include _src(_binder);
%*include _src(adldiff_grp);
%*include _src(adlhlp_grp);
%*include _src(equip_grp);
%*include _src(iadldiff_grp);
%*include _src(iadlhlp_grp);
%include _src(skip_grp);
%*include _src(why_grp);

run;
quit;





