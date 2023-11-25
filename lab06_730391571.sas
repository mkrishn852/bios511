* Print log from this program to the following location in SAS Studio;
proc printto log='/home/u59228083/BIOS511/Logs/lab06_730391571.log' new; 
run;

* Program Header;
/****************************************************************************
* 
* Project           : BIOS 511 Course 
* 
* Program name      : lab06_730391571.sas 
* 
* Author            : Maya Krishnamoorthy (MK) 
* 
* Date created      : 2022-08-31 
* 
* Purpose           : This program has been created to complete the lab 6 assignment.  
* 
* Revision History  : 
* 
* Date          Author   Ref (#)  Revision 
* 2022-08-31    MK       1        Initial creation of program.
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

* #1 all variables in data are numeric so don't need to specify - run proc means;
proc means data=shared.preemies std uclm lclm sum median mode;
	title1 "Proc Means on Preemies Data";
run;

* #2 run proc means by region for years 2016 and 2017;
proc means data=shared.budget n sum mean;
	title1 "Proc Means on Budget by Region for 2016 & 2017";
	class region;
	var yr2016 yr2017;
run;

* #3 run proc means on sashelp orsales dataset by creating a new nways dataset;
proc means data=sashelp.orsales noprint nway;
	where year=2001;
	class Product_Line Product_Category;
	var Quantity Profit Total_Retail_Price;
	output out=orsales_nway sum=/autoname;
run;

* #4 run proc print on new NWAY dataset looking at only golf and running-jogging categories;
proc print data=orsales_nway NOOBS;
	title1 "Proc Print on NWAY OrSales Dataset";
	where Product_Category in ("Golf" "Running - Jogging");
	format Profit_Sum dollar12.2;
	var Product_Line Product_Category Profit_Sum;
run;
	
* #5 re-run proc means from #3 but must create my own variable names instead of autonames in nway;
proc means data=sashelp.orsales noprint nway;
	where year=2001;
	class Product_Line Product_Category;
	var Profit Total_Retail_Price;
	output out=orsales_modified sum(profit)=Profit_Sum sum(total_retail_price)=Retail_Price_Sum mean(profit)=Profit_Mean mean(total_retail_price)=Retail_Price_Mean;
run;

* #6 sort data in shared.budget before running proc univariate on sorted data with confidence intervals;
proc sort data=shared.budget out=work.budget_sorted;
	by department;
run;

proc univariate data=work.budget_sorted cibasic vardef=df;
	title1 "Proc Univariate on Budget Dataset by Department in 2020";
	by department;
	var yr2020;
run;

* #7 run proc univariate by departmennt and ultimately print histogram of budget by department in 2020;
proc univariate data=shared.budget noprint;
	title1 "Histogram of Budget by Department in Year 2020";
	histogram;
	class department;
	var yr2020;
	inset mean std /position=NE;
run;
	
proc printto;
run;