* Print log from this program to the following location in SAS Studio;
proc printto log='/home/u59228083/BIOS511/Logs/lab22_730391571.log' new; 
run;

* Program Header;
/****************************************************************************
* 
* Project           : BIOS 511 Course Lab 22
* 
* Program name      : lab22_730391571.sas 
* 
* Author            : Maya Krishnamoorthy (MK) 
* 
* Date created      : 2022-11-09
* 
* Purpose           : This program has been created to complete the lab 21 assignment.  
* 
* Revision History  : 
* 
* Date          Author   Ref (#)  Revision 
* 2022-11-09    MK       1        Initial creation of program.
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
ods pdf file='/home/u59228083/BIOS511/Output/lab22_730391571.pdf';

libname shared "/home/u59228083/my_shared_file_links/u49231441/Data";
run;

* #1: proc import to import data into my library;
filename country '/home/u59228083/my_shared_file_links/u49231441/Data/country.dat';
proc import datafile=country
	out=countrydlm replace 
	dbms=dlm;
	delimiter='!';
	getnames=no;
run;

* #2: rename and label variables;
data country2;
	set countrydlm;
	rename var1=Abbrev var2=Full;
	label var1="Country Name Abbreviation" var2="Country Full Name";
run;

* #3: importing file using data step infile statement;
data country3;
	infile country delimiter='!';
	length var1 $3 var2 $20;
	input var1 $ var2 $;
	label var1="Data Step Country Abbrev" var2="Data Step Country Full Name";
run;

* #4: Compare the Variables between Datasets Countrydlm and Country3;
proc compare base=countrydlm compare=country3;
	title1 "Compare the Variables between Datasets Countrydlm and Country3";
run;

* #5: create a format from the variables in the data set;
data country5;
	set countrydlm;
	start=var1; 
	label=var2;
	retain fmtname '$cnty';
run;

proc format cntlin=country5 lib=work 
fmtlib; 
title1 "Contents of Proc Format on Country5 Dataset";
run;

* #6: create schedule dataset;
data schedule;
	input name $1-8 section $9-15 building $16-23 room day $29-32 time time.;
	label name="Class Name" section="Section Type" building="Building" room="Room Number" day="Day of Week" time="Start Time";
	format time time.;
	datalines;
SPHG351 Lecture Rosenau 0133 Mon 08:00
BIOS511 Lecture McG-G   2306 Mon 09:05
BIOS511 Lab     McG-G   2306 Mon 10:10
COMP550 Lecture Chapman 0201 Mon 11:15
NSCI175 Lecture Peabody 3050 Tue 12:30
MATH347 Lecture GC      1015 Tue 02:00
SPHG351 Lecture Rosenau 0133 Wed 08:00
BIOS511 Lecture McG-G   2306 Wed 09:05
BIOS511 Lab     McG-G   2306 Wed 10:10
COMP550 Lecture Chapman 0201 Wed 11:15
NSCI175 Lecture Peabody 3050 Thu 12:30
MATH347 Lecture GC      1015 Thu 02:00
SPHG351 Lecture Rosenau 0133 Fri 08:00
;
run;

* #6: ;
proc print data=schedule noobs label;
	title1 "Print Contents of Schedule Dataset in Chronological Order";
run;

* close pdf;
ods pdf close;

proc printto;
run;