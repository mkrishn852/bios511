* Print log from this program to the following location in SAS Studio;
proc printto log='/home/u59228083/BIOS511/Logs/lab18_730391571.log' new; 
run;

* Program Header;
/****************************************************************************
* 
* Project           : BIOS 511 Course Lab 18
* 
* Program name      : lab18_730391571.sas 
* 
* Author            : Maya Krishnamoorthy (MK) 
* 
* Date created      : 2022-10-26
* 
* Purpose           : This program has been created to complete the lab 18 assignment.  
* 
* Revision History  : 
* 
* Date          Author   Ref (#)  Revision 
* 2022-10-26    MK       1        Initial creation of program.
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
ods pdf file='/home/u59228083/BIOS511/Output/lab18_730391571.pdf';

libname shared "/home/u59228083/my_shared_file_links/u49231441/Data";
run;

* #1: create an array of profits based on each price variable per row;

data prices;
	set shared.prices;
	array pricesarray{*} price:;
	array profit{15}; 
	do i=1 to 15;
		profit{i} = pricesarray{i}-discount;
	end;
	drop i;
	format profit: dollar8.2;
	keep profit:;
run;

* #2: find max profit per row and rename max_price to the profit name;

data highest_profit;
   set prices;
   length max_price $10;
    
      array max{*} profit:;
      hold=0; 
 
      do i=1 to dim(max); 
         if max{i} > hold then do; 
            hold = max{i};
            max_price = vname(max{i});     
         end; 
      end; 
      drop i;
run; 

* #3: check distribution of max_price;

proc freq data=highest_profit;
	title1 "Distribution of Each Maximum Profit Variable in Highest_Profit Dataset";
	table max_price;
run;

* #4: rename all 0s and 1s in variables;

data birthweight;
	set sashelp.birthwgt;
	array hold{*} lowbirthwgt married drinking death smoking somecollege;
	array tonum{*} lowbirthwgt1 married1 drinking1 death1 smoking1 somecollege1;
	do i=1 to dim(tonum);
		if hold{i}="Yes" then tonum{i}=1;
		else if hold{i}="No" then tonum{i}=0;
	end;
	drop i;
run;

* #5: run chi squared test by race and only print chisq output;

proc sort data=birthweight;
	by race;
run;

proc freq data=birthweight;
	title1 "Chi-Square Test: Low Birth Weight vs Smoking by Race";
	ods noproctitle;
	tables lowbirthwgt1*smoking1 / chisq;
	by race;
	ods select chisq;
run;

* #6: change characters to uppercase, numeric, and subset observations;

data heart;
	set sashelp.heart;
	array chars{*} _CHARACTER_;
	do i=1 to dim(chars);
		chars{i} = upcase(chars{i});
	end;
	array nums{*} _NUMERIC_;
	do i=1 to dim(nums);
		if nums{i}^=. then do;
			nums{i} = 1.1*nums{i};
		end;
	end;
	if sex="FEMALE" and status="DEAD" and weight<160;
	drop i;
run;

* #7: print first 10 observations of heart dataset;

proc print data=heart (obs=10);
	title1 "First 10 Observations of Cause of Death and Age at Death from Temporary Heart Dataset";
	var DeathCause AgeAtDeath;
run;

* close pdf;
ods pdf close;

proc printto;
run;