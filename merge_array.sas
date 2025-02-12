libname clinic "/home/chetan.saraswat@aiproff.ai";

data clinic.demog;
    input id $ Name $ Age Gender $ date : mmddyy10. ;
    datalines;
101 Danny 25 M 01-21-1980
202 Jim   43 M 03-04-1990
303 Joe   18 M 09-21-1967
404 Tracy 24 F 10-14-1956
;
run;

data clinic.visit;
    input id $ Name $ visit $ weight date :mmddyy10.;
    datalines;
404 Beth   Y 67 10-11-2010
101 Danny  N 77 09-12-2011
202 Jim    Y 71 04-23-2014
;
run;

proc sort data = clinic.demog;
by id;
run;

proc sort data = clinic.visit;
by id;
run;



data clinic.combined(drop=id); 
   merge clinic.demog(in=indemog rename=(date=BirthDate)) 	clinic.visit(drop=weight in=invisit rename=(date=VisitDate)); 
	by id; 
	if indemog and invisit; 
run; 

proc print data= clinic.combined;
run;

proc print data= clinic.combined;
format birthdate date9. visitdate date11.;
run;


/* array 
collection of variables */

/* 
In this example, the array size is determined automatically by SAS.
*/

data sales;
    input Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec;
    array monthly_sales {*} Jan--Dec;  /* Use * to let SAS determine the array size */
    TotalSales = sum(of monthly_sales[*]);  /* Calculate total sales across all months */
    AverageSales = mean(of monthly_sales[*]);  /* Calculate average sales */
    format TotalSales AverageSales dollar10.2;
    datalines;
1000 1200 1500 1300 1600 1400 1700 1800 2000 2100 2300 2500
800  950  1100 1000 1200 1300 1400 1500 1600 1700 1800 2000
;
run;

proc print data=sales noobs;
    title "Using * in Array Dimension";
run;


/*
Using _TEMPORARY_ 
Temporary arrays store values but do not create variables in the dataset.
*/

data sales_growth;
    array growth{12} _temporary_ (2 5 3 4 6 7 8 9 10 11 12 15);  /* Growth rates for each month */
    set sales;
    array monthly_sales {*} Jan--Dec;
    array adjusted_sales{12};

    do i = 1 to 12;
        adjusted_sales{i} = monthly_sales{i} * (1 + growth{i} / 100);  /* Adjust each month's sales by its growth rate */
    end;
    drop i;
run;

proc print data=sales_growth noobs;
    title "Using _TEMPORARY_ Arrays";
run;


