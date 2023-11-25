* Print log from this program to the following location in SAS Studio;
proc printto log='/home/u59228083/BIOS511/Logs/final_730391571.log' new; 
run;

* Program Header;
/****************************************************************************
* 
* Project           : BIOS 511 Course Final
* 
* Program name      : final_730391571.sas 
* 
* Author            : Maya Krishnamoorthy (MK) 
* 
* Date created      : 2022-11-30
* 
* Purpose           : This program has been created to complete the final.  
* 
* Revision History  : 
* 
* Date          Author   Ref (#)  Revision 
* 2022-11-30    MK       1        Initial creation of program.
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
ods pdf file='/home/u59228083/BIOS511/Output/final_730391571.pdf';

libname shared "/home/u59228083/my_shared_file_links/u49231441/Data";
run;

* #1: Import the HYPERTENSION_DIAGNOSIS.csv file in the course data folder using PROC IMPORT;
proc import datafile='/home/u59228083/my_shared_file_links/u49231441/Data/HYPERTENSION_DIAGNOSIS.csv'
	out=hypertensioncsv replace
	dbms=csv;
	getnames=yes;
run;

* #2: Create a format for the numeric severity code value in the hypertension data;
proc format;
	value sev
	1 = "Intermittent"
	2 = "Mild"
	3 = "Moderate"
	4 = "Severe"
	. = "Unknown";
run;

* #3: View the distribution of the hypertension severity code using format;
proc freq data=hypertensioncsv;
	title1 "Proc Freq: Severity Code Variable in Hypertension Dataset";
	ods noproctitle;
	format SeverityCode sev.;
	tables SeverityCode / missing;
run;

* #4: Calculate the ratio of the oil production and the ratio of gas production from the first 
extraction to the last extraction for each protraction name;
* a) Sort sashelp.gulfoil by protraction name and date;
proc sort data=sashelp.gulfoil out=gulfoil;
	by protractionname date;
run;
* b) Create a data set based on the sorted data set;
* c) Create a retain one variable for the first oil value and one variable for the first gas value;
* d) Set values to first date of extraction for each protraction name;
* e) Create variables containing the last oil and gas extraction values for each protraction name;
* f-j) Calculate ratios for each protraction name;
data gulfoil2;
	set gulfoil;
	by protractionname date;
	retain firstoil firstgas 0;
	if first.protractionname & first.date then do;
		firstoil=oil; 
		firstgas=gas;
	end;
	if last.protractionname & last.date then do;
		lastoil=oil;
		lastgas=gas;
	end;
	if last.protractionname;
	oilratio = firstoil/lastoil;
	gasratio = firstgas/lastgas;
	format oilratio gasratio 8.4;
	format firstgas lastgas firstoil lastoil comma10.;
	keep protractionname firstoil firstgas lastoil lastgas oilratio gasratio;
run;

* #5: View the data set created in #4;
proc print data=gulfoil2;
	title1 "Proc Print: Gulf Oil Dataset";
	title2 "Ratio of the oil production and the ratio of gas 
production from the first extraction to the last extraction for each protraction name";
run;

* #6: Sort the sashelp.baseball dataset by league, division, and team;
proc sort data=sashelp.baseball out=baseball;
	by league division team;
run;

* #7: PROC MEANS on the sorted data set from #6 and suppress output;
proc means data=baseball noprint;
	by league division team;
	var nHits nAtBat nRBI;
	output out=baseballmeans sum= mean= n=/ autoname;
run;

* #8: Use PROC SGPLOT to generate vertical bars for the total number of hits in the data set created in #7;
proc sgplot data=baseballmeans;
	title1 "Total Hits by League and Division";
	footnote "Footnote for #8 Proc SGPlot.";
	by league division;
	vbar team / group=team response=nHits_Sum;
	label league="League" team="Team" division="Division" nHits_Sum="Hits";
	yaxis values=(0 to 1750 by 250);
run;

* #9: Clear the footnote that was created as part of #8;
footnote;

* #10: Use PROC TRANSPOSE to transpose the budget data set in the course folder by department;
proc sort data=shared.budget out=budget;
	by department;
run;

proc transpose data=budget out=tbudget (drop=_name_) prefix=region;
	by department;
	id region;
	var yr2020;
run;

* #11: Use a DATA Step on the data set created in #10 to calculate statistics;
data budgetstat;
	set tbudget;
	regionsum = sum(region1, region2, region3);
	regionmean = mean(region1, region2, region3);
	format regionsum regionmean dollar12.;
run;

* #12: Run a PROC REPORT step on the data set created in #11;
proc report data=budgetstat;
	title1 "Proc Report: Budget Data Statistics and Grand Total";
	rbreak after / summarize;
run;

* #13: Create a data set containing the orders from Israel using a merge;
proc sort data=shared.customer_dim out=customer_dim;
	by customer_id;
	where customer_country="IL";
run;

proc sort data=shared.order_fact out=order_fact;
	by customer_id;
run;

data customer_order;
	merge customer_dim(in=inc) order_fact;
	by customer_id;
	if inc=1;
	if total_retail_price > 50 then flag=1;
	else flag=0;
	days = delivery_date - order_date;
run;

* #14: Use a PROC MEANS on the data set from #13 on the days calculation;
proc means data=customer_order;
	title1 "Dataset: Analyze Number of Days Variable in Merged Customer/Order Dataset";
	class flag;
	var days;
run;

* close pdf;
ods pdf close;

proc printto;
run;