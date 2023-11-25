* Print log from this program to the following location in SAS Studio;
proc printto log='/home/u59228083/BIOS511/Logs/lab13_730391571.log' new; 
run;

* Program Header;
/****************************************************************************
* 
* Project           : BIOS 511 Course Lab 13
* 
* Program name      : lab13_730391571.sas 
* 
* Author            : Maya Krishnamoorthy (MK) 
* 
* Date created      : 2022-10-05 
* 
* Purpose           : This program has been created to complete the lab 13 assignment.  
* 
* Revision History  : 
* 
* Date          Author   Ref (#)  Revision 
* 2022-10-05    MK       1        Initial creation of program.
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
ods pdf file='/home/u59228083/BIOS511/Output/lab13_730391571.pdf';

libname shared "/home/u59228083/my_shared_file_links/u49231441/Data";
run;

* #1: create temporary dataset for AE type vascular disorders and keep only necessary columns;
data temp_ae;
	set shared.ae;
	where aesoc='Vascular disorders';
	keep usubjid aesev aeout aestdtc;
run;

* #2: run proc contents of temporary AE dataset but exclude engine/host information;

ods exclude enginehost;
proc contents data=temp_ae;
	title1 "Contents of Temporary AE dataset excluding Engine/Host Information";
run;

* #3: create temporary dataset for snacks that shows only pretzel twists and shows them at 90% of their original price;

data temp_snacks;
	set sashelp.snacks;
	price_percent = 0.9*price;
	if product = 'Pretzel twists';
	label price_percent = '90% of price';
	drop price;
run;

* #4: same as #2 but for temp_snacks dataset;

ods exclude enginehost;
proc contents data=temp_snacks;
	title1 "Contents of Temporary Snacks dataset excluding Engine/Host Information";
run;

* #5: create temporary dataset for employee donation and creates new column for total donations per year for each employee;

data temp_employee_donations;
	set shared.employee_donations;
	total_per_year = sum(qtr1, qtr2, qtr3, qtr4);
run;

* #6: proc means on temporary employee donations total per year for each type of payment;

proc means data=temp_employee_donations n mean nonobs;
	title1 "N and Mean Statistics for Each Type of Payment of Employee Donations";
	ods noproctitle;
	class paid_by;
	var total_per_year;
run;

* close pdf;
ods pdf close;

proc printto;
run;