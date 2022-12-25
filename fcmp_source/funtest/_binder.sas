function bind_vgrps(vgrps $) $ group = "binder";
  /* Returns list of variable groups */ 
  length grplist $ 5000;
  /* Include all variable groups in `grplist` below.*/
  /* $ sign indicates _character_ variable group */
  grplist = vgrps;
  if vgrps = "?" then grplist = "subhh$ adldiff adlhlp iadldiff iadl"; 
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
   when(1995) dt ="a95e_r";
   when(1996) dt ="h96e_r";
   when(1998) dt ="h98e_r";
   when(2000) dt ="h00e_r";
   otherwise  dt ="h"||yr2||"g_r";
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
  when("adldiff")    vout = "skip_dress skip_other adldiff_dress adldiff_walkr adldiff_bath adldiff_eat adldiff_bed adldiff_toilt";
  when("adlhlp")     vout = "adlhlp_dress adlhlp_walkre adlhlp_walkr adlhlp_bath adlhlp_eat adlhlp_bede adlhlp_bed adlhlp_toilt";
  when("iadldiff")   vout = "iadldiff_meals iadldiff_shop iadldiff_phone iadldiff_meds iadldiff_money";
  when("iadl")       vout = "iadl_meals iadl_shop iadl_phone iadl_meds iadl_money";
  otherwise  ok =0;
 end;
 put "FUN: dispatch_vout(): vgrp =" vgrp ", vout =" vout msg; 
return(vout); /* function dispatch_vout */
endsub;      

function dispatch_vin(studyyr, vgrp $) $ group ="binder";

/* Based on `studyyr` and `vgrp` returns list of input variables */
 length vin $2000;
 length _vgrp $2000;
 length msg2 $25;
 _vgrp = lowcase(vgrp);
 
 /* Check studyyr, vgrp arguments */
  msg2 = yrvgrp_ok(studyyr, vgrp);
  select(_vgrp);
   when("subhh$")     vin = subhh_vin(studyyr);
   when("adldiff")    vin = adldiff_vin(studyyr);
   when("adlhlp")     vin = adlhlp_vin(studyyr);
   when("iadldiff")   vin = iadldiff_vin(studyyr);
   when("iadl")       vin = iadl_vin(studyyr);
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
  when("adldiff")  call adldiff_sub(studyyr, cout, cin);
  when("adlhlp")   call adlhlp_sub(studyyr, cout, cin);
  when("iadldiff") call iadldiff_sub(sutdyyr, cout, cin);
  when("iadl")     call iadl_sub(sutdyyr, cout, cin);
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
 return(cout); /* function exec_vgrpc */
endsub; 


 
