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


%macro IADL_function_test(hrsyears, 
                          hrs_datalib =,
                          fcmplib = WORK, 
                          fcmpmember = Function_5g, 
                          out = WORK);
/* Load FCMP library FCMP member */                          
options cmplib = &fcmplib..&fcmpmember;

/* --- Use `hrs_project_info` function to extract project info from cmplib */
%fcmp_member_datainfo; /* Data with _label, _member, _version, _datestamp vars created*/
*proc print data = fcmp_member_datainfo; run;

%local fcmp_label fcmp_version fcmp_datestamp fcmp_member;
proc sql noprint; /* Macro vars created */
 select _member     into :fcmp_member    from fcmp_member_datainfo;
 select _version    into :fcmp_version   from fcmp_member_datainfo;
 select _label      into :fcmp_label     from fcmp_member_datainfo;
 select _datestamp  into :fcmp_datestamp from fcmp_member_datainfo;
quit;

%put fcmp_member          := &fcmp_member;
%put FCMP version (date)  := &fcmp_version;
%put fcmp_label           := &fcmp_label;
%put Compiled on          := &fcmp_datestamp;


/*-- Data: _datain_info,  ---*/
%hrs_project_info(&fcmpmember, fcmplib = &fcmplib, hrsyears = &hrsyears, printit = N);

/* STEP 0: Create list of harmonized vars */
proc sql noprint;
 select count(*) into :cnt_vout from _vout_info;
 select vout_nm  into :vout_list  separated by " "  from _vout_info;
 select vout_lbl into :lbl_list   separated by "~"  from _vout_info;
quit;

data _tmp1;
  set  _vout_info;
  if strip(ctypelen) ne '';
run;

proc print data=_tmp1;
run;


proc sql noprint;
 select count(*)  into :cnt_ctypelen                    from _tmp1;
 select ctypelen  into :ctypelen_list separated by "~"  from _tmp1;
 select vout_nm   into :ctypelen_nms  separated by " "  from _tmp1;
quit;

%put # of harmonized vars    := &cnt_vout;
%put List of harmonized vars := &vout_list;
%put # of vars with non blank length := &cnt_ctypelen; 
%put List of ctypelen values := &ctypelen_list;

/* STEP0: initialize `_harmonized_out` data */
data _harmonized_out (label ="fcmp_label (FCMP &fcmp_member compiled on &fcmp_datestamp).");
 label hhid         = "HOUSEHOLD IDENTIFIER"
      pn            = "PERSON NUMBER"
      studyyr       = "STUDY YEAR";
 /*-- Label statements ---*/
 %do i=1 %to &cnt_vout; 
   %let vnm = %scan(&vout_list, &i);   
   %let vlbl= %scan(&lbl_list, &i, ~);
   %*put vnm := &vnm;
   label &vnm = "&vlbl";
 %end;    
 
 /*-- Length statements ---*/      
 length hhid $6 pn $3;
  %if %eval(&cnt_ctypelen) > 0 %then 
    %do i= 1 %to &cnt_ctypelen;
     %let vnm = %scan(&ctypelen_nms, &i);  
     %let ctp = %scan(&ctypelen_list, &i, ~);
     length &vnm &ctp;
    %end;
 
  call missing(of _all_);
  stop;
;
run;


%mend IADL_function_test;

%let fcmp_member = Function_5g;
libname lib1 "&_cmplib_path/&fcmp_member";
%IADL_function_test(1992-2000, fcmplib =lib1, fcmpmember = &fcmp_member);
ods html close;
endsas;






   

 
 





%mend IADL_function_test;


ods listing close;
options nocenter;

ods html;
%let fcmp_member = Function_5g;
libname lib1 "&_cmplib_path/
%IADL_function_test(1992-2000, cmplib =_cmplib, member = &member);
ods html close;
ENDSAS;


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

