libname lib "/home/chetan.saraswat@aiproff.ai/";


proc contents data = lib.geosocioecon;
run;

proc print data = lib.geosocioecon;
run;

proc contents data = lib.related_geosocioecon;
run;

proc print data = lib.related_geosocioecon;
run;
