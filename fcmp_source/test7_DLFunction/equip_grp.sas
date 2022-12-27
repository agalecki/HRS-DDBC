%macro populate_equip_array;

cout[1] = equip_walk; 
cout[2] = equip_bed; 

%mend populate_equip_array;

/* ====== equip variables for all years =====*/

subroutine equip_9294(cout[*], cin[*]) group ="equip";
 outargs cout;
   
   equip_walk   =.N;
   equip_bed    =.N;
   %populate_equip_array;

endsub; /*  equip_9294 */

subroutine equip_95_xx(cout[*], cin[*]) group ="equip";
 outargs cout;
   
 do i = 1 to 2;
   cout[i] = cin[i];
   select(cin[i]);
	 when(5) cout[i] = 0;
	 when(7) cout[i] =.O;     /*7. Other*/
     when(8) cout[i] =.D;
     when(9) cout[i] =.R;
     otherwise;
    end;
 end;

endsub; /*  equip_9596 */

subroutine equip_sub(studyyr, cout[*], cin[*]) group ="equip";
 outargs cout;

 select(studyyr);
   when (1992,1994) call equip_9294(cout, cin);
   otherwise        call equip_95_xx(cout, cin);
 end;
endsub; /*subroutine equip_sub */

function equip_vin(studyyr) $ group ="equip";

 length vin $500;
 length cx $1;
 clist = upcase("hjklmnopqrstuvwxyz");
 length _tmpc $200; 
 _tmpc = "@G017 @G026";

 select (studyyr);
   when (1992) vin = ""; /*NA V302*/                   
   when (1993) vin = "V772 V810";     
   when (1994) vin = ""; /*NA W302 */                    
   when (1995) vin = "D1874 D1917";     
   when (1996) vin = "E1898 E1941";      
   when (1998) vin = "F2428 F2467"; 
   when (2000) vin = "G2726 G2765";
   otherwise 
     do; 
       wv = (studyyr - 2000)/2;
       cx = substr(clist,wv,1);
       vin = translate(_tmpc, cx, "@");
     end;
 end;
 put "FUN equip_vin(): studyyr=" studyyr ", vin=" vin;

 return(vin);
endsub; /* function equip_vin */
