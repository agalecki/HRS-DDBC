/* Create global macro vars */
/* Code below requires _cmplib path and cdir_path macro vars */    

libname _cmplib "&_cmplib_path"   FILELOCKWAIT=60;


filename _tstmac "&test_fcmp_path\hrs-macros";

%let _dataout_path = &test_fcmp_path\data_out;



