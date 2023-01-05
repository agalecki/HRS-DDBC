%macro expand_years(hrsyears);

data _hrsyears;
 length years $ 100;
 years = "&hrsyears";
 nwords = countw(years, " ");
 do idx =1 to nwords;
   yrc  = scan(years, idx, ' ');
   yrx_start = input(scan(yrc, 1, "-"), 8.);
   if find(yrc,'-') > 0 then yrx_end = input(scan(yrc,2, "-"), 8.);
     else yrx_end = yrx_start;
    do jx = yrx_start to yrx_end by 1;
     yearx = jx;
     year = put(yearx, 4.);
     if 1992<= jx <= 1996 then output;
	 else if jx > 1996 & mod(jx,2)=0 then output;
    end; /* do  jx */
 end; /* do wordi */
 run;
 
%mend expand_years;


/* https://support.sas.com/resources/papers/proceedings09/022-2009.pdf */
%macro isBlank(param);
 %sysevalf(%superq(param)=, boolean)
%mend isBlank;

%macro fcmp_member_datainfo;
/* Creates auxiliary dataset with info on fcmp member */
/* Requires that `options cmplib=` be defined */
data fcmp_member_datainfo;
 length _label  $256;
 length _member $32;
 length _version $30;
 length _datestamp $30;
_label     = fcmp_member_info("label");
_member    = fcmp_member_info("fcmp_member");
_version   = fcmp_member_info("version_date");
_datestamp = fcmp_member_info("datestamp");
run;
%mend  fcmp_member_datainfo;

%macro _contents_vars(data, printit = Y);
/* creates `_contents_vars` dataset */

*ods trace on;
ods exclude all;
ods output variables =_contents_vars;
proc contents data= &data position; run;
run;
quit;
ods output close;
ods exclude none;
*ods trace off;
proc sort data=_contents_vars;
by num;
run;

%if &printit =Y %then %do;
 proc print data= _contents_vars(drop=num);
 run;
%end;
%mend _contents_vars;

