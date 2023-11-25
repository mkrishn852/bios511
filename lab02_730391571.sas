* Print log from this program to the following location in SAS Studio;
proc printto log='/home/u59228083/BIOS511/Logs/lab02_730391571.log' new; 
run;

* Program Header;
/****************************************************************************
* 
* Project           : BIOS 511 Course 
* 
* Program name      : lab02_730391571.sas 
* 
* Author            : Maya Krishnamoorthy (MK) 
* 
* Date created      : 2022-08-17 
* 
* Purpose           : This program has been created to complete the lab 2 assignment.  
* 
* Revision History  : 
* 
* Date          Author   Ref (#)  Revision 
* 2022-08-17    MK       1        Initial creation of program.
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
* Run the proc contents to see the attributes of the dataset and the descriptors;
proc contents data=sashelp.orsales;
run;
* Contains variable names Product_Category, Product_Group, Product_Line, Profit, Quantity, Quarter, Total_Retail_Price, Year;

* Run a proc print to see 10 observations in the dataset;
proc print data=sashelp.orsales (obs=10);
run;

* Create my own dataset in SAS with my personal informatio;
data personal_info;
	first_name = "Maya";	* add my first name to dataset;
	last_name = "Krishnamoorthy";	* add my last name to dataset;
	age = 20;	* add my age to dataset;
run;

* Run a proc contents to see the attributes of the data and the descriptors;
proc contents data=personal_info;
run;
* Observation names match!;

ods _all_ close;
proc printto;
run;