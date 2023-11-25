* Print log from this program to the following location in SAS Studio;
proc printto log='/home/u59228083/BIOS511/Logs/lab19_730391571.log' new; 
run;

* Program Header;
/****************************************************************************
* 
* Project           : BIOS 511 Course Lab 19
* 
* Program name      : lab19_730391571.sas 
* 
* Author            : Maya Krishnamoorthy (MK) 
* 
* Date created      : 2022-10-31
* 
* Purpose           : This program has been created to complete the lab 19 assignment.  
* 
* Revision History  : 
* 
* Date          Author   Ref (#)  Revision 
* 2022-10-31    MK       1        Initial creation of program.
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
ods pdf file='/home/u59228083/BIOS511/Output/lab19_730391571.pdf';

libname shared "/home/u59228083/my_shared_file_links/u49231441/Data";
run;


* #1: sum the nruns and nrbi variables within each combination of 
league and division using retain statement;
proc sort data=sashelp.baseball out=baseball;
	by league division;
run;

data sum_baseball;
	set baseball;
	by league division;
	retain total_nruns total_nrbi;
	if first.division then do;
		total_nruns = 0;
		total_nrbi = 0;
	end;
	total_nruns = total_nruns + nRuns;
	total_nrbi = total_nrbi + nRBI;
	if last.division;
	keep league division total_nruns total_nrbi;
	label total_nruns="Total Runs";
	label total_nrbi="Total RBIs";
run;

* #2: print sum_baseball data and run a proc means to find sum of nruns and nrbis based on league and division;
proc print data=sum_baseball label;
	title1 "Print Data from #1: Baseball";
run;

proc means data=sum_baseball sum;
	title1 "Proc Means on Baseball Data: Sum nRuns and nRBIs with League and Division";
	var total_nruns total_nrbi;
	class league division;
run;

* #3: Standardize the value of the dates and create numeric versions;

data ae;
	set shared.ae;
	if length(aestdtc) = 7 then aestdtc = catx('-',aestdtc,'01'); 
	if length(aeendtc) = 7 then aeendtc = catx('-',aeendtc,'01'); 
	stdtcnum = input(aestdtc, yymmdd10.);
	endtcnum = input(aeendtc, yymmdd10.);
	format stdtcnum yymmdd10. endtcnum yymmdd10.;
run;

* #4: Sort the data set created in #3 by the subject and numeric start date;

proc sort data=ae out=ae;
	by usubjid stdtcnum;
run;

* #5: sort data and merge based on what's in ae dataset;
* identify earliest adverse event for each subject;

proc sort data=shared.dm out=dm;
	by usubjid;
run;

data aedm;
	merge ae(in=ina) dm(in=ind);
	by usubjid;
	if ina=1 and first.usubjid;
		numdt=input(rfxstdtc, yymmdd10.);
		days=stdtcnum-numdt;
	label days="Number of days to the first adverse event";
	drop numdt;
run;

* #6: print histogram for Number of Days to First Adverse Event by Treatment in Arm;

proc sgplot data=aedm;
	title1 "Histogram for Number of Days to First Adverse Event by Treatment in Arm";
	histogram days / group=arm;
	density days / type=normal;
	density days / type=kernel;
	label arm="Type of Medication Arm Receives";
run;

* close pdf;
ods pdf close;

proc printto;
run;