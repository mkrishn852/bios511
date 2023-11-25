* Print log from this program to the following location in SAS Studio;
proc printto log='/home/u59228083/BIOS511/Logs/lab08_730391571.log' new; 
run;

* Program Header;
/****************************************************************************
* 
* Project           : BIOS 511 Course 
* 
* Program name      : lab08_730391571.sas 
* 
* Author            : Maya Krishnamoorthy (MK) 
* 
* Date created      : 2022-09-12 
* 
* Purpose           : This program has been created to complete the lab 8 assignment, and learn how to use ODS.  
* 
* Revision History  : 
* 
* Date          Author   Ref (#)  Revision 
* 2022-09-12    MK       1        Initial creation of program.
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

* #1: create RTF file for ODS;

libname shared "/home/u59228083/my_shared_file_links/u49231441/Data";
run;
ods rtf file='/home/u59228083/BIOS511/Output/lab08_730391571.rtf';

* running a proc freq on living_data and request Fisher's exact test;
proc freq data=shared.living_data;
	title1 "Chi-Square Fisher's Exact Test 2x2 Table of Living Data";
	ods noproctitle;
	tables treatment*status / chisq;
	ods select "Fisher's Exact Test";
run;

* running a proc print on sashelp dataset;
* sort the data first;
proc sort data=sashelp.us_data out=us_data_sorted;
	by region;
run;
* print the data and split the ods output into pages by region;
proc print data=us_data_sorted;
	title1 "US Population Data Sorted by Region (2000, 2010)";
	var division statename population_2000;
	var population_2010 / style(column)=[background=pink];
	by region;
	ods rtf startpage=bygroup;
run;

* close rtf;
ods rtf close;

* #2: create PDF ODS file;

* create ODS file and use ocean style template;
ods pdf file='/home/u59228083/BIOS511/Output/lab08_730391571.pdf' style=ocean;

* proc univariate on sashelp dataset;
ods exclude all;
ods output quantiles=dataquantiles;
proc univariate data=sashelp.pricedata;
	var sale;
run;

* turn printing back on;
ods select all;

* print dataset dataquantiles;
proc print data=dataquantiles;
	title1 "ODS Output of Quantiles Data";
run;

* proc means on sashelp.shoes dataset;
proc means data=sashelp.shoes;
	title1 "Proc Means of Shoes Dataset by Sales Variable";
	ods output summary=shoes_summary_ods;
	var sales;
	output out=shoes_summary_output;
run;

* proc print of ods output;
proc print data=shoes_summary_ods;
	title1 "ODS Output from Shoes Dataset Proc Means Summary";
run;

* proc print of output out=;
proc print data=shoes_summary_output;
	title1 "Basic Output from Shoes Dataset Proc Means Summary";
run;

* close pdf;
ods pdf close;

proc printto;
run;