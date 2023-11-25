* Print log from this program to the following location in SAS Studio;
proc printto log='/home/u59228083/BIOS511/Logs/lab21_730391571.log' new; 
run;

* Program Header;
/****************************************************************************
* 
* Project           : BIOS 511 Course Lab 21
* 
* Program name      : lab21_730391571.sas 
* 
* Author            : Maya Krishnamoorthy (MK) 
* 
* Date created      : 2022-11-07
* 
* Purpose           : This program has been created to complete the lab 21 assignment.  
* 
* Revision History  : 
* 
* Date          Author   Ref (#)  Revision 
* 2022-11-07    MK       1        Initial creation of program.
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
ods pdf file='/home/u59228083/BIOS511/Output/lab21_730391571.pdf';

libname shared "/home/u59228083/my_shared_file_links/u49231441/Data";
run;

* #1: create new columns counting mild moderate severe - manually transpose; 
proc sort data=shared.ae out=ae_out;
	by AESOC AETERM;
run;

data temp_ae;
	set ae_out;
	by AESOC AETERM;
	
	array name{3} $ _temporary_ ("MILD" "MODERATE" "SEVERE");
	array val{3} mild moderate severe;
	retain mild moderate severe;
	
	if first.aeterm then do j=1 to dim(val);
		val{j} = 0;
	end;
	
	do i=1 to dim(name);
		if aesev = name{i} then val{i}=val{i}+1;
	end;
	
	if last.aeterm;
	keep AETERM AESOC mild moderate severe;
run;

* #2: proc print for where AETERM variable = low energy;
proc print data=temp_ae;
	title1 "AE Dataset where AETERM Variable = Low Energy";
	where aeterm = "Low energy";
run;

* #3: restructure the lb data set and assign the lab result variable to new variables based on the lbtestcd variable;
proc sort data=shared.lb out=lb_out;
	by usubjid visitnum visit;
run;

data temp_lb;
	set lb_out;
	by usubjid visitnum visit;
	
	retain alb ca hct;
	
	array name{3} $ _temporary_ ("ALB" "CA" "HCT");
	array val{3} alb ca hct;
	
	if first.visitnum then do j=1 to dim(name);
		val{j}=.;
	end;
		
	do i=1 to dim(name);
		if lbtestcd = name{i} then val{i}=lbstresn;
	end;
	
	if last.visitnum;
	keep usubjid visit visitnum alb ca hct;
run;

* #4: proc print Temporary LB Dataset for Observations ECHO-016-011;
proc print data=temp_lb;
	title1 "Temporary LB Dataset for Observations ECHO-016-011";
	where usubjid = "ECHO-016-011";
run;

* #5: for every observation in the data set tumor1, add an observation with a treatment value of Z;
data tumor;
	set shared.tumor1;
	output;
	trt="Z"; output;
run;

* #6: proc freq to get number of patients per treatment;
proc freq data=tumor;
	title1 "Tumor Dataset Frequency of Patients per Treatment";
	tables trt;
run;

* close pdf;
ods pdf close;

proc printto;
run;