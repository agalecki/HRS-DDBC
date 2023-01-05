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
 endsub;
 
function studyyr_ok(yr) group ="aux";
 ok  = 1;
 select;
   when(yr = .)    ok =0;
   when(yr < 1992) ok =0;
   when(yr > 1996 and mod(yr,2)=1) ok =0;
   when(yr > 2030) ok = 0;
   otherwise;
 end;
 return(ok); /* function studyyr_ok */
endsub; 

function data_exist(ref $) group = "aux";
 rc = exist(ref);
 if (ref = "") then rc=0;
 return(rc);
endsub;


