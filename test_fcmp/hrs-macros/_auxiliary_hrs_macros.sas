%macro expand_years(years);

data _temp1_init;
 length years $ 100;
 length year_sel $1;
 years = "&years";
 year_sel = "Y";
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
 %sysevalf(%superq(param)=,boolean)
%mend isBlank;
