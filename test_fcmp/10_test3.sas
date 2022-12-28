options mprint;
%let  test_fcmp_path =.;           /* Path to test_fcmp folder */
%let _cmplib_path = ../_cmplib;    /* Path to _complib folder  */
libname hrs_data "C:\Users\agalecki\Dropbox (University of Michigan)\DDBC HRS Project\scrambled data";

%put test_fcmp_path := &test_fcmp_path;
%put _cmplib_path := &_cmplib_path;

%include "&test_fcmp_path/_global_test_mvars.inc"; /* global macro vars loaded */

%include _tstmac(harmonize_1cmpyr array_stmnt2); /* Macros loaded */

/* --- function_5g ----*/
%let hrs_fcmp = function_5g;
options cmplib=_cmplib.&hrs_fcmp; 
/* subhh$ adldiff adlhlp iadldiff iadl */
%harmonize_1cmpyr(1995, outdata = _95); 

%harmonize_1cmpyr(1996,  outdata = _96); 
proc print data =_96(obs=30);
run;

%harmonize_1cmpyr(2000,  outdata = _00); 
proc print data =_00(obs=30);
run;

%*harmonize_1cmpyr(1995);


endsas;

/* --- test7_DLFunction ----*/
%let hrs_fcmp = test7_DLFunction;
options cmplib=_cmplib.&hrs_fcmp; 
/* subhh$ skip adldiff adlhlp equip iadldiff iadlhlp why */
 %harmonize_1cmpyr(1992, ?, outdt = _92all); 
 %harmonize_1cmpyr(1993, ?, outdt = _93all); 

/* --- DLFUNCTION ----*/
%let hrs_fcmp = dlfunction;
options cmplib=_cmplib.&hrs_fcmp; 
/* subhh$ skip adldiff adlhlp equip iadldiff iadlhlp why */
%harmonize_1cmpyr(1995, ?, outdt = _95all); 

endsas;

