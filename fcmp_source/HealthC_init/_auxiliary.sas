function HQ_fun(studyyr, var_old) group ="aux"; 
/* Auxiliary function */
  var_new = var_old;
  select (var_old);
    when (1) var_new = 1;       /*Yes*/
    when (5) var_new = 0;       /*No*/
    when (7) var_new =.O;       /*Other. ATG: May be .X would be better to distinguish from zero*/
    when (8,98) var_new =.D;    /*Don't Know; DK*/
    when (9,99) var_new =.R;    /*Refused; RF*/
    otherwise;
  end;
  if studyyr in (1995, 1996, 1998) and var_old = 3 then var_new = 5;   /*Disp prev record (DK if cond)*/
  if studyyr = 1994 and var_old = 0 then var_new =.I;                  /*Inap.*/
  return(var_new);
 endsub; /* end function HQ_fun */

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
 vgrps = bind_vgrps("?");
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

