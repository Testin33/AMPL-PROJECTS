param n;		#number of customers (demands)
param m;		#number of potential facilities
param B>=0;		#opening budget {{EXTRA}}
set J := {1..n};# customer demand regions 
set I :={1..m}; # plants origins
param F{I}>=0; 	#fixed costs this to open a facility i
param C{I,J} >= 0;# objective function coefficients
param D{J} >= 0; # demand required by client j
param cap{I}>=0; # capacity of facility i


var y {i in I} binary; #decision variable: 1 if facility
						# is opened 0 if otherwise
var x {i in I,j in J} >= 0; # quantity shipped form facility i to client j

#objective function
minimize z: sum {i in I} F[i]*y[i] + sum{i in I, j in J} C[i,j]*x[i,j];

#demand satisfaction const
s.t. demandsat {j in J}: sum {i in I} x[i,j] = D[j];

#open link flow constraint
s.t. openLink {i in I, j in J}: x[i,j] <= D[j]*y[i];

#the plant capacity
s.t. CapacityPlant{i in I}: sum{j in J} x[i,j] <= cap[i]*y[i];