/* Create global macro vars */


libname _cmplib "&fcmp_path\_cmplib"   FILELOCKWAIT=60;

%let _cmplib_info_path = &fcmp_path/_cmplib_info;

%let _fcmp_source_path = &fcmp_path/fcmp_source;

/*--- No changes in the section below -------*/
filename _macros "&fcmp_path/macros";

