param n;
param m;


set J:={1..n};  #set of facilities
set I:= {1..m}; #set of customers

#parameters

param f{I}>=0;



param c{I,J} >=0;
param d{J}>=0;
param cap{I}>=0; 

param h{I}>=0; 	#holding cost per unit of inventory 
#at facility i
param mininv{I}>=0;
param ss{I}>=0;

var y {i in I} binary;
var x {i in I,j in J}>=0;

#additional decision variable
var s{i in I} >=0;


#objective function
minimize z: sum {i in I} f[i]*y[i] + sum{i in I, j in J} c[i,j]*x[i,j] + sum{i in I} h[i]*s[i];

#demand satisfaction const
s.t. demandsat {j in J}: sum {i in I} x[i,j] = d[j];

#open link flow constraint
s.t. openLink {i in I, j in J}: x[i,j] <= d[j]*y[i];

#the plant capacity
#s.t. capacityplant{i in I}: sum{j in J} x[i,j] <= cap[i]*y[i];
s.t. caplimit {i in I}: sum{j in J} x[i,j] <= cap[i]*y[i];

#the safety stock constraint

s.t. safetystock  {i in I} : s[i]>= ss[i] * y[i];
s.t. mininventory {i in I}: s[i]>= mininv[i]*y[i];

