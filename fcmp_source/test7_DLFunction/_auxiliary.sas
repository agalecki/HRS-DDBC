function FQ_fun(studyyr, var_old) group ="aux"; 
/* Auxiliary function */
  var_new = var_old;
  /*0.Not at all difficult; No*/
  /*1.Yes*/
  /*2.Yes,A little difficult*/
  /*3.Yes,Somewhat difficult*/
  /*4.Yes,A lot difficult*/
  /*6.Can't Do; Very difficult/can't do*/
  /*7.Don't Do*/
  /*8.Yes,DK/NA how much*/
  /*9.Yes,RF how much*/
  /*.O,.D,.R*/
  if studyyr = 1992 then do;
    select (var_old);
	  when (1) var_new = 0;                
	  when (4) var_new = 6;                
      when (6) var_new = 7; 
	end;
  end;  
  if studyyr = 1994 then do;
    select (var_old);
      when (1) var_new = 2;                
      when (2) var_new = 4;                
      when (3) var_new = 8;                
	  when (4) var_new = 9;                
	  when (5) var_new = 0;
	  when (6) var_new = 7;                
	  when (8) var_new =.D;
	  when (9) var_new =.R;
	  when (0) var_new =.;
	  otherwise;
	end;
  end;
  if studyyr not in (1992, 1994) then do;
  select (var_old);
    when (1) var_new = 1;       
    when (5) var_new = 0;       
	when (97) var_new =.O;      
    when (8,98) var_new =.D;    
    when (9,99) var_new =.R;    
    otherwise;
  end;
  end;
  return(var_new);
 endsub; /* end function FQ_fun */
 
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

