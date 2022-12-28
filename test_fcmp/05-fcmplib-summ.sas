options mprint;
%let  test_fcmp_path =.;           /* Path to test_fcmp folder */
%let _cmplib_path = ../_cmplib;    /* Path to _complib folder  */
%put test_fcmp_path := &test_fcmp_path;
%put _cmplib_path := &_cmplib_path;

%include "&test_fcmp_path/_global_test_mvars.inc"; /* global macro vars loaded */

%*include _tstmac(??); /* Macros loaded */

%macro printdt(data);
Title "Dataset: &data";
proc print data= &data;
run;
%mend printdt;

%macro cum_var(data, cvar);
/* Cumulate cvar strings and store in _tmpc macro variable */ 
data _null_;

 set &data (keep=&cvar) end = last;
 length _tmpc $5000;
 retain _tmpc;
 _tmpc = strip(_tmpc) || " " || strip(&cvar); 
 if last then call symput("_tmpc", strip(_tmpc)); 
run;

%mend cum_var;

%macro summarize_fcmplib(fcmplib, fcmpnm, select_hrsyears = _select_hrsyears, outlib = work);

options cmplib = &fcmplib..&fcmpnm;


%***printdt(_all_hrsyears);

data summary_datain;
  set &select_hrsyears;
  length datain $ 20;
  length skipit $ 1;
  datain = dispatch_datain(year);
  skipit = " ";
  if strip(datain) = "" then skipit = "?";
run;
%printdt(summary_datain);


data summary_vgrps;
  length fcmpnm $ 32;
  length vgrps $ 1000;
  length vgrp $ 32;
  length ctype $ 1;
  length cnt_vout 8;
  length vout_nms $ 1000;
   fcmpnm = "&fcmpnm";

  vgrps = bind_vgrps("?");
  cnt_vgrps = countw(vgrps);
  do i =1 to cnt_vgrps;
   vgrp = scan(vgrps,i, " ");
   vgrp = strip(vgrp);
   if findc(vgrp,'$') then ctype ="$"; else ctype ="";
   vout_nms = dispatch_vout(vgrp);
   vout_nms = strip(vout_nms);
   cnt_vout = countw(vout_nms);
   output;
  end;
  keep fcmpnm vgrp cnt_vout vout_nms ctype;
run;
%printdt(summary_vgrps);

data summary_vout;
 set summary_vgrps;
 length vout_nm $32;
 length vout_lbl $256;
 do i =1 to cnt_vout;
  vout_nm = scan(vout_nms,i, ' ');
  vout_nm = strip(vout_nm);
  vout_lbl = vout_labels(vout_nm);
  output;
 end;
 drop i cnt_vout vout_nms;
run;
%printdt(summary_vout);

/* Cartesian product of years by vgrp */
data aux_datain(drop=skipit);
 set summary_datain;
 if skipit ="?" then delete;
run;


data xprod_yr_by_vgrps;
 set aux_datain;
 label fcmpnm = "FCMP library memebr name";
 label vgrp  =  "Group variable name ";
 label ctype =  "Group variable type";
 label cnt_vin = "Number of input variables in a given group";
 ;
 length vin_nms $ 2000;
 do i =1 to n;
  set summary_vgrps point=i nobs =n;
  vin_nms = dispatch_vin(year, vgrp);
  cnt_vin = countw(vin_nms);
  if cnt_vin = 0 then do;
   if ctype ="$" then vin_nms = "_CHARZZZ_"; else vin_nms = "_ZZZ_"; /* Artificial vars */
  end;
  
  output;
 end;
 drop vout_nms cnt_vout;
run;

%printdt(xprod_yr_by_vgrps);
data summary_yr_by_vgrps;
  set xprod_yr_by_vgrps;
  if cnt_vin = 0 then delete;
run;

data driver_yr_by_vgrps;
  set xprod_yr_by_vgrps;
  if cnt_vin = 0 then cnt_vin=1;
run;


%printdt(summary_yr_by_vgrps);
%printdt(driver_yr_by_vgrps);


%mend summarize_fcmplib;

/* Auxiliary dataset that contains `year` variable (one row per selected year */ 

data _select_hrsyears;
   do year= 1992 to 1995;
   output;
  end;
  do year = 1996 to 2002 by 2;
   output;
  end;
run;
ods listing close;
options nocenter;

ods html;
%*summarize_fcmplib(_cmplib, test7_DLFunction); /* By default: select_hrsyears = _select_hrsyears, outlib = work */
%summarize_fcmplib(_cmplib, Function_5g);      /* By default: select_hrsyears = _select_hrsyears, outlib = work */
ods html close;
