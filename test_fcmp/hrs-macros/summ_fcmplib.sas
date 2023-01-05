


%macro fcmp_member_info(
  cmplib=,                /* FCMP library */
  fcmpmember = , /* FCMP member */
  printit = Y
);
options cmplib = &cmplib..&fcmpmember;
%let fcmpmember =; /* `fcmp_member` will be used instead */

%local version_date datestamp fcmp_member;
%let version_date=;
%let datestamp=;
%let fcmp_member =;
%fcmp_member_datainfo; /* Data with _label, _member, _version, _date vars created*/

proc sql noprint;
 select _version    into :version_date  separated by " "  from fcmp_member_datainfo;
 select _datestamp  into :datestamp     separated by " "  from fcmp_member_datainfo;
 select _member     into :fcmp_member   separated by " "  from fcmp_member_datainfo;
quit;


data fcmp_member_info;
 label fcmp_name ="Function/subroutine name";
 label fcmp_grp  ="Function/subroutine group";
 set &cmplib..&fcmp_member(keep=name value);
 if name in ("FUNCTION", "SUBROUTI");
 length scan1 scan2 fcmp_grp fcmp_name $200;
 scan1 = scan(strip(value),2,')');
 scan2 = scan(strip(scan1), 2,"=");
 scan2 = translate(strip(scan2),"",";");
 scan2 = translate(scan2,'','"');
 fcmp_grp = translate(scan2,'',"'");
 fcmp_name =scan(strip(value),2," (");
 drop scan1 scan2;
run;

proc sort data = fcmp_member_info;
by fcmp_grp;
run;

/* Conditionally prints info datasets */ 
%if &printit =Y %then %do;
 Title "FCMP member:  &fcmp_member..";
 Title2 "Version date: &version_date.. Compiled on &datestamp..";
 proc print data = fcmp_member_info; 
 by fcmp_grp;
 run;
 %end;
%mend fcmp_member_info;

