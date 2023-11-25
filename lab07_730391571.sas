* Print log from this program to the following location in SAS Studio;
proc printto log='/home/u59228083/BIOS511/Logs/lab07_730391571.log' new; 
run;

* Program Header;
/****************************************************************************
* 
* Project           : BIOS 511 Course 
* 
* Program name      : lab07_730391571.sas 
* 
* Author            : Maya Krishnamoorthy (MK) 
* 
* Date created      : 2022-09-07 
* 
* Purpose           : This program has been created to complete the lab 7 assignment.  
* 
* Revision History  : 
* 
* Date          Author   Ref (#)  Revision 
* 2022-09-07    MK       1        Initial creation of program.
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
* ods <destination> file='<PATH TO YOUR BIOS511/OUTPUT FOLDER>/lab##_PID.ext';

/**********MY CODE**********/

*first access the shared library;
libname shared "/home/u59228083/my_shared_file_links/u49231441/Data";
run;

* 1: create a proc report for the montreal team subset of the baseball dataset;
proc report data=sashelp.baseball (obs=25);
	title1 "Detailed Report on Team Montreal Subset of Baseball Dataset";
	where Team = "Montreal";
	column name position ("Statistics" nAtBat nHits);
run;

* 2: create a proc report on the shoes dataset, and created two new column headers that requested statistics of sales and inventory;
proc report data=sashelp.shoes;
	title1 "Summary Report on Shoes Dataset";
	column region product sales inventory;
	define region / group 'Region';
	define product / group 'Product';
	define sales / 'Max Sales' analysis max;
	define inventory / 'Avg Inventory' analysis mean;
run;

* 3: create a proc report for budget by department for years 2018-2020;
proc report data=shared.budget;
	title1 "Proc Report for Budget 2018-2020";
	column department,(yr2018 yr2019 yr2020);
	define department / across '';
	
run;

* 4: create a summary report for employee donations, grouped by type of payment;
proc report data=shared.employee_donations;
	title1 "Summary Report for Employee Donations";
	column paid_by qtr1 qtr2 qtr3 qtr4;
	define paid_by / group "Paid By";
	format qtr: dollar8.;
	define qtr1 / style(column)=[background=yellow];
run;

* 5: create a report for the number of cars by type and suppress printing of column labels;
proc report data=sashelp.cars;
	title1 "Proc Report for Number of Cars by Type";
	define origin / group '';
	define type / across '';
	define n / '';
	column origin type, n;
	option missing=0;
	
run;

proc printto;
run;