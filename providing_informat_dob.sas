Libname Mylib "/home/chetan.saraswat@aiproff.ai/";
Filename Myfile "/home/chetan.saraswat@aiproff.ai/Data.txt";

data mylib.test2;
	infile myfile;
	Informat Dob YYMMDD8.;
	Input Id 1-3 Name $ 5-9 Sex $ 11-11 Dob ;
	Age=(Today()- dob) / 365;
	Format Dob YYMMDD10.;
	Label Id="Patient Id" Name="Patient Name"
	Sex="Gender"
	Dob="Date of Birth";
Run;

proc print data=mylib.test2;
run;