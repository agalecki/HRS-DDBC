
options mprint nocenter;

%let fcmp_path = .;     /* Path to fcmp folder */


* libname out "S:\Jin\DDBC\program\Version-2022-10-28\fcmp\"   FILELOCKWAIT=60;
libname out "&fcmp_path\_cmplib"   FILELOCKWAIT=60;

%*let x = S:\Jin\DDBC\program\Version-2022-10-28\fcmp\fcmp_source;


%let DLfunction_info = DLfunction( 
          _binder 
          _auxiliary 
          adldiff_grp 
          adlhlp_grp 
          equip_grp
          iadldiff_grp
          iadlhlp_grp
          skip_grp
          why_grp 
          subhh_grp
);



/*--- No changes below */
%*** let source_info = &DLfunction_info;  /* Subfolder name */
%macro create_fcmp_lib(source_info);
%let cmplib_name = %scan(&source_info, 1, "(");    /* Ex. DLfunction */
%let fcmp_funs = %scan(&source_info, 2, "()");      /* Ex. _binder _auxiliary ... */
%let fcmp_src = &fcmp_path/src/&cmplib_name;       /* Ex.  ./src/DLFunction */

filename _source  "&fcmp_src";                     /* Ex.  filename _source './src/DLfunction' */
%let _source_info = _source(&fcmp_funs);
%put  _source_info = &_source_info;

proc datasets library = out;
delete &cmplib_name;
run;
quit;

proc fcmp outlib = out.&cmplib_name..all; /* 3 level name */

%include &_source_info;

run;
quit; /* FCMP */

data dt;
 label fcmp_name ="Function/subroutine name";
 label fcmp_grp  ="Function/subroutine group";
 set out.&cmplib_name(keep=name value);
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

proc sort data=dt;
by fcmp_grp;
run;
ods listing close;
%let html_path = &fcmp_path/html/&cmplib_name..html;
ods html file = "&html_path";

Title "List of funs/subs in &cmplib_name library";
proc print data=dt;
by fcmp_grp;
run;
ods html close;
%mend create_fcmp_lib;

%create_fcmp_lib(&DLfunction_info);
