#  Macro health (29APR22)

* This file contains information about the execution of `health` macro
* Macro `health` (Version 2022-04-27) was executed on 29APR22 at 13:02
* Macro `health` can be executed in one of the two modes: _test_ or _regular_ mode
* Execution mode of the `health` is determined based on the value of the `outinfo` argument
   - By default the `outinfo` argument is blank and the `health` macro is executed in a _regular_ mode
   - If the `outinfo` argument is not blank  the `health` macro is executed in a _test_ mode

## Macro arguments

Macro arguments provided by the user

| Argument Description         | Arg. Name     | Value            | Comment    | Default value    |
| :-------------------------   | :-------      | :--------------- | :---       | :---             |
| Range of HRS years           | `years`       | 1992-2018        | Mandatory  | No defualt       |
| Input SAS library            | `libin`       | hrslibin         | Mandatory  | No default       |
| Output data                  | `outdt`       | myout.health     | Mandatory  | No default       |
| Fileref to trace file        | `tracemd`     | utrace           | Optional   | Blank            |
| Data with output info        | `outinfo`     | lib.health_info2 | Optional   | Blank            |
| Macro with format statements | `fmts`        | health_fmts      | Optional   | `health_fmts`    |
| Dtin macro                   | `dtin_macro`  |                  | Optional   | Blank            |
| Last HRS year                | `last_hrsyr`  | 2018             | Optional   | `2018`           |

Notes pertaining to main macro execution mode:

* Macro argument `outinfo` is not blank.
* Macro `health` is executed in a _TEST_ mode.
* Information about `health` macro execution is stored in `lib.health_info2` dataset
* Dataset specified in `outdt` argument will not be created
* The macro will check whether input datasets needed for execution exist in `hrslibin` input library or not

# Main loop
## Derived variables
Derived variables listed in the Table below will be stored in `myout.health` output dataset.

| List of vars          | Variable names                                                                                         |
| :---------------      | :-------                                                                                               |
| Health Rate vars      | hlthrte hlthrtecomp                                                                                    |
| Blood Pressure vars   | bloodp bloodprx bloodplwgt bloodpcont                                                                  |
| Diabetes vars         | diabetes diabswa diabins diablstwgt diabdiet diabcont diabkidney                                       |
| Cancer vars           | cancer cancerdr cancertrt cancernew canceryr                                                           |
| Cancer treatment vars | chemomed surgbiop RadiXray meditrt cannotrt othertrt                                                   |
| Lung vars          	| lung lungrx lungoxy lungthpy lungacti                                                                    |
| Heart Disease vars	| heart heartrx heartdr heartatt hrtattrx angina anginarx anglimit chf chfhosp chfrx hrttrt hrtsurg 	       |
| Stroke vars			| stroke strokedr strokepr strokwek strokspk strokvis strokthk strokrx strokthp strokoth strokyr strokmo         |
| Psychiatric vars		| psychiat psythrpy psyrx                                                                                    |
| Arthritis vars		| arthrit arthstif arthrx arthlimit arthjrepl                                                                  |
| Falls vars			| fall falltime fallinju fallbhip                                                                                 |
| Incontinence vars		| incontin incondlm incondk1 incondk2 inconpad                                                              |
| Vision vars			| eyerate eyedistv eyernearv eyecat_surg eyecat_surg2 eyecat_imp eye_glauc                                       |
| Hearing vars			| hearrate                                                                                                      |

## Loop Iterations 
Main loop execution started at 13:02

Loop will be executed for selected 16 study years:1992 ,1993 ,1994 ,1995 ,1996 ,1998 ,2000 ,2002 ,2004 ,2006 ,2008 ,2010 ,2012 ,2014 ,2016 ,2018 ,

1. --- Year 1992 selected (1/16) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                                                                      |
| :---------------        | :-------         | :-----                                                                       |
| Input library           | `libin`          | hrslibin                                                                     |
| Input dataset           | `datain`         | health                                                                       |
| Auxiliary variable      | `wv`             | .                                                                            |
| Auxiliary variable      | `cx`             |                                                                              |
| Health Rate vars		  |	`hlthrte_list`   | V301 V302	                                                                       |
| Blood Pressure vars     | `bloodp_list`    | V325 V326 XXX XXX	                                                           |
| Diabetes vars			  | `diabetes_list`  | V328 V335 V336 V334 V333 XXX XXX	                                                  |
| Cancer vars			  | `cancer_list`    | V337 V341 XXX XXX XXX		                                                              |
| Cancer treatment vars	  | `cancer_trt_list`| V342 V349 V343 V350 V344 V351 V345 V352                                      |
| Lung vars				  | `lung_list`		 | V401 V402 XXX XXX V405                                                                   |
| Heart Disease vars	  | `heart_list`     | V406 XXX V414 V407 XXX V409 V410 XXX V411 XXX V412 V415 V416                    |
| Stroke vars			  |	`stroke_list`    | V417 V420 V419 XXX XXX XXX XXX V421 XXX XXX V418 XXX                                 |
| Psychiatric vars		  | `psy_list`       | V422 V424 V425                                                                   |
| Arthritis vars		  | `arthrit_list`	 | V426 V427 V428 XXX XXX                                                              |
| Falls vars			  | `fall_list`		 | XXX XXX XXX XXX                                                                          |
| Incontinence vars		  | `incontin_list`	 | XXX XXX XXX XXX XXX                                                             |
| Vision vars			  | `eye_list`       | V450 XXX XXX XXX XXX XXX XXX                                                         |
| Hearing vars		      | `hear_list`      | V453                                                                             |
| Loop macro              | `umacro`         | _health_sub                                                                  |

Notes related to processing year 1992:

* Input dataset `health` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* Loop macro `_health_sub` _NOT_ executed in a test mode

======= Year 1992 processing completed =======


2. --- Year 1993 selected (2/16) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                                                                      |
| :---------------        | :-------         | :-----                                                                       |
| Input library           | `libin`          | hrslibin                                                                     |
| Input dataset           | `datain`         | BR21                                                                         |
| Auxiliary variable      | `wv`             | .                                                                            |
| Auxiliary variable      | `cx`             |                                                                              |
| Health Rate vars		  |	`hlthrte_list`   | V204 V208	                                                                       |
| Blood Pressure vars     | `bloodp_list`    | V215 XXX XXX XXX	                                                            |
| Diabetes vars			  | `diabetes_list`  | V219 V223 V224 XXX XXX XXX XXX	                                                    |
| Cancer vars			  | `cancer_list`    | V225 XXX XXX XXX XXX		                                                               |
| Cancer treatment vars	  | `cancer_trt_list`| V232A1 V232A2 V232A3 V232A4                                                  |
| Lung vars				  | `lung_list`		 | V235 XXX XXX XXX V238                                                                    |
| Heart Disease vars	  | `heart_list`     | V242 XXX XXX V244 XXX V245 XXX XXX XXX XXX XXX XXX XXX                          |
| Stroke vars			  |	`stroke_list`    | V252 XXX V254 XXX XXX XXX XXX XXX XXX XXX XXX XXX                                    |
| Psychiatric vars		  | `psy_list`       | V259 XXX XXX                                                                     |
| Arthritis vars		  | `arthrit_list`	 | V265 XXX XXX XXX XXX                                                                |
| Falls vars			  | `fall_list`		 | V274 XXX V275 V277                                                                       |
| Incontinence vars		  | `incontin_list`	 | V282 V283 XXX XXX V284                                                          |
| Vision vars			  | `eye_list`       | V288 XXX XXX V289 XXX XXX XXX                                                        |
| Hearing vars		      | `hear_list`      | V291                                                                             |
| Loop macro              | `umacro`         | _health_sub                                                                  |

Notes related to processing year 1993:

* Input dataset `BR21` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* Loop macro `_health_sub` _NOT_ executed in a test mode

======= Year 1993 processing completed =======


3. --- Year 1994 selected (3/16) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                                                                      |
| :---------------        | :-------         | :-----                                                                       |
| Input library           | `libin`          | hrslibin                                                                     |
| Input dataset           | `datain`         | w2b                                                                          |
| Auxiliary variable      | `wv`             | .                                                                            |
| Auxiliary variable      | `cx`             |                                                                              |
| Health Rate vars		  |	`hlthrte_list`   | W301 W302	                                                                       |
| Blood Pressure vars     | `bloodp_list`    | W328 w329 XXX XXX	                                                           |
| Diabetes vars			  | `diabetes_list`  | W333 W337 W338 W336 W335 XXX XXX	                                                  |
| Cancer vars			  | `cancer_list`    | W339 W344 XXX W340 W342		                                                            |
| Cancer treatment vars	  | `cancer_trt_list`| W345 W346 W347 W348 W349 W350 W351 W355 W356 W357                            |
| Lung vars				  | `lung_list`		 | W362 W363 XXX XXX W366                                                                   |
| Heart Disease vars	  | `heart_list`     | W368 XXX W376 W369 XXX W371 W372 XXX W373 XXX W374 W377 W378                    |
| Stroke vars			  |	`stroke_list`    | W379 W382 XXX XXX XXX XXX XXX W383 XXX XXX W380 XXX                                  |
| Psychiatric vars		  | `psy_list`       | W384 W385 W386                                                                   |
| Arthritis vars		  | `arthrit_list`	 | W387 W388 W389 XXX XXX                                                              |
| Falls vars			  | `fall_list`		 | XXX XXX XXX XXX                                                                          |
| Incontinence vars		  | `incontin_list`	 | XXX XXX XXX XXX XXX                                                             |
| Vision vars			  | `eye_list`       | W448 XXX XXX XXX XXX XXX XXX                                                         |
| Hearing vars		      | `hear_list`      | W451                                                                             |
| Loop macro              | `umacro`         | _health_sub                                                                  |

Notes related to processing year 1994:

* Input dataset `w2b` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* Loop macro `_health_sub` _NOT_ executed in a test mode

======= Year 1994 processing completed =======


4. --- Year 1995 selected (4/16) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                                                                      |
| :---------------        | :-------         | :-----                                                                       |
| Input library           | `libin`          | hrslibin                                                                     |
| Input dataset           | `datain`         | a95b_r                                                                       |
| Auxiliary variable      | `wv`             | .                                                                            |
| Auxiliary variable      | `cx`             |                                                                              |
| Health Rate vars		  |	`hlthrte_list`   | D769 D772	                                                                       |
| Blood Pressure vars     | `bloodp_list`    | D781 D782 D783 D784	                                                         |
| Diabetes vars			  | `diabetes_list`  | D788 D789 D790 D791 D792 D793 D795	                                                |
| Cancer vars			  | `cancer_list`    | D801 D802 D803 D806 D814		                                                           |
| Cancer treatment vars	  | `cancer_trt_list`| D804M1 D804M2 D804M3 D804M4                                                  |
| Lung vars				  | `lung_list`		 | D818 D823 D824 D825 D826                                                                 |
| Heart Disease vars	  | `heart_list`     | D828 D829 D830 D834 D837 D840 D841 D842 D843 D844 D845 D846 D847                |
| Stroke vars			  |	`stroke_list`    | D848 D850 D851 D852 D853 D854 D855 D856 D857 D858 D860 D859                          |
| Psychiatric vars		  | `psy_list`       | D861 D863 D864                                                                   |
| Arthritis vars		  | `arthrit_list`	 | D866 D869 D870 D871 D872                                                            |
| Falls vars			  | `fall_list`		 | D878 D879 D884 D887                                                                      |
| Incontinence vars		  | `incontin_list`	 | D892 D893 D894 D895 D896                                                        |
| Vision vars			  | `eye_list`       | D900 D901 D902 D903 D904 D905 D906                                                   |
| Hearing vars		      | `hear_list`      | D908                                                                             |
| Loop macro              | `umacro`         | _health_sub                                                                  |

Notes related to processing year 1995:

* Input dataset `a95b_r` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* Loop macro `_health_sub` _NOT_ executed in a test mode

======= Year 1995 processing completed =======


5. --- Year 1996 selected (5/16) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                                                                      |
| :---------------        | :-------         | :-----                                                                       |
| Input library           | `libin`          | hrslibin                                                                     |
| Input dataset           | `datain`         | h96b_r                                                                       |
| Auxiliary variable      | `wv`             | .                                                                            |
| Auxiliary variable      | `cx`             |                                                                              |
| Health Rate vars		  |	`hlthrte_list`   | E769 E772	                                                                       |
| Blood Pressure vars     | `bloodp_list`    | E781 E782 E783 E784	                                                         |
| Diabetes vars			  | `diabetes_list`  | E788 E789 E790 E791 E792 E793 E795	                                                |
| Cancer vars			  | `cancer_list`    | E801 E802 E803 E806 E814		                                                           |
| Cancer treatment vars	  | `cancer_trt_list`| E804M1 E804M2 E804M3 E804M4                                                  |
| Lung vars				  | `lung_list`		 | E818 E823 E824 E825 E826                                                                 |
| Heart Disease vars	  | `heart_list`     | E828 E829 E830 E834 E837 E840 E841 E842 E843 E844 E845 E846 E847                |
| Stroke vars			  |	`stroke_list`    | E848 E850 E851 E852 E853 E854 E855 E856 E857 E858 E860 E859                          |
| Psychiatric vars		  | `psy_list`       | E861 E863 E864                                                                   |
| Arthritis vars		  | `arthrit_list`	 | E866 E869 E870 E871 E872                                                            |
| Falls vars			  | `fall_list`		 | E878 E879 E884 E887                                                                      |
| Incontinence vars		  | `incontin_list`	 | E892 E893 E894 E895 E896                                                        |
| Vision vars			  | `eye_list`       | E900 E901 E902 E903 E904 E905 E906                                                   |
| Hearing vars		      | `hear_list`      | E908                                                                             |
| Loop macro              | `umacro`         | _health_sub                                                                  |

Notes related to processing year 1996:

* Input dataset `h96b_r` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* Loop macro `_health_sub` _NOT_ executed in a test mode

======= Year 1996 processing completed =======


6. --- Year 1998 selected (6/16) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                                                                      |
| :---------------        | :-------         | :-----                                                                       |
| Input library           | `libin`          | hrslibin                                                                     |
| Input dataset           | `datain`         | h98b_r                                                                       |
| Auxiliary variable      | `wv`             | .                                                                            |
| Auxiliary variable      | `cx`             |                                                                              |
| Health Rate vars		  |	`hlthrte_list`   | F1097 F1100	                                                                     |
| Blood Pressure vars     | `bloodp_list`    | F1109 F1110 F1111 F1112	                                                     |
| Diabetes vars			  | `diabetes_list`  | F1116 F1117 F1118 F1119 F1120 F1121 F1123	                                         |
| Cancer vars			  | `cancer_list`    | F1129 F1130 F1131 F1134 F1141		                                                      |
| Cancer treatment vars	  | `cancer_trt_list`| F1132M1 F1132M2 F1132M3 F1132M4                                              |
| Lung vars				  | `lung_list`		 | F1146 F1151 F1152 F1153 F1154                                                            |
| Heart Disease vars	  | `heart_list`     | F1156 F1157 F1158 F1162 F1165 F1168 F1169 F1170 F1171 F1172 F1173 F1174 F1175   |  
| Stroke vars			  |	`stroke_list`    | F1176 F1178 F1179 F1180 F1181 F1182 F1183 F1184 F1185 F1186 F1188 F1187              |
| Psychiatric vars		  | `psy_list`       | F1189 F1191 F1192                                                                |
| Arthritis vars		  | `arthrit_list`	 | F1194 F1197 F1198 F1199 F1200                                                       |
| Falls vars			  | `fall_list`		 | F1206 F1207 F1212 F1215                                                                  |
| Incontinence vars		  | `incontin_list`	 | F1220 F1221 F1222 F1223 F1224                                                   |
| Vision vars			  | `eye_list`       | F1228 F1229 F1230 F1231 F1232 F1233 F1234                                            |
| Hearing vars		      | `hear_list`      | F1236                                                                            |
| Loop macro              | `umacro`         | _health_sub                                                                  |

Notes related to processing year 1998:

* Input dataset `h98b_r` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* Loop macro `_health_sub` _NOT_ executed in a test mode

======= Year 1998 processing completed =======


7. --- Year 2000 selected (7/16) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                                                                      |
| :---------------        | :-------         | :-----                                                                       |
| Input library           | `libin`          | hrslibin                                                                     |
| Input dataset           | `datain`         | h00b_r                                                                       |
| Auxiliary variable      | `wv`             | .                                                                            |
| Auxiliary variable      | `cx`             |                                                                              |
| Health Rate vars		  |	`hlthrte_list`   | G1226 G1229	                                                                     |
| Blood Pressure vars     | `bloodp_list`    | G1238 G1239 G1240 G1241	                                                     |
| Diabetes vars			  | `diabetes_list`  | G1245 G1248 G1249 G1250 G1251 G1252 G1256	                                         |
| Cancer vars			  | `cancer_list`    | G1262 G1263 G1264 G1267 G1274		                                                      |
| Cancer treatment vars	  | `cancer_trt_list`| G1265M1 G1265M2 G1265M3 G1265M4                                              |
| Lung vars				  | `lung_list`		 | G1279 G1284 G1285 G1286 G1287                                                            |
| Heart Disease vars	  | `heart_list`     | G1289 G1290 G1291 G1295 G1298 G1301 G1302 G1303 G1304 G1305 G1306 G1307 G1308   |  
| Stroke vars			  |	`stroke_list`    | G1309 G1311 G1312 G1313 G1314 G1315 G1316 G1317 G1318 G1319 G1321 G1320              |
| Psychiatric vars		  | `psy_list`       | G1322 G1324 G1325                                                                |
| Arthritis vars		  | `arthrit_list`	 | G1327 G1330 G1331 G1332 G1333                                                       |
| Falls vars			  | `fall_list`		 | G1339 G1340 G1345 G1348                                                                  |
| Incontinence vars		  | `incontin_list`	 | G1353 G1354 G1355 G1356 G1357                                                   |
| Vision vars			  | `eye_list`       | G1361 G1362 G1363 G1364 G1365 G1366 G1367                                            |
| Hearing vars		      | `hear_list`      | G1369                                                                            |
| Loop macro              | `umacro`         | _health_sub                                                                  |

Notes related to processing year 2000:

* Input dataset `h00b_r` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* Loop macro `_health_sub` _NOT_ executed in a test mode

======= Year 2000 processing completed =======


8. --- Year 2002 selected (8/16) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                                                                      |
| :---------------        | :-------         | :-----                                                                       |
| Input library           | `libin`          | hrslibin                                                                     |
| Input dataset           | `datain`         | h02c_r                                                                       |
| Auxiliary variable      | `wv`             | 1                                                                            |
| Auxiliary variable      | `cx`             | H                                                                            |
| Health Rate vars		  |	`hlthrte_list`   | HC001 HC002	                                                                     |
| Blood Pressure vars     | `bloodp_list`    | HC005 HC006 HC007 HC008	                                                     |
| Diabetes vars			  | `diabetes_list`  | HC010 HC011 HC012 HC013 HC014 HC015 HC017	                                         |
| Cancer vars			  | `cancer_list`    | HC018 HC019 HC020 HC024 HC028		                                                      |
| Cancer treatment vars	  | `cancer_trt_list`| HC021m1 HC021m2 HC021m3 HC021m4 HC021m5 HC021m6 HC                           |
| Lung vars				  | `lung_list`		 | HC030 HC032 HC033 HC034 HC035                                                            |
| Heart Disease vars	  | `heart_list`     | HC036 HC037 HC038 HC040 HC042 HC045 HC046 HC047 HC048 HC049 HC050 HC051 HC052   |  
| Stroke vars			  |	`stroke_list`    | HC053 HC054 HC055 HC056 HC057 HC058 HC059 HC060 HC061 HC062 HC064 HC063              |
| Psychiatric vars		  | `psy_list`       | HC065 HC067 HC068                                                                |
| Arthritis vars		  | `arthrit_list`	 | HC070 HC073 HC074 HC075 HC076                                                       |
| Falls vars			  | `fall_list`		 | HC079 HC080 HC081 HC082                                                                  |
| Incontinence vars		  | `incontin_list`	 | HC087 HC088 HC089 HC090 HC094                                                   |
| Vision vars			  | `eye_list`       | HC095 HC096 HC097 HC098 HC099 HC100 HC101                                            |
| Hearing vars		      | `hear_list`      | HC103                                                                            |
| Loop macro              | `umacro`         | _health_sub                                                                  |

Notes related to processing year 2002:

* Input dataset `h02c_r` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* Loop macro `_health_sub` _NOT_ executed in a test mode

======= Year 2002 processing completed =======


9. --- Year 2004 selected (9/16) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                                                                      |
| :---------------        | :-------         | :-----                                                                       |
| Input library           | `libin`          | hrslibin                                                                     |
| Input dataset           | `datain`         | h04c_r                                                                       |
| Auxiliary variable      | `wv`             | 2                                                                            |
| Auxiliary variable      | `cx`             | J                                                                            |
| Health Rate vars		  |	`hlthrte_list`   | JC001 JC002	                                                                     |
| Blood Pressure vars     | `bloodp_list`    | JC005 JC006 JC007 JC008	                                                     |
| Diabetes vars			  | `diabetes_list`  | JC010 JC011 JC012 JC013 JC014 JC015 JC017	                                         |
| Cancer vars			  | `cancer_list`    | JC018 JC019 JC020 JC024 JC028		                                                      |
| Cancer treatment vars	  | `cancer_trt_list`| JC021m1 JC021m2 JC021m3 JC021m4 JC021m5 JC021m6 JC                           |
| Lung vars				  | `lung_list`		 | JC030 JC032 JC033 JC034 JC035                                                            |
| Heart Disease vars	  | `heart_list`     | JC036 JC037 JC038 JC040 JC042 JC045 JC046 JC047 JC048 JC049 JC050 JC051 JC052   |  
| Stroke vars			  |	`stroke_list`    | JC053 JC054 JC055 JC056 JC057 JC058 JC059 JC060 JC061 JC062 JC064 JC063              |
| Psychiatric vars		  | `psy_list`       | JC065 JC067 JC068                                                                |
| Arthritis vars		  | `arthrit_list`	 | JC070 JC073 JC074 JC075 JC076                                                       |
| Falls vars			  | `fall_list`		 | JC079 JC080 JC081 JC082                                                                  |
| Incontinence vars		  | `incontin_list`	 | JC087 JC088 JC089 JC090 JC094                                                   |
| Vision vars			  | `eye_list`       | JC095 JC096 JC097 JC098 JC099 JC100 JC101                                            |
| Hearing vars		      | `hear_list`      | JC103                                                                            |
| Loop macro              | `umacro`         | _health_sub                                                                  |

Notes related to processing year 2004:

* Input dataset `h04c_r` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* Loop macro `_health_sub` _NOT_ executed in a test mode

======= Year 2004 processing completed =======


10. --- Year 2006 selected (10/16) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                                                                      |
| :---------------        | :-------         | :-----                                                                       |
| Input library           | `libin`          | hrslibin                                                                     |
| Input dataset           | `datain`         | h06c_r                                                                       |
| Auxiliary variable      | `wv`             | 3                                                                            |
| Auxiliary variable      | `cx`             | K                                                                            |
| Health Rate vars		  |	`hlthrte_list`   | KC001 KC002	                                                                     |
| Blood Pressure vars     | `bloodp_list`    | KC005 KC006 KC007 KC008	                                                     |
| Diabetes vars			  | `diabetes_list`  | KC010 KC011 KC012 KC013 KC014 KC015 KC017	                                         |
| Cancer vars			  | `cancer_list`    | KC018 KC019 KC020 KC024 KC028		                                                      |
| Cancer treatment vars	  | `cancer_trt_list`| KC021m1 KC021m2 KC021m3 KC021m4 KC021m5 KC021m6 KC                           |
| Lung vars				  | `lung_list`		 | KC030 KC032 KC033 KC034 KC035                                                            |
| Heart Disease vars	  | `heart_list`     | KC036 KC037 KC038 KC040 KC042 KC045 KC046 KC047 KC048 KC049 KC050 KC051 KC052   |  
| Stroke vars			  |	`stroke_list`    | KC053 KC054 KC055 KC056 KC057 KC058 KC059 KC060 KC061 KC062 KC064 KC063              |
| Psychiatric vars		  | `psy_list`       | KC065 KC067 KC068                                                                |
| Arthritis vars		  | `arthrit_list`	 | KC070 KC073 KC074 KC075 KC076                                                       |
| Falls vars			  | `fall_list`		 | KC079 KC080 KC081 KC082                                                                  |
| Incontinence vars		  | `incontin_list`	 | KC087 KC088 KC089 KC090 KC094                                                   |
| Vision vars			  | `eye_list`       | KC095 KC096 KC097 KC098 KC099 KC100 KC101                                            |
| Hearing vars		      | `hear_list`      | KC103                                                                            |
| Loop macro              | `umacro`         | _health_sub                                                                  |

Notes related to processing year 2006:

* Input dataset `h06c_r` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* Loop macro `_health_sub` _NOT_ executed in a test mode

======= Year 2006 processing completed =======


11. --- Year 2008 selected (11/16) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                                                                      |
| :---------------        | :-------         | :-----                                                                       |
| Input library           | `libin`          | hrslibin                                                                     |
| Input dataset           | `datain`         | h08c_r                                                                       |
| Auxiliary variable      | `wv`             | 4                                                                            |
| Auxiliary variable      | `cx`             | L                                                                            |
| Health Rate vars		  |	`hlthrte_list`   | LC001 LC002	                                                                     |
| Blood Pressure vars     | `bloodp_list`    | LC005 LC006 LC007 LC008	                                                     |
| Diabetes vars			  | `diabetes_list`  | LC010 LC011 LC012 LC013 LC014 LC015 LC017	                                         |
| Cancer vars			  | `cancer_list`    | LC018 LC019 LC020 LC024 LC028		                                                      |
| Cancer treatment vars	  | `cancer_trt_list`| LC021m1 LC021m2 LC021m3 LC021m4 LC021m5 LC021m6 LC                           |
| Lung vars				  | `lung_list`		 | LC030 LC032 LC033 LC034 LC035                                                            |
| Heart Disease vars	  | `heart_list`     | LC036 LC037 LC038 LC040 LC042 LC045 LC046 LC047 LC048 LC049 LC050 LC051 LC052   |  
| Stroke vars			  |	`stroke_list`    | LC053 LC054 LC055 LC056 LC057 LC058 LC059 LC060 LC061 LC062 LC064 LC063              |
| Psychiatric vars		  | `psy_list`       | LC065 LC067 LC068                                                                |
| Arthritis vars		  | `arthrit_list`	 | LC070 LC073 LC074 LC075 LC076                                                       |
| Falls vars			  | `fall_list`		 | LC079 LC080 LC081 LC082                                                                  |
| Incontinence vars		  | `incontin_list`	 | LC087 LC088 LC089 LC090 LC094                                                   |
| Vision vars			  | `eye_list`       | LC095 LC096 LC097 LC098 LC099 LC100 LC101                                            |
| Hearing vars		      | `hear_list`      | LC103                                                                            |
| Loop macro              | `umacro`         | _health_sub                                                                  |

Notes related to processing year 2008:

* Input dataset `h08c_r` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* Loop macro `_health_sub` _NOT_ executed in a test mode

======= Year 2008 processing completed =======


12. --- Year 2010 selected (12/16) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                                                                      |
| :---------------        | :-------         | :-----                                                                       |
| Input library           | `libin`          | hrslibin                                                                     |
| Input dataset           | `datain`         | h10c_r                                                                       |
| Auxiliary variable      | `wv`             | 5                                                                            |
| Auxiliary variable      | `cx`             | M                                                                            |
| Health Rate vars		  |	`hlthrte_list`   | MC001 MC002	                                                                     |
| Blood Pressure vars     | `bloodp_list`    | MC005 MC006 MC007 MC008	                                                     |
| Diabetes vars			  | `diabetes_list`  | MC010 MC011 MC012 MC013 MC014 MC015 MC017	                                         |
| Cancer vars			  | `cancer_list`    | MC018 MC019 MC020 MC024 MC028		                                                      |
| Cancer treatment vars	  | `cancer_trt_list`| MC021m1 MC021m2 MC021m3 MC021m4 MC021m5 MC021m6 MC                           |
| Lung vars				  | `lung_list`		 | MC030 MC032 MC033 MC034 MC035                                                            |
| Heart Disease vars	  | `heart_list`     | MC036 MC037 MC038 MC040 MC042 MC045 MC046 MC047 MC048 MC049 MC050 MC051 MC052   |  
| Stroke vars			  |	`stroke_list`    | MC053 MC054 MC055 MC056 MC057 MC058 MC059 MC060 MC061 MC062 MC064 MC063              |
| Psychiatric vars		  | `psy_list`       | MC065 MC067 MC068                                                                |
| Arthritis vars		  | `arthrit_list`	 | MC070 MC073 MC074 MC075 MC076                                                       |
| Falls vars			  | `fall_list`		 | MC079 MC080 MC081 MC082                                                                  |
| Incontinence vars		  | `incontin_list`	 | MC087 MC088 MC089 MC090 MC094                                                   |
| Vision vars			  | `eye_list`       | MC095 MC096 MC097 MC098 MC099 MC100 MC101                                            |
| Hearing vars		      | `hear_list`      | MC103                                                                            |
| Loop macro              | `umacro`         | _health_sub                                                                  |

Notes related to processing year 2010:

* Input dataset `h10c_r` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* Loop macro `_health_sub` _NOT_ executed in a test mode

======= Year 2010 processing completed =======


13. --- Year 2012 selected (13/16) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                                                                      |
| :---------------        | :-------         | :-----                                                                       |
| Input library           | `libin`          | hrslibin                                                                     |
| Input dataset           | `datain`         | h12c_r                                                                       |
| Auxiliary variable      | `wv`             | 6                                                                            |
| Auxiliary variable      | `cx`             | N                                                                            |
| Health Rate vars		  |	`hlthrte_list`   | NC001 NC002	                                                                     |
| Blood Pressure vars     | `bloodp_list`    | NC005 NC006 NC007 NC008	                                                     |
| Diabetes vars			  | `diabetes_list`  | NC010 NC011 NC012 NC013 NC014 NC015 NC017	                                         |
| Cancer vars			  | `cancer_list`    | NC018 NC019 NC020 NC024 NC028		                                                      |
| Cancer treatment vars	  | `cancer_trt_list`| NC021m1 NC021m2 NC021m3 NC021m4 NC021m5 NC021m6 NC                           |
| Lung vars				  | `lung_list`		 | NC030 NC032 NC033 NC034 NC035                                                            |
| Heart Disease vars	  | `heart_list`     | NC036 NC037 NC038 NC040 NC042 NC045 NC046 NC047 NC048 NC049 NC050 NC051 NC052   |  
| Stroke vars			  |	`stroke_list`    | NC053 NC054 NC055 NC056 NC057 NC058 NC059 NC060 NC061 NC062 NC064 NC063              |
| Psychiatric vars		  | `psy_list`       | NC065 NC067 NC068                                                                |
| Arthritis vars		  | `arthrit_list`	 | NC070 NC073 NC074 NC075 NC076                                                       |
| Falls vars			  | `fall_list`		 | NC079 NC080 NC081 NC082                                                                  |
| Incontinence vars		  | `incontin_list`	 | NC087 NC088 NC089 NC090 NC094                                                   |
| Vision vars			  | `eye_list`       | NC095 NC096 NC097 NC098 NC099 NC100 NC101                                            |
| Hearing vars		      | `hear_list`      | NC103                                                                            |
| Loop macro              | `umacro`         | _health_sub                                                                  |

Notes related to processing year 2012:

* Input dataset `h12c_r` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* Loop macro `_health_sub` _NOT_ executed in a test mode

======= Year 2012 processing completed =======


14. --- Year 2014 selected (14/16) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                                                                      |
| :---------------        | :-------         | :-----                                                                       |
| Input library           | `libin`          | hrslibin                                                                     |
| Input dataset           | `datain`         | h14c_r                                                                       |
| Auxiliary variable      | `wv`             | 7                                                                            |
| Auxiliary variable      | `cx`             | O                                                                            |
| Health Rate vars		  |	`hlthrte_list`   | OC001 OC002	                                                                     |
| Blood Pressure vars     | `bloodp_list`    | OC005 OC006 OC007 OC008	                                                     |
| Diabetes vars			  | `diabetes_list`  | OC010 OC011 OC012 OC013 OC014 OC015 OC017	                                         |
| Cancer vars			  | `cancer_list`    | OC018 OC019 OC020 OC024 OC028		                                                      |
| Cancer treatment vars	  | `cancer_trt_list`| OC021m1 OC021m2 OC021m3 OC021m4 OC021m5 OC021m6 OC                           |
| Lung vars				  | `lung_list`		 | OC030 OC032 OC033 OC034 OC035                                                            |
| Heart Disease vars	  | `heart_list`     | OC036 OC037 OC038 OC040 OC042 OC045 OC046 OC047 OC048 OC049 OC050 OC051 OC052   |  
| Stroke vars			  |	`stroke_list`    | OC053 OC054 OC055 OC056 OC057 OC058 OC059 OC060 OC061 OC062 OC064 OC063              |
| Psychiatric vars		  | `psy_list`       | OC065 OC067 OC068                                                                |
| Arthritis vars		  | `arthrit_list`	 | OC070 OC073 OC074 OC075 OC076                                                       |
| Falls vars			  | `fall_list`		 | OC079 OC080 OC081 OC082                                                                  |
| Incontinence vars		  | `incontin_list`	 | OC087 OC088 OC089 OC090 OC094                                                   |
| Vision vars			  | `eye_list`       | OC095 OC096 OC097 OC098 OC099 OC100 OC101                                            |
| Hearing vars		      | `hear_list`      | OC103                                                                            |
| Loop macro              | `umacro`         | _health_sub                                                                  |

Notes related to processing year 2014:

* Input dataset `h14c_r` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* Loop macro `_health_sub` _NOT_ executed in a test mode

======= Year 2014 processing completed =======


15. --- Year 2016 selected (15/16) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                                                                      |
| :---------------        | :-------         | :-----                                                                       |
| Input library           | `libin`          | hrslibin                                                                     |
| Input dataset           | `datain`         | h16c_r                                                                       |
| Auxiliary variable      | `wv`             | 8                                                                            |
| Auxiliary variable      | `cx`             | P                                                                            |
| Health Rate vars		  |	`hlthrte_list`   | PC001 PC002	                                                                     |
| Blood Pressure vars     | `bloodp_list`    | PC005 PC006 PC007 PC008	                                                     |
| Diabetes vars			  | `diabetes_list`  | PC010 PC011 PC012 PC013 PC014 PC015 PC017	                                         |
| Cancer vars			  | `cancer_list`    | PC018 PC019 PC020 PC024 PC028		                                                      |
| Cancer treatment vars	  | `cancer_trt_list`| PC021m1 PC021m2 PC021m3 PC021m4 PC021m5 PC021m6 PC                           |
| Lung vars				  | `lung_list`		 | PC030 PC032 PC033 PC034 PC035                                                            |
| Heart Disease vars	  | `heart_list`     | PC036 PC037 PC038 PC040 PC042 PC045 PC046 PC047 PC048 PC049 PC050 PC051 PC052   |  
| Stroke vars			  |	`stroke_list`    | PC053 PC054 PC055 PC056 PC057 PC058 PC059 PC060 PC061 PC062 PC064 PC063              |
| Psychiatric vars		  | `psy_list`       | PC065 PC067 PC068                                                                |
| Arthritis vars		  | `arthrit_list`	 | PC070 PC073 PC074 PC075 PC076                                                       |
| Falls vars			  | `fall_list`		 | PC079 PC080 PC081 PC082                                                                  |
| Incontinence vars		  | `incontin_list`	 | PC087 PC088 PC089 PC090 PC094                                                   |
| Vision vars			  | `eye_list`       | PC095 PC096 PC097 PC098 PC099 PC100 PC101                                            |
| Hearing vars		      | `hear_list`      | PC103                                                                            |
| Loop macro              | `umacro`         | _health_sub                                                                  |

Notes related to processing year 2016:

* Input dataset `h16c_r` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* Loop macro `_health_sub` _NOT_ executed in a test mode

======= Year 2016 processing completed =======


16. --- Year 2018 selected (16/16) to be processed. Test mode = Yes ---

| Description             | Name             |   Value                                                                      |
| :---------------        | :-------         | :-----                                                                       |
| Input library           | `libin`          | hrslibin                                                                     |
| Input dataset           | `datain`         | h18c_r                                                                       |
| Auxiliary variable      | `wv`             | 9                                                                            |
| Auxiliary variable      | `cx`             | Q                                                                            |
| Health Rate vars		  |	`hlthrte_list`   | QC001 QC002	                                                                     |
| Blood Pressure vars     | `bloodp_list`    | QC005 QC006 QC007 QC008	                                                     |
| Diabetes vars			  | `diabetes_list`  | QC010 QC011 QC012 QC013 QC014 QC015 QC017	                                         |
| Cancer vars			  | `cancer_list`    | QC018 QC019 QC020 QC024 QC028		                                                      |
| Cancer treatment vars	  | `cancer_trt_list`| QC021m1 QC021m2 QC021m3 QC021m4 QC021m5 QC021m6 QC                           |
| Lung vars				  | `lung_list`		 | QC030 QC032 QC033 QC034 QC035                                                            |
| Heart Disease vars	  | `heart_list`     | QC036 QC037 QC038 QC040 QC042 QC045 QC046 QC047 QC048 QC049 QC050 QC051 QC052   |  
| Stroke vars			  |	`stroke_list`    | QC053 QC054 QC055 QC056 QC057 QC058 QC059 QC060 QC061 QC062 QC064 QC063              |
| Psychiatric vars		  | `psy_list`       | QC065 QC067 QC068                                                                |
| Arthritis vars		  | `arthrit_list`	 | QC070 QC073 QC074 QC075 QC076                                                       |
| Falls vars			  | `fall_list`		 | QC079 QC080 QC081 QC082                                                                  |
| Incontinence vars		  | `incontin_list`	 | QC087 QC088 QC089 QC090 QC094                                                   |
| Vision vars			  | `eye_list`       | QC095 QC096 QC097 QC098 QC099 QC100 QC101                                            |
| Hearing vars		      | `hear_list`      | QC103                                                                            |
| Loop macro              | `umacro`         | _health_sub                                                                  |

Notes related to processing year 2018:

* Input dataset `h18c_r` _NOT_ found in `hrslibin` library ... ERROR!
* Auxiliary variables `wv` and `cx` are blank for years <= 2000
* Loop macro `_health_sub` _NOT_ executed in a test mode

======= Year 2018 processing completed =======


---- Macro `health` ended  at 13:02 (Test mode = Yes)

