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


%macro cum_var(data, cvar);
/* Cumulate cvar strings and store in `_tmpc` macro variable */ 
/* Mvar `_tmpc` needs to be set  */
data _null_;
 set &data (keep=&cvar) end = last;
 length _tmpc $5000;
 retain _tmpc;
 _tmpc = strip(_tmpc) || " " || strip(&cvar); 
 if last then call symput("_tmpc", strip(_tmpc)); 
run;
%mend cum_var;
