* Print log from this program to the following location in SAS Studio;
proc printto log='/home/u59228083/BIOS511/Logs/lab17_730391571.log' new; 
run;

* Program Header;
/****************************************************************************
* 
* Project           : BIOS 511 Course Lab 17
* 
* Program name      : lab17_730391571.sas 
* 
* Author            : Maya Krishnamoorthy (MK) 
* 
* Date created      : 2022-10-24
* 
* Purpose           : This program has been created to complete the lab 18 assignment.  
* 
* Revision History  : 
* 
* Date          Author   Ref (#)  Revision 
* 2022-10-24    MK       1        Initial creation of program.
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
ods pdf file='/home/u59228083/BIOS511/Output/lab17_730391571.pdf';

libname shared "/home/u59228083/my_shared_file_links/u49231441/Data";
run;

* #1: create random dataset from oct to dec 2022 using do iteration;

data ds; 
   do date='01oct2022'd to '31dec2022'd; 
      random = rand("Uniform");
      output; 
   end; 
   format date MMDDYY10.;
run; 

* #2: print the ds contents of october and keep only 3 decimal places of random;

proc print data=ds noobs;
	title1 "October Contents of DS Dataset";
	where date < '01nov2022'd;
	format random 9.3;
run;

* #3: do from 2003 moving forward, incrementing yearly, keeping only stock date and adjclose;

data stocks;
	set sashelp.stocks;
	where stock="Intel" AND date="02JUN2003"d;
	do i=1 to 5;
		date = intnx("year", date, 1, "same");
		adjclose = 1.11*adjclose;
		output;
	end;
	keep stock date adjclose;
run;

* #4: print stocks dataset contents;

proc print data=stocks;
	title1 "5 Yearly Increment Adjusted Close Values for Intel Stock";
run;

* #5: use do until adjclose>200;

data stocks2;
	set sashelp.stocks;
	where stock="Intel" AND date="02JUN2003"d;
	do until (adjclose > 200);
		date = intnx("year", date, 1, "same");
		adjclose = 1.11*adjclose;
		output;
	end;
	keep stock date adjclose;
run;

* #6: print stocks2 dataset;

proc print data=stocks2;
	title1 "Yearly (June 2) Incremented Adjusted Close Value Until AdjClose > 200";
run;

* #7: put info in long after subsetting shared.prostate data;

data _null_;
	set shared.prostate;
	where Age > 80 and Stage=3 and treatment=2;
	putlog "Patient Number: " patientnumber;
run;

* close pdf;
ods pdf close;

proc printto;
run;