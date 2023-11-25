* Print log from this program to the following location in SAS Studio;
proc printto log='/home/u59228083/BIOS511/Logs/lab05_730391571.log' new; 
run;

* Program Header;
/****************************************************************************
* 
* Project           : BIOS 511 Course 
* 
* Program name      : lab05_730391571.sas 
* 
* Author            : Maya Krishnamoorthy (MK) 
* 
* Date created      : 2022-08-29 
* 
* Purpose           : This program has been created to complete the lab 5 assignment.  
* 
* Revision History  : 
* 
* Date          Author   Ref (#)  Revision 
* 2022-08-29    MK       1        Initial creation of program.
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

* #1 sort data by region, then print out temp data by region, selecting only the population and name;
proc sort data=sashelp.demographics out=work.demographics;
by region;
run;

proc print data=work.demographics;
	title1 "Proc Print of Demographics by Region";
	by region;
	var pop name;
run;


* #2 run a proc print on the shared data file employee donations
first access the shared library;
libname shared "/home/u59228083/my_shared_file_links/u49231441/Data";
run;

* hide observation ID, add label for "type of payment";
* replace missing by 0s, organize variable order, and print sums for numeric vars;
proc print data=shared.employee_donations NOOBS label;
	title1 "Proc Print of Modified Employee Donations";
	option missing = 0;
	label paid_by="Type of Payment";
	format qtr1 qtr2 qtr3 qtr4 dollar8.2;
	var paid_by recipients qtr1 qtr2 qtr3 qtr4;
	sum qtr1 qtr2 qtr3 qtr4;
run;

* #3 sort the shared dataset customer_dim so that there are no duplicate customer names;
proc sort data=shared.customer_dim out=work.customer_dim nodupkey;
	by Customer_Name;
run;

* run a proc freq on the country variable to see its distribution;
proc freq data=work.customer_dim;
	title1 "Proc Freq on Customer Country";
	tables customer_country;
run;

* #4 run a proc freq to get a table comparing distribution of customer country and age group;
proc freq data=work.customer_dim;
	title1 "Proc Freq on Customer Country by Customer Age Group";
	tables customer_country*customer_age_group;
run;

* #5 run a proc freq to get a table comparing customer type and group;
* limit customer age group to > 40;
* list contains percents in distribution;
proc freq data=work.customer_dim;
	title1 "Proc Freq on Customer Group by Customer Type";
	where customer_age > 40;
	tables customer_type*customer_group customer_group*customer_type / list;
run;
	
* #6 run a proc freq to get a table comparing treatment and status;
* request relative risk and Cochran-Mantel-Haenszel statistics;
proc freq data=shared.living_data;
	title1 "Proc Freq on Treatment vs. Status";
	tables treatment*status / relrisk cmh;
run;

proc printto;
run;