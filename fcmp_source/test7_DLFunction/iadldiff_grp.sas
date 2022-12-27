%macro populate_iadldiff_array;

cout[1] = iadldiff_meals;
cout[2] = iadldiff_shop; 
cout[3] = iadldiff_phone; 
cout[4] = iadldiff_meds;
cout[5] = iadldiff_money; 
 
%mend populate_iadldiff_array;

/* ====== iadldiff variables for all years =====*/

subroutine iadldiff_92(cout[*], cin[*]) group ="iadldiff";
 outargs cout;
   
   iadldiff_meals  =.N;
   iadldiff_shop   =.N;
   iadldiff_phone  =.N;
   iadldiff_meds   =.N;
   iadldiff_money  =.N;
   %populate_iadldiff_array;

endsub; /*  iadldiff_92 */

subroutine iadldiff_93(cout[*], cin[*]) group ="iadldiff";
 outargs cout;
   
   iadldiff_meals  =.N;
   iadldiff_shop   =.N;
   iadldiff_phone  =.N;
   iadldiff_meds   =.N;
   iadldiff_money  = FQ_fun(studyyr, cin[1]);
   %populate_iadldiff_array;

endsub; /*  iadldiff_93 */

subroutine iadldiff_94(cout[*], cin[*]) group ="iadldiff";
 outargs cout;
   
   iadldiff_meals  =.N;
   iadldiff_shop   =.N;
   iadldiff_phone  = FQ_fun(studyyr, cin[1]);
   iadldiff_meds   = FQ_fun(studyyr, cin[2]);
   iadldiff_money  = FQ_fun(studyyr, cin[3]);
   %populate_iadldiff_array;

endsub; /*  iadldiff_94 */

subroutine iadldiff_95_xx(studyyr, cout[*], cin[*]) group ="iadldiff";
 outargs cout;
    
   iadldiff_meals    = FQ_fun(studyyr, cin[1]);
   iadldiff_shop     = FQ_fun(studyyr, cin[2]);
   iadldiff_phone    = FQ_fun(studyyr, cin[3]);
   iadldiff_meds     = FQ_fun(studyyr, cin[4]);
   iadldiff_money    = FQ_fun(studyyr, cin[5]);
   %populate_iadldiff_array; /* Populate cout array */
 
endsub; /* subroutine iadldiff_yrs */

subroutine iadldiff_sub(studyyr, cout[*], cin[*]) group ="iadldiff";
 outargs cout;

 select(studyyr);
   when (1992)      call iadldiff_92(cout, cin);
   when (1993)      call iadldiff_93(cout, cin);  
   when (1994)      call iadldiff_94(cout, cin); 
   otherwise        call iadldiff_95_xx(studyyr, cout, cin);
 end;
endsub; /*subroutine iadldiff_sub */

function iadldiff_vin(studyyr) $ group ="iadldiff";

 length vin $500;
 length cx $1;
 clist = upcase("hjklmnopqrstuvwxyz");
 length _tmpc $200; 
 _tmpc = "@G041 @G044 @G047 @G050 @G059";

 select (studyyr);
   when (1992) vin = "";     /*NA V328*/                
   when (1993) vin = "V972";    
   when (1994) vin = "W326 W327 W325";                    
   when (1995) vin = "D2021 D2026 D2031 D2036 D2099";      
   when (1996) vin = "E2036 E2041 E2046 E2051 E2093";      
   when (1998) vin = "F2562 F2567 F2572 F2577 F2618"; 
   when (2000) vin = "G2860 G2865 G2870 G2875 G2916";
   otherwise 
     do; 
       wv = (studyyr - 2000)/2;
       cx = substr(clist,wv,1);
       vin = translate(_tmpc, cx, "@");
     end;
 end;
 put "FUN iadldiff_vin(): studyyr=" studyyr ", vin=" vin;

 return(vin);
endsub; /* function iadldiff_vin */
