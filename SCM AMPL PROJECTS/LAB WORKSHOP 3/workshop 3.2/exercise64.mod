param n;
param m;
param a;

set J := {1..n};  # customers
set I := {1..m};  # facilities
set K := {1..a};  # periods

# parameters
param f{I} >= 0;
param c{I,J} >= 0;
param d{J,K} >= 0;
param cap{I} >= 0;
param h{I} >= 0;
param mininv{I} >= 0;
param ss{I} >= 0;

param t{I,J}       >= 0;  # transportation cost i->j
param transcap{I}  >= 0;  # outbound capacity
param p{I}         >= 0;  # production/procurement cost
param init{I}      >= 0;  # initial inventory at t=1

# PARAMETER FOR EXERCISE 6.1.2
param mult{K} >= 0;   # demand multiplier per period

# PARAMETER FOR EXERCISE 6.1.3
param costmult{i in I} >= 0;  # procurement cost multiplier

# PARAMETER FOR TRANSPORTATION COST INCREASE
param transcostmult >= 0 ;  # transportation cost multiplier

# decision variables
var y{i in I} binary;
var x{i in I, k in K, j in J} >= 0;
var s{i in I, k in K} >= 0;
var q_ik{i in I, k in K} >= 0;

# objective function
minimize z:
      sum{i in I} f[i]*y[i]
    + sum{i in I, j in J, k in K} (c[i,j] + transcostmult * t[i,j]) * x[i,k,j]
    + sum{i in I, k in K} h[i] * s[i,k]
    + sum{i in I, k in K} (costmult[i] * p[i]) * q_ik[i,k]; #MODIFIED

# demand satisfaction with multiplier 
s.t. demandsat{j in J, k in K}:
	sum{i in I} x[i,k,j] = mult[k] * d[j,k];

# open link constraint with multiplier 
s.t. openLink{i in I, k in K, j in J}: 
	x[i,k,j] <= mult[k] * d[j,k] * y[i];

# capacity limit
s.t. caplimit{i in I, k in K}:
    sum{j in J} x[i,k,j] <= cap[i] * y[i];

# safety stock requirement
s.t. safetystock{i in I, k in K}:
    s[i,k] >= ss[i] * y[i];

# minimum inventory requirement
s.t. mininventory{i in I, k in K}:
    s[i,k] >= mininv[i] * y[i];

# transportation capacity
s.t. transportation_cap{i in I, k in K}:
    sum{j in J} x[i,k,j] <= transcap[i] * y[i];

# inventory balance for first period
s.t. inventory_balance_first_period{i in I}:
    s[i,1] = init[i] + q_ik[i,1] - sum{j in J} x[i,1,j];

# inventory balance for subsequent periods
s.t. inventory_balance{i in I, k in K: k >= 2}:
    s[i,k] = s[i,k-1] + q_ik[i,k] - sum{j in J} x[i,k,j];