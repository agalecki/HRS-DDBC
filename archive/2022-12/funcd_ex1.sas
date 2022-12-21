libname lib ".";

filename hrs_inc "_include-HRS-macros.sas";
%include hrs_inc;

/* Test mode 1 */
%funcd(1992-2012, libin = hrslibin, outdt = myout.adl_iadl, outinfo = lib.funcdl_info1);

/* Test mode 2 */
filename utrace "./tracemd/funcd_ex1_trace.md";
%funcd(1992-2018, libin = hrslibin, outdt = myout.adl_iadl2, outinfo = lib.funcdl_info2, tracemd = utrace);
