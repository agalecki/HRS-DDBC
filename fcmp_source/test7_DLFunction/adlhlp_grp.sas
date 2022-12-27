%macro populate_adlhlp_array;

cout[1] = adlhlp_dress;
cout[2] = adlhlp_walk; 
cout[3] = adlhlp_bath; 
cout[4] = adlhlp_eat;
cout[5] = adlhlp_bed; 
cout[6] = adlhlp_toilt;
 
%mend populate_adlhlp_array;

/* ====== adlhlp variables for all years =====*/

subroutine adlhlp_9294(cout[*], cin[*]) group ="adlhlp";
 outargs cout;
   
   adlhlp_dress  =.N;
   adlhlp_walk   =.N;
   adlhlp_bath   =.N;
   adlhlp_eat    =.N;
   adlhlp_bed    =.N;
   adlhlp_toilt  =.N;
   %populate_adlhlp_array;

endsub; /* adlhlp_9294 */

subroutine adlhlp_9596(cout[*], cin[*]) group ="adlhlp";
 outargs cout;
    
 do i = 1 to 6;
   cout[i] = cin[i];
   select(cin[i]);
	 when(5) cout[i] = 0;
	 when(7) cout[i] =.O;     /*7. Other*/
     when(8) cout[i] =.D;
     when(9) cout[i] =.R;
     otherwise;
    end;
 end;
 
endsub; /* adlhlp_9596 */

subroutine adlhlp_93_xx(studyyr, cout[*], cin[*]) group ="adlhlp";
 outargs cout;
    
   adlhlp_dress    = FQ_fun(studyyr, cin[1]);
   adlhlp_walk     = FQ_fun(studyyr, cin[2]);
   adlhlp_bath     = FQ_fun(studyyr, cin[3]);
   adlhlp_eat      = FQ_fun(studyyr, cin[4]);
   adlhlp_bed      = FQ_fun(studyyr, cin[5]);
   adlhlp_toilt    = FQ_fun(studyyr, cin[6]);
   %populate_adlhlp_array; /* Populate cout array */
 
endsub; /* subroutine adlhlp_yrs */

subroutine adlhlp_sub(studyyr, cout[*], cin[*]) group ="adlhlp";
 outargs cout;

 select(studyyr);
   when (1992,1994) call adlhlp_9294(cout, cin);
   when (1995,1996) call adlhlp_9596(cout, cin);
   otherwise        call adlhlp_93_xx(studyyr, cout, cin);
 end;
endsub; /*subroutine adlhlp_sub */

function adlhlp_vin(studyyr) $ group ="adlhlp";

 length vin $500;
 length cx $1;
 clist = upcase("hjklmnopqrstuvwxyz");
 length _tmpc $200; 
 _tmpc = "@G015 @G020 @G022 @G024 @G029 @G031";

 select (studyyr);
   when (1992) vin = ""; /* NA V304*/                    
   when (1993) vin = "V779 V768 V787 V795 V803 V814";    
   when (1994) vin = ""; /* NA W304*/                   
   when (1995) vin = "D1887 D1877 D1897 D1907 D1920 D1930";      
   when (1996) vin = "E1911 E1901 E1921 E1931 E1944 E1954";    
   when (1998) vin = "F2426 F2431 F2447 F2457 F2470 F2480"; 
   when (2000) vin = "G2724 G2729 G2745 G2755 G2768 G2778";
   otherwise 
     do; 
       wv = (studyyr - 2000)/2;
       cx = substr(clist,wv,1);
       vin = translate(_tmpc, cx, "@");
     end;
 end;
 put "FUN adlhlp_vin(): studyyr=" studyyr ", vin=" vin;

 return(vin);
endsub; /* function adlhlp_vin */
