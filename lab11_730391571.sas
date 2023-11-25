* Print log from this program to the following location in SAS Studio;
proc printto log='/home/u59228083/BIOS511/Logs/lab11_730391571.log' new; 
run;

* Program Header;
/****************************************************************************
* 
* Project           : BIOS 511 Course Lab 11
* 
* Program name      : lab11_730391571.sas 
* 
* Author            : Maya Krishnamoorthy (MK) 
* 
* Date created      : 2022-09-21 
* 
* Purpose           : This program has been created to complete the lab 11 assignment, and learn how to use proc sgpanel.  
* 
* Revision History  : 
* 
* Date          Author   Ref (#)  Revision 
* 2022-09-21    MK       1        Initial creation of program.
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
*ods _all_ close;

* create pdf file;
ods pdf file='/home/u59228083/BIOS511/Output/lab11_730391571.pdf';

libname shared "/home/u59228083/my_shared_file_links/u49231441/Data";
run;

* #1 use proc sgpanel to create a series of boxplots showing tumorsize based on treatment stage;
* also mark outliers;
title1 "Tumor Size Box Plots Based on Treatment Stage";
proc sgpanel data=shared.prostate(where=(tumorsize ^= -9999));
	panelby treatment stage / rows=2;
	hbox tumorsize / displaystats=(mean) outlierattrs=(color=black);
run;

* #2 proc sgpanel to create histogram and density curve for birthweight by sex;
* label y axis with Percent and iterate by 10;
title1 "Birth Weight Graph by Sex using SGPanel";
proc sgpanel data=shared.preemies noautolegend;
	panelby sex / novarname;
	histogram bw;
	density bw / lineattrs=(color=green);
	label bw = "Birth Weight";
	rowaxis label='Percent (%)' values=(0 to 50 by 10);
run;

* #3 sorted histogram by sex using proc sgplot and don't print byline;
* proc sort to sort dataset by sex before creating histogram and density curves;

proc sort data=shared.preemies out=preemies_sorted;
	by sex;
run;

* proc sgplot creates histogram and density curve and titles each by variable value;
title1 "Birth Weight Graph by Sex using SGPlot";
title2 "#byvar1 = #byval1";
proc sgplot data=preemies_sorted noautolegend;
	histogram bw;
	by sex;
	density bw / lineattrs=(color=green);
	label bw = "Birth Weight";
	yaxis label='Percent (%)' values=(0 to 50 by 10);
	options nobyline;
run;

* close pdf;
ods pdf close;

proc printto;
run;