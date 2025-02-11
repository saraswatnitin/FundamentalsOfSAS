libname lib "/home/chetan.saraswat@aiproff.ai";

proc sql;
	title "Inner Join: Common Cities in Both Datasets";
	select a.City, a.Population, a.CrimeRate_per_1000, b.Region, 
		b.InfrastructureScore
		from lib.geosocioecon as a
		inner join lib.related_geosocioecon as b
		on a.City=b.City;
quit;

/*
Inner Join returns only the rows where City exists in both datasets.
Useful for finding cities with detailed socio-economic and infrastructure data.
Data Step Limitation: Difficult to perform without manual sorting and merging steps.
*/
/* We can create a table to find this out as well */
proc sql;
	create table lib.left_join as
	(select a.City, a.Population, a.CrimeRate_per_1000, b.Region, 
		b.InfrastructureScore
		from lib.geosocioecon as a
		inner join lib.related_geosocioecon as b
		on a.City=b.City);
	 quit;



/* 
Left Join returns all rows from synthetic_data and matches values from related_dataset.
Cities without corresponding entries in the second dataset will have missing values (., null).
Data Step Limitation: Requires multiple merge steps and temporary datasets.
*/


proc sql;
   create table lib.left_join as 
(
   select a.City, a.Population, a.CrimeRate_per_1000, b.Region, b.InfrastructureScore
   from lib.geosocioecon as a
   left join lib.related_geosocioecon as b
   on a.City = b.City)
;
quit;

proc print data = lib.left_join;
run;


/*
Full Join combines all cities from both datasets, filling gaps with missing values.
Ideal for getting a complete picture with potential gaps identified.
Data Step Limitation: Full joins are very complex and require multiple merge steps with additional code for handling missing values.
*/


proc sql;
	create table lib.full_join as
	(select coalesce(a.City, b.City) as City, a.Population, a.CrimeRate_per_1000, 
		b.Region, b.InfrastructureScore
		from lib.geosocioecon as a
		full join lib.related_geosocioecon as b
		on a.City=b.City);
quit;



proc print data = lib.full_join;
run;

/*  Aggregation with GROUP BY – Average income by region*/
proc sql;
   title "Average Median Household Income by Region";
   select b.Region, 
          avg(b.MedianHouseholdIncome) as AvgIncome format=dollar12.2
   from lib.related_geosocioecon as b
   group by b.Region;
quit;


/* Filtering with WHERE Clause – Cities with a high crime rate and unemployment */
proc sql;
   title "Cities with High Crime Rate and Unemployment";
   select a.City, a.Population, a.CrimeRate_per_1000, a.UnemploymentRate
   from lib.geosocioecon as a
   where a.CrimeRate_per_1000 > 70 and a.UnemploymentRate > 10
   order by a.CrimeRate_per_1000 desc;
quit;


/* Join with Aggregation – Average infrastructure score for cities grouped by population size category */


proc sql;
   title "Average Infrastructure Score by Population Size Category";
   select case 
            when a.Population < 100000 then 'Small City'
            when a.Population between 100000 and 500000 then 'Medium City'
            else 'Large City'
          end as PopulationCategory,
          avg(b.InfrastructureScore) as AvgInfrastructureScore format=8.2
   from lib.geosocioecon as a
   left join lib.related_geosocioecon as b
   on a.City = b.City
   group by PopulationCategory;
quit;



