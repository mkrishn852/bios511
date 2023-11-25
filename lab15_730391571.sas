* Print log from this program to the following location in SAS Studio;
proc printto log='/home/u59228083/BIOS511/Logs/lab15_730391571.log' new; 
run;

* Program Header;
/****************************************************************************
* 
* Project           : BIOS 511 Course Lab 15
* 
* Program name      : lab15_730391571.sas 
* 
* Author            : Maya Krishnamoorthy (MK) 
* 
* Date created      : 2022-10-17 
* 
* Purpose           : This program has been created to complete the lab 15 assignment.  
* 
* Revision History  : 
* 
* Date          Author   Ref (#)  Revision 
* 2022-10-17    MK       1        Initial creation of program.
* 
* 
* searchable reference phrase: *** [1] ***; 
* 
* Note: Standard header taken from : 
*  https://www.phusewiki.org/wiki/index.php?title=Program_Header 
****************************************************************************/

* Adds the following notes to the log;
%put %upcase(no)TE: Program being run by 730391571;
options nofullstimer;

/*********MY CODE***********/
ods _all_ close;

* create pdf file;
ods pdf file='/home/u59228083/BIOS511/Output/lab15_730391571.pdf';

libname shared "/home/u59228083/my_shared_file_links/u49231441/Data";
run;

* #1: create a new temporary dataset with a new categorical variable based off shared lib depression dataset;
data depression;
	set shared.depression;
	length cat $20;
	if case=0 then do;
		if health<=2 then cat = "Good";
		if health=3 then cat = 'Acceptable';
	end;
	else if case=1 then do;
		if health<=3 then cat = "Bad";
		if health=4 then cat = 'Very Bad';
	end;
	if health=. then cat = "Unknown";
	label cat = "Resulting Category";
run;


* #2: run proc freq to check results;
title1 "Proc Freq on Dataset by Category";
proc freq data=depression;
table cat;
run;

* #3: same process as #1 but using select instead of if statements;
data depression_select;
	set shared.depression;
	length cat $20;
	select;
		when (health=.) cat = "Unknown";
		when ((case=0) and (health<=2)) cat = "Good";
		when ((case=0) and (health=3)) cat = "Acceptable";
		when ((case=1) and (health<=3)) cat = "Bad";
		when ((case=1) and (health=4)) cat = "Very Bad";
	end;
	label cat = "Resulting Category";
run;

* #4: use proc compare to compare data methods;
title1 "Compare Datasets Using If vs. Select Method";
proc compare base=depression comp=depression_select;
run;

* #5: calculate sum of donations by observation using sum function versus add operator, then compute difference;
data donations;
	set shared.employee_donations;
	total_sum = sum(qtr1, qtr2, qtr3, qtr4);
	if qtr1=. then qtr1=0;
	if qtr2=. then qtr2=0;
	if qtr3=. then qtr3=0;
	if qtr4=. then qtr4=0;
	total_add = qtr1+qtr2+qtr3+qtr4;
	total_diff = total_sum - total_add;
run;

* #6: proc means shows that total diff is always 0;
title1 "Proc Means on Total Difference in Donations Dataset";
proc means data=donations min max mean sum nmiss;
	var total_diff;
run;

* close pdf;
ods pdf close;

proc printto;
run;