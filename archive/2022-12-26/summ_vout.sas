%macro summ_vout(cmplib);
options cmplib =_cmplib.&cmplib;

%let all_vgrps =; 
%let nvgrps =;
%let all_vout=;


data _dtinfo_;
 length all_vgrps $ 1000; 
 length vgrp  $32;
 length vout $1000;
 length all_vout $5000;
 retain all_vout;
 all_vgrps = bind_vgrps();      /* List of var groups. Ex: subhh$ skip adldiff ...*/
 nvgrps  = countw(all_vgrps);   /* Number of var groups */
 /* List of var groups sep by | . Ex: subhh$ | skip | adldiff ...*/
 all_vgrps = translate(strip(all_vgrps),"|", " ");
 do i =1 to nvgrps;
   vgrp = scan(all_vgrps, i, '|');   /*  Var group name */
   vout= dispatch_vout(vgrp);        /* output vars for a given var group*/
   *all_vout = strip(all_vout)|| strip(vout)|| "|"; 
   output;
 end;
 *call symput("all_vgrps", strip(all_vgrps));
 *call symput("nvgrps", strip(nvgrps));
 *call symput("all_vout", strip(all_vout));
run;

%*put all_vgrps :=&all_vgrps; 
%*put nvgrps    :=&nvgrps;

%*put all_vout  :=&all_vout;
proc print data=_dtinfo_;
run;


%mend summ_vout;
