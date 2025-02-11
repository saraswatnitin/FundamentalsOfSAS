Libname mylib "/home/chetan.saraswat@aiproff.ai/";
Filename Myfile "/home/chetan.saraswat@aiproff.ai/Data.txt";

proc print data=mylib.address_v2 (obs=10);
run;

data newstate(rename=(State=US_State));
	set mylib.address_v2;
run;

proc print data=newstate;
run;

data newvar;
	set mylib.address_v2;
	Country="US";
	run;

proc print data=newvar;
run;

proc contents data = newvar;
run;

data newvar1;
set newvar;
attrib Country length=$30 label='Name of Country';
run;

proc contents data = newvar1;
run;
 
data newvar2;
length Country $30; 
set newvar;
attrib Country label='Name of Country';
run;


proc contents data = newvar2;
run;


data person;
	input name $ dept $;
	datalines;
John Sales 
Mary Accounting
Ravi Logistic
;

proc print data=person;
run;

data biblio; 
input number citation $50.; 
datalines4; 
KIRK, 1988 2 LIN ET AL., 1995;BRADY, 1993 
3 BERG, 1990; ROA, 1994; WILLIAMS, 1992 
;;;;

proc print data= biblio;
run;

proc print data=mylib.address_v2;
run;

data add2;
set mylib.address_v2;
if State="AZ" then delete;
run;

proc print data=add2;
where State="AZ" or State="CA";
run;

/* routing data to multiple datasets */

data AZ_state CA_state rest_states;
set mylib.address_v2;
if State="AZ" then output AZ_State;
else if State="CA" then output CA_State;
else output rest_states;
run;

proc print data = AZ_state ;
run;

proc print data = CA_state ;
run;
proc print data = rest_states ;
run;



