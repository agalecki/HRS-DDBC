%macro hrs_binder_arguments;
Title "HRS_BINDER macro arguments. (Version: 3JAN2023)"; /* update, if needed */
data hrs_binder_arguments;
length name $32;
length desc $250;
length default $200;
name = "cmplib";
desc = "?? more to follow";
default ="";
output;
run;
proc print data = hrs_binder_arguments;
run;
title "";
%mend hrs_binder_arguments;

%macro _cmplib_info(cmplib =);
/* Macro returns dataset with info on FCMP cmplib members */
ods exclude all;
ods output Members =_cmplib_members;
ods output directory =_cmplib_directory;

title "CMPLIB: `&cmplib info`"; 
* ods trace on;
PROC CONTENTS data = &cmplib.._ALL_ NODS;
RUN;
ods show;
ods output close;
ods exclude none;
quit;
*ods trace off;

title "FCMP members in `&cmplib` info library (&sysdate)"; 
proc print data = _cmplib_members;
run;

title "Directories for `&cmplib info` FCMP library"; 
proc print data = _cmplib_directory;
run;


title "";
%mend _cmplib_info;

%macro hrs_binder(
    cmplib =,
    member =,
    hrs_years =,
    vgrps = ?,
    hrs_libin =,
    dataout =
);

/* --- Prepare ex? vriables for conditional execution */ 
 %let ex0 =N; /*        -> hrs_binder_arguments */
 %let ex1 =N; /* cmplib -> _cmplib_info  */
 %let ex2 =N; /* member -> _fcmp_member_info */
 %let ex3 =N; /* hrs_years -> hrs_project_info */
 %let ex4 =N; /* hrs_libin ->  hrs_project_info*/
 %let ex5 =N; /* dataout -> main_macro */
 
 %if %isblank(&cmplib) = 1 %then %let ex0 = Y;
 %if %isblank(&cmplib) = 0 %then 
  %do;
    %let ex0 =N;
    %let ex1 =Y; /* ex1 cmplib */
  %end;
    
%if %isblank(&member) = 0 %then 
  %do;
    %let ex0 =N;
    %let ex1 =N;
    %let ex2 =Y; /* ex2 member*/
  %end;

%if %isblank(&hrs_years) = 0 %then 
  %do;
    %let ex0 =N;
    %let ex1 =N;
    %let ex2 =N;
    %let ex3 =Y; /* ex3 hrs_years*/
  %end;
 
 %if %isblank(&hrs_libin) = 0 %then 
  %do;
    %let ex0 =N;
    %let ex1 =N;
    %let ex2 =N;
    %let ex3 =N;
    %let ex4 =Y; /* ex4 hrs_libin*/
  %end;

 %if %isblank(&dataout) = 0 %then 
  %do;
    %let ex0 =N;
    %let ex1 =N;
    %let ex2 =N;
    %let ex3 =N;
    %let ex4 =N;
    %let ex5 =Y; /* ex5 dataout*/
  %end;  
 
/* Conditionaly execute macros */
%put ex0 :=&ex0, ex1 := &ex1, ex2 := &ex2, ex3 := &ex3, ex4= &ex4, ex5 := &ex5;
%if &ex0 = Y %then %hrs_binder_arguments;
%if &ex1 = Y %then %_cmplib_info(cmplib =&cmplib);
%if &ex2 = Y %then %fcmp_member_info(cmplib =&cmplib, fcmpmember=&member, printit = Y); 
%if &ex3 = Y %then %hrs_project_info(fcmplib =&cmplib, fcmpmember=&member,
                                       hrsyears =&hrs_years,vgrps=&vgrps, printit = Y); 
%if &ex4 = Y %then %hrs_project_info(fcmplib =&cmplib, fcmpmember=&member, hrsyears =&hrs_years,
                        vgrps=&vgrps, hrs_datalib =&hrs_libin, printit = Y);
%if &ex5 = Y %then %hrs_main_macro(fcmplib =&cmplib, fcmpmember=&member, hrsyears =&hrs_years,
                        vgrps=&vgrps, hrs_datalib =&hrs_libin, out =&dataout);

%mend hrs_binder;
