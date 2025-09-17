param n;
param m;
set J := {1..n}; # set of decision variables
set I :={1..m}; # set of constraints

param f{I}>=0; #fixed costs
param C {J} >= 0; 	# objective function coefficients
param A {I,J} >= 0; #constraint coefficient matrix
param B {I} >= 0; # RHS of the constraints

var X {J} >= 0; # decision variables

minimize z: (sum{j in J} C[j]* X[j] ) + (sum {i in I}f[i]) ;

s.t. Constraint {i in I}:
	sum {j in J} A[i,j]* X[j] >= B[i];