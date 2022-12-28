%macro array_stmnt2(year, vgrp, vout, vin);
%local i vin_cnt vgrpnm grp_type vin2;
/* call this macro from inside DATA step */
%let vgrpnm = %sysfunc(compress(&vgrp,'$'));
%let grp_type =  %sysfunc(findc(&vgrp,'$'));
%let ctype = $;
%if %eval(&grp_type) =0 %then %let ctype =;
%put ==>: year :=&year, var_grp := &vgrp, ctype := &ctype;
%put var_in := &vin;
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
      &vout = exec_vgrpc(&year, "&vgrp", &vgrpnm._vin);
  %end;
%else
  %do;  
      %*put --- &vgrp (numeric) processed ---- ;
       array &vgrpnm._vout {&vout_cnt} &vout;
       call exec_vgrpx(&year, "&vgrp", &vgrpnm._vout, &vgrpnm._vin);  
  %end;

%mend array_stmnt2; 

%macro all_vin2nodupkey ;
options nosource nonotes nomprint;
/* Remove duplicates from `all_vin2` macro variable */
data _all_vin2;
 length  all_vin2 $ 5000;
 all_vin2 = symget("all_vin2");
 count_w = countw(all_vin2);
 do i =1 to count_w;
   vin = scan(all_vin2, i, ' ');
   vin = upcase(vin);
   output;
 end;
 keep i vin; 
run;

proc sort data =_all_vin2 nodupkey;
 by vin;
run;

proc sort data =_all_vin2;
by i;
run;

data null;
 set _all_vin2 end = last;
 length all_vin2s $2000;
 retain all_vin2s;
 all_vin2s = strip(all_vin2s) || " " || strip(vin);
 if last then call symput("all_vin2s", all_vin2s);
run;
options source notes mprint;
%mend all_vin2nodupkey;

