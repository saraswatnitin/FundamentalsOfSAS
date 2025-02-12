libname lib "/home/chetan.saraswat@aiproff.ai";

data lib.A;
    input Name $ Age Gender $;
    datalines;
Danny 25 M
Jim   43 M
Joe   18 M
Tracy 24 F
;
run;

data lib.B;
    input Name $ Gender $;
    datalines;
Beth   F
Danny  F
Jim    M
;
run;


proc print data = lib.a;
run;
proc print data =lib.b;
run;


/* one to one merge or one to one match like set a and set b datasets*/

data mergedata;
merge lib.a lib.b;
run;

proc print data = mergedata;
run;

/* Now if we wish to join data we must use BY group processing */
/* In order for BY to work we should sort data */

proc sort data = lib.a;
by name;
run;

proc sort data =lib.b;
by name;
run;


data mergedata1;
merge lib.a lib.b;
by name;
run;

proc print data =mergedata;
run;

proc print data =mergedata1;
run;

/* We can use IN option to select obs from specific datasets*/

data mergeindata;
merge lib.a(in=var1) lib.b(in=var2);
by name;
if var1;
run;

proc print data = mergeindata;
run;

