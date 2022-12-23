%macro process_1yr (year);

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
 all_vgrps = bind_vgrps();
 nvgrps  = countw(all_vgrps);
 all_vgrps = translate(strip(all_vgrps),"|", " ");
 datain  = dispatch_datain(&year);
 do i =1 to nvgrps;
   vgrp = scan(all_vgrps, i, '|'); /*  Variable group name */
   vin = dispatch_vin(&year, vgrp);
   vout= dispatch_vout(vgrp);
   all_vin = strip(all_vin)  || strip(vin) || "|"; 
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

data _out&year; 
  set libin.&datain(keep = pn hhid &all_vin2);
  missing O D R I N;
  studyyr =&year;
  %do i=1 %to &nvgrps;
   %let vgrp = %scan(&all_vgrps,&i, "|");
   %let vin  = %scan(&all_vin, &i,  "|");
   %let vout  = %scan(&all_vout, &i,  "|");
   %put --- Group `&vgrp` processed ---;
   %array_stmnt(&year, &vgrp, &vout, &vin);
%end;
  drop &all_vin2;
run;

*Title "Year &year(DATA=&datain) processed for &nvgrps groups of variables (obs=30)";
*proc print data=_out&year (obs=30);
*run;

%mend process_1yr;
