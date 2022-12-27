
%macro all_vin2nodupkey;

/* Remove duplicates from `all_vin2` macro variable */
data _all_vin2;
 length  all_vin2 $ 5000;
 all_vin2 = symget("all_vin2");
 count_w = countw(all_vin2);
 do i =1 to count_w;
   vin = scan(all_vin2, i, ' ');
   vin = upcase(vin);
   output;
 end;
 keep i vin; 
run;

proc sort data =_all_vin2 nodupkey;
 by vin;
run;

proc sort data =_all_vin2;
by i;
run;


data null;
 set _all_vin2 end = last;
 length all_vin2s $2000;
 retain all_vin2s;
 all_vin2s = strip(all_vin2s) || " " || strip(vin);
 if last then call symput("all_vin2s", all_vin2s);
run;
%mend all_vin2nodupkey;

%let all_vin2 = BSUBHH V781 V781 V789 V797 V811 V816 V779 V768 V787 V795 V803 V814 V772 V810 V972;
%let all_vin2s =;
%all_vin2nodupkey;
%put all_vin2s := &all_vin2s;
proc print data = _all_vin2;
run;