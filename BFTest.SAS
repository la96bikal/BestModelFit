data GPA;
input X Y;
datalines;
2.69 2.8
0.83 1.6
2.39 2.0
3.65 2.9
1.85 2.3
3.83 3.2
1.22 1.8
1.48 1.4
2.28 2.0
4.0 3.8
2.28 2.2
1.88 1.6
2.83 2.5
4.32 3.7
3.39 3.4
2.32 2.6
3.04 3.1
2.35 2.3
2.7 3.0
2.05 1.9
;
run;

proc reg data = GPA;
	model y=x;
	output out= temp r=r;
run;

data temp1;
	set temp;
	id = _n_;
	group = .;
	if x <=2.37 then group = 1;
	if x > 2.37 then group = 2;
run;

proc sort data=temp1;
	by group;
run;

proc means data = temp1;
	by group;
	var r;
	output out=mout median=mr;
run;

proc print data = mout;
	var group mr;
run;

data mtemp;
	merge temp1 mout;
	by group;
	d = abs(r-mr);
run;

proc sort data = mtemp;
	by group;
run;

proc means data = mtemp;
	by group;
	var d;
	output out = mout1 mean = md;
run;

proc print data = mout1;
	var group md;
run;

data mtemp1;
	merge mtemp mout1;
	by group;
	ddif = (d-md)**2;
run;

proc sort data=mtemp1;
	by group x;
run;

proc ttest data = mtemp1;
	class group;
	var d;
run;

proc print data = mtemp1;
 	by group ;
 	var id x r d ddif;
 run;
	

