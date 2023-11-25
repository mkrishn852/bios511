* Print log from this program to the following location in SAS Studio;
proc printto log='/home/u59228083/BIOS511/Logs/lab24_730391571.log' new; 
run;

* Program Header;
/****************************************************************************
* 
* Project           : BIOS 511 Course Lab 24
* 
* Program name      : lab24_730391571.sas 
* 
* Author            : Maya Krishnamoorthy (MK) 
* 
* Date created      : 2022-11-16
* 
* Purpose           : This program has been created to complete the lab 24 assignment.  
* 
* Revision History  : 
* 
* Date          Author   Ref (#)  Revision 
* 2022-11-16    MK       1        Initial creation of program.
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
ods pdf file='/home/u59228083/BIOS511/Output/lab24_730391571.pdf';

libname shared "/home/u59228083/my_shared_file_links/u49231441/Data";
run;

* #1: macro debugging options;
options mprint;
options mlogic;
options symbolgen;

* #2: create macro with parameters, run proc means and proc print;
%macro program2(lib=, ds=, class=, var=, stats=);
	title1 "Dataset: &ds.";
	ods noproctitle;
	proc means data=&lib..&ds &stats;
		class &class;
		var &var;
		output out=&ds._stats;
	run;
	title1 "Dataset: &ds._stats";
	proc print data=&ds._stats;
		where _type_=1 & _stat_="MIN";
	run;
%mend program2;

* #3: Execute the macro created in #1;
%program2(lib=shared, ds=order_fact, class=order_type, var=total_retail_price, stats=sum min);
%program2(lib=sashelp, ds=pricedata, class=region product, var=price discount, stats=mean min max);


* #4: create macro using if then do block;
%macro program4(ds=);
	title1 "Dataset: &ds.";
	%if &obs.^=0 %then %do;
		proc print data=&ds. (obs=5);
		run;
	%end;
%mend program4;

* #5: execute macro in #4;
%let obs=0;
%program4(ds=sashelp.baseball);

%let obs=1;
%program4(ds=sashelp.snacks);

* close pdf;
ods pdf close;

proc printto;
run;