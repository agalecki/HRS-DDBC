proc format;
        value yn_fmt
                 0='No'
                 1='Yes';
  	value gender_fmt 
  	        1='Male' 
  	        2='Female';
   	value race_fmt 
   	        1='White/Caucasian' 
   	        2='Black/African American'
   	        3='Other';
   	value hispanic_fmt
   	        0='Not Hispanic'
   	        1='Hispanic';
   	value bplace_fmt 
   	        1='New England' 
   	        2='Mid Atlantic' 
   	        3='EN Central'
		4='WN Central'
		5='S Atlantic'
		6='ES Central'
		7='WS Central' 
		8='Mountain' 
		9='Pacific'
		10='US/NA Division' 
		11='Not US/inc US terr';
 	value mstat_fmt 
 	        1='Married' 
 	        2='Married,spouse absent' 
 	        3='Partnered'
 	        4='Separated' 
 	        5='Divorced' 
 	        6='Separated/divorced'
		7='Widowed'
		8='Never married';
	value cpl_fmt 
	        0='Not a couple HH' 
	        1='Couple HH';
	value edegrm_fmt
	        0='No degree'
	        1='GED' 
	        2='HS' 
	        3='HS/GED' 
	        4='AA/Lt BA'
		5='BA' 
		6='MA/MBA' 
		7='Law/MD/PhD' 
		8='Other';
	value cohort_fmt 
	        0='Hrs/Ahead ovrlap' 
	        1='Ahead' 
	        2='Coda' 
	        3='Hrs'
		4='WarBabies' 
		5='Early BabyBoomers' 
		6='Mid BabyBoomers' 
		7='Late BabyBoomers';
	value sayret_fmt 
	        0='Not retired' 
	        1='Completely retired'
		2='Partly retired' 
		3='Question irrelevant';
	value retemp_fmt 
	        0='No retire empstat'
	        1='Only retire empstat' 
		2='Retire plus other empstat';
	value work_fmt 
	        0='Not working for pay'
	        1='Working for pay';
	value slfemp_fmt 
	        0='Not self-employed' 
	        1='Self-employed';
	value lbrf_fmt
	        1='Works FT'
	        2='Works PT' 
	        3='Unemployed' 
	        4='Partly retired'
		5='Retired'
		6='Disabled'
		7='Not in LbrF';
value proxy_fmt
			0='Not proxy'
			1='Proxy';
	value iwstat_fmt
			0='Inap.'
			1='Resp,alive'
			4='NR,alive'
			5='NR,died this wv'
			6='NR,died prev wv'
			7='NR,dropped from samp'
			9='NR,DK if alive or died';

   value hlthrte_fmt
   			1='EXCELLENT'
			2='VERY GOOD'
			3='GOOD'
			4='FAIR'
			5='POOR';   		
   value hlthrtecomp_fmt
			1='BETTER'
			2='ABOUT SAME'
			3='WORSE';
   value incondlm_fmt
   			31='EVERY DAY';
   value eyerate_fmt
   			1='EXCELLENT'
			2='VERY GOOD'
			3='GOOD'
			4='FAIR'
			5='POOR'
			6='[VOL] LEGALLY BLIND';
   value eyedistv_fmt
   			1='EXCELLENT'
			2='VERY GOOD'
			3='GOOD'
			4='FAIR'
			5='POOR';
   value eyernearv_fmt
   			1='EXCELLENT'
			2='VERY GOOD'
			3='GOOD'
			4='FAIR'
			5='POOR';
   value eyecat_surg2_fmt
   			1='ONE EYE ONLY'
			2='BOTH EYES';
   value hearrate_fmt
   			1='EXCELLENT'
			2='VERY GOOD'
			3='GOOD'
			4='FAIR'
			5='POOR';		
run;

%macro sociodemo_fmts;
  format gender gender_fmt. 
         race race_fmt. 
         hispanic hispanic_fmt. 
         bplace bplace_fmt. 
         mstat mstat_fmt.
         cpl cpl_fmt. 
         edegrm edegrm_fmt. 
         cohort cohort_fmt.
         sayret sayret_fmt.
         retemp retemp_fmt.
         work work_fmt.
         slfemp slfemp_fmt.
         lbrf lbrf_fmt.;
%mend sociodemo_fmts;

%macro funcd_fmts;
format dress_ADL yn_fmt. 
       bathe_ADL yn_fmt. 
       eat_ADL yn_fmt. 
       toilet_ADL yn_fmt. 
       walk_ADL yn_fmt. 
       bed_ADL yn_fmt.
       meal_IADL yn_fmt.
       groc_IADL yn_fmt.
       phone_IADL yn_fmt.
       medicine_IADL yn_fmt. 
       money_IADL yn_fmt.
       dress_DD yn_fmt.
       bathe_DD yn_fmt.
       eat_DD yn_fmt. 
       toilet_DD yn_fmt. 
       walk_DD yn_fmt. 
       bed_DD yn_fmt.;
%mend funcd_fmts;

%macro health_fmts;
 format hlthrte hlthrte_fmt.
        hlthrtecomp hlthrtecomp_fmt. 
	bloodp yn_fmt. 
	bloodprx yn_fmt.
	bloodplwgt yn_fmt. 
	bloodpcont yn_fmt.
        diabetes yn_fmt.
        diabswa yn_fmt.
        diabins yn_fmt.
        diablstwgt yn_fmt.
        diabdiet yn_fmt.
        diabcont yn_fmt.
        diabkidney yn_fmt.
        cancer yn_fmt.
        cancerdr yn_fmt.
        cancertrt yn_fmt.
        chemomed yn_fmt. 
        surgbiop yn_fmt. 
        RadiXray yn_fmt. 
        meditrt yn_fmt.
	cannotrt yn_fmt.
	othertrt yn_fmt.
	cancernew yn_fmt.
      	lung yn_fmt.
      	lungrx yn_fmt.
      	lungoxy yn_fmt.
      	lungthpy yn_fmt.
      	lungacti yn_fmt.
	heart yn_fmt.
	heartrx yn_fmt.
	heartdr yn_fmt.
	heartatt yn_fmt.
	hrtattrx yn_fmt.
	angina yn_fmt.
	anginarx yn_fmt. 
        anglimit yn_fmt.
        chf yn_fmt.
        chfhosp yn_fmt.
        chfrx yn_fmt.
        hrttrt yn_fmt.
        hrtsurg yn_fmt.
	stroke yn_fmt.
	strokedr yn_fmt.
	strokepr yn_fmt.
	strokwek yn_fmt.
	strokspk yn_fmt.
	strokvis yn_fmt.
	strokthk yn_fmt.
        strokrx yn_fmt.
        strokthp yn_fmt.
        strokoth yn_fmt.
	psychiat yn_fmt.
	psythrpy yn_fmt. 
	psyrx	yn_fmt.
	arthrit yn_fmt.
	arthstif yn_fmt.
	arthrx yn_fmt.
	arthlimit yn_fmt.
	arthjrepl yn_fmt.
	fall yn_fmt.
	fallinju yn_fmt.
	fallbhip yn_fmt.
	incontin yn_fmt. 
	incondlm incondlm_fmt.
	incondk1 yn_fmt. 
	incondk2 yn_fmt. 
	inconpad yn_fmt.
	eyerate eyerate_fmt.
	eyedistv eyedistv_fmt.
	eyernearv eyernearv_fmt. 
	eyecat_surg yn_fmt.
	eyecat_surg2 eyecat_surg2_fmt.
	eyecat_imp yn_fmt. 
	eye_glauc yn_fmt.
	hearrate hearrate_fmt.;
%mend health_fmts;
