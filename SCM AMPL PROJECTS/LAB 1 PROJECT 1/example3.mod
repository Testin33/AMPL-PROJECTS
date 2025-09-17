param n;
param m;
set J := {1..n}; # set of decision variables
set I :={1..m}; # set of constraints

param f{I}>=0; #fixed costs
param c{I,J} >= 0; 	# objective function coefficients
param d{J} >= 0; 

var y {i in I} binary;
var x {i in I,j in J} >= 0; 

#objective function
minimize TotalCost: sum {i in I} f[i]*y[i] + sum{i in I, j in J} c[i,j]*x[i,j];

#demand satisfaction const
s.t. demandsat {j in J}: sum {i in I} x[i,j] = d[j];

#open link flow constraint
s.t. OpenLink {i in I, j in J}: x[i,j] <= d[j]*y[i];