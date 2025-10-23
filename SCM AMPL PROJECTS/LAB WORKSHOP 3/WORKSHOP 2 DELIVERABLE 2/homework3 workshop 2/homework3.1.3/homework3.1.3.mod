
#this file is to answer 3.1.1 sep 30
#One-Echelon Location & Inventory Problem 
# 3.1.What if the original problem is modified by setting the minimum inventory 
#level = 0 and safety stock levels = 0 for all facility locations? Solve it and take a 
#screenshot of your solution console. 
param n;
param m;


set J:={1..n};  #set of facilities
set I:= {1..m}; #set of customers

#parameters

param f{I}>=0;

#--------ADDED FROM ORIGINAL FILE-------
# Calculating automatically the holding 
param holding_percentage default 0.20 ; #using default because it
										# allows to change the value later
										
param h{i in I} = f[i] * holding_percentage; # so it calculates h based on f

param c{I,J} >=0;
param d{J}>=0;
param cap{I}>=0; 

# param h{I}>=0; 	#holding cost per unit of inventory 
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

