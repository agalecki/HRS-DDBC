libname cmp "S:\Jin\DDBC\program\Version-2022-10-28\fcmp\";
options cmplib=cmp.function mprint nocenter;

/*libname libin "S:\Jin\DDBC\scrambled data";*/
%let ahead = \\maize.umhsnas.med.umich.edu\Geriatrics-HRS\External Drive\AHead_hrs_c\AHEAD;
libname hrs2020c "&ahead\hrs2020\data";
libname hrs2018c "&ahead\hrs2018\data";
libname hrs2016c "&ahead\hrs2016\data";
libname hrs2014c "&ahead\hrs2014\data";
libname hrs2012c "&ahead\hrs2012\data";
libname hrs2010c "&ahead\hrs2010\data";
libname hrs2008c "&ahead\hrs2008\Data";
libname hrs2006c "&ahead\hrs2006\newest data";
libname hrs2004c "&ahead\hrs2004\data";
libname hrs2002c "&ahead\hrs2002\data";
libname hrs2000c "&ahead\hrs2000\data";
libname hrs1998c "&ahead\hrs98\data";
libname hrs1996c "&ahead\hrs1996\data";
libname hrs1995c "&ahead\Ahead95\data";
libname hrs1994c "&ahead\hrs94\data";
libname hrs1993c "&ahead\AHEAD93\data";
libname hrs1992c "&ahead\hrs92\data";

libname out "S:\Jin\DDBC\program\Version-2022-10-28\out";

/* Concatenate libraries */
libname libin (hrs2020c
               hrs2018c hrs2016c hrs2014c hrs2012c hrs2010c hrs2008c hrs2006c hrs2004c  
               hrs2002c hrs2000c hrs1998c hrs1996c hrs1995c hrs1994c hrs1993c hrs1992c);

filename mac "S:\Jin\DDBC\program\Version-2022-10-28\test_fcmp\auxiliary macros.sas";
%include mac;

%macro process_1yr (year);

%let all_vgrps =; 
%let nvgrps =;
%let datain =;
%let all_vout=;
%let all_vin=;
%let all_vin2=;

data _null_;
 length all_vgrps $ 1000;
 length vgrp datain $32;
 length vin vout $1000;
 length all_vin all_vout $5000;
 retain  all_vin all_vout;
 all_vgrps = bind_vgrps();
 nvgrps  = countw(all_vgrps);
 all_vgrps = translate(strip(all_vgrps),"|", " ");
 datain  = dispatch_datain(&year);
 do i =1 to nvgrps;
   vgrp = scan(all_vgrps, i, '|'); /*  Variable group name */
   vin = dispatch_vin(&year, vgrp);
   vout= dispatch_vout(vgrp);
   all_vin = strip(all_vin)  || strip(vin) || "|"; 
   all_vout = strip(all_vout)|| strip(vout)|| "|"; 
 end;
 all_vin2 =translate(all_vin, " ","|");
 call symput("all_vgrps", strip(all_vgrps));
 call symput("nvgrps", strip(nvgrps));
 call symput("datain", strip(datain));
 call symput("all_vin", strip(all_vin));
 call symput("all_vin2", strip(all_vin2));
 call symput("all_vout", strip(all_vout));
run;

%put all_vgrps :=&all_vgrps; 
%put nvgrps    :=&nvgrps;
%put datain    :=&datain;
%put all_vin   :=&all_vin;
%put all_vin2  :=&all_vin2;

%put all_vout  :=&all_vout;

data out.fn&year; 
  set libin.&datain(keep = pn hhid &all_vin2);
  missing O D R I N;
  studyyr =&year;
  %do i=1 %to &nvgrps;
   %let vgrp = %scan(&all_vgrps,&i, "|");
   %let vin  = %scan(&all_vin, &i,  "|");
   %let vout  = %scan(&all_vout, &i,  "|");
   %put --- Group `&vgrp` processed ---;
   %array_stmnt(&year, &vgrp, &vout, &vin);
%end;
  drop &all_vin2;
run;

*Title "Year &year(DATA=&datain) processed for &nvgrps groups of variables (obs=30)";
*proc print data=yeardata (obs=30);
*run;

%mend process_1yr;

%process_1yr(1995); %process_1yr(1996); %process_1yr(1998); %process_1yr(2000);
%process_1yr(2002); %process_1yr(2004); %process_1yr(2006); %process_1yr(2008); 
%process_1yr(2010); %process_1yr(2012); %process_1yr(2014); %process_1yr(2016);
%process_1yr(2018);

ods html close;
ods preferences;

data out; 
 set out.fn1995 out.fn1996 out.fn1998 out.fn2000 out.fn2002 out.fn2004 
     out.fn2006 out.fn2008 out.fn2010 out.fn2012 out.fn2014 out.fn2016 out.fn2018; 
run;
proc format;
 value skip_dressfmt
   .N = ".N=Not Available"
   .M = ".M=Missing Nagi's disability"
 	0 = "0.Asked ADL DRESS questions"
    1 = "1.Skips b/c no Nagi's disability";

 value skip_otherfmt
    .N = ".N=Not Available"
    .M = ".M=Missing Nagi's disability"
 	0 = "0.Asked ADL WALKR BATH EAT BED TOILT questions"
    1 = "1.Skips ADL WALKR BATH EAT BED TOILT questions";

 value adlfmt
 	1 = "1.Yes"
	0 = "0.No"
	6 = "6.Can't Do"
	7 = "7.Don't Do"
	.S = ".S=Missing Nagi's disability"
	.N = ".N=Not Available"
	.M = ".M=Other Missing"
    .R = ".R=Refused"
	.D = ".D=Don't Know";

 value hlpfmt
 	1 = "1.Yes"
	0 = "0.No"
	6 = "6.Can't Do"
	7 = "7.Don't Do"
	.S = ".S=Skip"
	.N = "Not Available"
    .M= ".M=Other Missing"
    .R= ".R=Refused"
	.D= ".D=Don't Know";
run;
Title "ADL: Dress";
proc freq data = out;
tables (skip_dress adldiff_dress adlhlp_dress)*studyyr/nopercent nocol norow missing;
format skip_dress skip_dressfmt. adldiff_dress adlfmt. adlhlp_dress hlpfmt.;
run;
Title "ADL: Walk across a room";
proc freq data = out;
tables (skip_other adldiff_walkr adlhlp_walkre adlhlp_walkr)*studyyr/nopercent nocol norow missing;
format skip_other skip_otherfmt. adldiff_walkr adlfmt. adlhlp_walkre hlpfmt. adlhlp_walkr hlpfmt.;
run;
Title "ADL: Bath";
proc freq data = out;
tables (adldiff_bath adlhlp_bath)*studyyr/nopercent nocol norow missing;
format adldiff_bath adlfmt. adlhlp_bath hlpfmt.;
run;
Title "ADL: Eat";
proc freq data = out;
tables (adldiff_eat adlhlp_eat)*studyyr/nopercent nocol norow missing;
format adldiff_eat adlfmt. adlhlp_eat hlpfmt.;
run;
Title "ADL: Bed";
proc freq data = out;
tables (adldiff_bed adlhlp_bede adlhlp_bed)*studyyr/nopercent nocol norow missing;
format adldiff_bed adlfmt. adlhlp_bede hlpfmt. adlhlp_bed hlpfmt.;
run;
Title "ADL: Toilet";
proc freq data = out;
tables (adldiff_toilt adlhlp_toilt)*studyyr/nopercent nocol norow missing;
format adldiff_toilt adlfmt. adlhlp_toilt hlpfmt.;
run;

Title "IADL: Meals";
proc freq data = out;
tables iadldiff_meals*studyyr/nopercent nocol norow missing;
format iadldiff_meals adlfmt.;
run;
Title "IADL: Grocery Shopping";
proc freq data = out;
tables iadldiff_shop*studyyr/nopercent nocol norow missing;
format iadldiff_shop adlfmt.;
run;
Title "IADL: Phone";
proc freq data = out;
tables iadldiff_phone*studyyr/nopercent nocol norow missing;
format iadldiff_phone adlfmt.;
run;
Title "IADL: Meds";
proc freq data = out;
tables iadldiff_meds*studyyr/nopercent nocol norow missing;
format iadldiff_meds adlfmt.;
run;
Title "IADL: Money";
proc freq data = out;
tables iadldiff_money*studyyr/nopercent nocol norow missing;
format iadldiff_money adlfmt.;
run;
