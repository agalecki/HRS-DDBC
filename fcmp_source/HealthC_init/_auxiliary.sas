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

