options mprint;
%let  test_fcmp_path =.;           /* Path to test_fcmp folder */
%let _cmplib_path = ../_cmplib;    /* Path to _complib folder  */
%put test_fcmp_path := &test_fcmp_path;
%put _cmplib_path := &_cmplib_path;

%include "&test_fcmp_path/_global_test_mvars.inc"; /* global macro vars loaded */

%include _tstmac(_aux_mac summ_fcmplib); /* Macros loaded */

/* Auxiliary dataset that contains `year` variable (one row per selected year */ 

ods listing close;
options nocenter;

/* --- Process one fcmp member at a time */

%*let fcmp_member = Function_5g;
%*let fcmp_member = test7_DLFunction;
%let fcmp_member = healthC_init;

/*-- Do not make changes below */
libname libx "&_cmplib_path\&fcmp_member";
ods html file = "&test_fcmp_path/05-fcmplib-info1.html";
%fcmp_member_info(libx, &fcmp_member);
ods html close;

ods html file = "&test_fcmp_path/05-fcmplib-info2.html";
%hrs_project_info(&fcmp_member, fcmplib=libx, hrsyears = 1992-2000); 
ods html close;
