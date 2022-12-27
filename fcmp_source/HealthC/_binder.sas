
function bind_vgrps(select_vgrps $) $ group = "binder";
  /* Changed Dec. 25, 2022 */
  /* Returns list of variable groups */ 
  length grplist select_vgrps $ 5000;
  /* Include all variable groups in `grplist` below.*/
  /* $ sign indicates _character_ variable group */
  grplist = select_vgrps;
  if select_vgrps = "?" then grplist = "subhh$ healthrate cancer"; /* By default all vgroups */
  return(grplist);
endsub; 


function dispatch_datain(studyyr) $ group ="binder";
 length msg $15;
 msg = studyyr_ok(studyyr);
 put "FUN dispatch_datain(): studyr :=" studyyr msg;
 length dt $32;
 length yr2 $2;
 length yearc $4;
 yearc = put(studyyr, 4.);  /* From numeric to character */
 yr2  = substr(yearc,3,2);

 select(studyyr);
   when(1992) dt ="health";
   when(1993) dt ="BR21";
   when(1994) dt ="w2b";
   when(1995) dt ="a95b_r";
   when(1996) dt ="h96b_r";
   when(1998) dt ="h98b_r";
   when(2000) dt ="h00b_r";
   otherwise  dt ="h"||yr2||"c_r";
 end;  
return(dt);
endsub; /* function dispatch_datain */

function dispatch_vout(vgrp $) $ group ="binder";
/* Based on `vgrp` returns list of output variables */
 length vout $500;
 length _vgrp $500;
 _vgrp = lowcase(vgrp);
 length msg $15;
 msg = vgrp_ok(vgrp);
 select(_vgrp);
  when("subhh$")     vout = "subhh";
  when("healthrate") vout = "hlth_rate htn_cont"; 
  when("cancer")     vout = "ca ca_dr ca_tx ca_new ca_yr";
  otherwise  ok =0;
 end;
 put "FUN: dispatch_vout(): vgrp =" vgrp ", vout =" vout msg; 
return(vout);
endsub;      /* function dispatch_vout */

function dispatch_vin(studyyr, vgrp $) $ group ="binder";

/* Based on `studyyr` and `vgrp` returns list of input variables */
 length vin $500;
 length _vgrp $500;
 length msg2 $25;
 _vgrp = lowcase(vgrp);
 
 /* Check studyyr, vgrp arguments */
  msg2 = yrvgrp_ok(studyyr, vgrp);
  select(_vgrp);
   when("subhh$")     vin = subhh_vin(studyyr);
   when("healthrate") vin = healthrate_vin(studyyr); 
   when("cancer")     vin = cancer_vin(studyyr);
   otherwise  ok=0;
  end;
  put "FUN dispatch_vin(): studyyr=" studyyr ", vgrp=" vgrp ", vin =" vin msg2; 
return(vin);
endsub;      /* function dispatch_vin */

subroutine exec_vgrpx(studyyr, vgrp $, cout[*], cin[*]) group ="binder";
/* Used for _numeric_  variable groups only */ 
 
 /* Check studyyr, vgrp arguments */
  length msg2 $50;
  msg2 = yrvgrp_ok(studyyr, vgrp);

 put "- SUB  exec_vgrpx(): studyyr:=" studyyr ", vgrp :=" vgrp  msg2;
 outargs cout;
 length _vgrpx $50;
 _vgrpx = lowcase(vgrp);
 select(_vgrpx);
  when("healthrate") call healthrate_sub(studyyr, cout, cin); 
  when("cancer")     call cancer_sub    (studyyr, cout, cin);
  otherwise;
 end;
endsub; /* subroutine exec_vgrpx */

function exec_vgrpc(studyyr, vgrp $, cin[*] $) $ group ="binder";
/* Used for _character_  variable groups only */ 
 /* Check studyyr, vgrp arguments */
  length msg2 $50;
  msg2 = yrvgrp_ok(studyyr, vgrp);

 put "- FUN exec_vgrpc(): studyyr:=" studyyr ", vgrp :=" vgrp msg2;

 length _vgrpc $50;
 _vgrpc = lowcase(vgrp);
 select(_vgrpc);
  when("subhh$")  cout = subhh_cfun(cin);      /* Character value */
  otherwise;
 end;
 return(cout);
endsub; /* function exec_vgrpc */


 