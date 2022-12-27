%macro populate_adldiff_array;

cout[1] = skip_dress; /*skip pattern for adldiff_dress*/
cout[2] = skip_other; /*skip pattern for adldiff_walkr, adldiff_bath, adldiff_eat, adldiff_bed, adldiff_toilt*/

cout[3] = adldiff_dress;
cout[4] = adldiff_walkr; 
cout[5] = adldiff_bath; 
cout[6] = adldiff_eat;
cout[7] = adldiff_bed; 
cout[8] = adldiff_toilt;
 
%mend populate_adldiff_array;

/* ====== adl variables for all years =====*/
subroutine adldiff_9596(studyyr, cout[*], cin[*]) group ="adldiff";
 outargs cout;

   if cin[1] =. then skip_dress =.M;
   else if cin[2] = 5 then skip_dress = 1;
   else skip_dress = 0;

   if cin[1] in (.,-8) then skip_other =.M;
   else if cin[2] = 5 then skip_other = 1;
   else skip_other = 0;

   adldiff_dress    = ADL_fun(studyyr, skip_dress, cin[3]);
   adldiff_walkr    = ADL_fun(studyyr, skip_other, cin[4]);
   adldiff_bath     = ADL_fun(studyyr, skip_other, cin[5]);
   adldiff_eat      = ADL_fun(studyyr, skip_other, cin[6]);
   adldiff_bed      = ADL_fun(studyyr, skip_other, cin[7]);
   adldiff_toilt    = ADL_fun(studyyr, skip_other, cin[8]);

   %populate_adldiff_array; /* Populate cout array */
 
endsub; /*  adldiff_9596 */

subroutine adldiff_9800(studyyr, cout[*], cin[*]) group ="adldiff";
 outargs cout;
 
   ADLCK = cin[1] + cin[2] + cin[3] + cin[4] + cin[5] + cin[6] + cin[7] + cin[8] + cin[9] + cin[10];
   if cin[1] =. then skip_dress =.M;
   else if ADLCK =0 then skip_dress = 1;
   else skip_dress = 0;

   if cin[1] =. then skip_other =.M;
   else if ADLCK =0 or (ADLCK =1 & cin[11] =5) then skip_other = 1;
   else skip_other = 0;

   adldiff_dress    = ADL_fun(studyyr, skip_dress, cin[11]);
   adldiff_walkr    = ADL_fun(studyyr, skip_other, cin[12]);
   adldiff_bath     = ADL_fun(studyyr, skip_other, cin[13]);
   adldiff_eat      = ADL_fun(studyyr, skip_other, cin[14]);
   adldiff_bed      = ADL_fun(studyyr, skip_other, cin[15]);
   adldiff_toilt    = ADL_fun(studyyr, skip_other, cin[16]);

   %populate_adldiff_array; /* Populate cout array */
 
endsub; /*  adldiff_9800 */


subroutine adldiff_02_xx(studyyr, cout[*], cin[*]) group ="adldiff";
 outargs cout;

   if cin[1] in (.,-8) then skip_dress =.M;
   else if cin[2] = 0 then skip_dress = 1;
   else skip_dress = 0;

   if cin[1] in (.,-8) then skip_other =.M;
   else if cin[2] = 0 or (cin[2] = 1 and cin[3] = 5) then skip_other = 1;
   else skip_other = 0;

   adldiff_dress    = ADL_fun(studyyr, skip_dress, cin[3]);
   adldiff_walkr    = ADL_fun(studyyr, skip_other, cin[4]);
   adldiff_bath     = ADL_fun(studyyr, skip_other, cin[5]);
   adldiff_eat      = ADL_fun(studyyr, skip_other, cin[6]);
   adldiff_bed      = ADL_fun(studyyr, skip_other, cin[7]);
   adldiff_toilt    = ADL_fun(studyyr, skip_other, cin[8]);

   %populate_adldiff_array; /* Populate cout array */
 
endsub; /* subroutine adldiff_yrs */

subroutine adldiff_sub(studyyr, cout[*], cin[*]) group ="adldiff";
 outargs cout;

 select(studyyr);
   when (1995,1996)      call adldiff_9596(studyyr, cout, cin);
   when (1998,2000)      call adldiff_9800(studyyr, cout, cin);
   otherwise             call adldiff_02_xx(studyyr, cout, cin);
 end;
endsub; /*subroutine adldiff_sub */

function adldiff_vin(studyyr) $ group ="adldiff";

 length vin $2000;
 length cx $1;
 clist = upcase("hjklmnopqrstuvwxyz");
 length _tmpc $200; 
 _tmpc = "@G012 @G013 @G014 @G016 @G021 @G023 @G025 @G030";

 select (studyyr);            
   when (1995) vin = "D1867 D1870 D1884 D1871 D1894 D1904 D1914 D1927";      
   when (1996) vin = "E1891 E1894 E1908 E1895 E1918 E1928 E1938 E1951";      
   when (1998) vin = "F2424_1 F2424_2 F2424_3 F2424_4 F2424_5 F2424_6 F2424_7 F2424_8 F2424_9 F2424_10 F2425 F2427 F2444 F2454 F2464 F2477"; 
   when (2000) vin = "G2722_1 G2722_2 G2722_3 G2722_4 G2722_5 G2722_6 G2722_7 G2722_8 G2722_9 G2722_10 G2723 G2725 G2742 G2752 G2762 G2775";
   otherwise 
     do; 
       wv = (studyyr - 2000)/2;
       cx = substr(clist,wv,1);
       vin = translate(_tmpc, cx, "@");
     end;
 end;
 put "FUN adldiff_vin(): studyyr=" studyyr ", vin=" vin;

 return(vin);
endsub; /* function adldiff_vin */
