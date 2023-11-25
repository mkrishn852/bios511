* Print log from this program to the following location in SAS Studio;
proc printto log='/home/u59228083/BIOS511/Logs/lab20_730391571.log' new; 
run;

* Program Header;
/****************************************************************************
* 
* Project           : BIOS 511 Course Lab 20
* 
* Program name      : lab20_730391571.sas 
* 
* Author            : Maya Krishnamoorthy (MK) 
* 
* Date created      : 2022-11-02
* 
* Purpose           : This program has been created to complete the lab 20 assignment.  
* 
* Revision History  : 
* 
* Date          Author   Ref (#)  Revision 
* 2022-11-02    MK       1        Initial creation of program.
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
ods pdf file='/home/u59228083/BIOS511/Output/lab20_730391571.pdf';

libname shared "/home/u59228083/my_shared_file_links/u49231441/Data";
run;

* #1: sort budget data by region and then transpose data and create new year variable combining individual year columns;

proc sort data=shared.budget out=budget;
	by region;
run;

proc transpose data=budget out=tbudget(rename=(_name_=year));
	by region;
	id department;
	var yr2016 yr2017 yr2018 yr2019 yr2020;
run;

* #2: print transposed dataset for observations where region=2;

proc print data=tbudget;
	title1 "Transposed Budget Data where Region=2";
	where region=2;
run;

* #3: transpose data stocks by date, id=stock, and look at close variable;

proc sort data=sashelp.stocks out=stocks;
	by date;
run;

proc transpose data=stocks out=tstocks(drop=_name_);
	by date;
	id stock;
	var close;
run;

* #4: series graph where x axis is data and y axis is ibm;

proc sgplot data=tstocks;
	title1 "Series Plot of IBM Stock Value Over Time";
	series x=date y=ibm;
run;

* #5: use the data step to transpose the budget dataset manually;

data budget5;
	set shared.budget;
	where department="C";
	year=2016; budgetval=yr2016; output;
	year=2017; budgetval=yr2017; output;
	year=2018; budgetval=yr2018; output;
	year=2019; budgetval=yr2019; output;
	year=2020; budgetval=yr2020; output;
	format budgetval dollar10.;
	keep region qtr year budgetval;
	label region="Region" qtr="Quarter" year="Years 2016-2020" budgetval="Budget Value";
run;

* #6: print contents of only variables table;

proc contents data=budget5;
	title1 "Contents of Budget5 - Variable Table";
	ods select variables;
run;

* close pdf;
ods pdf close;

proc printto;
run;