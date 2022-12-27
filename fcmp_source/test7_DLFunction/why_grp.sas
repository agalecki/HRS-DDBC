%macro populate_why_array;

cout[1] = why_meals;
cout[2] = why_shop; 
cout[3] = why_phone; 
cout[4] = why_meds;
cout[5] = why_money; 
 
%mend populate_why_array;

/* ====== why variables for all years =====*/

subroutine why_92_94(cout[*], cin[*]) group ="why";
 /* --- List of input variables stored in cin[*] array (for year 1992)
   (1992) data = health, cin{*] = "V337 V341 XXX XXX XXX";
 */
 outargs cout;
   
   why_meals  =.N;
   why_shop   =.N;
   why_phone  =.N;
   why_meds   =.N;
   why_money  =.N;
   %populate_why_array;

endsub; /* why_92_94 */

subroutine why_95_xx(cout[*], cin[*]) group ="why";
 outargs cout;
 
 do i = 1 to 5;
   cout[i] = cin[i];
   select(cin[i]);
	 when(5) cout[i] = 0;
	 when(7) cout[i] =.O;     /*7. Other*/
     when(8) cout[i] =.D;
     when(9) cout[i] =.R;
     otherwise;
    end;
 end;
endsub; /* why_95 */

subroutine why_sub(studyyr, cout[*], cin[*]) group ="why";
 outargs cout;

 select(studyyr);
   when (1992,1993,1994) call why_92_94(cout, cin);
   otherwise             call why_95_xx(cout, cin);
 end;
endsub; /*subroutine why_sub */

function why_vin(studyyr) $ group ="why";

 length vin $500;
 length cx $1;
 clist = upcase("hjklmnopqrstuvwxyz");
 length _tmpc $200; 
 _tmpc = "@G042 @G045 @G048 @G052 @G060";

 select (studyyr);
   when (1992) vin = ""; /* NA V303 */                    
   when (1993) vin = ""; /* NA V359 */      
   when (1994) vin = ""; /* NA V303 */                   
   when (1995) vin = "D2023 D2028 D2033 D2038 D2100";      
   when (1996) vin = "E2038 E2043 E2048 E2053 E2094"; 
   when (1998) vin = "F2564 F2569 F2574 F2579 F2619";
   when (2000) vin = "G2862 G2867 G2872 G2877 G2917";
   otherwise 
     do; 
       wv = (studyyr - 2000)/2;
       cx = substr(clist,wv,1);
       vin = translate(_tmpc, cx, "@");
     end;
 end;
 **put "FUN why_vin(): studyyr=" studyyr ", vin=" vin;

 return(vin);
endsub; /* function why_vin */
