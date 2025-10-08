# Two-Echelon Location & Inventory Problem
param n;
param m;
param p; # 

set J:={1..n};  
set I:= {1..m}; 
set W:= {1..p}; #set of warehouses

#parameters

param f{W}>=0;
# param c{I,J} >=0;
param d{J}>=0;
param cap{I}>=0; 
param h{W}>=0;  
param c_iw{I,W}>=0; #transport cost from the plants -> warehouses
param c_wj{W,J}>=0; #transport cost from warehouse->customer
param mininv{W}>=0; #minimun inventory at warehouse w
param ss{W}>=0; #safety stock at warehouse w

# decision variables

var y {w in W} binary;
var x_iw {i in I,w in W}>=0; #units shipped from i to w
var x_wj {w in W,j in J}>=0;

#additional decision variable

var s{w in W} >=0;


#objective function\\\
minimize z: sum {w in W} f[w]*y[w] + sum{i in I, w in W} c_iw[i,w]*x_iw[i,w]+ sum{w in W, j in J} c_wj[w,j] * x_wj[w,j] + sum{w in W} h[w]*s[w];

#demand satisfaction const\\\
s.t. demandsat {j in J}: sum {w in W} x_wj[w,j] = d[j];

#open link flow constraint\\\\
s.t. openLink {w in W, j in J}: x_wj[w,j] <= d[j]*y[w];

#the plant capacity\\\\
s.t. capacityplant{i in I}: sum{w in W} x_iw[i,w] <= cap[i];

#the safety stock constraint\\\\
s.t. safetystock  {w in W} : s[w]>= ss[w] * y[w];
s.t. mininventory {w in W}: s[w]>= mininv[w]*y[w];

#warehouse balance

s.t. wh_balance {w in W}: sum {i in I} x_iw[i,w] = sum {j in J} x_wj[w,j]+s[w];


