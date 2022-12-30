function subhh_cfun(cin[*] $) $ group = "subhh"; 
/* --- Info on cin argument (for every study year);
;
(1992) cin = "ASUBHH";
(1993) cin = "BSUBHH";
(1994) cin = "CSUBHH";
(1995) cin = "DSUBHH";
(1996) cin = "ESUBHH";
(1998) cin = "FSUBHH";
(2000) cin = "GSUBHH";    
(2002) cin = "HSUBHH";   
(2004) cin = "JSUBHH";   
(2006) cin = "KSUBHH";   

...;
(2018) cin = "QSUBHH";

*/;

 length res $1;
 res = cin[1];  /* subhh */;
 return(res);
endsub; /*  subhh_cfun */;

function subhh_vin(yr) $ group = "subhh";
 length vin $500;
 length cx $1;
 clist = upcase("abcdefghjklmnopqrstuvwxyz");
 length _tmpc $200; 
 _tmpc = "@SUBHH";
 ;
 select; 
  when (1992 <= yr <= 1996) idx = yr - 1991;
  when (1998 <= yr <= 2030) idx = (yr -1996)/2 + 5; 
  otherwise;
 end;
 ;
 cx = substr(clist, idx, 1);
 vin = translate(_tmpc, cx, "@");
 put "FUN subhh_vin(): year =" yr ", idx =" idx ", cx =" cx ", vin=" vin;
 return(vin);
endsub; /*  subhh_vin */;
