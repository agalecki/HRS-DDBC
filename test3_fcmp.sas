%let cdir_path =.;    /* Current directory */
%put cdir_path = &cdir_path;
%let fcmp_cmplib = dlfunction;

filename macros "&cdir_path\hrs-macros";
%include macros(process_1yr array_stmnt);

libname cmp "&cdir_path\create_fcmp\_cmplib";
options cmplib=cmp.&fcmp_cmplib mprint nocenter;

libname dataout "&cdir_path\dataout";

libname libin "C:\Users\agalecki\Dropbox (University of Michigan)\DDBC HRS Project\scrambled data";



%process_1yr(1995); %process_1yr(1996); %process_1yr(1998); %process_1yr(2000);
%process_1yr(2002); %process_1yr(2004); %process_1yr(2006); %process_1yr(2008); 
%process_1yr(2010); %process_1yr(2012); %process_1yr(2014); %process_1yr(2016);
%process_1yr(2018);

ods html close;
ods preferences;

data dataout.out; 
 set _out1995 _out1996 _out1998 _out2000 _out2002 _out2004 
     _out2006 _out2008 _out2010 _out2012 _out2014 _out2016 _out2018
;
run;

proc datasets library = dataout;
 copy out= work;
 select out;
quit;

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
