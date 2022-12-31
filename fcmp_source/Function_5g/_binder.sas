function hrs_project_info(item $) $ group = "binder";
/*-- Includes the name of FCMP member and date */
 length tx  $20;
 length res $200; 
 tx = lowcase(item);
 select(tx);
    when ("label")        res= "ADL/IADL function";
    when ("fcmp_member")  res= "Function_5g";
    when ("version_date") res= "29Dec2022";
    when ("datestamp")    res= put("&sysdate9"d, DATE9.);
  otherwise res= "hrs_project_info items: label fcmp_member version_date datestamp"; 
  end;
return (res);
endsub;

function bind_vgrps(select_vgrps $) $ group = "binder";
  /* Changed Dec. 25, 2022 */
  /* Returns list of variable groups */ 
  length grplist select_vgrps $ 5000;
  /* Include all variable groups in `grplist` below.*/
  /* $ sign indicates _character_ variable group */
  /* Note: One _character_ output variable is allowed per $ group */  
  grplist = select_vgrps;
  if select_vgrps = "?" then           /* Use ?  for all vgroups */
      grplist = "subhh$ adldiff adlhlp iadldiff iadl"; 
  return(grplist);
endsub; 


function dispatch_datain(studyyr) $ group ="binder";
 put "FUN dispatch_datain(): studyr :=" studyyr;
 length dt $32;
 length yr2 $2;
 length yearc $4;
 yearc = put(studyyr, 4.);  /* From numeric to character */
 yr2  = substr(yearc,3,2);

 select(studyyr);
   when(1992, 1993, 1994) dt = "";  /* ?? */
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
 
 select(_vgrp);
  when("subhh$")     vout = "subhh";
  when("adldiff")    vout = "skip_dress skip_other adldiff_dress adldiff_walkr adldiff_bath adldiff_eat adldiff_bed adldiff_toilt";
  when("adlhlp")     vout = "adlhlp_dress adlhlp_walkre adlhlp_walkr adlhlp_bath adlhlp_eat adlhlp_bede adlhlp_bed adlhlp_toilt";
  when("iadldiff")   vout = "iadldiff_meals iadldiff_shop iadldiff_phone iadldiff_meds iadldiff_money";
  when("iadl")       vout = "iadl_meals iadl_shop iadl_phone iadl_meds iadl_money";
  otherwise; 
 end; 
return(vout);
endsub;

function vout_label(vout $) $  group = "binder";  /* added Dec. 2022 */
/* Returns label for vout  variable */
length v $32;
length tmpc lbl $255;
v = lowcase(vout);
tmpc = "-- Variable: " || trim(v); 
select(v);
  when("subhh") lbl = "SUB-HOUSEHOLD IDENTIFIER";
  otherwise lbl =tmpc;
end;
return(lbl);
endsub;

function vout_length(vout $)  group = "binder";  /* added Dec. 2022 */
/* Returns length for vout  variable */
/* It is mandatory to provide length for character variables */
length v $32;
length tmpc len $10;
v = lowcase(vout); 
select(v);
  when("subhh") len = 1;
  otherwise;
end;
return(len);
endsub;


function dispatch_vin(studyyr, vgrp $) $ group ="binder";

/* Based on `studyyr` and `vgrp` returns list of input variables */
 length vin $2000;
 length _vgrp $2000;
 _vgrp = lowcase(vgrp);
  select(_vgrp);
   when("subhh$")     vin = subhh_vin(studyyr);
   when("adldiff")    vin = adldiff_vin(studyyr);
   when("adlhlp")     vin = adlhlp_vin(studyyr);
   when("iadldiff")   vin = iadldiff_vin(studyyr);
   when("iadl")       vin = iadl_vin(studyyr);
   otherwise;
  end;
return(vin);
endsub;   

subroutine exec_vgrpx(studyyr, vgrp $, cout[*], cin[*]) group ="binder";
/* Used for _numeric_  variable groups only */ 
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

 length _vgrpc $50;
 _vgrpc = lowcase(vgrp);

 select(_vgrpc);
  when("subhh$")  cout = subhh_cfun(cin);      /* Character value */
  otherwise;
 end;
 return(cout);
endsub; /* function exec_vgrpc */


 
