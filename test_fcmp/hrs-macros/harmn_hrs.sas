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



