

options mprint nocenter;

%let fcmp_path = .;     /* !!! Path to fcmp folder */
libname _cmplib "&fcmp_path\_cmplib"   FILELOCKWAIT=60;

/*--- No changes in the section below -------*/
filename macros "&fcmp_path/macros";
%include macros(summ_vin summ_vout);  

/* process FCMP cmplib (source in src folder)*/


%summ_vout(dlfunction);







































































































































































































































































































































































function);
%*summary_cmplib(healthC);
