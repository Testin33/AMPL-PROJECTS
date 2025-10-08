# Two-Echelon Location & Inventory Problem

param n; #quantity of customers
param m; #quantity of plants
param p; #quantity of warehouses 
param t; #quantity of DC's

#Set declaration

set J:={1..n};  #set of customers
set I:={1..m}; # set of plants 
set W:={1..p}; #set of warehouses
set D:={1..t}; #set of DC's

#PARAMETERS

param cap_Plant{I}>=0; # capacity of the Plants

#parameters for DC's
param f_Dist{D} >=0; #fixed cost of opening a DC
param cap_Dist{D}>=0; #capacity of the DC
param h_Dist{D}>=0; #holding cost in DC
param mininv_Dist{D}>=0; #Minimun Inventory on DC
param ss_Dist{D}>=0; #Safety Stock on DC's  

#Parameters for Warehouses
param f_Warehouse{W}>=0; #fixed cost of opening a Warehouse
param cap_Warehouse{W}>=0; #capacity of a warehouse 
param h_Warehouse{W}>=0; #holding cost on warehouse
param mininv_Warehouse{W}>=0; #minimun inventory on Warehouse
param ss_Warehouse{W}>=0; #safety stock for a warehouse

#Transportation Costs
param c_id {I,D}>=0; #from plant to DC
param c_dw {D,W}>=0; #from DC to Warehouse
param c_wj {W,J}>=0; #from Warehouse to Customer

#demand
param demand{J}>=0; # Customer Demand

#DECISION VARIABLES
#binary decisions
var y_Warehouse {w in W} binary; #if a warehouse is opened
var y_Dist {d in D} binary;  
#units shipped from .... to ....
var x_id {i in I,d in D}>=0; #from plant to DC
var x_dw {d in D,w in W}>=0; #from DC to Warehouse
var x_wj {w in W,j in J}>=0; #from Warehouse to customer 
#additional decision variable
var s_Warehouse{w in W} >=0; #inventory on warehouse
var s_Dist{D}>=0; #inventory on DCs


#OBJECTIVE FUNTION
minimize z: (sum {d in D} f_Dist[d]*y_Dist[d]) + (sum{w in W} f_Warehouse[w]*y_Warehouse[w]) + (sum{i in I, d in D} c_id[i,d]*x_id[i,d])+ (sum{d in D, w in W} c_dw[d,w] * x_dw[d,w])+ (sum{w in W, j in J} c_wj[w,j] * x_wj[w,j]) + (sum{w in W} h_Warehouse[w]*s_Warehouse[w])+(sum{d in D} h_Dist[d]*s_Dist[d]) ;

#CONSTRAINTS
#demand satisfaction constraint (checked)
s.t. demandsat {j in J}: sum {w in W} x_wj[w,j] = demand[j];

#open link flow constraint for Plant-DC (checked)
s.t. openLink_Plant_DC {i in I, d in D}: x_id[i,d] <= 1000000*y_Dist[d];
#open link flow constraint for DC-Warehouse
s.t. openLink_DC_Warehouse {d in D, w in W}: x_dw[d,w]<=1000000*y_Warehouse[w];
#open link flow constrain Warehouse-Customer
s.t. openLink_Warehouse_Customer {w in W, j in J}: x_wj[w,j] <= demand[j]*y_Warehouse[w];

#the plant capacity(checked)
s.t. capacityplant{i in I}: sum{d in D} x_id[i,d] <= cap_Plant[i];
# DC capacity (checked)
s.t. capacitydist {d in D}: sum{w in W}x_dw[d,w] <= cap_Dist[d]*y_Dist[d];
#the warehouse capacity (checked)
s.t. capacitywarehouse {w in W}: sum{j in J} x_wj[w,j]<= cap_Warehouse[w]*y_Warehouse[w];

#warehouse balance (checked)
s.t. wh_balance {w in W}: sum {d in D} x_dw[d,w] = sum {j in J} x_wj[w,j]+s_Warehouse[w];
#distribution balance (checked)
s.t. dist_balance {d in D}: sum{i in I} x_id[i,d] = sum{w in W} x_dw[d,w]+s_Dist[d];

# Safety Stock of DC (checked)
s.t. ss_Dist_const {d in D}: s_Dist[d] >= ss_Dist[d]*y_Dist[d];
# Minimun Inventory (checked)
s.t. min_Dist_const {d in D}: s_Dist[d]>= mininv_Dist[d]*y_Dist[d];

#safety stock of warehouse 
s.t. ss_Warehouse_const {w in W}: s_Warehouse[w] >= ss_Warehouse[w] *y_Warehouse[w];
#minimun Inventory for warehouse
s.t. min_Warehouse_const {w in W}: s_Warehouse[w] >= mininv_Warehouse[w] * y_Warehouse[w];












