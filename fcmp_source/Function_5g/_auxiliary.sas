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
endsub;

