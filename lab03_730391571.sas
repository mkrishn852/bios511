* Print log from this program to the following location in SAS Studio;
proc printto log='/home/u59228083/BIOS511/Logs/lab03_730391571.log' new; 
run;

* Program Header;
/****************************************************************************
* 
* Project           : BIOS 511 Course 
* 
* Program name      : lab03_730391571.sas 
* 
* Author            : Maya Krishnamoorthy (MK) 
* 
* Date created      : 2022-08-22 
* 
* Purpose           : This program has been created to complete the lab 3 assignment.  
* 
* Revision History  : 
* 
* Date          Author   Ref (#)  Revision 
* 2022-08-22    MK       1        Initial creation of program.
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

* #1: Assigns a libref called classlib that accesses the path to the shared data folder;
* Only allows readonly access;
libname shared "/home/u59228083/my_shared_file_links/u49231441/Data"
	access=readonly;
run;

* #2: Assigns a libref called personallib that accesses the path to my personal data folder for the class;
libname personal "/home/u59228083/BIOS511/Data";
run;

* #3: Creates a temporary dataset for the dmvs.sas7bdat dataset in the shared data folder;
data dmvs; 
	set shared.dmvs;
run; 

* Tested #2 by printing the dataset;
/*
proc print data=dmvs;
run;
*/

* #4: Creates a permanent dataset for the dmvs.sas7bdat dataset in my personal data folder;
data personal.dmvs; 
	set shared.dmvs; 
run; 

* #5: Prints five observations from the permanent dataset and adds title and footnote;
proc print data=dmvs(obs=5);
	title1 "BIOS 511 Lab 3: DMVS dataset";
	footnote "602 observations, 20 variables";
run;

* #6: Run a PROC OPTIONS step, printing only the LOGCONTROL options;
proc options group=logcontrol;
run;