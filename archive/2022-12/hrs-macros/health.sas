/***************************************************************************************
 Name: Functional limitation from 1993 to 2018
***************************************************************************************/
options mprint;

%macro health(years, libin =, outdt =, tracemd =, 
              outinfo =, fmts = health_fmts, dtin_macro =, last_hrsyr = 2018
);
/* health Macro to create ADL and IADL variables for selected years */

/* PATH OF HRS CORE DATA FILES 
   NOTE: 1. Functional Limitations and Helpers (Respondent) files.
	     Year 1993: Section BR21
             Year 1995: Section A_R
             Year 1996 ~ 2000: Section E_R
	     Year 2002 ~ : Section G_R 
	     Year 1992 and 1994 not available.
*/
%local _macro_version;
%let _macro_version = 2022-04-27;

/*---- Auxiliary macros defined <START> ----*/
/* https://support.sas.com/resources/papers/proceedings09/022-2009.pdf */


%macro _check_args_putstmnts;
/*--- Contains put statements to be used by `_check_macroargs` macro:  START --- */
 
   put "#  Macro health (&sysdate)" /;
   put "* This file contains information about the execution of `health` macro";
   put "* Macro `health` (Version &_macro_version) was executed on &sysdate at &systime";
   put "* Macro `health` can be executed in one of the two modes: _test_ or _regular_ mode";
   Put "* Execution mode of the `health` is determined based on the value of the `outinfo` argument"; 
   put "   - By default the `outinfo` argument is blank and the `health` macro is executed in a _regular_ mode";
   put "   - If the `outinfo` argument is not blank  the `health` macro is executed in a _test_ mode";
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
   put "| Macro with format statements | `fmts`        | &fmts           " @p "| Optional   | `health_fmts`    |";
   put "| Dtin macro                   | `dtin_macro`  | &dtin_macro     " @p "| Optional   | Blank            |";
   put "| Last HRS year                | `last_hrsyr`  | &last_hrsyr     " @p "| Optional   | `2018`           |";
   put;

   put "Notes pertaining to main macro execution mode:" /;
   _tmp1 = upcase(strip("&test_mode"));
   if   _tmp1 = "YES" then do;
     put "* Macro argument `outinfo` is not blank.";
     put "* Macro `health` is executed in a _TEST_ mode.";
     put "* Information about `health` macro execution is stored in `&outinfo` dataset";
     put "* Dataset specified in `outdt` argument will not be created";
     put "* The macro will check whether input datasets needed for execution exist in `&libin` input library or not"; 
     put;
   end;
   if   _tmp1 = "NO" then do;
        put "* Macro argument `outinfo` is blank";
        put "* ... Macro `health` is executed in a _REGULAR_ mode.";
        put "* Dataset specified in `outdt` argument will be created";
   end;
/*--- Contains put statements END --- */
%mend _check_args_putstmnts;
  
%macro _check_macroargs;

/* Auxiliary macro to provide info on macro arguments */
Title "Macro health (&sysdate)";
ods proclabel = "Macro health (&sysdate)";
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
   
   p = 130; /* Column pointer control position */ *<-Jin;
   /*   ----5----0----5---20----5---30----5---40----5---50----5---60----5---70 */
   put "| List of vars          | Variable names       " @p "|";
   put "| :---------------      | :-------             " @p "|";
   put "| Health Rate vars      | &hlthrte_new_list    " @p "|";
   put "| Blood Pressure vars   | &bloodp_new_list     " @p "|";
   put "| Diabetes vars         | &diabetes_new_list   " @p "|";
   put "| Cancer vars           | &cancer_new_list     " @p "|";
   put "| Cancer treatment vars | &cancer_trt_new_list " @p "|";
   put "| Lung vars          	| &lung_new_list       " @p "|";
   put "| Heart Disease vars	| &heart_new_list 	   " @p "|";
   put "| Stroke vars			| &stroke_new_list     " @p "|";
   put "| Psychiatric vars		| &psy_new_list        " @p "|";
   put "| Arthritis vars		| &arthrit_new_list    " @p "|";
   put "| Falls vars			| &fall_new_list       " @p "|";
   put "| Incontinence vars		| &incontin_new_list   " @p "|";
   put "| Vision vars			| &eye_new_list        " @p "|";
   put "| Hearing vars			| &hear_new_list       " @p "|";
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
   
   
   p =  125; /* Column pointer control position */ *<-Jin;
   /*   ----5----0----5---20----5---30----5---40----5---50----5---60----5---70 */
  
   put "| Description             | Name             |   Value          " @p "|";
   put "| :---------------        | :-------         | :-----           " @p "|";
   put "| Input library           | `libin`          | &libin           " @p "|";
   put "| Input dataset           | `datain`         | &datain          " @p "|";
   put "| Auxiliary variable      | `wv`             | &wv              " @p "|";
   put "| Auxiliary variable      | `cx`             | &cx              " @p "|";
   put "| Health Rate vars		  |	`hlthrte_list`   | &hlthrte_list	" @p "|";
   put "| Blood Pressure vars     | `bloodp_list`    | &bloodp_list	    " @p "|";
   put "| Diabetes vars			  | `diabetes_list`  | &diabetes_list	" @p "|";
   put "| Cancer vars			  | `cancer_list`    | &cancer_list		" @p "|"; 
   put "| Cancer treatment vars	  | `cancer_trt_list`| &cancer_trt_list " @p "|";
   put "| Lung vars				  | `lung_list`		 | &lung_list       " @p "|";
   put "| Heart Disease vars	  | `heart_list`     | &heart_list      " @p "|";
   put "| Stroke vars			  |	`stroke_list`    | &stroke_list     " @p "|";
   put "| Psychiatric vars		  | `psy_list`       | &psy_list        " @p "|";
   put "| Arthritis vars		  | `arthrit_list`	 | &arthrit_list    " @p "|";
   put "| Falls vars			  | `fall_list`		 | &fall_list       " @p "|";
   put "| Incontinence vars		  | `incontin_list`	 | &incontin_list   " @p "|";
   put "| Vision vars			  | `eye_list`       | &eye_list        " @p "|";
   put "| Hearing vars		      | `hear_list`      | &hear_list       " @p "|";
   put "| Loop macro              | `umacro`         | &umacro          " @p "|";
   put;
   
   put "Notes related to processing year &year:" /;
   put "* Input dataset `&datain` &dtin_msg";
   put "* Auxiliary variables `wv` and `cx` are blank for years <= 2000";
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

%macro YN(var_old, var_new); 
  /*1.Yes, 5.No*/
  &var_new. = &var_old.;

  if studyyr = 1992 then do;
  	if &var_old. in (1) then &var_new. = 1; 		
  	else if &var_old. in (5) then &var_new. = 0; 
  	else if &var_old. in (0, .) then &var_new. = .; end;

  if studyyr = 1993 then do;
  	if &var_old. in (1) then &var_new. = 1; 	
  	else if &var_old. in (5) then &var_new. = 0; 
  	else if &var_old. in (.D,.R) then &var_new. = .; end;   

  if studyyr = 1994 then do;
  	if &var_old. in (1) then &var_new. = 1;			
  	else if &var_old. in (0,5) then &var_new. = 0; 		   /*0.Inap.*/
  	else if &var_old. in (8,9, .) then &var_new. = .; end; /*8.Don't Know; DK, 9.Refused; RF*/

  if studyyr in (1995, 1996, 1998) then do;
  	if &var_old. in (1,2) then &var_new. = 1;			   /*2.[VOL] POSSIBLE OR TIA for 1995 STROKE*/
  	else if &var_old. in (3,5) then &var_new. = 0;		   /*3.[VOL] DISPUTES PREVIOUS WAVE RECORD*/
  	else if &var_old. in (7,8,9, .) then &var_new. = .; end; /*7.Other; 8.Don't Know; DK, 9.Refused; RF*/

  if 2000 <= studyyr <= 2016 then do;
    if &var_old. in (1,3) then &var_new. = 1; 			   /*3.DISPUTES PREVIOUS WAVE RECORD, BUT NOW HAS CONDITION*/			
  	else if &var_old. in (4,5) then &var_new. = 0; 		   /*4.DISPUTES PREVIOUS WAVE RECORD, DOES NOT HAVE CONDITION*/
  	else if &var_old. in (8,9, .) then &var_new. = .; end; /*8.Don't Know; DK, 9.Refused; RF*/

  if 2018 <= studyyr then do;
    if &var_old. in (1,3) then &var_new. = 1; 			   /*3.DISPUTES PREVIOUS WAVE RECORD, BUT NOW HAS CONDITION*/			
  	else if &var_old. in (4,5,6) then &var_new. = 0; 	   /*4.DISPUTES PREVIOUS WAVE RECORD, DOES NOT HAVE CONDITION*/
														   /*6.[HAD the condition, BUT DO NOT HAVE IT NOW AND AM NOT TAKING MEDICATION FOR IT]*/
  	else if &var_old. in (8,9,98,99,.) then &var_new. = .; end; /*8,98.Don't Know; DK, 9,99.Refused; RF*/
%mend;

%macro _health_sub;
data _yearoutdata(keep = hhid pn studyyr
						 &hlthrte_new_list &bloodp_new_list &diabetes_new_list
						 &cancer_new_list &cancer_trt_new_list
						 &lung_new_list &heart_new_list &stroke_new_list &psy_new_list &arthrit_new_list
						 &fall_new_list &incontin_new_list &eye_new_list &hear_new_list);
set &libin..&datain;    /*--- &hrs.&yr.&section._r */
studyyr= &year;  /* &year1 */

/* Health Rate */
array hl{*} &hlthrte_list.;
array hl_new{*} &hlthrte_new_list.;
 hl_new{1} = hl(1); if hl(1) in (7,8,9,.,.D) then hl_new(1) = .;
 if studyyr in (1992, 1994) then do;
  hl_new(2) = 1*(hl(2) in (1,2)) + 2*(hl(2) = 3) + 3*(hl(2) in (4,5));
  if hl(2) in (8,9,0,.) then hl_new(2) = .; end;
 else if studyyr = 1993 then do; 
  hl_new(2) = 1*(hl(2) = 1) + 2*(hl(2) = 3) + 3*(hl(2) = 5);
  if hl(2) in (.,.D,.R) then hl_new(2) = .; end;
 else if studyyr not in (1992,1993,1994) then do;
  hl_new{2} = hl(2); if hl(2) in (7,8,9,.,.D) then hl_new(2) = .; end;

/* Blood pressure */
array bp{*} &bloodp_list.;
array bp_new{*} &bloodp_new_list.;
 do i = 1 to 4; %YN(bp(i), bp_new(i)); end;

/* Diabetes */
array di{*} &diabetes_list.;
array di_new{*} &diabetes_new_list.;
 do i = 1 to 7; %YN(di(i), di_new(i)); end;

/* Cancer */
array ca{*} &cancer_list.;
array ca_new{*} &cancer_new_list.;
 do i = 1 to 4; %YN(ca(i), ca_new(i)); end;
 ca_new(5) = ca(5); if ca(5) in (9997, 9998, 9999, 0, .) then ca_new(5) = .;

array ca_t{*} &cancer_trt_list.;
array ca_t_new{*} &cancer_trt_new_list.;
if studyyr = 1992 then do; 
  chemomed = (ca_t(1) = 1 or ca_t(2) = 1);  
  surgbiop = (ca_t(3) = 1 or ca_t(4) = 1);
  RadiXray = (ca_t(5) = 1 or ca_t(6) = 1); 
  othertrt = (ca_t(7) = 1 or ca_t(8) = 1);
  cannotrt = (ca_t(1) = 6 or ca_t(2) = 6);
  if ca(1) = 5 then do; 
  chemomed =.; surgbiop =.; RadiXray =.; meditrt =.; cannotrt =.; othertrt =.; end; end;

if studyyr = 1993 then do;
*1.  CHEMOTHERAPY OR MEDICATION
 2.  SURGERY OR BIOPSY
 3.  RADIATION/ X-RAY
 4.	 OTHER (SPECIFY)
 6.  NONE
 .D .R;
 do i = 1 to dim(ca_t);
 ca_t_new(1) = 1*(ca_t(i) = 1); ca_t_new(2) = 1*(ca_t(i) = 2);
 ca_t_new(3) = 1*(ca_t(i) = 3); ca_t_new(5) = 1*(ca_t(i) = 6);
 ca_t_new(6) = 1*(ca_t(i) = 4);
 end; 
 if ca(1) in (.D,.R,.) & ca(2) in (.D,.R,.) & ca(3) in (.D,.R,.) & ca(4) in (.D,.R,.) then do; 
 chemomed =.; surgbiop =.; RadiXray =.; meditrt =.; cannotrt =.; othertrt =.; end; end;

if studyyr = 1994 then do;
*1.  CHEMOTHERAPY OR MEDICATION
 2.  SURGERY OR BIOPSY
 3.  RADIATION/ X-RAY
 6.  NONE
 7.  OTHER (SPECIFY)
 8.  DK, NA
 9.  RF
 0.  Inap.;
 do i = 1 to 14;
 ca_t_new(1) = 1*(ca_t(i) = 1); ca_t_new(2) = 1*(ca_t(i) = 2);
 ca_t_new(3) = 1*(ca_t(i) = 3); ca_t_new(5) = 1*(ca_t(i) = 6); 
 ca_t_new(6) = 1*(ca_t(i) = 7);
 end; 
 if ca_t(1) in (0,8,9) & ca_t(2) in (0,8,9) & ca_t(3) in (0,8,9) & ca_t(4) in (0,8,9) & ca_t(5) in (0,8,9) &
    ca_t(6) in (0,8,9) & ca_t(7) in (0,8,9) & ca_t(8) in (0,8,9) & ca_t(9) in (0,8,9) & ca_t(10) in (0,8,9) &
    ca_t(11) in (0,8,9) & ca_t(12) in (0,8,9) & ca_t(13) in (0,8,9) & ca_t(14) in (0,8,9) then do; 
 chemomed =.; surgbiop =.; RadiXray =.; meditrt =.; cannotrt =.; othertrt =.; end; end;

 if 1995 <= studyyr <= 2000 then do;
*1.  CHEMOTHERAPY OR MEDICATION
 2.  SURGERY OR BIOPSY
 3.  RADIATION/ X-RAY
 4.  MEDICATIONS/TREATMENT FOR SYMPTOMS (PAIN, NAUSEA, RASHES)
 5.  NONE
 7.  OTHER (SPECIFY)
 8.  DK, NA
 9.  RF;
 do i = 1 to dim(ca_t);
 if ca_t(i) = 1 then ca_t_new(1) = 1; 
 else if ca_t(i) = 2 then ca_t_new(2) = 1;
 else if ca_t(i) = 3 then ca_t_new(3) = 1;
 else if ca_t(i) = 4 then ca_t_new(4) = 1;
 else if ca_t(i) = 5 then ca_t_new(5) = 1;
 else if ca_t(i) = 7 then ca_t_new(6) = 1;
 else if ca_t(i) in (.,8,9) then ca_t(i) = 9;
 end; 
 if sum(of &cancer_trt_list.) = 9*dim(ca_t) then do;
 chemomed =.; surgbiop =.; RadiXray =.; meditrt =.; cannotrt =.; othertrt =.; end;
 if sum(of &cancer_trt_new_list.) >= 1 then
 do i = 1 to 6;
 if ca_t_new(i) = . then ca_t_new(i) = 0;
 end; 
 end;

 if 2002 <= studyyr then do;
*1.  CHEMOTHERAPY or other therapies
 2.  SURGERY
 3.  RADIATION
 4.  MEDICATIONS/TREATMENT FOR SYMPTOMS
 5.  BIOPSY
 6.  X-RAY
 7.  OTHER (SPECIFY)
 8.  NONE
 98.  DK, NA
 99.  RF;
  do i = 1 to dim(ca_t);
 if ca_t(i) = 1 then ca_t_new(1) = 1; 
 else if ca_t(i) in (2,5) then ca_t_new(2) = 1;
 else if ca_t(i) in (3,6)then ca_t_new(3) = 1;
 else if ca_t(i) = 4 then ca_t_new(4) = 1;
 else if ca_t(i) = 8 then ca_t_new(5) = 1;
 else if ca_t(i) = 7 then ca_t_new(6) = 1;
 else if ca_t(i) in (98,99,.) then ca_t(i) = 9;
 end; 
 if sum(of &cancer_trt_list.) = 9*dim(ca_t) then do;
 chemomed =.; surgbiop =.; RadiXray =.; meditrt =.; cannotrt =.; othertrt =.; end;
 if sum(of &cancer_trt_new_list.) >= 1 then
 do i = 1 to 6;
 if ca_t_new(i) = . then ca_t_new(i) = 0;
 end; 
 end;

 /* Lung */
array lu{*} &lung_list.;
array lu_new{*} &lung_new_list.;
 do i = 1 to 5; %YN(lu(i), lu_new(i)); end;

/* Heart Disease */
array he{*} &heart_list.;
array he_new{*} &heart_new_list.;
 do i = 1 to 13; %YN(he(i), he_new(i)); end;

/* Stroke */
array st{*} &stroke_list.;
array st_new{*} &stroke_new_list.;
 do i = 1 to 10; %YN(st(i), st_new(i)); end; 
 st_new(11) = st(11); if st(11) in (0, 9997, 9998, 9999, .) then st_new(11) = .;
 st_new(12) = st(12); if st(12) in (0, 98, 99, .) then st_new(12) = .;

/* Psychiatric */
array ps{*} &psy_list.;
array ps_new{*} &psy_new_list.;
 do i = 1 to 3;
 %YN(ps(i), ps_new(i));
 end;

/* Arthritis */
array ar{*} &arthrit_list.;
array ar_new{*} &arthrit_new_list.;
 do i = 1 to 5;
 %YN(ar(i), ar_new(i));
 end;

/* Falls */
array fa{*} &fall_list.;
array fa_new{*} &fall_new_list.;
 do i = 1,3,4;
 %YN(fa(i), fa_new(i));
 end;
 fa_new(2) = fa(2); if fa(2) in (98, 99, 997, 998, 999, .) then fa_new(2) = .;	

/* Incontinence */
array ic{*} &incontin_list.;
array ic_new{*} &incontin_new_list.;
 do i = 1,3 to 5;
 %YN(ic(i), ic_new(i));
 end;
 ic_new(2) = ic(2); if ic(2) in (95, 97, 98, 99,.) then ic_new(2) = .;
 if incontin = 1 and incondlm ne . then do;
	incondk1 = 1*(5 < incondlm); 
    incondk2 = 1*(15 < incondlm); end;
 if studyyr = 1993 and incondlm = 30 then incondlm = 31;

/* Vision */
array ey{*} &eye_list.;
array ey_new{*} &eye_new_list.;
 do i = 1 to 3, 5;
 ey_new(i)=ey(i); if ey(i) in (7,8,9,.,.D,.R) then ey_new(i) = .;
 end;
 do i = 4,6,7;
 %YN(ey(i), ey_new(i));
 end;

/* Hearing */
array hr{*} &hear_list.;
array hr_new{*} &hear_new_list.;
 hr_new(1)=hr(1); if hr(1) in (7,8,9,.,.D,.R) then hr_new(1) = .;

/* statements from `dtin_macro` conditionally inserted */
%if %isBlank(&dtin_macro) = 0 %then %dtin_macro;; /*--- User defined macro is invoked */
   
run;
%mend _health_sub;

/*---- Auxiliary macros defined <END> ----*/

/*==== Macro  execution starts here */

/*---  Step 1: Initialize output dataset */

data _health (label = "Functional ADL/IADL variables: <&years>");
label hhid         ="HOUSEHOLD IDENTIFIER"
      pn           ="PERSON NUMBER"
      studyyr      ="STUDY YEAR"  
	  hlthrte 		="RATE HEALTH (1-5)"
      hlthrtecomp 	="COMPARE HEALTH TO PREVIOUS WAVE (1-3)"
	  bloodp 		="HIGH BLOOD PRESSURE"
	  bloodprx 		="BLOOD PRESSURE MEDICATION"
	  bloodplwgt 	="LOST WEIGHT HIGH BLOOD PRESSURE"
	  bloodpcont	="BLOOD PRESSURE UNDER CONTROL"
      diabetes 	    ="DIABETES"
      diabswa	    ="SWALLOWED MEDICATION FOR DIABETES"
      diabins	    ="TAKING INSULIN" 
      diablstwgt 	="LOST WEIGHT TO CONTROL DIABETES"
      diabdiet 	    ="SPECIAL DIET DUE TO DIABETES"
      diabcont      ="DIABETES UNDER CONTROL"
	  diabkidney	="KIDNEY TROUBLE DUE TO DIABETES"
      cancer		="CANCER"
	  cancerdr 		="SEEN DOCTER CONCERNING CANCER"
      cancertrt 	="PAST CANCER TREATED"
	  chemomed 		="CANCER: CHEMOTHERAPY OR MEDICATION"
	  surgbiop 		="CANCER: SURGERY OR BIOPSY"
	  RadiXray 		="CANCER: RADIATION/ X-RAY"
	  meditrt 	    ="CANCER: MEDICATIONS/TREATMENT"
	  cannotrt 		="CANCER: NO TREATMENT"
      othertrt 		="CANCER: OTHER TREATMENT"
      cancernew 	="NEW CANCER EXCLUDING SKIN"
      canceryr		="YEAR RECENT CANCER"
      lung 			="LUNG DISEASE"
	  lungrx 		="LUNG MEDICATION"
	  lungoxy 		="LUNG OXYGEN"
	  lungthpy 		="LUNG RESPIRATORY THERAPY"
	  lungacti		="LUNG LIMIT ACTIVITY"
	  heart			="HEART"
	  heartrx 		="HEART MEDICATION" 
      heartdr 		="HAS R SEEN HEART DOCTOR"
      heartatt 		="HEART ATTACK"
	  hrtattrx		="HEART ATTACK MEDICATION" 
      angina 		="ANGINA"
	  anginarx 		="ANGINA MEDICATION"
	  anglimit 		="LIMIT ACTIVITIES DUE TO ANGINA"
	  chf 			="CONGESTIVE HEART FAILURE"
	  chfhosp 		="HOSPITALIZED DUE TO HEART FAILURE"
	  chfrx 		="CONGESTIVE HEART FAILURE MEDICATION"
	  hrttrt 		="HEART TREATMENT"
	  hrtsurg		="HEART SURGERY"
	  stroke 		="STROKE"
	  strokedr 		="R SEEN DOCTOR FOR STROKE" 
	  strokepr 		="STROKE PROBLEMS"
	  strokwek 		="WEAKNESS DUE TO STROKE"
	  strokspk 		="SPEECH/SWALLOWING DIFF. DUE TO STROKE"
	  strokvis 		="VISION DIFFICULTY DUE TO STROKE"
	  strokthk 		="DIFFICULTY THINKING DUE TO STROKE"
	  strokrx 		="STROKE MEDICATION"
	  strokthp 		="STROKE THERAPY"
	  strokoth 		="ANOTHER STROKE SINCE PREVIOUS WAVE"
	  strokyr 		="MOST RECENT STROKE-YEAR"
	  strokmo		="MOST RECENT STROKE-MONTH"
	  psychiat 		="PSYCHIATRIC PROBLEMS"
	  psythrpy 		="PSYCHIATRIC TREATMENT"
	  psyrx			="PSYCHIATRIC MEDICATION"
	  arthrit		="ARTHRITIS" 
	  arthstif 		="ARTHRITIS STIFNESS"
	  arthrx 		="ARTHRITIS MEDICATION"
	  arthlimit 	="ARTHRITIS LIMIT ACTIVITY"
	  arthjrepl		="ARTHRITIS JOINT REPLACE"
	  fall 			="FALL (Age 65+)"
	  falltime		="NUMBER TIMES FALLEN (Age 65+)"
	  fallinju 		="INJURY DUE TO FALL (Age 65+)"
	  fallbhip		="BROKEN HIP (Age 65+)"
	  incontin 		="INCONTINENCE"
	  incondlm 		="INCONTINENCE # DAYS"
	  incondk1      ="INCONTINENCE: MORE THAN 5 DAYS"
	  incondk2 		="INCONTINENCE: MORE THAN 15 DAYS"
      inconpad		="INCONTINENCE PADS"
	  eyerate 		="RATE EYESIGHT (1-6)"
      eyedistv 		="RATE DISTAL VISION (1-5)"
      eyernearv     ="RATE NEAR VISION (1-5)"
      eyecat_surg   ="CATARACT SURGERY (Age 65+)"
      eyecat_surg2 	="CATARACT SURGERY ON ONE OR BOTH EYES (Age 65+)"
	  eyecat_imp 	="CATARACT IMPLANT LENS (Age 65+)"
	  eye_glauc		="GLAUCOMA (Age 65+)"
	  hearrate		="RATE HEARING (1-5)"
;
/* Include length statements. Mandatory for character variables   */	
length hhid $6 pn $3;						/*added by Jin*/				
%if %isBlank(&fmts) = 0 %then %&fmts;; /* format statements */
   call missing(of _all_);
   stop;
;
run;

/*--- Step 2a: Unpack macro arguments and create auxiliary macro variables  ----*/

%if %isBlank(&outdt)  = 1 %then %let outdt=work._healthout;
%if %isBlank(&outinfo)= 1 %then %let test_mode = No;
%if %isBlank(&outinfo)= 0 %then %let test_mode = Yes;

%put ===  Macro `health` arguments` ===;
%put years := &years;
%put libin := &libin;
%put outdt := &outdt;
%put fmts  := &fmts;
%put outinfo := &outinfo;
%put dtin_macro := &dtin_macro;
%put test_mode := &test_mode;

%_check_macroargs;

/*--- Step 2b: Create `_health_info` dataset ---*/

data _health_info; /*-- One row per HRS study year (1992-20??)*/
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
   
   select(yearx); /*<-Jin*/
     when (1992)       		 	commnt = "Section Health"; 
     when (1993)             	commnt = "Section BR21";
	 when (1994) 			 	commnt = "Section W2B";
     when (1995,1996,1998,2000)	commnt = "Section B_R";
     otherwise               	commnt = "Section C_R"; 
   end;

  /* Define `umacro` variable 
    select(yearx);
     when (1992, 1994) umacro =  "";
     when (1993)      umacro   = "_health_1993";
     otherwise        umacro   = "_health_sub";
    end;*<-Jin*/ 
   umacro   = "_health_sub";
    
  /* Define `libin` variable 
    select(yearx);
     when (1992, 1994) libin =  "";
     otherwise         libin = "&libin";
    end;*<-Jin*/
   libin = "&libin";
        
  /* Define `fmts` variable 
      select(yearx);
       when (1992, 1994) fmts = "";
       otherwise         fmts = "&fmts";
    end;*<-Jin*/
   fmts = "&fmts";
    
    /* define auxiliary variables: hrs, section, datain */
    hrs = "h";
    if yearx = 1995 then hrs = "a";
    if yearx < 2002 then section= "b"; /*<-Jin*/
    if yearx >= 2002 then section= "c"; /*<-Jin*/
    
    datain   = strip(hrs)||strip(yr2)||strip(section)||"_r";
	if yearx = 1992 then datain = "health"; /*<-Jin*/
    if yearx = 1993 then datain = "BR21";   /*<-Jin*/
    if yearx = 1994 then datain = "w2b";    /*<-Jin*/

    /* Create hlthrte_list variable */ 
    length hlthrte_list $50;
    select(yearx);
     when (1992) hlthrte_list = "V301 V302";
	 when (1993) hlthrte_list = "V204 V208";
     when (1994) hlthrte_list = "W301 W302";
	 when (1995) hlthrte_list = "D769 D772";
	 when (1996) hlthrte_list = "E769 E772";
	 when (1998) hlthrte_list = "F1097 F1100";
	 when (2000) hlthrte_list = "G1226 G1229";
     otherwise;
    end;
   /* Create bloodp_list variable */ 
    length bloodp_list $50;
    select(yearx);
     when (1992) bloodp_list = "V325 V326 XXX XXX";
	 when (1993) bloodp_list = "V215 XXX XXX XXX";
     when (1994) bloodp_list = "W328 w329 XXX XXX";
	 when (1995) bloodp_list = "D781 D782 D783 D784";
	 when (1996) bloodp_list = "E781 E782 E783 E784";
	 when (1998) bloodp_list = "F1109 F1110 F1111 F1112";
	 when (2000) bloodp_list = "G1238 G1239 G1240 G1241";
     otherwise;
    end;
   /* Create diabetes_list variable */ 
    length diabetes_list $50;
    select(yearx);
     when (1992) diabetes_list = "V328 V335 V336 V334 V333 XXX XXX";
	 when (1993) diabetes_list = "V219 V223 V224 XXX XXX XXX XXX";
     when (1994) diabetes_list = "W333 W337 W338 W336 W335 XXX XXX";
	 when (1995) diabetes_list = "D788 D789 D790 D791 D792 D793 D795";
	 when (1996) diabetes_list = "E788 E789 E790 E791 E792 E793 E795";
	 when (1998) diabetes_list = "F1116 F1117 F1118 F1119 F1120 F1121 F1123";
	 when (2000) diabetes_list = "G1245 G1248 G1249 G1250 G1251 G1252 G1256";
     otherwise;
    end;
   /* Create cancer_list variable */
    length cancer_list $50;
    select(yearx);
     when (1992) cancer_list = "V337 V341 XXX XXX XXX";
	 when (1993) cancer_list = "V225 XXX XXX XXX XXX";
	 when (1994) cancer_list = "W339 W344 XXX W340 W342";
	 when (1995) cancer_list = "D801 D802 D803 D806 D814";
	 when (1996) cancer_list = "E801 E802 E803 E806 E814";
	 when (1998) cancer_list = "F1129 F1130 F1131 F1134 F1141";
	 when (2000) cancer_list = "G1262 G1263 G1264 G1267 G1274";
     otherwise;
    end;
    length cancer_trt_list $50;
    select(yearx);
	 when (1992) cancer_trt_list = "V342 V349 V343 V350 V344 V351 V345 V352"; 
	 when (1993) cancer_trt_list = "V232A1 V232A2 V232A3 V232A4";
	 when (1994) cancer_trt_list = "W345 W346 W347 W348 W349 W350 W351 W355 W356 W357 W358 W359 W360 W361";
	 when (1995) cancer_trt_list = "D804M1 D804M2 D804M3 D804M4";
	 when (1996) cancer_trt_list = "E804M1 E804M2 E804M3 E804M4";
	 when (1998) cancer_trt_list = "F1132M1 F1132M2 F1132M3 F1132M4";
	 when (2000) cancer_trt_list = "G1265M1 G1265M2 G1265M3 G1265M4";
 	 otherwise;
	end;
   /* Create lung_list variable */ 
    length lung_list $50;
    select(yearx);
     when (1992) lung_list = "V401 V402 XXX XXX V405";
	 when (1993) lung_list = "V235 XXX XXX XXX V238";
     when (1994) lung_list = "W362 W363 XXX XXX W366";
	 when (1995) lung_list = "D818 D823 D824 D825 D826";
	 when (1996) lung_list = "E818 E823 E824 E825 E826";
	 when (1998) lung_list = "F1146 F1151 F1152 F1153 F1154";
	 when (2000) lung_list = "G1279 G1284 G1285 G1286 G1287";
     otherwise;
    end;
   /* Create heart_list variable */ 
    length heart_list $100;
    select(yearx);
     when (1992) heart_list = "V406 XXX V414 V407 XXX V409 V410 XXX V411 XXX V412 V415 V416";
	 when (1993) heart_list = "V242 XXX XXX V244 XXX V245 XXX XXX XXX XXX XXX XXX XXX";
     when (1994) heart_list = "W368 XXX W376 W369 XXX W371 W372 XXX W373 XXX W374 W377 W378";
	 when (1995) heart_list = "D828 D829 D830 D834 D837 D840 D841 D842 D843 D844 D845 D846 D847";
	 when (1996) heart_list = "E828 E829 E830 E834 E837 E840 E841 E842 E843 E844 E845 E846 E847";
	 when (1998) heart_list = "F1156 F1157 F1158 F1162 F1165 F1168 F1169 F1170 F1171 F1172 F1173 F1174 F1175";
	 when (2000) heart_list = "G1289 G1290 G1291 G1295 G1298 G1301 G1302 G1303 G1304 G1305 G1306 G1307 G1308";
     otherwise;
    end;
   /* Create stroke_list variable */ 
    length stroke_list $100;
    select(yearx);
     when (1992) stroke_list = "V417 V420 V419 XXX XXX XXX XXX V421 XXX XXX V418 XXX";
	 when (1993) stroke_list = "V252 XXX V254 XXX XXX XXX XXX XXX XXX XXX XXX XXX";
     when (1994) stroke_list = "W379 W382 XXX XXX XXX XXX XXX W383 XXX XXX W380 XXX";
	 when (1995) stroke_list = "D848 D850 D851 D852 D853 D854 D855 D856 D857 D858 D860 D859";
	 when (1996) stroke_list = "E848 E850 E851 E852 E853 E854 E855 E856 E857 E858 E860 E859";
	 when (1998) stroke_list = "F1176 F1178 F1179 F1180 F1181 F1182 F1183 F1184 F1185 F1186 F1188 F1187";
	 when (2000) stroke_list = "G1309 G1311 G1312 G1313 G1314 G1315 G1316 G1317 G1318 G1319 G1321 G1320";
     otherwise;
    end;
   /* Create psy_list variable */ 
    length psy_list $100;
    select(yearx);
     when (1992) psy_list = "V422 V424 V425";
	 when (1993) psy_list = "V259 XXX XXX";
     when (1994) psy_list = "W384 W385 W386";
	 when (1995) psy_list = "D861 D863 D864";
	 when (1996) psy_list = "E861 E863 E864";
	 when (1998) psy_list = "F1189 F1191 F1192";
	 when (2000) psy_list = "G1322 G1324 G1325";
     otherwise;
    end;
  /* Create arthrit_list variable */ 
    length arthrit_list $100;
    select(yearx);
     when (1992) arthrit_list = "V426 V427 V428 XXX XXX";
	 when (1993) arthrit_list = "V265 XXX XXX XXX XXX";
     when (1994) arthrit_list = "W387 W388 W389 XXX XXX";
	 when (1995) arthrit_list = "D866 D869 D870 D871 D872";
	 when (1996) arthrit_list = "E866 E869 E870 E871 E872";
	 when (1998) arthrit_list = "F1194 F1197 F1198 F1199 F1200";
	 when (2000) arthrit_list = "G1327 G1330 G1331 G1332 G1333";
     otherwise;
    end;
  /* Create fall_list variable */ 
    length fall_list $100;
    select(yearx);
     when (1992) fall_list = "XXX XXX XXX XXX";
	 when (1993) fall_list = "V274 XXX V275 V277";
     when (1994) fall_list = "XXX XXX XXX XXX";
	 when (1995) fall_list = "D878 D879 D884 D887";
	 when (1996) fall_list = "E878 E879 E884 E887";
	 when (1998) fall_list = "F1206 F1207 F1212 F1215";
	 when (2000) fall_list = "G1339 G1340 G1345 G1348";
     otherwise;
    end;
  /* Create incontin_list variable */ 
    length incontin_list $100;
    select(yearx);
     when (1992) incontin_list = "XXX XXX XXX XXX XXX";
	 when (1993) incontin_list = "V282 V283 XXX XXX V284";
     when (1994) incontin_list = "XXX XXX XXX XXX XXX";
	 when (1995) incontin_list = "D892 D893 D894 D895 D896";
	 when (1996) incontin_list = "E892 E893 E894 E895 E896";
	 when (1998) incontin_list = "F1220 F1221 F1222 F1223 F1224";
	 when (2000) incontin_list = "G1353 G1354 G1355 G1356 G1357";
     otherwise;
    end;
  /* Create eye_list variable */ 
    length eye_list $100;
    select(yearx);
     when (1992) eye_list = "V450 XXX XXX XXX XXX XXX XXX";
	 when (1993) eye_list = "V288 XXX XXX V289 XXX XXX XXX";
     when (1994) eye_list = "W448 XXX XXX XXX XXX XXX XXX";
	 when (1995) eye_list = "D900 D901 D902 D903 D904 D905 D906";
	 when (1996) eye_list = "E900 E901 E902 E903 E904 E905 E906";
	 when (1998) eye_list = "F1228 F1229 F1230 F1231 F1232 F1233 F1234";
	 when (2000) eye_list = "G1361 G1362 G1363 G1364 G1365 G1366 G1367";
     otherwise;
    end;
  /* Create hear_list variable */ 
    length hear_list $100;
    select(yearx);
     when (1992) hear_list = "V453";
	 when (1993) hear_list = "V291";
     when (1994) hear_list = "W451";
	 when (1995) hear_list = "D908";
	 when (1996) hear_list = "E908";
	 when (1998) hear_list = "F1236";
	 when (2000) hear_list = "G1369";
     otherwise;
    end;
  
    /* Create list variables for 2002-20?? years */
    clist = upcase("hjklmnopqrstuvwxyz");
    length _tmpc $200; /*<-Jin*/
    if 2002 <= yearx <= &last_hrsyr then do;
        wv = (yearx - 2000)/2;
        cx = substr(clist,wv,1);
        
        
 		_tmpc ="@C001 @C002";
        hlthrte_list     = translate(_tmpc, cx, "@");

		_tmpc ="@C005 @C006 @C007 @C008";
        bloodp_list     = translate(_tmpc, cx, "@");
     
		_tmpc ="@C010 @C011 @C012 @C013 @C014 @C015 @C017";
		diabetes_list	= translate(_tmpc, cx, "@");

		_tmpc ="@C018 @C019 @C020 @C024 @C028";
		cancer_list 	= translate(_tmpc, cx, "@");
		_tmpc ="@C021m1 @C021m2 @C021m3 @C021m4 @C021m5 @C021m6 @C021m7";
		cancer_trt_list = translate(_tmpc, cx, "@");

		_tmpc ="@C030 @C032 @C033 @C034 @C035";
		lung_list 		= translate(_tmpc, cx, "@");

		_tmpc ="@C036 @C037 @C038 @C040 @C042 @C045 @C046 @C047 @C048 @C049 @C050 @C051 @C052";
		heart_list 		= translate(_tmpc, cx, "@");

		_tmpc ="@C053 @C054 @C055 @C056 @C057 @C058 @C059 @C060 @C061 @C062 @C064 @C063";
		stroke_list 	= translate(_tmpc, cx, "@");

		_tmpc ="@C065 @C067 @C068";
		psy_list = translate(_tmpc, cx, "@");

		_tmpc ="@C070 @C073 @C074 @C075 @C076";
		arthrit_list = translate(_tmpc, cx, "@");

		_tmpc ="@C079 @C080 @C081 @C082";
		fall_list = translate(_tmpc, cx, "@");

		_tmpc ="@C087 @C088 @C089 @C090 @C094";
		incontin_list = translate(_tmpc, cx, "@");

		_tmpc ="@C095 @C096 @C097 @C098 @C099 @C100 @C101";
		eye_list = translate(_tmpc, cx, "@");

		_tmpc ="@C103";
		hear_list = translate(_tmpc, cx, "@");
     end;
     drop _tmpc clist;   
    
    
    output;
  end;
run; /* data `_health_info` created */


/*--- Step 2c: Merge `_health_info` with `_temp_init` dataset ---*/

%expand_years (&years); /* auxiliary dataset `_temp1_init` created (one row per HRS study year specified in `years` argument) */
/*<-Jin
data _aux1dt;
 set _temp1_init(keep= years year_sel year yearx);
 if yearx in (1992, 1994) then year_sel = "X"; /* years  1992, 1994 will be skipped 
run;*/
 
/*data _aux2dt (keep = yearx year_idx);
  set _aux1dt;<-Jin*/
data _aux2dt (keep = years year_sel year_idx yearx year_idx);
 set _temp1_init;
  if year_sel = "Y" then do;
   year_idx + 1;
   output;
  end;
  /*drop year_sel; <-Jin*/
run;

data _health_info_all;

 label years    =  "HRS years extracted from `years` macro argument";
 label year_sel =  "Indicates whether given year was selected for processing";
 label year_idx =  "Index in the MAIN loop";
 label year     =  "HRS year <$4>";
 label yearx    =  "HRS year <numeric>";
 merge _health_info /*_aux1dt <-Jin*/ _aux2dt 
 ;
 by yearx;
run;

%if &test_mode = Yes %then %do;
 data &outinfo (label = "Datainfo for `health` macro. Input library: &libin");
   set _health_info_all;
 drop yearx libin hrs wv yr2 section cx ; /* drop less important variables */
 run;
%end;

/*--- Step 2d: create `_driver_data` dataset ---*/

data _temp1x;
  set _health_info_all;
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
%local hlthrte_new_list bloodp_new_list diabetes_new_list lung_new_list heart_new_list stroke_new_list;

/* Newly defined ADL/IADL difficullty and ADL Don't Do variables */
%let hlthrte_new_list = hlthrte hlthrtecomp;
%let bloodp_new_list = bloodp bloodprx bloodplwgt bloodpcont;
%let diabetes_new_list = diabetes diabswa diabins diablstwgt diabdiet diabcont diabkidney;
%let cancer_new_list = cancer cancerdr cancertrt cancernew canceryr;
%let cancer_trt_new_list = chemomed surgbiop RadiXray meditrt cannotrt othertrt;
%let lung_new_list = lung lungrx lungoxy lungthpy lungacti;
%let heart_new_list = heart heartrx heartdr heartatt hrtattrx angina anginarx anglimit chf chfhosp chfrx hrttrt hrtsurg;
%let stroke_new_list = stroke strokedr strokepr strokwek strokspk strokvis strokthk strokrx strokthp strokoth strokyr strokmo;
%let psy_new_list = psychiat psythrpy psyrx;
%let arthrit_new_list = arthrit arthstif arthrx arthlimit arthjrepl;
%let fall_new_list = fall falltime fallinju fallbhip;
%let incontin_new_list = incontin incondlm incondk1 incondk2 inconpad;
%let eye_new_list = eyerate eyedistv eyernearv eyecat_surg eyecat_surg2 eyecat_imp eye_glauc;
%let hear_new_list = hearrate;

%_trace_loopinit;  /* Initialize trace of macro execution */

/*---  Step 3b: MAIN LOOP: Extract and append data ----*/

%put ============= Main loop <year_idx =1 to &year_no> executed. Test mode = &test_mode=======;


%do year_idx = 1 %to &year_no;  /* LOOP idx.  One year is processed at a time.*/


/* --- Step 3b: Extract info from `_driver_data` dataset ---- */
 %local year datain umacro wv cx;
 %local hlthrte_list bloodp_list diabetes_list cancer_list cancer_trt_list lung_list 
		heart_list stroke_list psy_list arthrit_list fall_list
        incontin_list eye_list hear_list;
 data _null_;
    do anl_idx=&year_idx;
       set _driver_data  point=anl_idx;
  
  /* Macro variables needed to execute main loop iteration step <START>*/
       call symput("year", strip(year));       /* Extract year */
       call symput("umacro", strip(umacro));   /* Extract macro name */
       call symput("datain", strip(datain));   /* Extract input data name */
       call symput("wv",    strip(wv));        /* Extract wave */
       call symput("cx",    strip(cx));        /* Extract auxiliary variable */
 	   call symput("hlthrte_list", strip(hlthrte_list));
	   call symput("bloodp_list", strip(bloodp_list));
	   call symput("diabetes_list", strip(diabetes_list));
	   call symput("cancer_list", strip(cancer_list));
	   call symput("cancer_trt_list", strip(cancer_trt_list));
	   call symput("lung_list", strip(lung_list));
	   call symput("heart_list", strip(heart_list));
	   call symput("stroke_list", strip(stroke_list));
	   call symput("psy_list", strip(psy_list));
	   call symput("arthrit_list", strip(arthrit_list));
	   call symput("fall_list", strip(fall_list));
	   call symput("incontin_list", strip(incontin_list));
	   call symput("eye_list", strip(eye_list));
	   call symput("hear_list", strip(hear_list));
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
  %put hlthrte_list := &hlthrte_list;
  %put bloodp_list := &bloodp_list;
  %put diabetes_list := &diabetes_list;
  %put cancer_list := &cancer_list cancer_trt_list := &cancer_trt_list;
  %put lung_list := &lung_list;
  %put heart_list := &heart_list;
  %put stroke_list := &stroke_list;
  %put psy_list := &psy_list;
  %put arthrit_list := &arthrit_list;
  %put fall_list := &fall_list;
  %put incontin_list := &incontin_list;
  %put eye_list := &eye_list;
  %put hear_list := &hear_list;
  %_trace_loopiter;     /* Traces execution of the main loop  */

%if &test_mode = No %then %do;
   %&umacro; /* Macro for one  HRS study year executed */ 
 
  proc append base = _health data= _yearoutdata;
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
   proc sort data= _health
          out = &outdt;
          by hhid pn studyyr; 
   run;
   proc datasets lib = work; delete _health;
   run;
%end; /* if test_mode = No */

Title "";

%if %isBlank(&tracemd) = 0 %then %do;
  data _null_;
   file &tracemd mod;
   put "---- Macro `health` ended  at &systime (Test mode = &test_mode)" /;
  run;
%end;  /* if  isBlank*/
%mend health;
  

