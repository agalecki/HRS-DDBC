/* Create global macro vars */
/* Code below requires _cmplib path and cdir_path macro vars */ 

/* Concatenate FCMP libraries into `_ucmplib` */ 
libname ucmp1 "&_cmplib_path\Function_5g";
libname ucmp2 "&_cmplib_path\test7_DLFunction";
libname ucmp3 "&_cmplib_path\healthC_init";

libname _ucmplib (ucmp1 ucmp2 ucmp3);  




filename _tstmac "&test_fcmp_path\hrs-macros";

%let _dataout_path = &test_fcmp_path\data_out;



