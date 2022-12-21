/***********
Examples of syntax executed in  TEST mode.
It is recommended to  use `libin` argument to specify SAS library with input data.

To run macro in REGULAR mode it is necessary to omit `outinfo` argument.
In addition SAS library referred to in `outdt` argument needs to be defined uing `LIBRARY` statement
**********/

libname lib ".";


filename hrs_inc "_include-HRS-macros.sas";
%include hrs_inc;

/* Test mode 1 */
%health(1992-2012, libin = hrslibin, outdt = myout.health, outinfo = lib.health_info1);

/* Test mode 2: `tracemd` argument is trace file */
filename utrace "./tracemd/health_ex1_trace.md";
%health(1992-2018, libin = hrslibin, outdt = myout.health, outinfo = lib.health_info2, tracemd = utrace);
