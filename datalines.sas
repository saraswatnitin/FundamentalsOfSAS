data person;
	infile datalines delimiter=',';
	input name $ dept $;
	datalines;
John,Sales 
Mary,Acctng 
;

proc print data=person;
run;