
options mprint nocenter;

%let fcmp_path = .;     /* !!! Path to fcmp folder */
%include "&fcmp_path/_global_mvars.inc"; /* Global macro vars defined */
%include _macros(create_fcmp_lib filenamesInFolder);  

/* process FCMP cmplib (source in src folder)*/

libname lib1 "&_cmplib_path\Function_5g";
%create_fcmp(lib1, Function_5g);


libname lib2 "&_cmplib_path\test7_DLFunction";
%create_fcmp(lib2,test7_DLFunction);


libname lib3 "&_cmplib_path\healthC_init";
%create_fcmp(lib3, healthC_init);
endsas;