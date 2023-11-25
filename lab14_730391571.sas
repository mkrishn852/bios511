* Print log from this program to the following location in SAS Studio;
proc printto log='/home/u59228083/BIOS511/Logs/lab14_730391571.log' new; 
run;

* Program Header;
/****************************************************************************
* 
* Project           : BIOS 511 Course Lab 14
* 
* Program name      : lab14_730391571.sas 
* 
* Author            : Maya Krishnamoorthy (MK) 
* 
* Date created      : 2022-10-10 
* 
* Purpose           : This program has been created to complete the lab 14 assignment, combining datasets.  
* 
* Revision History  : 
* 
* Date          Author   Ref (#)  Revision 
* 2022-10-10    MK       1        Initial creation of program.
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
ods pdf file='/home/u59228083/BIOS511/Output/lab14_730391571.pdf';

libname personal "/home/u59228083/BIOS511/Data";
run;

libname shared "/home/u59228083/my_shared_file_links/u49231441/Data";
run;

* #1: create a permanent merged dataset from DM and AE by subject ID;

proc sort data=shared.ae out=work.ae;
	by usubjid;
run;

proc sort data=shared.dm out=work.dm;
	by usubjid;
run;

data personal.aedm;
	merge ae dm;
	by usubjid;
run;

* #2: running proc contents on dataset from #1;

ods exclude enginehost variables;
proc contents data=personal.aedm;
	title1 "Contents of Permanent AE/DM Merged Dataset excluding Engine/Host Information";
run;

* #3: create temp merged dataset of ae and dm but only include subjects without adverse events;

data aedm;
	merge dm(in=ind) ae(in=int);
	if ind=1 and int=0;
	by usubjid;
	keep usubjid sex age;
run;

* #4: print first 10 obs of temporary dataset aedm;

proc print data=aedm (obs=10);
	title1 "First 10 Observations of Temporary AE/DM Merged Dataset without Adverse Event";
run;

* #5: create permanent merged dataset, subset subjects who did have adverse events;

data personal.aedm2;
	merge dm(in=ind) ae(in=int);
	if ind=1 and int=1;
	by usubjid;
run;

* #6: create panel graph of severity by gender - panel by race arm combination and hide var names;

proc sgpanel data=personal.aedm2;
	title1 "Panel Graph by Race Arm Combination of Severity by Gender";
	panelby race arm / novarname spacing=20 columns=4;
	vbar aesev / group=sex; 
run;

* #7: merge dbp and sbp datasets and create new columns in the dataset based on values in each;

data dbp;
	set shared.vs;
	where vstestcd = "DIABP";
run;

data sbp;
	set shared.vs;
	where vstestcd = "SYSBP";
run;

proc sort data=dbp; by usubjid visitnum visit;
proc sort data=sbp; by usubjid visitnum visit;
run;

data bp;
	merge dbp(rename=(vsstresn=DIABP)) sbp(rename=(vsstresn=SYSBP));
	by usubjid visitnum visit;
	keep usubjid visitnum visit DIABP SYSBP;
run;

* #8: print bp data for subject echo-015-018;

proc print data=bp;
	title1 "BP Data For Subject ECHO-015-018";
	where usubjid = "ECHO-015-018";
run;

* #9: repeat 7b by merging dataset on itself;

data vsbp;
	merge shared.vs (where=(vstestcd="DIABP") rename=(vsstresn=DIABP)) shared.vs (where=(vstestcd="SYSBP") rename=(vsstresn=SYSBP));
	keep usubjid visitnum visit DIABP SYSBP;
run;


* #10: proc contents on vs / vs merged dataset;

ods exclude enginehost;
proc contents data=vsbp;
	title1 "Contents of Temporary VS/VS Merged Dataset excluding Engine/Host Information";
run;

* close pdf;
ods pdf close;

proc printto;
run;