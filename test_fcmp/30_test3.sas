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
%*include _tstmac(summ_fcmplib binder_info); /* Macros loaded */




%let fcmp_member = Function_5g;
%hrs_main_macro(
        fcmplib      =_ucmplib,           /* FCMP libref (fcmplib) */ 
	fcmpmember   = &fcmp_member,
        hrsyears     = 1992-2000,       /* HRS years */
        hrs_datalib = hrs_data,       /* libref to hrs data library (hrs_datalib)*/
        vgrps = ?,
        out = lib.hrs_out); 
*ods html close;
ENDSAS;

