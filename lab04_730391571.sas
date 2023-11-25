* Print log from this program to the following location in SAS Studio;
proc printto log='/home/u59228083/BIOS511/Logs/lab04_730391571.log' new; 
run;

* Program Header;
/****************************************************************************
* 
* Project           : BIOS 511 Course 
* 
* Program name      : lab04_730391571.sas 
* 
* Author            : Maya Krishnamoorthy (MK) 
* 
* Date created      : 2022-08-24 
* 
* Purpose           : This program has been created to complete the lab 4 assignment.  
* 
* Revision History  : 
* 
* Date          Author   Ref (#)  Revision 
* 2022-08-24    MK       1        Initial creation of program.
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
* Create path to a library called "shared" that contains data from the shared file links folder;
libname shared "/home/u59228083/my_shared_file_links/u49231441/Data";
run;

* Create path to a personal library in my Data folder;
libname personal "/home/u59228083/BIOS511/Data";
run;

* 1: Sort data by customer last name and store in temporary dataset customer_lastname;
proc sort data=shared.customer_dim out=work.customer_lastname;
	by Customer_LastName;
run;

* 2: Sort data by unique customer group and customer type and store in temporary dataset unique_customer_dim;
* Only keep customer group and customer type columns in the temporary dataset unique_customer_dim;
proc sort data=shared.customer_dim out=work.unique_customer_dim (keep=Customer_Group Customer_Type) nodupkey;
	by Customer_Group Customer_Type;
run;

* 3: Sort data by customer age group in desceding order and store in temporary dataset customer_dim_desc;
proc sort data=shared.customer_dim out=work.customer_dim_desc;
	by descending Customer_Age_Group;
run;

* 4: Sort data by customer ID and store subset of this data where age = 33 in permanent dataset customer_dim_subset;
proc sort data=shared.customer_dim out=personal.customer_dim_subset;
	where Customer_Age = 33;
	by Customer_ID;
run;

* 5: Print contents of customer_lastname created in #1 where variable names are ordered in the same way they appear;
proc contents data=customer_lastname varnum;
	title1 "Customer_Dim Sorted by Last Name";
run;

* 6: Suppress print of customer_lastname contents and store this information in temporary dataset customer_lastname_contents;
proc contents data=customer_lastname noprint out=work.customer_lastname_contents;
run;
