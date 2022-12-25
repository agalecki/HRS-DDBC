%macro populate_iadldiff_array;

cout[1] = iadldiff_meals;
cout[2] = iadldiff_shop; 
cout[3] = iadldiff_phone; 
cout[4] = iadldiff_meds;
cout[5] = iadldiff_money; 
 
%mend populate_iadldiff_array;

/* ====== iadldiff variables for all years =====*/
subroutine iadldiff_95_xx(studyyr, cout[*], cin[*]) group ="iadldiff";
 outargs cout;
    
   iadldiff_meals    = IADL_fun(studyyr, cin[1], cin[2]);
   iadldiff_shop     = IADL_fun(studyyr, cin[3], cin[4]);
   iadldiff_phone    = IADL_fun(studyyr, cin[5], cin[6]);
   iadldiff_meds     = IADL_fun(studyyr, cin[7], cin[8]);
   iadldiff_money    = IADL_fun(studyyr, cin[9], cin[10]);
   %populate_iadldiff_array; /* Populate cout array */
 
endsub; /* subroutine iadldiff_yrs */

subroutine iadldiff_sub(studyyr, cout[*], cin[*]) group ="iadldiff";
 outargs cout;

 call iadldiff_95_xx(studyyr, cout, cin);

endsub; /*subroutine iadldiff_sub */

function iadldiff_vin(studyyr) $ group ="iadldiff";

 length vin $500;
 length cx $1;
 clist = upcase("hjklmnopqrstuvwxyz");
 length _tmpc $200; 
 _tmpc = "@G041 @G042 @G044 @G045 @G047 @G048 @G050 @G052 @G059 @G060";
    
 select (studyyr);                 
   when (1995) vin = "D2021 D2023 D2026 D2028 D2031 D2033 D2036 D2038 D2099 D2100";     
   when (1996) vin = "E2036 E2038 E2041 E2043 E2046 E2048 E2051 E2053 E2093 E2094 ";         
   when (1998) vin = "F2562 F2564 F2567 F2569 F2572 F2574 F2577 F2579 F2618 F2619";     
   when (2000) vin = "G2860 G2862 G2865 G2867 G2870 G2872 G2875 G2877 G2916 G2917";  
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
