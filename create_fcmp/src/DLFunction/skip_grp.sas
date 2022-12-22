%macro populate_skip_array;
 /*0.Asked ADL questions
   1.Skips ADL questions
  .S=Skipped prev Qs too */
cout[1] = skip; 

%mend populate_skip_array;

/* ====== skip variables for all years =====*/

subroutine skip_92_94(cout[*], cin[*]) group ="skip";
 outargs cout;
   
   skip  =.N;
   %populate_skip_array;

endsub; /*  skip_92_94 */

subroutine skip_9596(cout[*], cin[*]) group ="skip";
 outargs cout;
 
   skip =1*(cin[1] = 5);
   %populate_skip_array;

endsub; /*  skip_9596 */

subroutine skip_9800(cout[*], cin[*]) group ="skip";
 outargs cout;
 
   skip =1*(cin[1] = 0 & cin[2] = 0 & cin[3] = 0 & cin[4] = 0 & cin[5] = 0 &
            cin[6] = 0 & cin[7] = 0 & cin[8] = 0 & cin[9] = 0 & cin[10] = 0);
   %populate_skip_array;

endsub; /*  skip_9800 */

subroutine skip_02_xx(cout[*], cin[*]) group ="skip";
 outargs cout;
 
   if cin[1] = 0 then skip = 1;
   else if cin[1] = . then skip =.S; 
   else skip = 0;
   %populate_skip_array;

endsub; /*  skip_02_xx */

subroutine skip_sub(studyyr, cout[*], cin[*]) group ="skip";
 outargs cout;

 select(studyyr);
   when (1992,1993,1994) call skip_92_94(cout, cin);
   when (1995,1996)      call skip_9596(cout, cin);
   when (1998,2000)      call skip_9800(cout, cin);
   otherwise             call skip_02_xx(cout, cin);
 end;
endsub; /*subroutine skip_sub */

function skip_vin(studyyr) $ group ="skip";

 length vin $500;
 length cx $1;
 clist = upcase("hjklmnopqrstuvwxyz");
 length _tmpc $200; 
 _tmpc = "@G013";

 select (studyyr);
   when (1992) vin = "V304";      /*NA*/                   
   when (1993) vin = "V360";      /*NA*/      
   when (1994) vin = "W304";      /*NA*/                    
   when (1995) vin = "D1870";     
   when (1996) vin = "E1894";      
   when (1998) vin = "F2424_1 F2424_2 F2424_3 F2424_4 F2424_5 F2424_6 F2424_7 F2424_8 F2424_9 F2424_10"; 
   when (2000) vin = "G2722_1 G2722_2 G2722_3 G2722_4 G2722_5 G2722_6 G2722_7 G2722_8 G2722_9 G2722_10";
   otherwise 
     do; 
       wv = (studyyr - 2000)/2;
       cx = substr(clist,wv,1);
       vin = translate(_tmpc, cx, "@");
     end;
 end;
 put "FUN skip_vin(): studyyr=" studyyr ", vin=" vin;

 return(vin);
endsub; /* function skip_vin */
