%macro populate_adldiff_array;

cout[1] = adldiff_dress;
cout[2] = adldiff_walk; 
cout[3] = adldiff_bath; 
cout[4] = adldiff_eat;
cout[5] = adldiff_bed; 
cout[6] = adldiff_toilt;
 
%mend populate_adldiff_array;

/* ====== adldiff variables for all years =====*/

subroutine adldiff_9294(studyyr, cout[*], cin[*]) group ="adldiff";
 /* --- List of input variables stored in cin[*] array (for year 1992)
   (1992) data = health, cin{*] = "V337 V341 XXX XXX XXX";
 */
 outargs cout;
   
   adldiff_dress  = FQ_fun(studyyr, cin[1]);
   adldiff_walk   = FQ_fun(studyyr, cin[2]);
   adldiff_bath   = FQ_fun(studyyr, cin[3]);
   adldiff_eat    = FQ_fun(studyyr, cin[4]);
   adldiff_bed    = FQ_fun(studyyr, cin[5]);
   adldiff_toilt  =.N;
   %populate_adldiff_array;

endsub; /*  adldiff_92 */

subroutine adldiff_93(cout[*], cin[*]) group ="adldiff";
 outargs cout;
   
   adldiff_dress  = FQ_fun(1993, cin[1]);
   adldiff_walk   = FQ_fun(1993, cin[2]);
   adldiff_bath   = FQ_fun(1993, cin[3]);
   adldiff_eat    = FQ_fun(1993, cin[4]);
   adldiff_bed    = FQ_fun(1993, cin[5]);
   adldiff_toilt  = FQ_fun(1993, cin[6]);
   if cin[1] =. then adldiff_dress = 7;
   if cin[2] =. then adldiff_walk = 7;
   if cin[3] =. then adldiff_bath = 7;
   if cin[4] =. then adldiff_eat = 7;
   if cin[5] =. then adldiff_bed = 7;
   if cin[6] =. then adldiff_toilt = 7;
   %populate_adldiff_array;

endsub; /*  adldiff_93 */

subroutine adldiff_95_xx(studyyr, cout[*], cin[*]) group ="adldiff";
 outargs cout;
    
   adldiff_dress    = FQ_fun(studyyr, cin[1]);
   adldiff_walk     = FQ_fun(studyyr, cin[2]);
   adldiff_bath     = FQ_fun(studyyr, cin[3]);
   adldiff_eat      = FQ_fun(studyyr, cin[4]);
   adldiff_bed      = FQ_fun(studyyr, cin[5]);
   adldiff_toilt    = FQ_fun(studyyr, cin[6]);
   %populate_adldiff_array; /* Populate cout array */
 
endsub; /* subroutine adldiff_yrs */

subroutine adldiff_sub(studyyr, cout[*], cin[*]) group ="adldiff";
 outargs cout;

 select(studyyr);
   when (1992,1994) call adldiff_9294(studyyr, cout, cin);
   when (1993) call adldiff_93(cout, cin);
   otherwise  call adldiff_95_xx(studyyr, cout, cin);
 end;
endsub; /*subroutine adldiff_sub */

function adldiff_vin(studyyr) $ group ="adldiff";

 length vin $500;
 length cx $1;
 clist = upcase("hjklmnopqrstuvwxyz");
 length _tmpc $200; 
 _tmpc = "@G014 @G016 @G021 @G023 @G025 @G030";

 select (studyyr);
   when (1992) vin = "V320 V307 V316 V319 V310";                     
   when (1993) vin = "V781 V773 V789 V797 V811 V816";     
   when (1994) vin = "W322 W309 W318 W321 W312";                    
   when (1995) vin = "D1884 D1871 D1894 D1904 D1914 D1927";      
   when (1996) vin = "E1908 E1895 E1918 E1928 E1938 E1951";      
   when (1998) vin = "F2425 F2427 F2444 F2454 F2464 F2477"; 
   when (2000) vin = "G2723 G2725 G2742 G2752 G2762 G2775";
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
