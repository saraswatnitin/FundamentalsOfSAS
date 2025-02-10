/* Generated Code (IMPORT) */
/* Source File: Related_Geo-Socioeconomic_Dataset.csv */
/* Source Path: /home/chetan.saraswat@aiproff.ai/Related_Geo-Socioeconomic_Dataset.csv */
/* Code generated on: Monday, February 10, 2025, 12:47:55 PM */

/*
proc sql;
%if %sysfunc(exist(WORK.IMPORT)) %then %do;
    drop table WORK.IMPORT;
%end;
%if %sysfunc(exist(WORK.IMPORT,VIEW)) %then %do;
    drop view WORK.IMPORT;
%end;
quit;
*/

libname lib "/home/chetan.saraswat@aiproff.ai/";
FILENAME REFFILE DISK '/home/chetan.saraswat@aiproff.ai/Address_v2.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=lib.address_v2;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=lib.address; RUN;

proc print data = lib.address;
run;

