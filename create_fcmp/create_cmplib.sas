
options mprint nocenter;

%let fcmp_path = .;     /* !!! Path to fcmp folder */
libname _libout "&fcmp_path\_cmplib"   FILELOCKWAIT=60;

/* list of `common` .sas files stored in ./create_fcmp/src/_common_fcmp folder */
/* This list may need to be updated manually */
%let _common_fcmp_files = subhh_grp; 


/*--- No changes in the section below -------*/
filename macros "&fcmp_path/macros";
%include macros(create_fcmp_lib filenamesInFolder);  

/* process FCMP cmplib (source in src folder)*/


%create_fcmp_lib(DLfunction);
%create_fcmp_lib(healthC);
