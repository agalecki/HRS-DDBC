%macro populate_iadlhlp_array;

cout[1] = iadlhlp_meals;
cout[2] = iadlhlp_shop; 
cout[3] = iadlhlp_phone; 
cout[4] = iadlhlp_meds;
cout[5] = iadlhlp_money; 
 
%mend populate_iadlhlp_array;

/* ====== iadlhlp variables for all years =====*/

subroutine iadlhlp_92_94(cout[*], cin[*]) group ="iadlhlp";
 outargs cout;
   
   iadlhlp_meals  =.N;
   iadlhlp_shop   =.N;
   iadlhlp_phone  =.N;
   iadlhlp_meds   =.N;
   iadlhlp_money  =.N;
   %populate_iadlhlp_array;

endsub; /* iadlhlp_92_94 */

subroutine iadlhlp_9596(cout[*], cin[*]) group ="iadlhlp";
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
endsub; /* iadlhlp_9596 */

subroutine iadlhlp_98_xx(studyyr, cout[*], cin[*]) group ="iadlhlp";
 outargs cout;
 
   iadlhlp_meals    = FQ_fun(studyyr, cin[1]);
   iadlhlp_shop     = FQ_fun(studyyr, cin[2]);
   iadlhlp_phone    = FQ_fun(studyyr, cin[3]);
   iadlhlp_meds     = FQ_fun(studyyr, cin[4]);
   iadlhlp_money    = FQ_fun(studyyr, cin[5]);
   %populate_iadlhlp_array; /* Populate cout array */

endsub; /* iadlhlp_98_xx */

subroutine iadlhlp_sub(studyyr, cout[*], cin[*]) group ="iadlhlp";
 outargs cout;

 select(studyyr);
   when (1992,1993,1994) call iadlhlp_92_94(cout, cin);
   when (1995,1996)      call iadlhlp_9596(cout, cin);
   otherwise             call iadlhlp_98_xx(studyyr, cout, cin);
 end;
endsub; /*subroutine iadlhlp_sub */

function iadlhlp_vin(studyyr) $ group ="iadlhlp";

 length vin $500;
 length cx $1;
 clist = upcase("hjklmnopqrstuvwxyz");
 length _tmpc $200; 
 _tmpc = "@G043 @G046 @G049 @G053 @G061";

 select (studyyr);
   when (1992) vin = "";     /* NA V301*/                    
   when (1993) vin = "";     /* NA SEX*/  
   when (1994) vin = "";     /* NA W301*/                   
   when (1995) vin = "D2024 D2029 D2034 D2039 D2102";      
   when (1996) vin = "E2039 E2044 E2049 E2054 E2096";    
   when (1998) vin = "F2565 F2570 F2575 F2580 F2620"; 
   when (2000) vin = "G2863 G2868 G2873 G2878 G2918";
   otherwise 
     do; 
       wv = (studyyr - 2000)/2;
       cx = substr(clist,wv,1);
       vin = translate(_tmpc, cx, "@");
     end;
 end;
 put "FUN iadlhlp_vin(): studyyr=" studyyr ", vin=" vin;

 return(vin);
endsub; /* function iadlhlp_vin */
