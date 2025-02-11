libname lib "/home/chetan.saraswat@aiproff.ai";



/* inner join 
Requires sorting before merging, whereas PROC SQL does not.*/

data lib.inner_join_result;
    merge lib.geosocioecon (in=a) lib.related_geosocioecon (in=b);
    by City;
    if a and b; /* Keep only matching records */
run;

/*sort first */

proc sort data = lib.geosocioecon out = lib.geosocioecon_srted;
by City;
run;

proc sort data = lib.related_geosocioecon out = lib.related_geosocioecon_srted;
by City;
run;

/* Now merge */
data lib.inner_join_result;
    merge lib.geosocioecon_srted (in=a) lib.related_geosocioecon_srted (in=b);
    by City;
    if a and b; /* Keep only matching records */
run;


/* left join */

data lib.left_join_result;
    merge lib.geosocioecon_srted (in=a) lib.related_geosocioecon_srted (in=b);
    by City;
    if a; /* Keep all records from the left dataset */
run;


/* Full Join */
data lib.full_join_result;
    merge lib.geosocioecon_srted (in=a) lib.related_geosocioecon_srted (in=b);
    by City;
    if a or b; /* Keep all records from both datasets */
run;
