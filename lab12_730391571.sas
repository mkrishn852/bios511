* Print log from this program to the following location in SAS Studio;
proc printto log='/home/u59228083/BIOS511/Logs/lab12_730391571.log' new; 
run;

* Program Header;
/****************************************************************************
* 
* Project           : BIOS 511 Course Lab 12
* 
* Program name      : lab12_730391571.sas 
* 
* Author            : Maya Krishnamoorthy (MK) 
* 
* Date created      : 2022-10-03 
* 
* Purpose           : This program has been created to complete the lab 12 assignment, and learn how to create new datasets.  
* 
* Revision History  : 
* 
* Date          Author   Ref (#)  Revision 
* 2022-10-03    MK       1        Initial creation of program.
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
ods pdf file='/home/u59228083/BIOS511/Output/lab12_730391571.pdf';

libname shared "/home/u59228083/my_shared_file_links/u49231441/Data";
run;

* #1: create temporary version of dataset sashelp.us_data and alter some variables;
data temp_us_data;
	set sashelp.us_data;
	length comb_statediv $40;
	comb_statediv = catx(': ', statename, division);
	percentchange = round((((density_2010 - density_2000)/density_2000)*100),.01);
	output;
run;

* #2: organize temp_us_data by descending percent change;
proc sort data=temp_us_data out=sorted_temp_us_data;
	by descending percentchange;
run;

* #3: print sorted_temp_us_data observations;
proc print data=sorted_temp_us_data (obs=15) noobs;
	title1 "Top 15 Observations Sorted Based on Highest Percent Change in Density between 2000 and 2010";
	var statename division density_2010 density_2000 comb_statediv percentchange;
run;

* #4: create temporary version of budget and create new numeric variable for average;
data temp_budget;
	set shared.budget;
	five_year_avg = mean(yr2016, yr2017, yr2018, yr2019, yr2020);
run;

* #5: request mean, max, and min for each department;
proc sort data=temp_budget;
	by department;
run;

proc means data=temp_budget nonobs mean max min;
	title1 "Budget Average Mean, Maximum, and Minimum Funds for Each Department";
	ods noproctitle;
	by department;
	var five_year_avg;
run;

* close pdf;
ods pdf close;

proc printto;
run;