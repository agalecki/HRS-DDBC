/* Macro definitions 
- print_fcmp_summary

*/


%macro hrs_project_info(
   member,                  /* FCMP lib member: < */
   fcmplib = WORK,          /* FCMP library */
   hrsyears = ,             /* <1992 1994-2000, 2018> */ 
   vgrps = ?,               /* Variable groups. Ex: <subhh$ healthrate cancer>. 
                               See `bind_vgrps()`. By default ? all vgrps included */
   out = ,                  /* SAS library with summary datasets */ 
   printit = Y
 );

/* Select member in fcmp cmplib library */ 
options cmplib = &fcmplib..&member;

%local version_date datestamp;
%let version_date=;
%let datesatmp=;
%let member =;
data _null_;
 length version_date datestamp member $100;
 version_date = hrs_project_info("version_date");
 datestamp = hrs_project_info("datestamp");
 member = hrs_project_info("fcmp_member");
 call symput("version_date", strip(version_date));
 call symput("datestamp", strip(datestamp));
 call symput(member,strip(member));
run;


/* Create `_hrsyears` dataset with `year` variable */
%expand_years(&hrsyears); 
data _datain_info;
  set _hrsyears(keep = year);
  length member $ 32;
  length datain $ 20;
  length skipit $ 1;
  member = "&member";
  datain = dispatch_datain(year);
  skipit = " ";
  if strip(datain) = "" then skipit = "Y";
run;


data _vgrps_info;
  length member $ 32;
  length vgrps $ 1000;
  length vgrp $ 32;
  length ctype $ 1;
  length cnt_vout 8;
  length vout_nms $ 1000;
  member = "&member";

  vgrps = bind_vgrps("&vgrps");
  vgrps_sep = translate(trim(vgrps), "!", " ");
  cnt_vgrps = countw(vgrps_sep,'!');
  do i =1 to cnt_vgrps;
   vgrp = scan(vgrps_sep, i, "!");
   vgrp = strip(vgrp);
   if findc(vgrp,'$') then ctype ="$"; else ctype ="";
   vout_nms = dispatch_vout(vgrp);
   vout_nms = strip(vout_nms);
   cnt_vout = countw(vout_nms);
   output;
  end;
  keep member vgrp cnt_vout vout_nms ctype;
run;


data _vout_lbls; /* One row per vout variable */
 set _vgrps_info;
 length vout_nm $32;
 length vout_lbl $256;
 
 do i =1 to cnt_vout;
  rec_no +1;
  vout_nm = scan(vout_nms,i, ' '); /*-- Variable name --*/
  vout_nm = trim(vout_nm);
  vout_lbl = vout_label(vout_nm);
  output;
 end;
 drop i cnt_vout vout_nms;
run;

data _vout_length; /* One row per vout variable */
 set _vgrps_info;
 length vout_nm $32;
 length len $5;
 
 do i =1 to cnt_vout;
  rec_no+1;
  vout_nm = scan(vout_nms,i, ' '); /*-- Variable name --*/
  vout_nm = trim(vout_nm);
  len = vout_length(vout_nm);
  output;
 end;
 keep rec_no vout_nm len;
run;

data _vout_info;
 length member $ 32;
 length vgrp   $ 32;
 length vout_nm $32;
 length ctype $1;
 length len $5;
 length vout_lbl $256;

 merge _vout_lbls _vout_length;
 by rec_no;
drop rec_no;
run;

/* Cartesian product of years by vgrp */
data _datain_skip_info(drop=skipit);
 set _datain_info;
 if skipit ="Y" then delete;
run;


data xprod_yr_by_vgrps;
 set _datain_skip_info;
 label member = "FCMP library member name";
 label vgrp  =  "Group variable name ";
 label ctype =  "Group variable type";
 label cnt_vin = "Number of input variables in a given vgrp";
 ;
 length vin_nms $ 2000;
 do i =1 to n;
  set _vgrps_info point=i nobs =n;
  vin_nms = dispatch_vin(year, vgrp);
  cnt_vin = countw(vin_nms);
  if cnt_vin = 0 then do;
   if ctype ="$" then vin_nms = "_CHARZZZ_"; else vin_nms = "_ZZZ_"; /* Artificial vars */
  end;
  
  output;
 end;
 drop vout_nms cnt_vout;
run;

data _yr_by_vgrps_info;
  set xprod_yr_by_vgrps;
  if cnt_vin = 0 then delete;
run;

data _yr_by_vgrpszzz_info;
  set xprod_yr_by_vgrps;
  if cnt_vin = 0 then cnt_vin=1;
run;

/* Conditionally prints info datasets */ 
%if &printit = Y %then  %print_project_info; 

%mend hrs_project_info;

%macro print_project_info;
/* Prints selected temporary datasets created by `hrs_project_input` macro */

Title  "DATA: `_datain_info`: HRS Datasets.";
title2 "Rows skipit = Y will be omitted. Data `_datain_skip_info` will be used."; 
title3 "FCMP member `&member` compiled on &datestamp";
title4 "HRS years: &hrsyears"; 
proc print data = _datain_info;
run;

Title "DATA `_vgrps_info`: Variable groups (see `bind_vgrps()` function)";
proc print data=  _vgrps_info;
run;

Title "DATA ` _vout_info`: Harmonized variables";
proc print data = _vout_info;
run;

*Title "Cartesian product: year by vgroup (auxiliary)";
*proc print data = xprod_yr_by_vgrps;
*run;

Title "DATA: `_yr_by_vgrps_info`: Cartesian product: year by vgroup (cnt_vin = 0 omitted)";
Title "Dataset _yr_by_vgrps_driver includes rows with cnt_vin =0)";
proc print data = _yr_by_vgrps_info;
run;

Title "DATA: `_yr_by_vgrps_driver`: Cartesian product: year by vgroup (_ZZZ_ included)";
proc print data = _yr_by_vgrps_driver;
run; 

title;
%mend print_project_info;

%macro fcmp_member_info(
  fcmplib,                /* FCMP library */
  member,                 /* FCMP member */
  printit =Y
);
options cmplib = &fcmplib..&member;

%local version_date datestamp member;
%let version_date=;
%let datestamp=;
%let member =;
data _null_;
 length version_date datestamp member $100;
 version_date = hrs_project_info("version_date");
 datestamp = hrs_project_info("datestamp");
 member = hrs_project_info("fcmp_member");
 call symput("version_date", strip(version_date));
 call symput("datestamp", strip(datestamp));
 call symput("member", strip(member));
run;


data fcmp_member_info;
 label fcmp_name ="Function/subroutine name";
 label fcmp_grp  ="Function/subroutine group";
 set &fcmplib..&member(keep=name value);
 if name in ("FUNCTION", "SUBROUTI");
 length scan1 scan2 fcmp_grp fcmp_name $200;
 scan1 = scan(strip(value),2,')');
 scan2 = scan(strip(scan1), 2,"=");
 scan2 = translate(strip(scan2),"",";");
 scan2 = translate(scan2,'','"');
 fcmp_grp = translate(scan2,'',"'");
 fcmp_name =scan(strip(value),2," (");
 drop scan1 scan2;
run;

proc sort data = fcmp_member_info;
by fcmp_grp;
run;

/* Conditionally prints info datasets */ 
%if &printit = Y %then  %do;
 Title "FCMP member:  &member.. Compiled on &datestamp";
 proc print data = fcmp_member_info; 
 by fcmp_grp;
 run;
%end;
%mend fcmp_member_info;

