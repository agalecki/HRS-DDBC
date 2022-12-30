options mprint;
%let  test_fcmp_path =.;           /* Path to test_fcmp folder */
%let _cmplib_path = ../_cmplib;    /* Path to _complib folder  */
libname hrs_data "C:\Users\agalecki\Dropbox (University of Michigan)\DDBC HRS Project\scrambled data";

%put test_fcmp_path := &test_fcmp_path;
%put _cmplib_path := &_cmplib_path;

%include "&test_fcmp_path/_global_test_mvars.inc"; /* global macro vars loaded */

%include _tstmac(summ_fcmplib);
%include _tstmac(array_stmnt2);
%include _tstmac(_aux_mac);


%macro IADl_function_test(hrsyears, cmplib = WORK, member = Function_5g);
   %hrs_project_info(&member, fcmplib = &cmplib, hrsyears = &hrsyears, printit =N);
   
/* STEP 0:Create list of harmonized vars */
proc sql noprint;
 select count(*) into :cnt_vout from _vout_info;
 select vout_nm  into :vout_list  separated by " "  from _vout_info;
 select ctype    into :ctype_list separated by "!" from _vout_info;
 select vout_lbl into :lbl_list separated by "!" from _vout_info;
quit;
%put # of harmonized vars    := &cnt_vout;
%put List of harmonized vars := &vout_list;
%put List of ctype := &ctype_list;

/* STEP0: initialize `_hrs_out` data */
data _hrs_out (label ="XYZ");
 label hhid         = "HOUSEHOLD IDENTIFIER"
      pn            = "PERSON NUMBER"
      studyyr       = "STUDY YEAR";
 length hhid $6 pn $3;
 
 %do i=1 %to &cnt_vout;
   %let vnm = %scan(&vout_list, &i);   
   %let vlbl= %scan(&lbl_list, &i, !);
   %let ctp = %scan(&ctype_list, &i, !);
   %put vnm := &vnm;
   %put ctp := &ctp;
   %if %isBlank(&ctp) = 0 %then length &vnm $1;;
   label &vnm = "&vlbl";
  %end;
  call missing(of _all_);
  stop;
;
run;



%mend IADl_function_test;


ods listing close;
options nocenter;

ods html;
%let member = Function_5g;
libname lib1 "&_cmplib_path/
%IADl_function_test(1992-2000, cmplib =_cmplib, member = &member);
ods html close;
endsas;


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

