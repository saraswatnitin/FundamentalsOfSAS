options obs=max;

libname lib "/home/chetan.saraswat@aiproff.ai";

proc print data = lib.address_v2;
run;


data plan1 plan2(drop=street zipcode); 
	set lib.address_v2;
	run;


title "Printing plan1";

proc print data = plan1;
run;

title "Printing plan2";

proc print data = plan2;
run;

data plan3 (keep=state zipcode); 
	set lib.address_v2;
	MedianIncome_THOUSAND=(MedianIncome)/1000;
	run;
proc print data = plan3;
run;

data plan4 (keep=state zipcode MedianIncome_THOUSAND); 
	set lib.address_v2;
	MedianIncome_THOUSAND=(MedianIncome)/1000;
	run;
proc print data = plan4;
run;


data subset_5_20;
	set lib.address_v2 (firstobs=5 obs=20);
run;

proc print data=subset_5_20;
run;


/*do processing */

data earnings;
	Amount=1000;
	Rate=.075/12;

	do month=1 to 12;
		Earned+(amount+earned)*(rate);
	end;
run;

proc print data=earnings;
run;


data earnings;
	Amount=1000;
	Rate=.075/12;

	do month=1 to 12;
		Earned+(amount+earned)*(rate);
		OUTPUT;
	end;
run;

proc print data=earnings;
run;

/* Before we run this do a dry run */
data test; 
do i=1 to 5; 
	do j=1 to 4; 
		x+1; 
	end; 
end; 
run; 

proc print data=test;
run;

/* we can print value at each step of execution*/
data test;
	do i=1 to 5;

		do j=1 to 4;
			x+1;
			output;
		end;
	end;
run;

proc print data=test;
run;

/* do until*/
data work.test;
	/* does it make any difference if we write work. */
	x=15;

	do until(x>12);
		x+1;
	end;
run;

proc print data=work.test;
run;


data test;
	x=15;

	do while(x<12);
		x+1;
	end;
run;

proc print data=test;
run;


data invest(drop=i);
	do i=1 to 10 until(capital>50000);
		Year+1;
		capital+2000;
		capital+capital*.10;
	end;
run;

proc print data=invest;
run;

/* print each step */
data invest(drop=i);
	do i=1 to 10 until(capital>50000);
		Year+1;
		capital+2000;
		capital+capital*.10;
		output;
	end;
run;

proc print data=invest;
run;




/*retain*/

Data Sales;
Set lib.Qtr1;
Retain Tot_Sales 0;
Tot_Sales = Tot_sales + Sale_amount;
Run;

proc print data = sales;
run;


Data Sales_woretain_woinit;
Set lib.Qtr1;
/*Retain Tot_Sales; */
Tot_Sales = Tot_sales + Sale_amount;
Run;
 
proc print data = Sales_woretain_woinit;
run;

Data Sales_woretain_woinit;
Set lib.Qtr1;
Tot_Sales = Tot_sales + Sale_amount;
Run;

/* One approach to fix is to use retain with initial value 
and the other is using sum statement
*/
Data Sales_woretain;
	Set lib.Qtr1;
	Tot_sales + Sale_amount;
Run;

proc print data=Sales_woretain;
run;