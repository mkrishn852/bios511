* Print log from this program to the following location in SAS Studio;
proc printto log='/home/u59228083/BIOS511/Logs/lab23_730391571.log' new; 
run;

* Program Header;
/****************************************************************************
* 
* Project           : BIOS 511 Course Lab 23
* 
* Program name      : lab23_730391571.sas 
* 
* Author            : Maya Krishnamoorthy (MK) 
* 
* Date created      : 2022-11-14
* 
* Purpose           : This program has been created to complete the lab 23 assignment.  
* 
* Revision History  : 
* 
* Date          Author   Ref (#)  Revision 
* 2022-11-14    MK       1        Initial creation of program.
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

libname shared "/home/u59228083/my_shared_file_links/u49231441/Data";
run;

* #1: create a macro variable to hold my PID;
%let pid=730391571;
%put &pid; run;

* #2: create a macro variable that holds path to output files;
%let path=/home/u59228083/BIOS511/Output;
%put &path; run;

* #3: use macro variables created in #1 and #2 in an ODS PDF statement that creates output file;
ods pdf file="&path./lab23_&pid..pdf";

* #4: create a macro variable containing the text: BIOS 511 LAB 23 Macro Variables;
%let text="BIOS 511 LAB 23 Macro Variables";
title1 &text;

* #5: put the patient counts for each treatment into macro variables;
* a: find counts by doing proc means;
* b: use symputx to put it into macro variables;
proc means data=shared.tumor2 noprint;
	class treatment;
	output out=treatment_n n=count;
run;

data _NULL_;
	set treatment_n;
	if treatment="Placebo" then call symputx('tot1', count);
	if treatment="X 50mg" then call symputx('tot2', count);
	if treatment="" then call symputx('tot99', count); 
run;

* #6: write the values of the macro variables created in #5b to the log;
%put &tot1; run;
%put &tot2; run;
%put &tot99; run;

* #7: generate a horizontal bar chart of the frequency of the stage variable in the tumor1 data set;
proc sgplot data=shared.tumor1;
	title2 "Overall Population Total: &tot99.";
	hbar stage;
run;

* #8: programmatically create a macro variable containing a list of names of character variables from 
* the ae data set in the course folder;
proc contents data=shared.ae out=ae (where=(type=2)) noprint; 

proc sort data=ae; 
	by varnum;
run;
	
data _null_; 
  set ae end=eof;
  length var $100;
  retain var;
    var = catx(" ",var,name); 
if eof=1 then call symputx("CharVarNames", var);
run;

%put &CharVarNames; run;

* #9: use an ARRAY statement and a DO loop to change values of the character variables to be all lowercase;
data ae2;
	set shared.ae;
	array name{*} &CharVarNames;
	do i=1 to dim(name);
		name{i} = lowcase(name{i});
	end;
	drop i;
run;

* #10: print five observations from the data set created in #9;
proc print data=ae2(obs=5) noobs;
	title2 "Character Variable Names in Dataset: AE";
	var &CharVarNames;
run;

* #11: Create a series of macro variables, vstest1 – vstestN.  Each macro variable will hold the 
code name of one of the vital sign tests from the vs data set in the course folder.  
Create a second series of macro variables containing the corresponding full name of the 
test, vsname1 – vsnameN.;
proc sort data=shared.vs (keep=vstestcd vstest) out=vssorted nodupkey;
 	by vstestcd vstest;
run;

data _null_;
 set vssorted;
 if vstestcd='DIABP' then call symputx('vstest1', vstestcd);
 if vstest="Diastolic Blood Pressure" then call symputx('vsname1', vstest);
 if vstestcd='HEIGHT' then call symputx('vstest2', vstestcd);
 if vstest='Height' then call symputx('vsname2', vstest);
 if vstestcd='HR' then call symputx('vstest3', vstestcd);
 if vstest='Heart Rate' then call symputx('vsname3', vstest);
 if vstestcd='SYSBP' then call symputx('vstest4', vstestcd);
 if vstest='Systolic Blood Pressure' then call symputx('vsname4', vstest);
 if vstestcd='WEIGHT' then call symputx('vstest5', vstestcd);
 if vstest='Weight' then call symputx('vsname5', vstest);
run;

* #12: Create a report, using PROC REPORT, based on the vs data set for vsnmae1;	
proc report data=shared.vs;
	title2 "&vsname1.";
	where vstestcd="&vstest1.";
	column visitnum visit vsstresn;
	label vsstresn="Result";
	define visitnum / noprint group;
	define visit / group;
	define vsstresn / mean;
run;

* #13: repeat #12 for each of the remaining vstest values;
proc report data=shared.vs;
	title2 "&vsname2.";
	where vstestcd="&vstest2.";
	column visitnum visit vsstresn;
	label vsstresn="Result";
	define visitnum / noprint group;
	define visit / group;
	define vsstresn / mean;
	run;

proc report data=shared.vs;
	title2 "&vsname3.";
	where vstestcd="&vstest3.";
	column visitnum visit vsstresn;
	label vsstresn = "Result";
	define visitnum / noprint group;
	define visit / group;
	define vsstresn / mean;
	run;

proc report data=shared.vs;
	title2 "&vsname4.";
	where vstestcd="&vstest4.";
	column visitnum visit vsstresn;
	label vsstresn="Result";
	define visitnum / noprint group;
	define visit / group;
	define vsstresn / mean;
	run;

proc report data=shared.vs;
	title2 "&vsname5.";
	where vstestcd="&vstest5.";
	column visitnum visit vsstresn;
	label vsstresn="Result";
	define visitnum / noprint group;
	define visit / group;
	define vsstresn / mean;
	run;

* close pdf;
ods pdf close;

proc printto;
run;