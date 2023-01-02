%macro harmonize_1cmpyr (year, bind_vgrps=?, outdata = work.out);
/* Global macro variable `hrs_fcmp` required */
/* Invoke this macro after options cmplib=_cmplib.&hrs_fcmp statement*/
%let all_vgrps =; 
%let nvgrps =;
%let datain =;
%let all_vout=;
%let all_vin=;
%let all_vin2=;

data _null_;
 length all_vgrps $ 1000; 
 length vgrp datain $32;
 length vin vout $1000;
 length all_vin all_vout $5000;
 retain  all_vin all_vout;
 all_vgrps = bind_vgrps("&bind_vgrps");      /* List of var groups. Ex: subhh$ skip adldiff ...*/
 nvgrps  = countw(all_vgrps);   /* Number of var groups */
 
 /* List of var groups sep by | . Ex: subhh$ | skip | adldiff ...*/
 all_vgrps = translate(strip(all_vgrps),"|", " ");
 datain  = dispatch_datain(&year);
 do i =1 to nvgrps;
   vgrp = scan(all_vgrps, i, '|');   /*  Var group name */
   vin = dispatch_vin(&year, vgrp);  /* Input vars  for a given year/var group*/ 
   vout= dispatch_vout(vgrp);        /* output vars for a given var group*/
   if strip(vin) = "" then do;
      if findc(vgrp,"$") > 0 then vin = "_CHARZZZ_"; else vin = "_ZZZ_";
   end;
   all_vin = strip(all_vin)  || strip(vin) || "|"; /* list of all input vars grouped by | */
   all_vout = strip(all_vout)|| strip(vout)|| "|"; 
 end;
 all_vin2 =translate(all_vin, " ","|");
 all_vin2 = tranwrd(all_vin2, "_CHARZZZ_","");
 all_vin2 = strip(tranwrd(all_vin2, "_ZZZ_", ""));

 call symput("all_vgrps", strip(all_vgrps));
 call symput("nvgrps", strip(nvgrps));
 call symput("datain", strip(datain));
 call symput("all_vin", strip(all_vin));
 call symput("all_vin2", strip(all_vin2));
 call symput("all_vout", strip(all_vout));
run;

%put all_vgrps :=&all_vgrps; 
%put nvgrps    :=&nvgrps;
%put datain    :=&datain;
%put all_vin   :=&all_vin;
%put all_vin2  :=&all_vin2;

%put all_vout  :=&all_vout;
%if %length(&datain) =0 %then %return;

%let all_vin2s =;
%all_vin2nodupkey; /* Remove duplicates from `_all_vin2 macro variable */
%put all_vin2s := &all_vin2s;


data &outdata; 
  set hrs_data.&datain(keep = pn hhid &all_vin2s);
  missing O D R I N;
  _CHARZZZ_= ""; /*  Artificial variable */
  _ZZZ_ =.;
  studyyr =&year;
  %do i=1 %to &nvgrps;
   %let vgrp = %scan(&all_vgrps,&i, "|");
   %let vin  = %scan(&all_vin, &i,  "|");
   %let vout  = %scan(&all_vout, &i,  "|");
   %put;
   %put ===>===>  Var group `&vgrp` processed ---;
   %array_stmnt2(&year, &vgrp, &vout, &vin);
%end;
  drop &all_vin2s;
  drop _CHARZZZ_ _ZZZ_;
run;


%mend harmonize_1cmpyr;
