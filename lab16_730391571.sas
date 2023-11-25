* Print log from this program to the following location in SAS Studio;
proc printto log='/home/u59228083/BIOS511/Logs/lab16_730391571.log' new; 
run;

* Program Header;
/****************************************************************************
* 
* Project           : BIOS 511 Course Lab 16
* 
* Program name      : lab16_730391571.sas 
* 
* Author            : Maya Krishnamoorthy (MK) 
* 
* Date created      : 2022-10-19
* 
* Purpose           : This program has been created to complete the lab 16 assignment.  
* 
* Revision History  : 
* 
* Date          Author   Ref (#)  Revision 
* 2022-10-19    MK       1        Initial creation of program.
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
ods pdf file='/home/u59228083/BIOS511/Output/lab16_730391571.pdf';

libname shared "/home/u59228083/my_shared_file_links/u49231441/Data";
run;

* #1: create a number format;
proc format;
	title1 "New Formats";
	value num
	0 = "No"
	1 = "Yes";
run;

* #2: create a marital status format;
proc format fmtlib;
	title1 "New Formats";
	value marital
	1 = "Single"
	2 = "Married"
	3 = "Separated"
	4 = "Divorced"
	5 = "Widowed";
run;

* #3: create plot of acute illness by marital status;
* use formats from 1 and 2, as well as segment labels;
proc sgplot data=shared.depression;
	title1 "Segmented Bar Chart Representing Acute Illness by Marital Status";
	format Marital marital. AcuteIllness num.;
	vbar Marital / group=AcuteIllness seglabel name="Acute Illness by Marital Status";
	keylegend "Acute Illness by Marital Status" / position=topright;
run;

* #4: create new date-time variables using input function, as well as new numeric variables from those date-time variables;
data dm;
	set shared.dm;
	
	icdate = input(rficdtc, yymmdd10.);
	first = input(rfxstdtc, yymmdd10.);
	last = input(rfxendtc, yymmdd10.);
	
	fic = first - icdate;
	lf = last - first;
run;

* #5: proc means for dm data classified by sex and race, only looking at variables from #4;
proc means data=dm;
	title1 "Analysis of First-Informed and Last-First Data Points in Temporary DM Dataset";
	title2 "Classified by Sex and Race";
	class sex race;
	var fic lf;
run;

* #6: create a new percent change character variable using the put function;
* also add a label to the new variable;
data budget;
	set shared.budget;
	length char $15;
	change = (yr2020-yr2019)/yr2020;
	char = put(change, percent10.);
	label char = "Percent Change";
run;

* #7: print first ten observations;
proc print data=budget (obs=10) label;
	title1 "Percent Change in Budget per Department";
	title2 "";
	var department char;
run;

* close pdf;
ods pdf close;

proc printto;
run;