libname lib "/home/chetan.saraswat@aiproff.ai";


proc contents data = lib.address_woincome;
run;

proc print data = lib.address_woincome(obs=5);
run;

proc contents data = lib.address_withincome;
run;

proc print data = lib.address_withincome(obs=5);
run;

/* Do an inner join */

proc sql ;
create table lib.address_join 
as
(
select a.*,b.medianincome, b.populationdensity
 from 

lib.address_woincome a 
inner join 
lib.address_withincome b
on
a.geo_identifier = b.geo_identifier 
);
quit;

proc print data = lib.address_join;
run;


/* Find how many unique cities are there in State AZ and CA
HINT => Use count(distinct) */


proc sql;
select 
count(distinct City) as CNT_City, State 

from 
lib.address_join 

where 

State IN ("AZ", "CA")

group by State;

quit;



/* Find out sum of medianincome in CA => sum()*/

proc sql;

select 

sum(medianincome) as SUM_INCOME, State 

from 
lib.address_join
l
where 
State="CA"
group by State
;


quit;

proc contents data = lib.address_join;
run;


data lib.address_join1(drop=establisheddate);
set lib.address_join;
/* format establisheddate1 ddmmyy10.;*/
establisheddate1=put(establisheddate,8.);
run;

proc contents data = lib.address_join1;
run;

proc print data = lib.address_join1;
run;



/* Find the populationdensity of cities established before 01-01-1916 */


proc sql;



quit;



/* Which city has the lowest crimeindex and which city has the highest */
/* value , city name */

proc sql;

select 

crimeindex , City
from 
lib.address_join
having 
crimeindex=min(crimeindex)
;
quit;







/* How many unique zip codes are there in TX */
/* count , state */


proc sql;

select count(distinct zipcode), State
from 
lib.address_join

where State="TX"
group by State;

quit;




/* Proc Freq */

proc freq data=lib.address_join ;
tables State ;
run;

proc freq data=lib.address_join ;
tables State/nocum;
run;

proc freq data=lib.address_join ;
tables State/nopercent nocum;
run;

proc freq data=lib.address_join ;
tables State*City ;
run;

proc freq data=lib.address_join ;
tables State*City /nopercent nocum;
run;

proc freq data=lib.address_join ;
tables State*City /norow nocol nopercent nocum;
run;


proc freq data=lib.address_join ;
tables State*City /norow nocol nopercent nocum list ;
run;

/* nlevels => count number of unique values in a variable */
 
proc freq data=lib.address_join nlevel  ;
tables State*City /norow nocol nopercent nocum list ;
run;

/* writes to a dataset and does not write to list output */
proc freq data=lib.address_join noprint ;
tables State / norow nocol  nocum list out=test1 ;
run;

proc print data= test1;
run;



/* plot graphs */
ods graphics on;
proc freq data = lib.address_join;
tables State/ plots=freqplot (type=bar scale=percent);
run;
ods graphics off;


/* plot graphs */
ods graphics on;
proc freq data = lib.address_join;
tables State/ plots=freqplot (type=bar scale=freq);
run;
ods graphics off;


/* We can change the scale to FREQ */
ods graphics on;
proc freq data = lib.address_join;
tables State/ plots=freqplot (type=bar scale=freq);
run;
ods graphics off;


/* Change the graph to dot graph */
ods graphics on;
proc freq data = lib.address_join;
tables State/ plots=freqplot (type=dot scale=freq);
run;
ods graphics off;

/* Showing missing values */
/* first lets create some missing values */

data lib.address_join_withmiss;
set lib.address_join;
if geo_identifier IN 
(2217444183,
2219144200,
2220744216,
2222244231,
2223444243,
2225744266,
2227244281
) 
then 
do ;
State='';
ZipCode=.;
MedianIncome=.;

end;
run;

proc print data = lib.address_join_withmiss;
run;

/* By default, PROC FREQ does not consider missing values while calculating 
percent and cumulative percent. The number of missing values are shown separately
 (below the table) */

proc freq data = lib.address_join_withmiss;
tables State;
run;

/* Can we show these missing values in a category in the freq table */

proc freq data = lib.address_join_withmiss;
tables State /missing;
run;


/* Showing sorted values  */

proc freq data = lib.address_join_withmiss order=FREQ;
tables State /missing;
run;

/* Using Proc Format in Proc Freq to display a nice summary */

proc format;
value MedianIncomeformat
1 - 50000 = "Low Income"
50001 - 100000 = "Mid Income"
100001 - High = "High Income"
;
run;

proc print data = lib.address_join_withmiss;
Format medianincome MedianIncomeformat.;
run;

proc freq data = lib.address_join_withmiss;
Format medianincome MedianIncomeformat.;
tables medianincome;
run;



/* PROC MEANS => used to calculate descriptive statistics such as mean, median, 
count, sum etc.*/

proc means data = lib.address_join_withmiss;
var medianincome populationdensity;
run;
 

/* Selecting which statistic we want to see */

proc means data = lib.address_join_withmiss N NMISS;
var medianincome populationdensity;
run;

/* Grouping analysis based on some groups */
proc means data = lib.address_join_withmiss N NMISS SUM;
class State;
var medianincome populationdensity;
run;


/* Remove Noobs column  */
proc means data = lib.address_join_withmiss N NMISS NONOBS SUM;
class State;
var medianincome populationdensity;
run;


/* Using CLASS and BY statement */

proc means data = lib.address_join_withmiss ;
class State ;
var medianincome;
run;


/* What is the issue here ?? */

proc means data = lib.address_join_withmiss ;
BY State ;
var medianincome;
run;

/* This needs to be sorted*/


proc contents data = lib.address_join_withmiss ;
run;

proc sort data = lib.address_join_withmiss;
by State;
run;

proc contents data = lib.address_join_withmiss ;
run;


proc means data = lib.address_join_withmiss ;
BY State ;
var medianincome;
run;

/* Write to a dataset with some statistic */

proc means data = lib.address_join_withmiss ;
class State city ;
var medianincome;
output out= test2  ;
run;

proc print data =test2;
run;




/* Proc Report */

proc report data=lib.address_join_withmiss;
column State City Medianincome;
run;

proc report data=lib.address_join_withmiss;
column State City Medianincome;
where State <> '';
run;


/* 
change the headers of the columns using the display option in the define statement. 
This will change how the 
column names appear in the report without modifying the actual variable name
*/

proc report data=lib.address_join_withmiss;
column State City Medianincome;
define MedianIncome /display "Per Capita Income" format = dollar8.;
where State <> '';
run;

/* grouping */

proc report data=lib.address_join_withmiss;
column State City Medianincome;
define MedianIncome /display "Per Capita Income" format = dollar8.;
define State / group "US States";
where State <> '';
run;

proc report data=lib.address_join_withmiss;
column State City Medianincome;
define MedianIncome /display "Per Capita Income" format = dollar8.;
define State / group "US States";
define City / group "US Cities";
where State <> '';
run;


proc report data=lib.address_join_withmiss;
column State  Medianincome;
define MedianIncome /display "Per Capita Income" format = dollar8.;
define State / group "US States";
define medianincome / analysis sum "State Level Per Capita Income";
where State <> '';
run;


proc report data=lib.address_join_withmiss;
column State  City Medianincome;
define MedianIncome /display "Per Capita Income" format = dollar8.;
define State / group "US States";
define City / group "US Cities";
define medianincome / analysis sum ;
where State <> '';
run;




/* Transpose variables */
proc report data=lib.address_join_withmiss;
column State  City Medianincome;
define MedianIncome /display "Per Capita Income" format = dollar8.;
define State / group "US States";
define City/ across "Location";
where State <> '';
run;


/* Grouped Columns in report  */
proc report data=lib.address_join_withmiss;
column State  City, (Medianincome populationdensity);
/* define MedianIncome /display "Per Capita Income" format = dollar8.; */
define State / group "US States";
define City/ across "Location";
where State <> '';
run;


/* Adding Grand Total in the report */
proc report data=lib.address_join_withmiss;
column State City,(Medianincome populationdensity);
/* define MedianIncome /display "Per Capita Income" format = dollar8.; */
define State / group "US States";
define City/ across "Location";
where State <> '';
compute after;
State= "Total";
endcomp;
rbreak after /summarize;
run;



/* display mean value of PopulationDensity at a State * City* ZipCode level */

ods pdf file='/home/chetan.saraswat@aiproff.ai/report.pdf';
title 'State City ZipCode level mean pop density ';

proc report data=lib.address_join_withmiss;
column State City  zipcode populationdensity;
/* define MedianIncome /display "Per Capita Income" format = dollar8.; */
define State / group "US States";
define City/ group "Location";
define zipcode / group "Zipcode";
define populationdensity / analysis mean ;
where State <> '';
run;

ods pdf close;


/* Print subtotal after every State and a Grand Total value of Population 
Density after all rows are listed */


proc report data=lib.address_join_withmiss;
column State City  zipcode populationdensity;
define State / group "States";
define City/ group "City";
define zipcode / group "Zipcode";
define populationdensity / analysis sum ;
where State <> '';

break after State /summarize;
rbreak after /summarize;

compute after State;
State= "Total";
endcomp;

compute after;
State="Grand Total";
endcomp;
 
run;



/* report to display populationdensity  in thousand =>
Apply formula - populationdensity/1000 */


proc report data=lib.address_join_withmiss;
column State City  zipcode populationdensity popdensity;
define State / group "States";
define City/ group "City";
define zipcode / group "Zipcode";
define populationdensity / analysis sum ;
where State <> '';

define popdensity /computed;
compute popdensity;
popdensity=(populationdensity.sum)/1000;
endcomp;
 
break after State /summarize;
rbreak after /summarize;

compute after State;
State= "Total";
endcomp;

compute after;
State="Grand Total";
endcomp;
run;





/* proc tabulate */

proc tabulate data= lib.address_join_withmiss;
class State;
var medianincome;
table medianincome;
run;


proc tabulate data= lib.address_join_withmiss;
class State;
var medianincome;
table State*medianincome;
run;


proc tabulate data= lib.address_join_withmiss;
class State City;
var medianincome;
table State*City*medianincome;
run;

proc tabulate data= lib.address_join_withmiss;
class State City;
var medianincome;
table State *City,medianincome ;
run;


proc tabulate data= lib.address_join_withmiss;
class State City;
var medianincome;
table State *City,medianincome*(N SUM MEAN) 
;
run;

ods html file="/home/chetan.saraswat@aiproff.ai/proctab.html" style=sasweb;

proc tabulate data= lib.address_join_withmiss;
class State City;
var medianincome ;
table State *City,medianincome*(SUM [style=[foreground=yellow]] );
;
run;


ods html close;






/* write a proc tabulate which shows max value of medianincome at a 
State* City *ZipCode level */




proc tabulate data= lib.address_join_withmiss;
class State City;
var medianincome populationdensity;
table State *City,medianincome*(N SUM MEAN) 
populationdensity*(N SUM MEAN)
;
run;


/* ONLY AT STATE LEVEL */



proc tabulate data= lib.address_join_withmiss;
class State ;
var medianincome populationdensity;
table State,medianincome*(MAX) 
populationdensity*(MIN)
;
run;


proc print data = lib.address_join_withmiss;
;
run;


/* Zip Code * Street level - Mean of Crimeindex and Median of AvgHousingPrice */





proc format;
value medianincomefmt

1-500000 = "red"
500001 - 800000= "blue"
800001 - High = "green"
;
run;



ods html file="/home/chetan.saraswat@aiproff.ai/proctab.html" style=sasweb;

proc tabulate data= lib.address_join_withmiss;
class State City;
var medianincome ;
table State *City,medianincome*([style=[foreground=medianincomefmt.]] );
;
run;


ods html close;






