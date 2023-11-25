* Print log from this program to the following location in SAS Studio;
proc printto log='/home/u59228083/BIOS511/Logs/lab09_730391571.log' new; 
run;

* Program Header;
/****************************************************************************
* 
* Project           : BIOS 511 Course 
* 
* Program name      : lab09_730391571.sas 
* 
* Author            : Maya Krishnamoorthy (MK) 
* 
* Date created      : 2022-09-14 
* 
* Purpose           : This program has been created to complete the lab 9 assignment, and learn how to use ODS graphics.  
* 
* Revision History  : 
* 
* Date          Author   Ref (#)  Revision 
* 2022-09-14    MK       1        Initial creation of program.
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
ods pdf file='/home/u59228083/BIOS511/Output/lab09_730391571.pdf';

* #1: run a proc univariate and use ODS to only print the plots;
ods graphics on;

proc sort data=sashelp.bweight out=bweight_sorted;
	key momedlevel / ascending; 
run;

proc univariate data=bweight_sorted plots;
	title1 "Proc Univariate of BWeight Dataset Mom Weight Gain";
	title2 "Print ODS Plots Except the SSPlots";
	var momwtgain;
	by momedlevel;
	ods select plots;
run;

* #2: run a proc freq and customize frequency plot;
libname shared "/home/u59228083/my_shared_file_links/u49231441/Data";
run;

proc freq data=shared.dm;
	title1 "Proc Freq on DM Dataset of Armcd by Race";
	title2 "Print Frequency Plot of Armcd*Race";
	tables armcd*race / norow nocol plots=(freqplot(groupby=row twoway=cluster));
run;

* #3: run a proc freq and request an agree test;
proc freq data=sashelp.bweight;
	title1 "Proc Freq of BWeight Dataset of Smoking Mother vs. Boy";
	title2 "Agree Test and Agreement Plot";
	tables momsmoke*boy / agree plots=agreeplot;
run;

* close pdf;
ods pdf close;

proc printto;
run;