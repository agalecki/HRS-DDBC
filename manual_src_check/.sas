%let cmplib_name = funtest;

filename _src "../src/&cmplib_name";
filename _cmn "../src/_common_fcmp";

proc fcmp outlib = work.fun.test;
%include _cmn(subhh_grp);
%include _src(_binder);
%include _src(adldiff_grp);
%include _src(adlhlp_grp);
%include _src(iadl_grp);
%include _src(iadldiff_grp);
%include _src(_auxiliary);

run;
quit;





