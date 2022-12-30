
%macro cancer_vout_lbls;
label ca            ="CANCER [CA]"
      ca_dr         ="HAS R SEEN A DOCTOR CONCERNING CANCER"
      ca_tx         ="PAST CANCER TREATED"
      ca_new        ="NEW CANCER EXCLUDING SKIN"
      ca_yr         ="YEAR RECENT CANCER";
%mend cancer_vout_lbls;


%macro populate_cancer_array;
cout[1] = ca;
cout[2] = ca_dr; 
cout[3] = ca_tx; 
cout[4] = ca_new;
cout[5] = ca_yr; 
 
%mend populate_cancer_array;

/* ====== Cancer variables for all years =====*/


subroutine cancer_92(cout[*], cin[*]) group ="cancer";
 /* --- List of input variables stored in cin[*] array (for year 1992)
   (1992) data = health, cin{*] = "V337 V341 XXX XXX XXX";
 */

  outargs cout;
   
   ca     = HQ_fun(1992, cin[1]);
   ca_dr  = HQ_fun(1992, cin[2]);
   ca_tx  =.N;
   ca_new =.N;
   ca_yr  = .N;
   %populate_cancer_array;
endsub; /*  cancer_92 */

subroutine cancer_93(cout[*], cin[*]) group ="cancer";
 /* --- List of input variables stored in cin[*] array (for year 1993)
(1993) data = BR21,   cin[*] = "V225 XXX XXX XXX XXX";
 */
 
 outargs cout;
   
   ca     = HQ_fun(1993, cin[1]);
   ca_dr  = .N;
   ca_tx  = .N;
   ca_new = .N;
   ca_yr  = .N;
   %populate_cancer_array;
endsub; /*  cancer_93 */

subroutine cancer_94(cout[*], cin[*]) group ="cancer";
 /* --- List of input variables stored in cin[*] array (for year 1994)
 (1994) data = w2b,    cin[*] = "W339 W344 XXX W340 W342";
*/
 
 outargs cout;
    
    ca     = HQ_fun(1994, cin[1]);
    ca_dr  = HQ_fun(1994, cin[2]);
    ca_tx  = .N;
    ca_new = HQ_fun(1994, cin[3]);
    ca_yr  = cin[4]; /***!!! cin array has 4 elements not 5*/
    if ca_yr = 0 then ca_yr =.I;
    %populate_cancer_array;
endsub; /*  cancer_94 */


subroutine cancer_95_xx(studyyr, cout[*], cin[*]) group ="cancer";

 /* --- List of input variables stored in cin[*] array (for every study year)

  (1995) data = a95b_r, cin[*] = "D801 D802 D803 D806 D814";
  (1996) data = h96b_r, cin[*] = "E801 E802 E803 E806 E814";
  (1998) data = h98b_r, cin[*] = "F1129 F1130 F1131 F1134 F1141";
  (2000) data = h00b_r, cin[*] = "G1262 G1263 G1264 G1267 G1274";    

  (2002) data = h02c_r, cin[*] = "HC018 HC019 HC020 HC024 HC028"   
  (2004) data = h04c_r, cin[*] = "JC018 JC019 JC020 JC024 JC028"   
  (2006) data = h06c_r, cin[*] = "KC018 KC019 KC020 KC024 KC028"   
...
 (2018) data = h18c_r, cin[*] = "QC018 QC019 QC020 QC024 QC028"   

 */
 
  outargs cout;
    
   ca    = HQ_fun(studyyr, cin[1]);
   ca_dr = HQ_fun(studyyr, cin[2]);
   ca_tx = HQ_fun(studyyr, cin[3]);
   ca_new= HQ_fun(studyyr, cin[4]);
   ca_yr = cin[5]; 
    
   select (cin[5]);
      when (9997) ca_yr =.O;
      when (9998) ca_yr =.D; 
      when (9999) ca_yr =.R; 
      otherwise;
   end;
     
   /* Populate cout array */
    %populate_cancer_array;
 
endsub; /* subroutine cancer_yrs */

subroutine cancer_sub(studyyr, cout[*], cin[*]) group ="cancer";
  outargs cout;
  select(studyyr);
   when (1992) call cancer_92(cout, cin);
   when (1993) call cancer_93(cout, cin);
   when (1994) call cancer_94(cout, cin);
   otherwise  call cancer_95_xx(studyyr, cout, cin);
  end;
 endsub; /*subroutine cancer_sub */


function cancer_vin(studyyr) $ group ="cancer";

 length vin $500;
 length cx $1;
 clist = upcase("hjklmnopqrstuvwxyz");
 length _tmpc $200; 
 _tmpc = "@C018 @C019 @C020 @C024 @C028";
 select (studyyr);
  when (1992) vin = "V337 V341";                     /*V337 V341 XXX XXX  XXX */
  when (1993) vin = "V225";                          /*V225 XXX  XXX XXX  XXX */
  when (1994) vin = "W339 W344 W340 W342";           /*W339 W344 XXX W340 W342*/
  when (1995) vin = "D801 D802 D803 D806 D814";
  when (1996) vin = "E801 E802 E803 E806 E814";
  when (1998) vin = "F1129 F1130 F1131 F1134 F1141";
  when (2000) vin = "G1262 G1263 G1264 G1267 G1274";
  otherwise 
     do; 
       wv = (studyyr - 2000)/2;
       cx = substr(clist,wv,1);
       vin = translate(_tmpc, cx, "@");
     end;
 end;
 put "FUN cancer_vin(): studyyr=" studyyr ", vin=" vin;

 return(vin);
endsub; /* function cancer_vin */


