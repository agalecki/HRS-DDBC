%macro summary_cmplib (cmplib, year);
options cmplib =_cmplib.&cmplib;

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
 all_vgrps = bind_vgrps();      /* List of var groups. Ex: subhh$ skip adldiff ...*/
 nvgrps  = countw(all_vgrps);   /* Number of var groups */
 /* List of var groups sep by | . Ex: subhh$ | skip | adldiff ...*/
 all_vgrps = translate(strip(all_vgrps),"|", " ");
 datain  = dispatch_datain(&year);
 do i =1 to nvgrps;
   vgrp = scan(all_vgrps, i, '|');   /*  Var group name */
   vin = dispatch_vin(&year, vgrp);  /* Input vars  for a given year/var group*/ 
   vout= dispatch_vout(vgrp);        /* output vars for a given var group*/
   all_vin = strip(all_vin)  || strip(vin) || "|"; /* list of all input vars grouped by | */
   all_vout = strip(all_vout)|| strip(vout)|| "|"; 
 end;
 all_vin2 =translate(all_vin, " ","|");
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
%mend summary_cmplib;
