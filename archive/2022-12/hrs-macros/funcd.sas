%macro funcd(years, libin =, outdt =, tracemd =, 
              outinfo =, fmts = funcd_fmts, dtin_macro =, last_hrsyr = 2018
);
/* FUNCD Macro to create ADL and IADL variables for selected years */

/* PATH OF HRS CORE DATA FILES 
   NOTE: 1. Functional Limitations and Helpers (Respondent) files.
	     Year 1993: Section BR21
             Year 1995: Section A_R
             Year 1996 ~ 2000: Section E_R
	     Year 2002 ~ : Section G_R 
	     Year 1992 and 1994 not available.
*/
%local _macro_version;
%let _macro_version = 2022-04-22;

/*---- Auxiliary macros defined <START> ----*/

%macro isBlank(param);
 %sysevalf(%superq(param)=,boolean)
%mend isBlank;


%macro _check_args_putstmnts;
/*--- Contains put statements to be used by `_check_macroargs` macro:  START --- */
 
   put "#  Macro funcd (&sysdate)" /;
   put "* This file contains information about the execution of `funcd` macro";
   put "* Macro `funcd` (Version &_macro_version) was executed on &sysdate at &systime";
   put "* Macro `funcd` can be executed in one of the two modes: _test_ or _regular_ mode";
   Put "* Execution mode of the `funcd` is determined based on the value of the `outinfo` argument"; 
   put "   - By default the `outinfo` argument is blank and the `funcd` macro is executed in a _regular_ mode";
   put "   - If the `outinfo` argument is not blank  the `funcd` macro is executed in a _test_ mode";
   put;
   
   
   put "## Macro arguments" /;
   put "Macro arguments provided by the user" /;
  
   p = 67; /* Column pointer control position */
  
   put "| Argument Description         | Arg. Name     | Value           " @p "| Comment    | Default value    |";
   put "| :-------------------------   | :-------      | :---------------" @p "| :---       | :---             |";
   put "| Range of HRS years           | `years`       | &years          " @p "| Mandatory  | No defualt       |";
   put "| Input SAS library            | `libin`       | &libin          " @p "| Mandatory  | No default       |";
   put "| Output data                  | `outdt`       | &outdt          " @p "| Mandatory  | No default       |";
   put "| Fileref to trace file        | `tracemd`     | &tracemd        " @p "| Optional   | Blank            |";
   put "| Data with output info        | `outinfo`     | &outinfo        " @p "| Optional   | Blank            |";
   put "| Macro with format statements | `fmts`        | &fmts           " @p "| Optional   | `funcd_fmts`     |";
   put "| Dtin macro                   | `dtin_macro`  | &dtin_macro     " @p "| Optional   | Blank            |";
   put "| Last HRS year                | `last_hrsyr`  | &last_hrsyr     " @p "| Optional   | `2018`           |";
   put;

   put "Notes pertaining to main macro execution mode:" /;
   _tmp1 = upcase(strip("&test_mode"));
   if   _tmp1 = "YES" then do;
     put "* Macro argument `outinfo` is not blank.";
     put "* Macro `funcd` is executed in a _TEST_ mode.";
     put "* Information about `funcd` macro execution is stored in `&outinfo` dataset";
     put "* Dataset specified in `outdt` argument will not be created";
     put "* The macro will check whether input datasets needed for execution exist in `&libin` input library or not"; 
     put;
   end;
   if   _tmp1 = "NO" then do;
        put "* Macro argument `outinfo` is blank";
        put "* ... Macro `funcd` is executed in a _REGULAR_ mode.";
        put "* Dataset specified in `outdt` argument will be created";
   end;
/*--- Contains put statements END --- */
%mend _check_args_putstmnts;
  
%macro _check_macroargs;

/* Auxiliary macro to provide info on macro arguments */
Title "Macro funcd (&sysdate)";
ods proclabel = "Macro funcd (&sysdate)";
data _null_;
   file print;
   %_check_args_putstmnts; /* Macro with put statements */
run;

%if %isBlank(&tracemd) = 0 %then %do;
data _null_;
   file &tracemd;
   %_check_args_putstmnts; /* Macro with put statements */
run;
%end; /* if isBlank */

%mend _check_macroargs;

%macro trace_loopinit_stmnts;
/*--- Contains put statements to be used by `_trace_loopinit` macro:  START --- */
   put "# Main loop";
   put "## Derived variables";
   
   put "Derived variables listed in the Table below will be stored in `&outdt` output dataset." /;
   
   p = 80; /* Column pointer control position */
   /*   ----5----0----5---20----5---30----5---40----5---50----5---60----5---70 */
   put "| List of vars       | Variable names   " @p "|";
   put "| :---------------   | :-------         " @p "|";
   put "| ADL vars           | &ADL_new_list    " @p "|";
   put "| IADL vars          | &IADL_new_list   " @p "|";
   put "| ADL DD vars        | &ADL_DD_new_list " @p "|";
   put;
   
   length year_list $300;
   year_list = "&year_list";
   year_list =translate(year_list,",",":");
   put "## Loop Iterations ";
   put "Main loop execution started at &systime" /;
   put "Loop will be executed for selected &year_no study years:" year_list /;

/*--- Contains put statements END --- */
%mend trace_loopinit_stmnts;

%macro _trace_loopinit;
/* Auxiliary macro executed right before MAIN loop */

Title "Main loop starts: Derived variables";
ods proclabel = "Derived vars";
data _null_;
   file print;
   %trace_loopinit_stmnts; /* Macro with put statements */
run;

%if %isBlank(&tracemd) = 0 %then %do;
data _null_;
   file &tracemd mod;
   %trace_loopinit_stmnts; /* Macro with put statements */
run;
%end; /* if isBlank */

%mend _trace_loopinit;


%macro _trace_loopiter_putstmnts;
/*--- Contains put statements to be used by `_trace_loopiter` macro:  START --- */
 put "&year_idx.. --- Year &year selected (&_out1) to be processed. Test mode = &test_mode ---" /;
   
   
   p =  85; /* Column pointer control position */
   /*   ----5----0----5---20----5---30----5---40----5---50----5---60----5---70 */
  
   put "| Description             | Name             |   Value          " @p "|";
   put "| :---------------        | :-------         | :-----           " @p "|";
   put "| Input library           | `libin`          | &libin           " @p "|";
   put "| Input dataset           | `datain`         | &datain          " @p "|";
   put "| Auxiliary variable      | `wv`             | &wv              " @p "|";
   put "| Auxiliary variable      | `cx`             | &cx              " @p "|";
   put "| ADL_diff variables      | `ADL_diff_list`  | &ADL_diff_list   " @p "|";
   put "| ADL_help variables      | `ADL_help_list`  | &ADL_help_list   " @p "|";
   put "| ADL_equip variables     | `ADL_equip_list` | &ADL_equip_list  " @p "|";
   put "| IADL_diff variables     | `IADL_diff_list` | &IADL_diff_list  " @p "|";
   put "| IADL_help variables     | `IADL_help_list` | &IADL_help_list  " @p "|";
   put "| IADL_rsn variables      | `IADL_rsn_list`  | &IADL_rsn_list   " @p "|";
   put "| Loop macro              | `umacro`         | &umacro          " @p "|";
   put;
   
   put "Notes related to processing year &year:" /;
   put "* Input dataset `&datain` &dtin_msg";
   put "* Auxiliary variables `wv` and `cx` are blank for years <= 2000";
   put "* ADL/IADL lists of variables are blank for year 1993";
   put "* Loop macro `&umacro` &umacro_msg";
   put;
   put "======= Year &year processing completed =======" /;
   put;

/*--- Contains put statements END --- */
%mend _trace_loopiter_putstmnts;

%macro _trace_loopiter;
 /* Test various macro variables used for a given MAIN loop iteration step*/ 
  
  /* Create a message whether input dataset exists */
 
  %local dtin_msg dtin_obs;
   %let dtin_msg = _NOT_ found in `&libin` library ... ERROR!;
  
  %if %sysfunc(exist(&libin..&datain)) %then %do;
   proc sql noprint;
     select count(*) into :dtin_obs from &libin..&datain;
   quit;
   %let dtin_obs= %sysfunc(strip(&dtin_obs));
   %let dtin_msg = (# of rows=&dtin_obs) found in `&libin` library ... OK;;
  %end;
  
  /* Create a umacro message */
  %local umacro_msg;
  
  %if &test_mode = Yes %then %let umacro_msg = _NOT_ executed in a test mode;
  %if &test_mode = No  %then %let umacro_msg =  is executed;
  
  
  %local _out1;
  %let _out1 =%sysfunc(strip(&year_idx/&year_no));
  
  title "Year &year (&_out1)";
  ods proclabel = "Y&year (&_out1)";
  data _null_;
   file print;
   %_trace_loopiter_putstmnts; /* Macro with put statements */
  run;
 
%if %isBlank(&tracemd) = 0 %then %do;
   data _null_;
     file &tracemd mod;
     %_trace_loopiter_putstmnts; /* Macro with put statements */
   run;
%end; /* if isBlank */
 
%mend _trace_loopiter;

%macro _funcd_1993;
	data _yearoutdata(keep=hhid pn studyyr numADL numIADL numADL_DD 
                         &ADL_new_list &IADL_new_list &ADL_DD_new_list);
		set &libin..&datain;  /* datain = br21 */
		studyyr=&year;
		array x{*} dress walk bathe eat bed toilet meal groc phone medicine money;
		array y{*} &ADL_new_list. &IADL_new_list.;
		do i = 1 to dim(x);
			y{i} = x{i};
		end;
		array z{*} numADL_DD &ADL_DD_new_list.;
		do i = 1 to 7;
			z{i} = .;
		end;
		if hhid ne '';
	   /* statements from `dtin_macro` conditionally inserted */
		%if %isBlank(&dtin_macro)=0 %then %dtin_macro;; /*--- User defined macro is invoked */
   	run; 

%mend  _funcd_1993;


%macro _funcd_sub;
/* Macro variables needed:
 libin datain year hsr_yr
 ADL_new_list   IADL_new_list ADL_DD_new_list
 ADL_diff_list  ADL_help_list ADL_equip_list
 IADL_diff_list IADL_rsn_list IADL_help_list`
*/
data _yearoutdata(keep = hhid pn studyyr
			numadl numiadl numADL_DD 
			&ADL_new_list &IADL_new_list &ADL_DD_new_list);
set &libin..&datain;    /*--- &hrs.&yr.&section._r */
studyyr= &year;  /* &year1 */

/* ADL DIFFICULTIES
   NOTE: 1. Either having difficulty, can't do or don't do 
	 2. Receiving help from anyone 
*/
array ADL_diff{6}  &ADL_diff_list; 	*ADL difficulties;
array ADL_help{6}  &ADL_help_list; 	*ADL help;
array ADL_equip{2} &ADL_equip_list; 	*ADL equipment;
array ADL_new{6}   &ADL_new_list;
array ADL_DD_new{6} &ADL_DD_new_list.;
 do i=1 to 4;
  if ADL_diff(i) in (1,6,7) then ADL_new(i)=1;
   else if ADL_diff(i) in (8, 97, 98) and ADL_help(i)=1 then ADL_new(i)=1;
   else if ADL_diff(i) in (9, 99) then ADL_new(i)=.;
   else ADL_new(i)=0;
   ADL_DD_new(i)= (ADL_diff(i)=7 & ADL_help(i)=5);
 end;
 do i=5 to 6;
  if ADL_diff(i) in (1,6,7) or ADL_help(i)=1 or ADL_equip(i-4)=1 then ADL_new(i)=1;
  else if ADL_diff(i)=9 then ADL_new(i)=.;
  else ADL_new(i)=0;
  ADL_DD_new(i)= (ADL_diff(i)=7 & ADL_help(i)=5 & ADL_equip(i-4)=5);
 end;

numADL=SUM(dress_ADL,walk_ADL,bathe_ADL,eat_ADL,bed_ADL,toilet_ADL);
numADL_DD=sum(dress_DD, walk_DD, bathe_DD, eat_DD, bed_DD, toilet_DD);

/* IADL DIFFICULTIES
   NOTE: 1. Having difficulty
         2. Can't do or don't do because of a health or memory problem
         3. Receiving help from anyone 
*/
array IADL_diff{5} &IADL_diff_list.;    *IADL difficulties;
array IADL_rsn{5} &IADL_rsn_list.;      *IADL reasons;
array IADL_help{5} &IADL_help_list.;    *IADL help;
array IADL_new{5} &IADL_new_list.;
do i = 1 to 5;
 if IADL_diff(i)=1 or (IADL_diff(i) in (6,7) and IADL_rsn(i)=1) or IADL_help(i)=1 then IADL_new(i)=1;
  else if IADL_diff(i) in (9,.) then IADL_new(i)=.;
  else IADL_new(i)=0;
end;

numIADL=SUM(MEAL_IADL,GROC_IADL,PHONE_IADL,MEDICINE_IADL,MONEY_IADL);

/* statements from `dtin_macro` conditionally inserted */
%if %isBlank(&dtin_macro) = 0 %then %dtin_macro;; /*--- User defined macro is invoked */
   
run;
%mend _funcd_sub;

/*---- Auxiliary macros defined <END> ----*/

/*==== Macro  execution starts here */

/*---  Step 1: Initialize output dataset */

data _funcd (label = "Functional ADL/IADL variables: <&years>");
label hhid         ="HOUSEHOLD IDENTIFIER"
      pn           ="PERSON NUMBER"
      studyyr      ="STUDY YEAR"  
      DRESS_ADL	   ="ADL: DRESS DIFFICULTY"
      WALK_ADL	   ="ADL: WALK DIFFICULTY"
      BATHE_ADL	   ="ADL: BATHING DIFFICULY"
      EAT_ADL	   ="ADL: EAT DIFFICULTY"
      BED_ADL	   ="ADL: BED DIFFICULTY"
      TOILET_ADL   ="ADL: TOILET DIFFICULTY"
      DRESS_DD 	   ="Don't do DRESS"
      WALK_DD	   ="Don't do WALK"
      BATHE_DD	   ="Don't do BATHING"
      EAT_DD	   ="Don't do EAT"
      BED_DD       ="Don't do BED"
      TOILET_DD    ="Don't do TOILET"
      MEAL_IADL    ="IADL: MEAL DIFFICULTY"
      GROC_IADL    ="IADL: GROCERY DIFFICULTY"
      PHONE_IADL   ="IADL: PHONE DIFFICULTY"
      MEDICINE_IADL="IADL: MEDICATION DIFFICUTLY"
      MONEY_IADL   ="IADL: MONEY DIFFICUTLY"
      numADL       ="Total # of ADL DIFFICULTIES (0 - 6)"
      numIADL      ="Total # of IADL DIFFICULTIES (0 - 5)"
      numADL_DD	   ="Total # of don't do ADLs (0 - 6)"
;
/* Include length statements. Mandatory for character variables   */	
	
%if %isBlank(&fmts) = 0 %then %&fmts;; /* format statements */
   call missing(of _all_);
   stop;
;
run;

/*--- Step 2a: Unpack macro arguments and create auxiliary macro variables  ----*/

%if %isBlank(&outdt)  = 1 %then %let outdt=work._funcdout;
%if %isBlank(&outinfo)= 1 %then %let test_mode = No;
%if %isBlank(&outinfo)= 0 %then %let test_mode = Yes;

%put ===  Macro `funcd` arguments` ===;
%put years := &years;
%put libin := &libin;
%put outdt := &outdt;
%put fmts  := &fmts;
%put outinfo := &outinfo;
%put dtin_macro := &dtin_macro;
%put test_mode := &test_mode;

%_check_macroargs;

/*--- Step 2b: Create `_funcd_info` dataset ---*/

data _funcd_info; /*-- One row per HRS study year (1992-20??)*/
  label year       = "Study year ($4)"
        commnt     = "Comment"
        umacro     = "Macro executed for a given HRS study year"
        libin      = "SAS input library name"
        datain     = "Input data for a given HRS study year"
        fmts       = "Macro with format statements"
        yearx      = "Study year (numeric)"
        wv         = "HRS wave (on or after year 2002)"
        yr2        = "Study year ($2)"
  ;
  length year $4;
  length yr2 $2;
  length umacro libin datain fmts $40;
  length commnt $100;
  
  /*-- Variables constant for all years (if any)*/
  
  do yearx = 1992 to 1996, 1998 to &last_hrsyr by 2;
    year  = put(yearx, 4.);  /* From numeric to character */
    yr2   = substr(year,3,2);
    
  /* Define `commnt` variable for each year */
   
   select(yearx);
     when (1992, 1994)       commnt = "Not available"; 
     when (1993)             commnt = "Section BR21";
     when (1995)             commnt = "Section A_R";
     when (1996, 1998, 2000) commnt = "Section E_R";
     otherwise               commnt = "Section G_R"; 
   end;

  /* Define `umacro` variable */
    select(yearx);
     when (1992, 1994) umacro =  "";
     when (1993)      umacro   = "_funcd_1993";
     otherwise        umacro   = "_funcd_sub";
    end;
    
  /* Define `libin` variable */
    select(yearx);
     when (1992, 1994) libin =  "";
     otherwise         libin = "&libin";
    end;
        
  /* Define `fmts` variable */
      select(yearx);
       when (1992, 1994) fmts = "";
       otherwise         fmts = "&fmts";
    end;
    
    /* define auxiliary variables: hrs, section, datain */
    hrs = "h";
    if yearx = 1995 then hrs = "a";
    if yearx < 2002 then section= "e";
    if yearx >= 2002 then section= "g";
    
    datain   = strip(hrs)||strip(yr2)||strip(section)||"_r";
    if yearx in (1992,1993,1994) then do;
      hrs     = "";
      section = "";
      datain  = "";
    end;
    if yearx = 1993 then datain = "BR21";

   /* Create ADL_diff_list variable */ 
    length ADL_diff_list $50;
    select(yearx);
     when (1992, 1993, 1994) ADL_diff_list   = "";
     when (1995) ADL_diff_list   = "D1884 D1894 D1904 D1927 D1871 D1914";
     when (1996) ADL_diff_list   = "E1908 E1918 E1928 E1951 E1895 E1938";
     when (1998) ADL_diff_list   = "F2425 F2444 F2454 F2477 F2427 F2464";
     when (2000) ADL_diff_list   = "G2723 G2742 G2752 G2775 G2725 G2762";
     otherwise;
    end;
    
    /* Create ADL_help_list variable */ 
    length ADL_help_list $50;
    select(yearx);
         when (1992, 1993, 1994) ADL_help_list   = "";
         when (1995) ADL_help_list   = "D1887 D1897 D1907 D1930 D1877 D1917";
         when (1996) ADL_help_list   = "E1911 E1921 E1931 E1954 E1901 E1944";
         when (1998) ADL_help_list   = "F2426 F2447 F2457 F2480 F2431 F2470";
         when (2000) ADL_help_list   = "G2724 G2745 G2755 G2778 G2729 G2768";
         otherwise;
    end;
    
    /* Create ADL_help_list variable */ 
        length ADL_equip_list $50;
        select(yearx);
             when (1992, 1993, 1994) ADL_equip_list   = "";
             when (1995) ADL_equip_list   = "D1874 D1920";
             when (1996) ADL_equip_list   = "E1898 E1941";
             when (1998) ADL_equip_list   = "F2428 F2467";
             when (2000) ADL_equip_list   = "G2726 G2765";
             otherwise;
        end;

    /* Create IADL_diff_list variable */ 
       length IADL_diff_list $50;
       select(yearx);
            when (1992, 1993, 1994) IADL_diff_list   = "";
            when (1995) IADL_diff_list   = "D2021 D2026 D2031 D2036 D2099";
            when (1996) IADL_diff_list   = "E2036 E2041 E2046 E2051 E2093";
            when (1998) IADL_diff_list   = "F2562 F2567 F2572 F2577 F2618";
            when (2000) IADL_diff_list   = "G2860 G2865 G2870 G2875 G2916";
            otherwise;
       end;
       
    /* Create IADL_help_list variable */ 
    length IADL_help_list $50;
    select(yearx);
         when (1992, 1993, 1994) IADL_help_list   = "";
         when (1995) IADL_help_list   = "D2024 D2029 D2034 D2039 D2102";
         when (1996) IADL_help_list   = "E2039 E2044 E2049 E2054 E2096";
         when (1998) IADL_help_list   = "F2565 F2570 F2575 F2580 F2620";
         when (2000) IADL_help_list   = "G2863 G2868 G2873 G2878 G2918";
         otherwise;
    end;
    
    /* Create IADL_rsn_list variable */ 
    length IADL_rsn_list $50;
    select(yearx);
         when (1992, 1993, 1994) IADL_rsn_list   = "";
         when (1995) IADL_rsn_list   = "D2023 D2028 D2033 D2038 D2100";
         when (1996) IADL_rsn_list   = "E2038 E2043 E2048 E2053 E2094";
         when (1998) IADL_rsn_list   = "F2564 F2569 F2574 F2579 F2619";
         when (2000) IADL_rsn_list   = "G2862 G2867 G2872 G2877 G2917";
         otherwise;
    end;
  
    /* Create list variables for 2002-20?? years */
    clist = upcase("hjklmnopqrstuvwxyz");
    length _tmpc $100;
    if 2002 <= yearx <= &last_hrsyr then do;
        wv = (yearx - 2000)/2;
        cx = substr(clist,wv,1);
        
        _tmpc ="@G014 @G021 @G023 @G030 @G016 @G025";
        ADL_diff_list     = translate(_tmpc, cx, "@");
        
        _tmpc ="@G015 @G022 @G024 @G031 @G020 @G029";
        ADL_help_list     = translate(_tmpc, cx, "@");
        
        _tmpc ="@G017 @G026";
	ADL_equip_list     = translate(_tmpc, cx, "@");
       
        _tmpc ="@G041 @G044 @G047 @G050 @G059";
        IADL_diff_list     = translate(_tmpc, cx, "@");
      
        _tmpc = "@G042 @G045 @G048 @G052 @G060";
        IADL_rsn_list     = translate(_tmpc, cx, "@");

        _tmpc = "@G043 @G046 @G049 @G053 @G061";
         IADL_help_list    = translate(_tmpc, cx, "@");
     end;
     drop _tmpc clist;   
    
    
    output;
  end;
run; /* data `_funcd_info` created */


/*--- Step 2c: Merge `_funcd_info` with `_temp_init` dataset ---*/

%expand_years (&years); /* auxiliary dataset `_temp1_init` created (one row per HRS study year specified in `years` argument) */

data _aux1dt;
 set _temp1_init(keep= years year_sel year yearx);
 if yearx in (1992, 1994) then year_sel = "X"; /* years  1992, 1994 will be skipped */
run;
 
data _aux2dt (keep = yearx year_idx);
  set _aux1dt;
  if year_sel = "Y" then do;
   year_idx + 1;
   output;
  end;
  drop year_sel;
run;

data _funcd_info_all;

 label years    =  "HRS years extracted from `years` macro argument";
 label year_sel =  "Indicates whether given year was selected for processing";
 label year_idx =  "Index in the MAIN loop";
 label year     =  "HRS year <$4>";
 label yearx    =  "HRS year <numeric>";
 merge _funcd_info _aux1dt _aux2dt 
 ;
 by yearx;
run;

%if &test_mode = Yes %then %do;
 data &outinfo (label = "Datainfo for `funcd` macro. Input library: &libin");
   set _funcd_info_all;
 drop yearx libin hrs wv yr2 section cx ; /* drop less important variables */
 run;
%end;

/*--- Step 2d: create `_driver_data` dataset ---*/

data _temp1x;
  set _funcd_info_all;
  if year_sel = "Y";  /* Keep years selected by the user in `years` macro argument */
 run;
  
data _driver_data;
  set _temp1x;
  /*--- Additional auxiliary variables, specific for this macro can be created in this data step. Typically not needed */
  length year_list $500;
  retain year_list;
  year_list = strip(year_list) || strip(year)|| " :";  
run;

/* ==== STEP 3: MAIN LOOP ====*/

/*----- Step 3a: Create auxiliary macro variables, for example `year_no`, `year_list` (Before loop) */
%local year_no year_list;
data _null_;
   set _driver_data end = last;
   if last then do;
    call symput("year_no", strip(year_idx));  /*--- necessary statement*/
    call symput("year_list", strip(year_list)); 
   end;
run;

%put year_no := &year_no;
%put year_list := &year_list;


/* Original functional limitation variables from HRS Core interview file */
%local ADL_new_list IADL_new_list ADL_DD_new_list;

/* Newly defined ADL/IADL difficullty and ADL Don't Do variables */

%local ADL_new_list IADL_new_list ADL_DD_new_list;
%let ADL_new_list = dress_ADL bathe_ADL eat_ADL toilet_ADL walk_ADL bed_ADL;
%let IADL_new_list = meal_IADL groc_IADL phone_IADL medicine_IADL money_IADL;
%let ADL_DD_new_list = dress_DD bathe_DD eat_DD toilet_DD walk_DD bed_DD;

%_trace_loopinit;  /* Initialize trace of macro execution */

/*---  Step 3b: MAIN LOOP: Extract and append data ----*/

%put ============= Main loop <year_idx =1 to &year_no> executed. Test mode = &test_mode=======;


%do year_idx = 1 %to &year_no;  /* LOOP idx.  One year is processed at a time.*/


/* --- Step 3b: Extract info from `_driver_data` dataset ---- */
 %local year datain umacro wv cx;
 %local ADL_diff_list ADL_help_list ADL_equip_list IADL_diff_list IADL_rsn_list IADL_help_list;
 data _null_;
    do anl_idx=&year_idx;
       set _driver_data  point=anl_idx;
  
  /* Macro variables needed to execute main loop iteration step <START>*/
       call symput("year", strip(year));       /* Extract year */
       call symput("umacro", strip(umacro));   /* Extract macro name */
       call symput("datain", strip(datain));   /* Extract input data name */
       call symput("wv",    strip(wv));        /* Extract wave */
       call symput("cx",    strip(cx));        /* Extract auxiliary variable */
       call symput("ADL_diff_list",  strip(ADL_diff_list));       
       call symput("ADL_help_list",  strip(ADL_help_list));       
       call symput("ADL_equip_list", strip(ADL_equip_list));       
       call symput("IADL_diff_list",  strip(IADL_diff_list));       
       call symput("IADL_help_list",  strip(IADL_help_list));       
       call symput("IADL_RSN_list", strip(IADL_RSN_list));
  /* Macro variables needed to execute main loop iteration step <END>*/
    stop;
    end;
  run;
  
  /* Macro variables used for a given MAIN loop iteration step*/ 
  %put --->---> year := &year (year_idx := &year_idx) ---;
  %put year := &year;
  %put umacro := &umacro;
  %put datain := &datain;
  %put wv := &wv;
  %put ADL_diff_list := &ADL_diff_list;
  %put ADL_help_list := &ADL_help_list;
  %put ADL_equip_list := &ADL_equip_list;
  %put IADL_diff_list := &IADL_diff_list;
  %put IADL_help_list := &IADL_help_list;
  %put IADL_rsn_list := &IADL_rsn_list;
  %_trace_loopiter;     /* Traces execution of the main loop  */

%if &test_mode = No %then %do;
   %&umacro; /* Macro for one  HRS study year executed */ 
 
  proc append base = _funcd data= _yearoutdata;
  quit;
  
  data _null_;
   file print;
   put "Macro `&umacro` executed  at &systime." /;
  run;
  
  /* Cleanup */
  proc datasets lib = work; delete _yearoutdata;
  run;

  
%end; /* end if test_mode= No */
  
%end; /* end Loop year_idx */

%if &test_mode = No %then %do;
   proc sort data= _funcd
          out = &outdt;
          by hhid pn studyyr; 
   run;
   proc datasets lib = work; delete _funcd;
   run;
%end; /* if test_mode = No */

Title "";

%if %isBlank(&tracemd) = 0 %then %do;
  data _null_;
   file &tracemd mod;
   put "---- Macro `funcd` ended  at &systime (Test mode = &test_mode)" /;
  run;
%end;  /* if  isBlank*/
%mend funcd;
  
