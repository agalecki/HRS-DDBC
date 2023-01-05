options mprint;
%let  test_fcmp_path =.;           /* Path to test_fcmp folder */
%let _cmplib_path = ../_cmplib;    /* Path to _complib folder  */
libname hrs_data "C:\Users\agalecki\Dropbox (University of Michigan)\DDBC HRS Project\scrambled data";
libname lib ".";
%put test_fcmp_path := &test_fcmp_path;
%put _cmplib_path := &_cmplib_path;

%include "&test_fcmp_path/_global_test_mvars.inc"; /* global macro vars loaded */

%include _tstmac(summ_project);
%include _tstmac(_aux_mac);
%include _tstmac(harmn_hrs);
%include _tstmac(summ_fcmplib binder_info); /* Macros loaded */

%let fcmp_member = Function_5g;

ods html file = "&test_fcmp_path/30-test3.html";
%hrs_binder (cmplib= _ucmplib, member = &fcmp_member, 
             hrs_years = 1992-2032, hrs_libin = hrs_data, dataout=lib.hrs_out);
ods html close;



