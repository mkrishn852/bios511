* Print log from this program to the following location in SAS Studio;
proc printto log='/home/u59228083/BIOS511/Logs/lab25_730391571.log' new; 
run;

* Program Header;
/****************************************************************************
* 
* Project           : BIOS 511 Course Lab 25
* 
* Program name      : lab25_730391571.sas 
* 
* Author            : Maya Krishnamoorthy (MK) 
* 
* Date created      : 2022-11-21
* 
* Purpose           : This program has been created to complete the lab 25 assignment.  
* 
* Revision History  : 
* 
* Date          Author   Ref (#)  Revision 
* 2022-11-21    MK       1        Initial creation of program.
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
ods pdf file='/home/u59228083/BIOS511/Output/lab25_730391571.pdf';

libname shared "/home/u59228083/my_shared_file_links/u49231441/Data";
run;

* #1: Write a TITLE statement that uses %SYSFUNC and the TODAY() function to write today’s 
date in the date9. format.;
%let titletext="%sysfunc(today(), date9.)";

* #2: Within a PROC FREQ step use a WHERE statement that subsets the tumor1 data 
set in the course folder.  Use the value of the gen macro variable so have only 
females.;
* Generate a cross frequency table for the combination of stage and treatment.;
%let gen=f;
title &titletext;
title2 "Crosstabulation: Stage vs Treatment in Females in the Tumor1 Dataset";
proc freq data=shared.tumor1;
	where gender=%upcase("&gen");
	tables stage*trt;
run;

* #3: copy code from lab 23 #11;
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

* #4: Rewrite Lab 23 #12 and #13 using a macro program;
%let n=5;
%macro loop;
	%do i=1 %to &n;
		proc report data=shared.vs;
			title &titletext;
			title2 "&&vsname&i.";
			where vstestcd="&&vstest&i.";
			column visitnum visit vsstresn;
			label vsstresn="Result";
			define visitnum / noprint group;
			define visit / group;
			define vsstresn / mean;
		run;
	%end;
%mend loop;

%loop;	

* close pdf;
ods pdf close;

proc printto;
run;	