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

ods html file = "&test_fcmp_path/05-fcmplib-info1.html";
libname lib1 "&_cmplib_path\Function_5g";
%fcmp_member_info(lib1, Function_5g);
ods html close;


ods html file = "&test_fcmp_path/05-fcmplib-info2.html";
%hrs_project_info(Function_5g, fcmplib=lib1, hrsyears = 1992-2000); 
%*hrs_project_info( test7_DLFunction, fmplib=_cmplib, hrsyears = 1992-2000); 

ods html close;
