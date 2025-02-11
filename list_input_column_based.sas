Libname Mylib "/home/chetan.saraswat@aiproff.ai/";
Filename Myfile "/home/chetan.saraswat@aiproff.ai/Data.txt";

Data Mylib.Test1;
	Infile Myfile;
	Input Id 1-3 Name $ 5-9 Sex $ 11-11 Dob :yymmdd8. ;
	Age=(Today() -Dob ) / 365;
	Format Dob YYMMDD10.;
	Label Id="Patient Id"
	Name="Patient Name"
	Sex="Gender"
	Dob="Date of Birth";
Run;

proc print data=Mylib.Test1;
run;
