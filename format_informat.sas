/* 1. Create a user-defined format catalog. */
proc format library=work;
    value agegroup
        low - <18  = 'Under 18'
        18 - <30   = 'Young Adult'
        30 - <65   = 'Adult'
        65 - high  = 'Senior';
run;

/* 2. Read raw data using informats. */
data demo_data;
    length Name $25 Age 8 Income 8 JoinDate 8;
    infile datalines dsd truncover;
    informat 
        Name       $25.
        Age        2.
        Income     dollar8.
        JoinDate   mmddyy10.;
    input 
        Name 
        Age
        Income
        JoinDate
    ;
    format 
        Age        agegroup.      /* user-defined format from above */
        Income     dollar10.2
        JoinDate   date9.
    ;
datalines;
"John Doe",25,"$40,000","02/14/2020"
"Jane Smith",67,"$65,500","07/04/2019"
"Tim Johnson",16,"$0","01/01/2021"
;
run;

/* 3. Display the processed data with the assigned formats. */
proc print data=demo_data noobs;
    title "Formatted Output of Demo Data";
run;
