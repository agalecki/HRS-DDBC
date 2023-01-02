function fcmp_member_info(item $) $ group = "binder";
/*-- Povides info on FCMP member */
 length tx  $20;
 length res $200; 
 tx = lowcase(item);
 select(tx);
    when ("label")        res= "ADL/IADL function with 7 var groups";
    when ("fcmp_member")  res= "test7_DLFunction";
    when ("version_date") res= "30Dec2022";
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
  grplist = select_vgrps;
  if select_vgrps = "?" then grplist = "subhh$ skip adldiff adlhlp equip iadldiff iadlhlp why"; 
  return(grplist);
endsub; 


function dispatch_datain(studyyr) $ group ="binder";
 length dt $32;
 length yr2 $2;
 length yearc $4;
 yearc = put(studyyr, 4.);  /* From numeric to character */
 yr2  = substr(yearc,3,2);

 select(studyyr);
   when(1992) dt ="health";
   when(1993) dt ="BR21";
   when(1994) dt ="w2b";
   when(1995) dt ="a95e_r";
   when(1996) dt ="h96e_r";
   when(1998) dt ="h98e_r";
   when(2000) dt ="h00e_r";
   otherwise  dt ="h"||yr2||"g_r";
 end;  
 if studyyr_ok(studyyr) = 0 then dt = "";
return(dt);
endsub; /* function dispatch_datain */

function dispatch_vout(vgrp $) $ group ="binder";
/* Based on `vgrp` returns list of output variables */
 length vout $500;
 length _vgrp $500;
 _vgrp = lowcase(vgrp);
 select(_vgrp);
  when("subhh$")     vout = "subhh";
  when("skip")       vout = "skip";
  when("adldiff")    vout = "adldiff_dress adldiff_walk adldiff_bath adldiff_eat adldiff_bed adldiff_toilt";
  when("adlhlp")     vout = "adlhlp_dress adlhlp_walk adlhlp_bath adlhlp_eat adlhlp_bed adlhlp_toilt";
  when("equip")      vout = "equip_walk equip_bed";
  when("iadldiff")   vout = "iadldiff_meals iadldiff_shop iadldiff_phone iadldiff_meds iadldiff_money";
  when("iadlhlp")    vout = "iadlhlp_meals iadlhlp_shop iadlhlp_phone iadlhlp_meds iadlhlp_money";
  when("why")        vout = "why_meals why_shop why_phone why_meds why_money";
  otherwise;
 end;
return(vout);
endsub;      /* function dispatch_vout */

function vout_label(vout $) $ group="binder";  /* added Dec. 2022 */
/* Returns label for vout  variables */
length v $32;
length tmpc lbl $255;
v = lowcase(vout);
tmpc = "--Variable " || strip(v); 
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
 length vin $500;
 length _vgrp $500;
 _vgrp = lowcase(vgrp);
 
   select(_vgrp);
   when("subhh$")     vin = subhh_vin(studyyr);
   when("skip")       vin = skip_vin(studyyr);
   when("adldiff")    vin = adldiff_vin(studyyr);
   when("adlhlp")     vin = adlhlp_vin(studyyr);
   when("equip")      vin = equip_vin(studyyr);
   when("iadldiff")   vin = iadldiff_vin(studyyr);
   when("iadlhlp")    vin = iadlhlp_vin(studyyr);
   when("why")        vin = why_vin(studyyr);
   otherwise;
  end;
return(vin);
endsub;  


subroutine exec_vgrpx(studyyr, vgrp $, cout[*], cin[*]) group ="binder";
/* Used for _numeric_  variable groups only */ 
 
 /* Check studyyr, vgrp arguments */
   outargs cout;
 length _vgrpx $50;
 _vgrpx = lowcase(vgrp);
 select(_vgrpx);
  when("skip")        call skip_sub(studyyr, cout, cin);
  when("adldiff")     call adldiff_sub(studyyr, cout, cin);
  when("adlhlp")      call adlhlp_sub(studyyr, cout, cin);
  when("equip")       call equip_sub(studyyr, cout, cin);
  when("iadldiff")    call iadldiff_sub(studyyr, cout, cin);
  when("iadlhlp")     call iadlhlp_sub(studyyr, cout, cin);
  when("why")         call why_sub(studyyr, cout, cin);
  otherwise;
 end;
endsub; /* subroutine exec_vgrpx */;

function exec_vgrpc(studyyr, vgrp $, cin[*] $) $ group ="binder";
/* Used for _character_  variable groups only */ 
 
 length _vgrpc $50;
 _vgrpc = lowcase(vgrp);
 select(_vgrpc);
  when("subhh$")  cout = subhh_cfun(cin);      /* Character value */;
  otherwise;
 end;
 return(cout);
endsub; /* function exec_vgrpc */


 
