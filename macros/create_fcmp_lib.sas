%macro create_fcmp_lib(cmplib_name);
%* cmplib_name.  Ex. DLfunction;
%* fcmp_path  (global) Ex. .;

filename _common "&fcmp_path/src/_common_fcmp";


%let fcmp_src_path = &fcmp_path/src/&cmplib_name;       /* Ex.  ./src/DLFunction */
%filenamesInFolder(&fcmp_src_path);  /* Dataset `_filenames` created */
%let fcmp_files =;      /* Ex. _binder _auxiliary ... */
data _filenames;
  length filenames $5000;
  set _filenames end = last;
  retain filenames;
  if upcase(scan(fname, 2, ".")) = "SAS" then do;
  filenames = strip(filenames) || " " || strip(fname);
  end;
  if last then call symput("fcmp_files", strip(filenames));
run;
%put fcmp_files := &fcmp_files;


filename _source  "&fcmp_src_path";                     /* Ex.  filename _source './src/DLfunction' */
%let _source_info = _source(&fcmp_files);
%put  _source_info = &_source_info;

proc datasets library = _libout;
delete &cmplib_name;
run;
quit;

proc fcmp outlib = _libout.&cmplib_name..all; /* 3 level name */
%include _common(&_common_fcmp_files);
%include &_source_info;

run;
quit; /* FCMP */

data dt;
 label fcmp_name ="Function/subroutine name";
 label fcmp_grp  ="Function/subroutine group";
 set _libout.&cmplib_name(keep=name value);
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
