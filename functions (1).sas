libname lib "/home/chetan.saraswat@aiproff.ai";


data lib.sample_data;
    input Name :$ Date : mmddyy10. DateTime : datetime20. Balance : dollar10.2;
    format Date mmddyy10. DateTime datetime20. Balance dollar10.2;
    datalines;
John  01-01-2021 01JAN2021:08:30:00  1500.25
Mary  03/15/2020 15MAR2020:12:45:00  2500.50
Alex  07/04/2019 04JUL2019:10:15:00  3800.75
Tina  10/31/2018 31OCT2018:09:00:00  1000.20
Max   12/25/2022 25DEC2022:14:30:00  500.45
Sara  05/05/2021 05MAY2021:16:00:00  750.30
Luke  02/28/2023 28FEB2023:10:10:00  3200.00
Anna  11/11/2019 11NOV2019:13:45:00  2200.60
Jane  04/01/2020 01APR2020:07:15:00  1900.15
Paul  06/20/2022 20JUN2022:11:30:00  1450.70
;
run;

proc print data = lib.sample_data;
run;



/* INPUT function - 
The INPUT function converts a character value to a numeric value or another format.
*/

data lib.input_example;
    length Char_Age $5;
    Char_Age = "25";                /* Character variable containing a numeric-looking value */
    Num_Age = input(Char_Age, 8.);  /* Converts Char_Age from character to numeric using INPUT */
    format Num_Age 8.;
run;

proc print data=lib.input_example noobs;
    title "INPUT Function Example";
run;

proc contents data = lib.input_example;
run;


/* 
PUT function 
The PUT function converts a numeric value to a character value or applies a format to change how the value is displayed.
*/

data lib.put_example;
    Num_Salary = 50000;               /* Numeric variable */
    Char_Salary = put(Num_Salary, dollar10.);  /* Converts Num_Salary to a character string with a dollar format */
run;

proc print data=lib.put_example noobs;
    title "PUT Function Example";
run;

proc contents data = lib.put_example;
run;

/* INPUT and PUT Usage */

data lib.conversion_example;
    length Char_Date $10;
    Char_Date = "01JAN2023";                 /* Character date */
    Date = input(Char_Date, date9.);         /* Convert to numeric date value */
    Char_Format_Date = put(Date, mmddyy10.); /* Convert numeric date back to character in mm/dd/yyyy format */
    format Date date9.;
run;

proc print data=lib.conversion_example noobs;
    title "Practical Example of INPUT and PUT";
run;

proc contents data = lib.conversion_example;
run;

data a;
name="     Nitin ";
dept="  Maths ";
/*newname=tranwrd(name,"i","E");
upname=upcase(name);
lowname=lowcase(name);
*/
/* "Nitin";  => tin */
/* subname=substr(name,3,3);
scanname=scan(name,1,",");
*/

onlycatname=cat(name,dept);
catsname=cats(name,dept);
cattname=catt(name,dept);
catxname=catx("-",name,dept);

run;

proc print data = a;
run;

proc contents data=a;
run;

/* 
/* roundbalance_10=round(balance,10);
roundbalance_100=round(balance,100);
roundbalance_1000=round(balance,1000);
*/
/* 
floorbal=floor(balance);
ceilbal=ceil(balance);
*/
/* expbal=balance**3.4; */

/*
modbal=mod(Balance, 9);
*/
****/
;;;

data b;
/*
balance=245;
*/
trandate='2Feb2025'd;
format trandate date9.;
/* 
ddate=day(trandate);
mdate=month(trandate);
ydate=year(trandate);
*/
/* agetransaction=today()- trandate;
put agetransaction =  "Number of days elapsed since transaction";
*/

nextdt=intnx('week', trandate, 1, 'beginning');  /* First day of the current quarter */
format nextdt date11.;
run;

proc print data=b;
run;

proc contents data = b;
run;


data c;
trandate='2AUG2025'd;

days_after_start=intck('day','01JAN2025'd,trandate);
months_after_start=intck('month','01JAN2025'd,trandate);
quart_after_start=intck('quarter','01JAN2025'd,trandate);


Days_Since_Start = intck('day', trandate, '01JAN2025'd);  /* Days from Date to January 1, 2025 */
Months_Since_Start = intck('month', trandate, '01JAN2025'd);
quart_since_start=intck('quarter',trandate, '01JAN2025'd);


run;
proc print data = c;
run;



data lib.transformed_data;
    set lib.sample_data;

    /* Character Functions */
    Name_Trimmed = trim(Name);                /* Removes trailing spaces */
    Name_Replaced = tranwrd(Name, "a", "@");  /* Replace 'a' with '@' in Name */

    /* Numeric Functions */
    Balance_Rounded = round(Balance, 100);    /* Round balance to nearest 100 */
    Balance_Floor = floor(Balance);           /* Floor function to get largest integer <= Balance */
    Balance_Ceil = ceil(Balance);             /* Ceil function to get smallest integer >= Balance */

    /* Date Functions */
    Days_Since_Start = intck('day', Date, '01JAN2025'd);  /* Days from Date to January 1, 2025 */
    Next_Quarter_Date = intnx('quarter', Date, 1, 'same'); /* Date of the next quarter */

    format Next_Quarter_Date mmddyy10.;
run;

proc print data=lib.transformed_data noobs;
    title "Transformed Data with Character, Numeric, and Date Functions";
run;


/* 
Character Functions:

trim(Name): Removes trailing blanks from Name.
tranwrd(Name, "a", "@"): Replaces all occurrences of "a" with "@" in Name.

Numeric Functions:
round(Balance, 100): Rounds Balance to the nearest 100.
floor(Balance): Returns the largest integer less than or equal to Balance.
ceil(Balance): Returns the smallest integer greater than or equal to Balance.

Date Functions:
intck('day', Date, '01JAN2025'd): Calculates the number of days between Date and January 1, 2025.
intnx('quarter', Date, 1, 'same'): Returns the date of the next quarter.

*/


data lib.extended_transformed_data;
    set lib.sample_data;

    /* --- Character Functions --- */
    Name_Upper = upcase(Name);               /* Converts Name to uppercase */
    Name_Lower = lowcase(Name);              /* Converts Name to lowercase */
    Name_Substr = substr(Name, 1, 3);        /* Extracts the first 3 characters of Name */
    Name_Length = length(Name);              /* Calculates the length of Name */
    Name_Scan = scan(Name, 1, ' ');          /* Extracts the first word from Name */
    Name_Cat = cats("User_", Name);          /* Concatenates "User_" with Name */

    /* --- Numeric Functions --- */
    Log_Balance = log(Balance);              /* Natural log of Balance */
    Square_Balance = Balance**2;             /* Square of Balance */
    Int_Balance = int(Balance);              /* Returns the integer part of Balance */
    Mod_Balance = mod(Balance, 100);         /* Returns the remainder of Balance divided by 100 */
    Random_Value = rand("uniform")*100;      /* Generates a random value between 0 and 100 */

    /* --- Date Functions --- */
    Year_Extract = year(Date);               /* Extracts the year from Date */
    Month_Extract = month(Date);             /* Extracts the month from Date */
    Day_Extract = day(Date);                 /* Extracts the day from Date */
    Weekday_Extract = weekday(Date);         /* Extracts the weekday from Date (1=Sunday, 7=Saturday) */
    Today_Difference = today() - Date;       /* Number of days between Date and today's date */
    Date_Add_10Days = Date + 10;             /* Adds 10 days to Date */
    First_Day_Of_Quarter = intnx('quarter', Date, 0, 'beginning');  /* First day of the current quarter */

    format Date_Add_10Days First_Day_Of_Quarter mmddyy10.;
run;

proc print data=lib.extended_transformed_data noobs;
    title "Extended Transformed Data with More Functions";
run;


/* 

Character Functions:
upcase(Name): Converts Name to uppercase (e.g., "John" → "JOHN").
lowcase(Name): Converts Name to lowercase (e.g., "Mary" → "mary").
substr(Name, 1, 3): Extracts the first three characters from Name.
length(Name): Returns the number of characters in Name.
scan(Name, 1, ' '): Extracts the first word from Name.
cats("User_", Name): Concatenates "User_" with Name without adding extra spaces.


Numeric Functions:
log(Balance): Calculates the natural logarithm of Balance.
Balance**2: Squares Balance.
int(Balance): Extracts the integer part of Balance.
mod(Balance, 100): Returns the remainder when Balance is divided by 100.
rand("uniform"): Generates a random number between 0 and 1, multiplied by 100 here for scaling.


Date Functions:
year(Date): Extracts the year from Date.
month(Date): Extracts the month from Date.
day(Date): Extracts the day from Date.
weekday(Date): Returns the day of the week (1 for Sunday, 7 for Saturday).
today(): Returns the current date.
Date + 10: Adds 10 days to the date.
intnx('quarter', Date, 0, 'beginning'): Finds the first day of the current quarter.
*/


/* substr */

data substr_example;
    FullName = "Johnathan Doe";
    FirstName = substr(FullName, 1, 4);  /* Extracts the first 4 characters (John) */
run;

proc print data=substr_example noobs;
    title "SUBSTR Function Example";
run;

/* SCAN 
Extracts a specific word from a string based on a delimiter.
*/

data scan_example;
    FullName = "Johnathan Doe";
    FirstWord = scan(FullName, 1, ' ');  /* Extracts the first word (Johnathan) */
    LastWord = scan(FullName, 2, ' ');  /* Extracts the second word (Doe) */
run;

proc print data=scan_example noobs;
    title "SCAN Function Example";
run;


/* 
MDY 
*/
data mdy_example;
    Month = 12;
    Day = 25;
    Year = 2023;
    Date = mdy(Month, Day, Year);       /* Creates a date for December 25, 2023 */
    format Date mmddyy10.;              /* Formats the date in MM/DD/YYYY format */
run;

proc print data=mdy_example noobs;
    title "MDY Function Example";
run;

/* 
MEAN 
*/
data mean_example;
    x = 10;
    y = 20;
    z = 30;
    Average = mean(x, y, z);  /* Calculates the mean of x, y, and z (20) */
run;

proc print data=mean_example noobs;
    title "MEAN Function Example";
run;


/* Today()
*/
data today_example;
    CurrentDate = today();  /* Returns the current date */
    format CurrentDate date9.;
run;

proc print data=today_example noobs;
    title "TODAY Function Example";
run;

/* 
index
*/
data index_example;
    Text = "Welcome to SAS programming!";
    Position = index(Text, "SAS");  /* Returns 12, as 'SAS' starts at the 12th position */
run;

proc print data=index_example noobs;
    title "INDEX Function Example";
run;
