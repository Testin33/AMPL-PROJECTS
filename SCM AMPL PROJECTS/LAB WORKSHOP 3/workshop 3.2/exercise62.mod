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
param p{I}         >= 0;  # (e.g., production cost)
param init{I}      >= 0;  # initial inventory at t=1
#CHANGES FROM THE BASE MODEL FOR THE ITEM 6.2
param mult{K} >= 0;   # demand multiplier per period
# decision variables
var y{i in I} binary;
var x{i in I, k in K, j in J} >= 0;
var s{i in I, k in K} >= 0;
var q_ik{i in I, k in K} >= 0;
# objective
minimize z:
      sum{i in I} f[i]*y[i]
    + sum{i in I, j in J, k in K} (c[i,j] + t[i,j]) * x[i,k,j]
    + sum{i in I, k in K} h[i] * s[i,k]
    + sum{i in I, k in K} p[i] * q_ik[i,k];
# constraints
#CHANGING THE DEMAND SATISFATIION BASE MODEL
#s.t. demandsat{j in J, k in K}:
#    sum{i in I} x[i,k,j] = d[j,k];
#------ new constraint
s.t. demandsat{j in J, k in K}:
	sum{i in I} x[i,k,j] = mult[k] * d[j,k];
#CHANGING THE OPEN LINK CONSTRAINT 
#s.t. openLink{i in I, k in K, j in J}:
#   x[i,k,j] <= d[j,k] * y[i];
#---------new constraint
s.t. openLink{i in I, k in K, j in J}: 
	x[i,k,j] <= mult[k] * d[j,k] * y[i];
# all other constraints stays the same as the base model
s.t. caplimit{i in I, k in K}:
    sum{j in J} x[i,k,j] <= cap[i] * y[i];
s.t. safetystock{i in I, k in K}:
    s[i,k] >= ss[i] * y[i];
s.t. mininventory{i in I, k in K}:
    s[i,k] >= mininv[i] * y[i];
s.t. transportation_cap{i in I, k in K}:
    sum{j in J} x[i,k,j] <= transcap[i] * y[i];
s.t. inventory_balance_first_period{i in I}:
    s[i,1] = init[i] + q_ik[i,1] - sum{j in J} x[i,1,j];
s.t. inventory_balance{i in I, k in K: k >= 2}:
    s[i,k] = s[i,k-1] + q_ik[i,k] - sum{j in J} x[i,k,j];
