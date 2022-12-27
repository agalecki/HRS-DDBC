
options mprint nocenter;

%let fcmp_path = .;     /* !!! Path to fcmp folder */
%include "&fcmp_path/_global_mvars.inc"; /* Global macro vars defined */
%include _macros(create_fcmp_lib filenamesInFolder);  

/* process FCMP cmplib (source in src folder)*/
%let _common_fcmp_files = subhh_grp; /* Needs to match files in ./fcmp_source/_common_fcmp */


%create_fcmp_lib(test7_DLFunction);
endsas;

%create_fcmp_lib(Function_5g);

%create_fcmp_lib(DLfunction);
%create_fcmp_lib(healthC);
