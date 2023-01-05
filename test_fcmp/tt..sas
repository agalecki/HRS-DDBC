data dt;
x=1; a=3;
run;

ods html;
*ods trace on;
ods exclude all;
ods output variables =_contents_vars;
proc contents data=dt;
run;
quit;
ods output close;
ods exclude none;
*ods trace off;
proc sort data=_contents_vars;
by num;
run;

Title "xyz";

proc print data= _contents_vars;
run;

