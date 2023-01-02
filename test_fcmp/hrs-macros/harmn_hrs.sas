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
proc contents data= _harmonized_base position; run;
%mend harmonized_init;

