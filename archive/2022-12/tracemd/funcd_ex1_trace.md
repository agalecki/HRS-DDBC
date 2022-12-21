#  Macro funcd (21DEC22)

* This file contains information about the execution of `funcd` macro
* Macro `funcd` (Version 2022-04-22) was executed on 21DEC22 at 18:08
* Macro `funcd` can be executed in one of the two modes: _test_ or _regular_ mode
* Execution mode of the `funcd` is determined based on the value of the `outinfo` argument
   - By default the `outinfo` argument is blank and the `funcd` macro is executed in a _regular_ mode
   - If the `outinfo` argument is not blank  the `funcd` macro is executed in a _test_ mode

## Macro arguments

Macro arguments provided by the user

| Argument Description         | Arg. Name     | Value            | Comment    | Default value    |
| :-------------------------   | :-------      | :--------------- | :---       | :---             |
| Range of HRS years           | `years`       | 1992-2018        | Mandatory  | No defualt       |
| Input SAS library            | `libin`       | hrslibin         | Mandatory  | No default       |
| Output data                  | `outdt`       | myout.adl_iadl2  | Mandatory  | No default       |
| Fileref to trace file        | `tracemd`     | utrace           | Optional   | Blank            |
| Data with output info        | `outinfo`     | lib.funcdl_info2 | Optional   | Blank            |
| Macro with format statements | `fmts`        | funcd_fmts       | Optional   | `funcd_fmts`     |
| Dtin macro                   | `dtin_macro`  |                  | Optional   | Blank            |
| Last HRS year                | `last_hrsyr`  | 2018             | Optional   | `2018`           |

Notes pertaining to main macro execution mode:

* Macro argument `outinfo` is not blank.
* Macro `funcd` is executed in a _TEST_ mode.
* Information about `funcd` macro execution is stored in `lib.funcdl_info2` dataset
* Dataset specified in `outdt` argument will not be created
* The macro will check whether input datasets needed for execution exist in `hrslibin` input library or not

# Main loop
## Derived variables
Derived variables listed in the Table below will be stored in `myout.adl_iadl2` output dataset.

| List of vars       | Variable names                                          |
| :---------------   | :-------                                                |
| ADL vars           | dress_ADL bathe_ADL eat_ADL toilet_ADL walk_ADL bed_ADL |  
| IADL vars          | meal_IADL groc_IADL phone_IADL medicine_IADL money_IADL | 
| ADL DD vars        | dress_DD bathe_DD eat_DD toilet_DD walk_DD bed_DD       |

## Loop Iterations 
Main loop execution started at 18:08

Loop will be executed for selected 14 study years:1993 ,1995 ,1996 ,1998 ,2000 ,2002 ,2004 ,2006 ,2008 ,2010 ,2012 ,2014 ,2016 ,2018 ,

1. --- Year 1993 selected (1/14) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                              |
| :---------------        | :-------         | :-----                               |
| Input library           | `libin`          | hrslibin                             |
| Input dataset           | `datain`         | BR21                                 |
| Auxiliary variable      | `wv`             | .                                    |
| Auxiliary variable      | `cx`             |                                      |
| ADL_diff variables      | `ADL_diff_list`  |                                      |
| ADL_help variables      | `ADL_help_list`  |                                      |
| ADL_equip variables     | `ADL_equip_list` |                                      |
| IADL_diff variables     | `IADL_diff_list` |                                      |
| IADL_help variables     | `IADL_help_list` |                                      |
| IADL_rsn variables      | `IADL_rsn_list`  |                                      |
| Loop macro              | `umacro`         | _funcd_1993                          |

Notes related to processing year 1993:

* Input dataset `BR21` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* ADL/IADL lists of variables are blank for year 1993
* Loop macro `_funcd_1993` _NOT_ executed in a test mode

======= Year 1993 processing completed =======


2. --- Year 1995 selected (2/14) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                              |
| :---------------        | :-------         | :-----                               |
| Input library           | `libin`          | hrslibin                             |
| Input dataset           | `datain`         | a95e_r                               |
| Auxiliary variable      | `wv`             | .                                    |
| Auxiliary variable      | `cx`             |                                      |
| ADL_diff variables      | `ADL_diff_list`  | D1884 D1894 D1904 D1927 D1871 D1914  |
| ADL_help variables      | `ADL_help_list`  | D1887 D1897 D1907 D1930 D1877 D1917  |
| ADL_equip variables     | `ADL_equip_list` | D1874 D1920                          |
| IADL_diff variables     | `IADL_diff_list` | D2021 D2026 D2031 D2036 D2099        |
| IADL_help variables     | `IADL_help_list` | D2024 D2029 D2034 D2039 D2102        |
| IADL_rsn variables      | `IADL_rsn_list`  | D2023 D2028 D2033 D2038 D2100        |
| Loop macro              | `umacro`         | _funcd_sub                           |

Notes related to processing year 1995:

* Input dataset `a95e_r` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* ADL/IADL lists of variables are blank for year 1993
* Loop macro `_funcd_sub` _NOT_ executed in a test mode

======= Year 1995 processing completed =======


3. --- Year 1996 selected (3/14) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                              |
| :---------------        | :-------         | :-----                               |
| Input library           | `libin`          | hrslibin                             |
| Input dataset           | `datain`         | h96e_r                               |
| Auxiliary variable      | `wv`             | .                                    |
| Auxiliary variable      | `cx`             |                                      |
| ADL_diff variables      | `ADL_diff_list`  | E1908 E1918 E1928 E1951 E1895 E1938  |
| ADL_help variables      | `ADL_help_list`  | E1911 E1921 E1931 E1954 E1901 E1944  |
| ADL_equip variables     | `ADL_equip_list` | E1898 E1941                          |
| IADL_diff variables     | `IADL_diff_list` | E2036 E2041 E2046 E2051 E2093        |
| IADL_help variables     | `IADL_help_list` | E2039 E2044 E2049 E2054 E2096        |
| IADL_rsn variables      | `IADL_rsn_list`  | E2038 E2043 E2048 E2053 E2094        |
| Loop macro              | `umacro`         | _funcd_sub                           |

Notes related to processing year 1996:

* Input dataset `h96e_r` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* ADL/IADL lists of variables are blank for year 1993
* Loop macro `_funcd_sub` _NOT_ executed in a test mode

======= Year 1996 processing completed =======


4. --- Year 1998 selected (4/14) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                              |
| :---------------        | :-------         | :-----                               |
| Input library           | `libin`          | hrslibin                             |
| Input dataset           | `datain`         | h98e_r                               |
| Auxiliary variable      | `wv`             | .                                    |
| Auxiliary variable      | `cx`             |                                      |
| ADL_diff variables      | `ADL_diff_list`  | F2425 F2444 F2454 F2477 F2427 F2464  |
| ADL_help variables      | `ADL_help_list`  | F2426 F2447 F2457 F2480 F2431 F2470  |
| ADL_equip variables     | `ADL_equip_list` | F2428 F2467                          |
| IADL_diff variables     | `IADL_diff_list` | F2562 F2567 F2572 F2577 F2618        |
| IADL_help variables     | `IADL_help_list` | F2565 F2570 F2575 F2580 F2620        |
| IADL_rsn variables      | `IADL_rsn_list`  | F2564 F2569 F2574 F2579 F2619        |
| Loop macro              | `umacro`         | _funcd_sub                           |

Notes related to processing year 1998:

* Input dataset `h98e_r` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* ADL/IADL lists of variables are blank for year 1993
* Loop macro `_funcd_sub` _NOT_ executed in a test mode

======= Year 1998 processing completed =======


5. --- Year 2000 selected (5/14) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                              |
| :---------------        | :-------         | :-----                               |
| Input library           | `libin`          | hrslibin                             |
| Input dataset           | `datain`         | h00e_r                               |
| Auxiliary variable      | `wv`             | .                                    |
| Auxiliary variable      | `cx`             |                                      |
| ADL_diff variables      | `ADL_diff_list`  | G2723 G2742 G2752 G2775 G2725 G2762  |
| ADL_help variables      | `ADL_help_list`  | G2724 G2745 G2755 G2778 G2729 G2768  |
| ADL_equip variables     | `ADL_equip_list` | G2726 G2765                          |
| IADL_diff variables     | `IADL_diff_list` | G2860 G2865 G2870 G2875 G2916        |
| IADL_help variables     | `IADL_help_list` | G2863 G2868 G2873 G2878 G2918        |
| IADL_rsn variables      | `IADL_rsn_list`  | G2862 G2867 G2872 G2877 G2917        |
| Loop macro              | `umacro`         | _funcd_sub                           |

Notes related to processing year 2000:

* Input dataset `h00e_r` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* ADL/IADL lists of variables are blank for year 1993
* Loop macro `_funcd_sub` _NOT_ executed in a test mode

======= Year 2000 processing completed =======


6. --- Year 2002 selected (6/14) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                              |
| :---------------        | :-------         | :-----                               |
| Input library           | `libin`          | hrslibin                             |
| Input dataset           | `datain`         | h02g_r                               |
| Auxiliary variable      | `wv`             | 1                                    |
| Auxiliary variable      | `cx`             | H                                    |
| ADL_diff variables      | `ADL_diff_list`  | HG014 HG021 HG023 HG030 HG016 HG025  |
| ADL_help variables      | `ADL_help_list`  | HG015 HG022 HG024 HG031 HG020 HG029  |
| ADL_equip variables     | `ADL_equip_list` | HG017 HG026                          |
| IADL_diff variables     | `IADL_diff_list` | HG041 HG044 HG047 HG050 HG059        |
| IADL_help variables     | `IADL_help_list` | HG043 HG046 HG049 HG053 HG061        |
| IADL_rsn variables      | `IADL_rsn_list`  | HG042 HG045 HG048 HG052 HG060        |
| Loop macro              | `umacro`         | _funcd_sub                           |

Notes related to processing year 2002:

* Input dataset `h02g_r` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* ADL/IADL lists of variables are blank for year 1993
* Loop macro `_funcd_sub` _NOT_ executed in a test mode

======= Year 2002 processing completed =======


7. --- Year 2004 selected (7/14) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                              |
| :---------------        | :-------         | :-----                               |
| Input library           | `libin`          | hrslibin                             |
| Input dataset           | `datain`         | h04g_r                               |
| Auxiliary variable      | `wv`             | 2                                    |
| Auxiliary variable      | `cx`             | J                                    |
| ADL_diff variables      | `ADL_diff_list`  | JG014 JG021 JG023 JG030 JG016 JG025  |
| ADL_help variables      | `ADL_help_list`  | JG015 JG022 JG024 JG031 JG020 JG029  |
| ADL_equip variables     | `ADL_equip_list` | JG017 JG026                          |
| IADL_diff variables     | `IADL_diff_list` | JG041 JG044 JG047 JG050 JG059        |
| IADL_help variables     | `IADL_help_list` | JG043 JG046 JG049 JG053 JG061        |
| IADL_rsn variables      | `IADL_rsn_list`  | JG042 JG045 JG048 JG052 JG060        |
| Loop macro              | `umacro`         | _funcd_sub                           |

Notes related to processing year 2004:

* Input dataset `h04g_r` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* ADL/IADL lists of variables are blank for year 1993
* Loop macro `_funcd_sub` _NOT_ executed in a test mode

======= Year 2004 processing completed =======


8. --- Year 2006 selected (8/14) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                              |
| :---------------        | :-------         | :-----                               |
| Input library           | `libin`          | hrslibin                             |
| Input dataset           | `datain`         | h06g_r                               |
| Auxiliary variable      | `wv`             | 3                                    |
| Auxiliary variable      | `cx`             | K                                    |
| ADL_diff variables      | `ADL_diff_list`  | KG014 KG021 KG023 KG030 KG016 KG025  |
| ADL_help variables      | `ADL_help_list`  | KG015 KG022 KG024 KG031 KG020 KG029  |
| ADL_equip variables     | `ADL_equip_list` | KG017 KG026                          |
| IADL_diff variables     | `IADL_diff_list` | KG041 KG044 KG047 KG050 KG059        |
| IADL_help variables     | `IADL_help_list` | KG043 KG046 KG049 KG053 KG061        |
| IADL_rsn variables      | `IADL_rsn_list`  | KG042 KG045 KG048 KG052 KG060        |
| Loop macro              | `umacro`         | _funcd_sub                           |

Notes related to processing year 2006:

* Input dataset `h06g_r` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* ADL/IADL lists of variables are blank for year 1993
* Loop macro `_funcd_sub` _NOT_ executed in a test mode

======= Year 2006 processing completed =======


9. --- Year 2008 selected (9/14) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                              |
| :---------------        | :-------         | :-----                               |
| Input library           | `libin`          | hrslibin                             |
| Input dataset           | `datain`         | h08g_r                               |
| Auxiliary variable      | `wv`             | 4                                    |
| Auxiliary variable      | `cx`             | L                                    |
| ADL_diff variables      | `ADL_diff_list`  | LG014 LG021 LG023 LG030 LG016 LG025  |
| ADL_help variables      | `ADL_help_list`  | LG015 LG022 LG024 LG031 LG020 LG029  |
| ADL_equip variables     | `ADL_equip_list` | LG017 LG026                          |
| IADL_diff variables     | `IADL_diff_list` | LG041 LG044 LG047 LG050 LG059        |
| IADL_help variables     | `IADL_help_list` | LG043 LG046 LG049 LG053 LG061        |
| IADL_rsn variables      | `IADL_rsn_list`  | LG042 LG045 LG048 LG052 LG060        |
| Loop macro              | `umacro`         | _funcd_sub                           |

Notes related to processing year 2008:

* Input dataset `h08g_r` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* ADL/IADL lists of variables are blank for year 1993
* Loop macro `_funcd_sub` _NOT_ executed in a test mode

======= Year 2008 processing completed =======


10. --- Year 2010 selected (10/14) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                              |
| :---------------        | :-------         | :-----                               |
| Input library           | `libin`          | hrslibin                             |
| Input dataset           | `datain`         | h10g_r                               |
| Auxiliary variable      | `wv`             | 5                                    |
| Auxiliary variable      | `cx`             | M                                    |
| ADL_diff variables      | `ADL_diff_list`  | MG014 MG021 MG023 MG030 MG016 MG025  |
| ADL_help variables      | `ADL_help_list`  | MG015 MG022 MG024 MG031 MG020 MG029  |
| ADL_equip variables     | `ADL_equip_list` | MG017 MG026                          |
| IADL_diff variables     | `IADL_diff_list` | MG041 MG044 MG047 MG050 MG059        |
| IADL_help variables     | `IADL_help_list` | MG043 MG046 MG049 MG053 MG061        |
| IADL_rsn variables      | `IADL_rsn_list`  | MG042 MG045 MG048 MG052 MG060        |
| Loop macro              | `umacro`         | _funcd_sub                           |

Notes related to processing year 2010:

* Input dataset `h10g_r` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* ADL/IADL lists of variables are blank for year 1993
* Loop macro `_funcd_sub` _NOT_ executed in a test mode

======= Year 2010 processing completed =======


11. --- Year 2012 selected (11/14) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                              |
| :---------------        | :-------         | :-----                               |
| Input library           | `libin`          | hrslibin                             |
| Input dataset           | `datain`         | h12g_r                               |
| Auxiliary variable      | `wv`             | 6                                    |
| Auxiliary variable      | `cx`             | N                                    |
| ADL_diff variables      | `ADL_diff_list`  | NG014 NG021 NG023 NG030 NG016 NG025  |
| ADL_help variables      | `ADL_help_list`  | NG015 NG022 NG024 NG031 NG020 NG029  |
| ADL_equip variables     | `ADL_equip_list` | NG017 NG026                          |
| IADL_diff variables     | `IADL_diff_list` | NG041 NG044 NG047 NG050 NG059        |
| IADL_help variables     | `IADL_help_list` | NG043 NG046 NG049 NG053 NG061        |
| IADL_rsn variables      | `IADL_rsn_list`  | NG042 NG045 NG048 NG052 NG060        |
| Loop macro              | `umacro`         | _funcd_sub                           |

Notes related to processing year 2012:

* Input dataset `h12g_r` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* ADL/IADL lists of variables are blank for year 1993
* Loop macro `_funcd_sub` _NOT_ executed in a test mode

======= Year 2012 processing completed =======


12. --- Year 2014 selected (12/14) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                              |
| :---------------        | :-------         | :-----                               |
| Input library           | `libin`          | hrslibin                             |
| Input dataset           | `datain`         | h14g_r                               |
| Auxiliary variable      | `wv`             | 7                                    |
| Auxiliary variable      | `cx`             | O                                    |
| ADL_diff variables      | `ADL_diff_list`  | OG014 OG021 OG023 OG030 OG016 OG025  |
| ADL_help variables      | `ADL_help_list`  | OG015 OG022 OG024 OG031 OG020 OG029  |
| ADL_equip variables     | `ADL_equip_list` | OG017 OG026                          |
| IADL_diff variables     | `IADL_diff_list` | OG041 OG044 OG047 OG050 OG059        |
| IADL_help variables     | `IADL_help_list` | OG043 OG046 OG049 OG053 OG061        |
| IADL_rsn variables      | `IADL_rsn_list`  | OG042 OG045 OG048 OG052 OG060        |
| Loop macro              | `umacro`         | _funcd_sub                           |

Notes related to processing year 2014:

* Input dataset `h14g_r` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* ADL/IADL lists of variables are blank for year 1993
* Loop macro `_funcd_sub` _NOT_ executed in a test mode

======= Year 2014 processing completed =======


13. --- Year 2016 selected (13/14) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                              |
| :---------------        | :-------         | :-----                               |
| Input library           | `libin`          | hrslibin                             |
| Input dataset           | `datain`         | h16g_r                               |
| Auxiliary variable      | `wv`             | 8                                    |
| Auxiliary variable      | `cx`             | P                                    |
| ADL_diff variables      | `ADL_diff_list`  | PG014 PG021 PG023 PG030 PG016 PG025  |
| ADL_help variables      | `ADL_help_list`  | PG015 PG022 PG024 PG031 PG020 PG029  |
| ADL_equip variables     | `ADL_equip_list` | PG017 PG026                          |
| IADL_diff variables     | `IADL_diff_list` | PG041 PG044 PG047 PG050 PG059        |
| IADL_help variables     | `IADL_help_list` | PG043 PG046 PG049 PG053 PG061        |
| IADL_rsn variables      | `IADL_rsn_list`  | PG042 PG045 PG048 PG052 PG060        |
| Loop macro              | `umacro`         | _funcd_sub                           |

Notes related to processing year 2016:

* Input dataset `h16g_r` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* ADL/IADL lists of variables are blank for year 1993
* Loop macro `_funcd_sub` _NOT_ executed in a test mode

======= Year 2016 processing completed =======


14. --- Year 2018 selected (14/14) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                              |
| :---------------        | :-------         | :-----                               |
| Input library           | `libin`          | hrslibin                             |
| Input dataset           | `datain`         | h18g_r                               |
| Auxiliary variable      | `wv`             | 9                                    |
| Auxiliary variable      | `cx`             | Q                                    |
| ADL_diff variables      | `ADL_diff_list`  | QG014 QG021 QG023 QG030 QG016 QG025  |
| ADL_help variables      | `ADL_help_list`  | QG015 QG022 QG024 QG031 QG020 QG029  |
| ADL_equip variables     | `ADL_equip_list` | QG017 QG026                          |
| IADL_diff variables     | `IADL_diff_list` | QG041 QG044 QG047 QG050 QG059        |
| IADL_help variables     | `IADL_help_list` | QG043 QG046 QG049 QG053 QG061        |
| IADL_rsn variables      | `IADL_rsn_list`  | QG042 QG045 QG048 QG052 QG060        |
| Loop macro              | `umacro`         | _funcd_sub                           |

Notes related to processing year 2018:

* Input dataset `h18g_r` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* ADL/IADL lists of variables are blank for year 1993
* Loop macro `_funcd_sub` _NOT_ executed in a test mode

======= Year 2018 processing completed =======


---- Macro `funcd` ended  at 18:08 (Test mode = Yes)

