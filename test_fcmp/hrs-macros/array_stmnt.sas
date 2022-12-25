%macro array_stmnt(year, vgrp, vout, vin);
/* call this macro from inside DATA step */
%let vgrpnm = %sysfunc(compress(&vgrp,'$'));
%let ctype =  %sysfunc(findc(&vgrp,'$'));
%put -- Macro ARRAY_STMNT: year :=&year, vgrp := &vgrp, ctype := &ctype;
%let vin_cnt=%sysfunc(countw(&vin));
%let vout_cnt=%sysfunc(countw(&vout));

%if %eval(&ctype) = 0 %then 
  %do;
    %put --- &vgrp (numeric) processed ---- ;
    
     array &vgrpnm._vin {&vin_cnt}  &vin;
     array &vgrpnm._vout {&vout_cnt} &vout;
     call exec_vgrpx(&year, "&vgrp", &vgrpnm._vout, &vgrpnm._vin);
  %end;
%else
  %do;
    %put --- &vgrp (character) processed ---- ;
     array &vgrpnm._vin {&vin_cnt} $ &vin;
     &vout = exec_vgrpc(&year, "&vgrp", &vgrpnm._vin);
  %end;

%mend array_stmnt; 