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
%include _tstmac(harmn_hrs);


%macro harmonize_1year;

data _year_outdata; 
  set &hrs_datalib..&datain(keep = pn hhid &vin_nms_all);
  missing O D R I N Z;
  _CHARZZZ_= ""; /*  Artificial variable */
  _ZZZ_ =.;
  studyyr =&year;
  
   /*-- set initial values to missing ---*/
   %do i=1 %to &cnt_vout; 
     %let vnm = %scan(&vout_list, &i);   
     %let ctype= %scan(&ctype_list, &i, ~);
     %*put ctype := &;
     &vnm =
     %if &ctype =$ %then "?"; %else .Z;;
   %end;    
   %do i =1 %to &cnt_vgrps;
     %let _vgrp = %scan(&vgrp_list, &i); 
     %let vinz = %scan(&vinz_nms_grpd, &i, '~');
     %let vout = %scan(&vout_nms_grpd, &i,  '~');
     %array_stmnt2(&year, &_vgrp, &vout, &vinz);
   %end;
 drop &vin_nms_all;
  drop _CHARZZZ_ _ZZZ_;
run;

proc append base = _harmonized_base
            data = _year_outdata;
run;

proc print data =  _harmonized_base;
run;


  

%mend harmonize_1year;

%macro harmonize_main_loop;
%do iyear = 1 %to &cnt_hrsyears;
 %let year =%scan(&hrsyears_list, &iyear, ' ');
 %put ===>->-> Main loop executed for year &year   ========;
 
  
 /* Auxiliary dataset with info pertaining to a given year */
 data tmp1z;
    set xprod_yr_by_vgrps;
    if year ="&year";
 run;
  
 data tmp1a;
   set tmp1z(keep = vin_nms);
   length vnm $32;
   n = countw(vin_nms);
   if (n>0) then;
    do i=1 to n;
    vnm =scan(vin_nms,i);
    output;
   end;
 run;
 
 proc sql noprint;
  select datain   into :datain  from _datain_skip_info where year = "&year";   /* datain */
  select vin_nms  into :vin_nms_grpd  separated by "~"  from tmp1z;
  select vinz_nms into :vinz_nms_grpd separated by "~"  from tmp1z;
  select vout_nms into :vout_nms_grpd separated by "~"  from tmp1z;
  select distinct vin_nms into :vin_nms_all separated by " "  from tmp1a;
 
 quit;
 
 %put === Macro vars used to execute macro `harmonize_1year` ====;
 %put year                    := &year;
 %put # of var groups         := &cnt_vgrps;
 %put List of var groups      := &vgrp_list;
 %put # of harmonized vars    := &cnt_vout;
 %put List of grouped harmonized vars := &vout_nms_grpd;
 %put datain                  := &datain;
 %put vin_nms_grpd            := &vin_nms_grpd; 
 %put vinz_nms_grpd           := &vinz_nms_grpd; /* Will be used to declare arrays of variables */
 %put vin_nms_all            := &vin_nms_all;
 %harmonize_1year;

%end; /* Main loop: iyear */

%mend harmonize_main_loop;



%macro IADL_function_test(hrsyears, 
                          hrs_datalib =,
                          fcmplib = WORK, 
                          fcmpmember = Function_5g, 
                          vgrps = ?,
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
%let fcmp_member= %trim(&fcmp_member);
%let fcmp_version = %trim(&fcmp_version);
%let fcmp_label = %qtrim(&fcmp_label);
%let fcmp_datestamp = %trim(&fcmp_datestamp);


%put fcmp_member          := &fcmp_member;
%put FCMP version (date)  := &fcmp_version;
%put fcmp_label           := &fcmp_label;
%put Compiled on          := &fcmp_datestamp;


/*-- Data: _datain_info,  ---*/
%hrs_project_info(&fcmpmember, fcmplib = &fcmplib, hrsyears = &hrsyears, printit = N,
   vgrps = &vgrps);

/* STEP0: ====initialize `_harmonized_out` data */
proc sql noprint;
 select vgrp     into :vgrp_list  separated by " "  from _vgrps_info;
 select count(*) into :cnt_vgrps  from _vgrps_info;
 select count(*) into :cnt_vout from _vout_info;
 select vout_nm  into :vout_list  separated by " "  from _vout_info;
 select year     into :hrsyears_list separated by  " "  from  _datain_skip_info;
 select count(*) into :cnt_hrsyears from _datain_skip_info;
 select vout_lbl into :lbl_list   separated by "~"  from _vout_info;
 select ctype    into :ctype_list  separated by "~"  from _vout_info;
quit;
%put # of var groups         := &cnt_vgrps;
%put List of var groups      := &vgrp_list;
%put # of harmonized vars    := &cnt_vout;
%put List of harmonized vars := &vout_list;
%put List of ctype variable  := &ctype_list;
%harmonized_init;

/* ===>> */
%put hrsyears_list := &hrsyears_list;
%put cnt_hrsyears  := &cnt_hrsyears;
%harmonize_main_loop;

%mend IADL_function_test;

%let fcmp_member = Function_5g;
libname lib1 "&_cmplib_path/&fcmp_member";
%IADL_function_test(1992-2000, hrs_datalib = hrs_data, fcmplib =lib1, fcmpmember = &fcmp_member,
                    vgrps = ?);  /*iadl */
ods html close;
ENDSAS;


%mend IADL_function_test;


ods listing close;
options nocenter;

ods html;


%let fcmp_member = Function_5g;
libname cmplib1 "&_cmplib_path/&fcmp_member";
%IADL_function_test(1992-2000, hrs_datalib = hrs_data, cmplib = cmplib1, member = &member);
ods html close;
-- ENDSAS;


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

