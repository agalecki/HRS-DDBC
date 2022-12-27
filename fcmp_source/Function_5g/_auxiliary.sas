function ADL_fun(studyyr, skip, var_old) group ="aux"; 

 var_new = var_old;
   if skip =.M & var_old =. then var_new =.S;
   else if skip = 1 or var_old = 5 then var_new =0;
   else if var_old in (.,97,-8) then var_new =.M;
   else if var_old in (8,98) then var_new =.D;    
   else if var_old in (9,99) then var_new =.R;

  return(var_new);
 endsub; /* end function ADL_fun */

function IADL_fun(studyyr, var_old, var_why) group ="aux"; 

 var_new = var_old;
   if var_old in (.,-8) then var_new =.S;
   else if var_old = 5 then var_new =0;
   else if var_old = 1 then var_new =1;
   else if (var_old = 6 and var_why ne 5) or (var_old = 7 and var_why = 1) then var_new = 6;
   else if (var_old = 6 and var_why = 5) or (var_old = 7 and var_why ne 1) then var_new = 7;
   else if var_old in (97) then var_new =.M;
   else if var_old in (8,98) then var_new =.D;    
   else if var_old in (9,99) then var_new =.R;

  return(var_new);
 endsub; /* end function IADL_fun */

function IADLs_fun(studyyr, var_old, var_why) group ="aux"; 

 var_new = var_old;
   if var_old in (.,-8) then var_new =.S;
   else if var_old = 5 then var_new =0;
   else if var_old = 1 then var_new =1;
   else if (var_old = 6 and var_why ne 5) or (var_old = 7 and var_why = 1) then var_new = 1;
   else if (var_old = 6 and var_why = 5) or (var_old = 7 and var_why ne 1) then var_new = 7;
   else if var_old in (97) then var_new =.M;
   else if var_old in (8,98) then var_new =.D;    
   else if var_old in (9,99) then var_new =.R;

  return(var_new);
 endsub; /* end function IADL_fun */

function studyyr_ok(yr) $ group ="aux";
 ok  = 1;
 select;
   when(yr = .)    ok =0;
   when(yr < 1992) ok =0;
   when(yr > 1996 and mod(yr,2)=1) ok =0;
   when(yr > 2030) ok = 0;
   otherwise;
 end;
 length msg $15;
 
 if ok =1 then msg = "... OK"; else msg = ".... year??";
 
 return(msg);
endsub; /* function studyyr_ok */

function vgrp_ok(vgrp $) $ group = "aux";
 length vgrps $ 5000;
 length word $ 50;
 vgrps = bind_vgrps("?");  /* Dec. 25th, 2022 */
 ngrps = countw(vgrps, " ");
 ok  = 0;
 
 do i =1 to ngrps;
   word = scan(strip(vgrps), i, " ");
   **put word =;
   **put vgrp =;
   if ok = 0 and word = vgrp then ok =1;
 end;
 length msg $15;
 if ok =1 then msg = "... OK"; else msg = "... vgrp??";
 
 return(msg);
endsub; /* function vgrp_ok */

function yrvgrp_ok(yr, vgrp $) $ group = "aux";
 length msg1 msg2 msg $50;
 msg1 = studyyr_ok(yr);
 msg2 = vgrp_ok(vgrp);
 msg  = "... OK";
 if findc(msg1,"?") or findc(msg2,"?") then msg = msg1 || msg2;
  return(msg);
endsub; /* function yrvgrp_ok */

