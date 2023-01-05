options mprint;
libname hrs_data "C:\Users\agalecki\Dropbox (University of Michigan)\DDBC HRS Project\scrambled data";

%let  test_fcmp_path =.;           /* Path to test_fcmp folder */
%let _cmplib_path = ../_cmplib;    /* Path to _complib folder  */
%put test_fcmp_path := &test_fcmp_path;
%put _cmplib_path := &_cmplib_path;

%include "&test_fcmp_path/_global_test_mvars.inc"; /* global macro vars loaded */
%include _tstmac(_aux_mac summ_fcmplib summ_project binder_info harmn_hrs); /* Macros loaded */

/* Auxiliary dataset that contains `year` variable (one row per selected year */ 

ods listing close;
options nocenter mprint nodate;

/* --- Process one fcmp member at a time */


%*let fmember = Function_5g;
%let fmember = test7_DLFunction;
%*let fmember = healthC_init;

ods html file = "&test_fcmp_path/10_project-info.html";
%hrs_binder();
%hrs_binder (cmplib= _ucmplib);
%hrs_binder (cmplib= _ucmplib, member = &fmember);
%hrs_binder (cmplib= _ucmplib, member = &fmember, hrs_years = 1992-2032);
%hrs_binder (cmplib= _ucmplib, member = &fmember, hrs_years = 1992-2032, hrs_libin = hrs_data);

ods html close;
endsas;
