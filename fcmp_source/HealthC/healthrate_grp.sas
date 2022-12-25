%macro healthrate_vout_labels;
label  hlth_rate     ="RATE HEALTH (1-5)"            
       hlth_comp     ="COMPARE HEALTH TO PREVIOUS WAVE (1-3)";
%mend  healthrate_vout_labels;


/* ====== healthrate variables for all years =====*/

subroutine healthrate_94(hl_new[*], hl[*]) group="healthrate";
 /* --- List of input variables stored in hl[*] array (for year 1994)
 (1994) data = w2b,    hl[*] = W301 W302
 */
  outargs hl_new;
   
 do i = 1 to 2; 
    hl_new[i] = hl[i]; 
    select(hl[i]);
     when(8) hl_new[i] =.D;
     when(9) hl_new[i] =.R;
     when(0) hl_new[i] =.I;
     otherwise;
    end;
 end;
   %**populate_healthrate_array;
endsub; /*  healthrate_94 */

subroutine healthrate_92_xx(hl_new[*], hl[*]) group="healthrate";
/*
(1992) hl = V301 V302
(1993) hl = V204 V208
(1995) hl = D769 D772
(1996) hl = E769 E772
(1998) hl = F1097 F1100
(2000) hl = G1226 G1229
(2002) hl = HC001 HC002
...
(2030) hl = ZC001 ZC002
*/


  outargs hl_new;
   
 do i = 1 to 2; 
    hl_new[i] = hl[i]; 
    select(hl[i]);
     when(8) hl_new[i] =.D;
     when(9) hl_new[i] =.R;
     otherwise;
    end;
 end;
   %**populate_healthrate_array;
endsub; /*  healthrate_92_xx */

subroutine healthrate_sub(studyyr, cout[*], cin[*]) group="healthrate";
  outargs cout;
  select(studyyr);
   when (1994) call healthrate_94(cout, cin);
   otherwise   call healthrate_92_xx(cout, cin);
  end;
 endsub; /* subroutine healthrate_sub */


function healthrate_vin(studyyr) $ group="healthrate";

 length vin $500;
 length cx $1;
 clist = upcase("hjklmnopqrstuvwxyz");
 length _tmpc $200; 
  
    _tmpc ="@C001 @C002";
    select(studyyr);
      when (1992) vin = "V301 V302";
      when (1993) vin = "V204 V208";
      when (1994) vin = "W301 W302";
      when (1995) vin = "D769 D772";
      when (1996) vin = "E769 E772";
      when (1998) vin = "F1097 F1100";
      when (2000) vin = "G1226 G1229";
      otherwise;
       do; 
        wv = (studyyr - 2000)/2;
        cx = substr(clist,wv,1);
        vin = translate(_tmpc, cx, "@");
       end;
    end;
    put "healthrate_vin(): studyyr=" studyyr ", vin=" vin;
 return(vin);
endsub; /* function healthrate_vin */