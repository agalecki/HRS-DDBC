
/* ====== skip variables for all years =====*/

function skip_92_94() group ="skip";
 /* 0.Asked ADL questions */
 /* 1.Skips ADL questions */
 /* .S=Skipped prev Qs too */

   skip  = .N;  /* NA */;
   return(skip);
endsub;     /*  skip_92_94 */;

function skip_9596(cin[*]) group ="skip";
   skip = 1*(cin[1] = 5);
   return(skip);
endsub; /*  skip_9596 */;

function skip_9800(cin[*]) group ="skip";
 
   skip =1*(cin[1] = 0 & cin[2] = 0 & cin[3] = 0 & cin[4] = 0 & cin[5] = 0 &
            cin[6] = 0 & cin[7] = 0 & cin[8] = 0 & cin[9] = 0 & cin[10] = 0);
   return(skip);
endsub; /*  skip_9800 */;

function skip_02_xx(cin[*]) group ="skip";
  select(cin[1]);
    when (0) skip = 1;
    when (.) skip =.S;
    otherwise skip = 0;
  end;
 return(skip); 
endsub; /*  skip_02_xx */;


function skip_vin(studyyr) $ group = "skip";

 length vin $500;
 length cx $1;
 clist = upcase("hjklmnopqrstuvwxyz");
 length _tmpc $200; 
 _tmpc = "@G013";

 select (studyyr);
   when (1992) vin = "";       /*NA */                   
   when (1993) vin = "";       /*NA */      
   when (1994) vin = "";       /*NA */                    
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

subroutine skip_sub(studyyr, cout[*], cin[*]) group ="skip";
 outargs cout;
 select(studyyr);
   when (1992,1993,1994) sx = skip_92_94();
   when (1995,1996)      sx = skip_9596(cin);
   when (1998,2000)      sx = skip_9800(cin);
   otherwise             sx = skip_02_xx(cin);
 end;
 cout[1] = sx;
endsub; /*subroutine skip_sub */;
