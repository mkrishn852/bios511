* Print log from this program to the following location in SAS Studio;
proc printto log='/home/u59228083/BIOS511/Logs/lab10_730391571.log' new; 
run;

* Program Header;
/****************************************************************************
* 
* Project           : BIOS 511 Course Lab 10
* 
* Program name      : lab10_730391571.sas 
* 
* Author            : Maya Krishnamoorthy (MK) 
* 
* Date created      : 2022-09-19 
* 
* Purpose           : This program has been created to complete the lab 10 assignment, and learn how to use proc sg plot.  
* 
* Revision History  : 
* 
* Date          Author   Ref (#)  Revision 
* 2022-09-19    MK       1        Initial creation of program.
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
ods pdf file='/home/u59228083/BIOS511/Output/lab10_730391571.pdf';

libname shared "/home/u59228083/my_shared_file_links/u49231441/Data";
run;

* #1 create horizontal bar chart for employee donations by payment category;

title2 "Data: Employee Donations"; 
title3 "Horizontal Bar Chart by Payment Category";
proc sgplot data=shared.employee_donations;
	hbar paid_by / response=qtr4 stat=sum dataskin=pressed;
run;

* #2 create overlaid bar plot by origin category;

title2 "Data: Cars";
title3 "Vertical Overlaid Bar Chart by Origin Category for MSRP and Invoice Variables";
proc sgplot data=sashelp.cars;
	vbar origin / response=msrp stat=sum transparency=.3;
	vbar origin / response=invoice stat=sum transparency=.3 barwidth=.5;
run;

* #3 summarize vs dataset and store the results in a temporary data set vs_output;

proc means data=shared.vs noprint nway;
	class vstestcd vstest visitnum visit;
	var vsstresn;
	output out=vs_output mean=;
run;

* #4 create graph with overlaid scatter and series plot based on output dataset from proc means in #3;

title2 "Data: Vital Signs";
title3 "Series Plot Overlaid by Scatter Plot Measuring Patient Weight Average";
proc sgplot data=vs_output noautolegend;
	where vstestcd="WEIGHT";
	series x=visit y=vsstresn;
	scatter x=visit y=vsstresn / markerattrs=(symbol=diamond);
	yaxis values=(69.8 to 70.7 by .1);
	label vsstresn = "Patient Weight";
run;

* close pdf;
ods pdf close;

proc printto;
run;