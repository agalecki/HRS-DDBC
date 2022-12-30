%let cmplib_name = FUNCTION_5G;

filename _src "../fcmp_source/&cmplib_name";
proc fcmp outlib = work.fun.test;
%include _src(_common);
%include _src(subhh_grp);
%include _src(_auxiliary);
%include _src(_binder);
%include _src(adldiff_grp);
%include _src(adlhlp_grp);
%include _src(iadl_grp);
%include _src(iadldiff_grp);

run;
quit;



options cmplib = work.fun;

data dt;
  vgrpz = vgrp_name3("subhh$1");
 
  vgrps  = bind_vgrps("?");
  vgrps_sep = translate(trim(vgrps), "!", " ");
  cnt_vgrps = countw(vgrps_sep,'!');
  
  i=1;
     vgrp = scan(vgrps_sep, i, "!");
     vgrp = strip(vgrp);
     
     if findc(vgrp,'$') then ctype ="$"; else ctype ="";
     vout_nms = dispatch_vout(vgrp);
     vout_nms = strip(vout_nms);
     cnt_vout = countw(vout_nms);

;
run;

proc print data=dt;
run;






