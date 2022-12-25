%macro populate_adlhlp_array;

cout[1] = adlhlp_dress;
cout[2] = adlhlp_walkre;  
cout[3] = adlhlp_walkr;
cout[4] = adlhlp_bath; 
cout[5] = adlhlp_eat;
cout[6] = adlhlp_bede;
cout[7] = adlhlp_bed; 
cout[8] = adlhlp_toilt;
 
%mend populate_adlhlp_array;

/* ====== adlhlp variables for all years =====*/
subroutine adlhlp_9596(cout[*], cin[*]) group ="adlhlp";
 outargs cout;
    
 do i = 1 to 8;
   cout[i] = cin[i];
   select(cin[i]);
	 when(5) cout[i] = 0;
	 when(.) cout[i] =.S;
	 when(7) cout[i] =.M;     /*7. Other*/
     when(8) cout[i] =.D;
     when(9) cout[i] =.R;
     otherwise;
    end;
 end;
 
endsub; /* adlhlp_9596 */

subroutine adlhlp_98_xx(studyyr, cout[*], cin[*]) group ="adlhlp";
 outargs cout;
    
 do i = 1 to 8;
   cout[i] = cin[i];
   select(cin[i]);
	 when(5)    cout[i] = 0;
	 when(.,-8) cout[i] =.S;
     when(8)    cout[i] =.D;
     when(9)    cout[i] =.R;
     otherwise;
    end;
 end;
 
endsub; /* subroutine adlhlp_yrs */

subroutine adlhlp_sub(studyyr, cout[*], cin[*]) group ="adlhlp";
 outargs cout;

 select(studyyr);
   when (1995,1996)      call adlhlp_9596(cout, cin);
   otherwise             call adlhlp_98_xx(studyyr, cout, cin);
 end;
endsub; /*subroutine adlhlp_sub */

function adlhlp_vin(studyyr) $ group ="adlhlp";

 length vin $500;
 length cx $1;
 clist = upcase("hjklmnopqrstuvwxyz");
 length _tmpc $200; 
 _tmpc = "@G015 @G017 @G020 @G022 @G024 @G026 @G029 @G031";

 select (studyyr);               
   when (1995) vin = "D1887 D1874 D1877 D1897 D1907 D1917 D1920 D1930";      
   when (1996) vin = "E1911 E1898 E1901 E1921 E1931 E1941 E1944 E1954";    
   when (1998) vin = "F2426 F2428 F2431 F2447 F2457 F2467 F2470 F2480"; 
   when (2000) vin = "G2724 G2726 G2729 G2745 G2755 G2765 G2768 G2778";
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
