%macro harmonized_init;
/* STEP 0: Create list with labels of harmonized vars */


data _tmp;
  set  _vout_info;
  if strip(ctypelen) ne '';
run;

*proc print data=_tmp;
run;

%let ctypelen_list =;
proc sql noprint;
 select count(*)  into :cnt_ctypelen                    from _tmp;
 select ctypelen  into :ctypelen_list separated by "~"  from _tmp;
 select vout_nm   into :ctypelen_nms  separated by " "  from _tmp;
quit;

%put # of vars with non blank length := &cnt_ctypelen; 
%put List of ctypelen values := &ctypelen_list;

/* STEP0: initialize `_harmonized_out` data */
data _harmonized_base (label ="&fcmp_label.. FCMP member `&fcmp_member` compiled on &fcmp_datestamp.");
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
* proc contents data= _harmonized_base position; run;
%mend harmonized_init;

%macro array_stmnt2(year, _vgrp, vout, vin);
%local i vin_cnt vgrpnm grp_type vin2;
/* call this macro from inside DATA step */
%let vgrpnm = %sysfunc(compress(&_vgrp,'$'));
%let grp_type =  %sysfunc(findc(&_vgrp,'$'));
%let ctype = $;
%if %eval(&grp_type) =0 %then %let ctype =;
%put ==>: array_stmnt year :=&year, var_grp := &_vgrp, ctype := &ctype;
%put > var_in := &vin;
%put > var_out := &vout;
%let vin_cnt=%sysfunc(countw(&vin));
%*put vin_cnt := &vin_cnt;

%let vout_cnt=%sysfunc(countw(&vout));

array &vgrpnm._vin {&vin_cnt} &ctype  _temporary_; 
%do i =1 %to &vin_cnt; /* Populate temp array */
  &vgrpnm._vin[&i] = %scan(&vin, &i, ' ');
%end;

%if &ctype = $ %then 
  %do;
      %* put --- &vgrp (character) processed ---- ;
      &vout = exec_vgrpc(&year, "&_vgrp", &vgrpnm._vin);
  %end;
%else
  %do;  
      %*put --- &vgrp (numeric) processed ---- ;
       array &vgrpnm._vout {&vout_cnt} &vout;
       call exec_vgrpx(&year, "&_vgrp", &vgrpnm._vout, &vgrpnm._vin);  
  %end;

%mend array_stmnt2; 

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
     %let _vgrp = %scan(&vgrp_list, &i,'~'); 
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

* proc print data =  _harmonized_base;
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

%macro hrs_main_macro(
         fcmplib=, 
         fcmpmember=, 
         hrsyears=, 
         hrs_datalib=,
         vgrps = ?,
         out =);
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
%hrs_project_info( fcmplib = &fcmplib, fcmpmember=&fcmp_member,hrsyears = &hrsyears, printit = N,
   vgrps = &vgrps, hrs_datalib = &hrs_datalib, out =);

/* STEP0: ====initialize `_harmonized_out` data */
proc sql noprint;
 select vgrp     into :vgrp_list  separated by "~"  from _vgrps_info;
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

/* --- Finish -----*/
%if %isblank(&out) = 0 %then %do;
/* rename and move `_harmonized_base` dataset */
%let out1 = %scan(&out, 1, '.');
%let out2 = %scan(&out, 2, '.');
proc datasets library = work ;
   change _harmonized_base=&out2;
run;
   copy in=work out = &out1 move;
   select &out2;
run;
quit;
%end;

%mend hrs_main_macro;


