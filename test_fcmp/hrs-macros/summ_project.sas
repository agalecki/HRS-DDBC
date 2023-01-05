

%macro hrs_project_info (
   fcmplib,                 /* FCMP library */
   fcmpmember,              /* FCMP lib member: */
   hrsyears = 1992-2030,    /* <1992 1994-2000, 2018> */ 
   hrs_datalib =,           /* If provided then checked whether library exist */
   vgrps = ?,               /* Variable groups. Ex: <subhh$ healthrate cancer>. 
                               See `bind_vgrps()`. By default ? all vgrps included */
   out = work.hrs_project_definition,  /* SAS dataset with project definition */ 
   printit = Y,
 );

/* Select member in fcmp cmplib library */ 
options cmplib = &fcmplib..&fcmpmember;

%let fcmpmember =; /* `fcmp_member` extracted from fcmp library will be used instead */


%local version_date datestamp fcmp_member;
%let version_date=;
%let datestamp=;
%let fcmp_member =;
%fcmp_member_datainfo; /* Data with _label, _member, _version, _date vars created*/

proc sql noprint; /* Macro vars created */
 select _version    into :version_date  separated by " "  from fcmp_member_datainfo;
 select _datestamp  into :datestamp     separated by " "  from fcmp_member_datainfo;
 select _member     into :fcmp_member     separated by " "  from fcmp_member_datainfo;
quit;

 
%put fcmp_member := &fcmp_member;


/* Create `_hrsyears` dataset with `year` variable */
%expand_years(&hrsyears); 
data _datain_info;
  set _hrsyears(keep = year);
  length fcmp_member $ 32;
  length hrs_datalib $ 8;
  length datain $ 20;
  label datain_exist = "";
  length skipit $ 1;
  length dtref $45;

  fcmp_member = "&fcmp_member";
  hrs_datalib = "&hrs_datalib";
  datain = dispatch_datain(year);
  dtref = "";
  datain_exist =.D; /* not checked */
  if hrs_datalib ne "" then do;
    dtref = strip(hrs_datalib)||"."|| strip(datain);
    datain_exist = data_exist(dtref);
  end; else hrs_datalib ="-Unknown";
  skipit = " ";
  if strip(datain) = "" then skipit = "Y";
  if datain_exist = 0 then skipit = "Y";
  drop dtref;
run;


data _vgrps_info;
  length fcmp_member $ 32;
  length vgrps $ 1000;
  length vgrp $ 32;
  length ctype $ 1;
  length cnt_vout 8;
  length vout_nms $ 1000;
  fcmp_member = "&fcmp_member";

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
  keep fcmp_member vgrp cnt_vout vout_nms ctype;
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
  if strip(len) = "." then len ="";
  output;
 end;
 keep rec_no vout_nm len;
run;

data _vout_info;
 length fcmp_member $ 32;
 length vgrp   $ 32;
 length vout_nm $32;
 length ctype $1;
 length len $5;
 length ctypelen $6;
 length vout_lbl $256;

 merge _vout_lbls _vout_length;
 by rec_no;
 ctypelen = strip(ctype)||strip(len);
drop rec_no;
run;

/* Cartesian product of years by vgrp */
%macro nobs;
   %let mydataID=%sysfunc(OPEN(&mydata.,IN));
    %let NOBS=%sysfunc(ATTRN(&mydataID,NOBS));
    %let RC=%sysfunc(CLOSE(&mydataID));
    &NOBS
%mend nobs;

data _datain_skip_info(drop=skipit);
 set _datain_info;
 if skipit ="Y" then delete;
run;


data xprod_yr_by_vgrps; /* Cartesian product of years by vgrp */
 set _datain_skip_info;
 label fcmp_member = "FCMP library member name";
 label vgrp  =  "Group variable name ";
 label ctype =  "Group variable type";
 label cnt_vin = "Number of input variables in a given vgrp";
 ;
 length  vin_nms $ 2000;
  length vinz_nms $ 2000;
 do i =1 to n;
  set _vgrps_info point=i nobs =n;
  vin_nms = dispatch_vin(year, vgrp);
  vinz_nms = strip(vin_nms);
  cnt_vinz = countw(vin_nms);
  if cnt_vinz = 0 then do;
   if ctype ="$" then vinz_nms = "_CHARZZZ_"; else vinz_nms = "_ZZZ_"; /* Artificial vars */
   cnt_vinz = 1;
  end;
  output;
 end;
 drop cnt_vout;
run;


/* Conditionally prints info datasets */ 
%if &printit = Y %then  %print_project_info; 

%*if %isblank(&hrs_datalib) =0 %then %harmonized_init;
%mend hrs_project_info;

%macro print_project_info;
/* Prints selected temporary datasets created by `hrs_project_input` macro */

Title  "DATA: `_datain_info`: HRS Datasets.";
title2 "Rows skipit = Y will be omitted. Data `_datain_skip_info` will be used."; 
title3 "FCMP member `&fcmp_member` compiled on &datestamp";
title4 "HRS years: &hrsyears"; 
proc print data = _datain_info;
run;

Title "DATA `_vgrps_info`: Variable groups (see `bind_vgrps()` function)";
proc print data=  _vgrps_info;
run;

Title "DATA ` _vout_info`: Harmonized variables";
proc print data = _vout_info;
run;

%put hrs_datalib := &hrs_datalib; 
%if %isblank(&hrs_datalib) =0 %then %do;
Title "Cartesian product: year by vgroup (`xprod_yr_by_vgrps`)";
proc print data = xprod_yr_by_vgrps;
run;
%end;

title;
%mend print_project_info;
