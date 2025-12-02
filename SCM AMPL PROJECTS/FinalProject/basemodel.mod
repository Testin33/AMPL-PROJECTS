# =========================================================
# basemodel.mod
# Vehicle Routing Problem in Omni-Channel Retailing
# Based on Abdulkader et al. (2018)
# =========================================================

# --------------------
# SETS
# --------------------

set K;              # vehicles
set P;              # products
set N;              # customer nodes (retail stores + consumers)
set R within N;     # retail stores
set C within N;     # consumers

set V := {0} union N; # all nodes including depot (0)
# --------------------
# PARAMETERS
# --------------------

param Q   >= 0;                 # vehicle capacity
param L   >= 0;                 # max route length
param D{N} >= 0;                # delivery to retail stores (0 for consumers)
param d{P,C} >= 0;              # product demand of consumers
param I{P,R} >= 0;              # inventory at retail stores
param Cdist{V,V} >= 0;          # distance cost
param Ttime{V,V} >= 0;          # travel time
param O{V} >= 0;                # service time {Para el ejemplo incial no se usa}
param Mbig >= 0 default 1e5;    # big-M constant


# --------------------
# VARIABLES
# --------------------

# ARC VARIABLES — defined for ALL pairs (i,j), including i=j
var x{k in K, i in V, j in V} binary;

# assignment store → consumer
var y{i in R, j in C} binary;

# load after leaving node
#La carga que lleva el vehículo k justo después de salir del nodo i,
#y eso incluye también al depot (0) porque 0 pertenece V.
var load{k in K, i in V} >= 0 <= Q;

# service start time
#el momento en el que el vehículo k empieza a atender el nodo i
var s{k in K, i in V} >= 0;


# --------------------
# OBJECTIVE
# --------------------
#aca buscamos minimizar el producto ente el costo de la distancia del arco i->j
# y la distancia en si desde el node de acuerdo al vehiculo k en el nodo i->j

minimize Total_Distance: sum{k in K, i in V, j in V} Cdist[i,j] * x[k,i,j];

# --------------------
# ROUTING STRUCTURE 
# --------------------

# No self-loops: x[k,i,i] = 0
s.t. No_Self_Loops{k in K, i in V}: x[k,i,i] = 0;

# Visit each customer node once
s.t. Visit_Once{j in N}:sum{k in K, i in V: i != j} x[k,i,j] = 1;

# Each vehicle starts at depot once
s.t. Start_Depot{k in K}: sum{j in N} x[k,0,j] = 1;

# Each vehicle returns to depot once
s.t. End_Depot{k in K}: sum{i in N} x[k,i,0] = 1;

# Flow conservation at customer nodes
s.t. Flow_Balance{k in K, n in N}: 
	sum{j in V: j != n} x[k,n,j] = sum{j in V: j != n} x[k,j,n];


# --------------------
# ASSIGNMENT & INVENTORY
# --------------------

s.t. Assign_Consumer{j in C}:
    sum{i in R} y[i,j] = 1;

s.t. Inventory_Limit{i in R, p in P}:
    sum{j in C} d[p,j] * y[i,j] <= I[p,i];


# --------------------
# LINKING store–consumer
# (Linearization of Eq. (6) → Eqs. (15)-(16))
# --------------------

s.t. Link_SC_1{i in R, j in C, k in K}:
    sum{ell in V} x[k,i,ell]
  - sum{ell in V} x[k,ell,j]
    <= Mbig * (1 - y[i,j]);

s.t. Link_SC_2{i in R, j in C, k in K}:
    sum{v in V} x[k,v,j]
  - sum{v in V} x[k,i,v]
    <= Mbig * (1 - y[i,j]);


# --------------------
# CAPACITY / LOAD CONSISTENCY
# (Linearization of Eq. (9) → Eq. (17))
# --------------------

s.t. Load_Propagation{k in K, i in V, j in N: i != j}:
    load[k,j] + D[j] - load[k,i] <= Mbig * (1 - x[k,i,j]);


# --------------------
# TIME CONSISTENCY
# (Linearization of Eq. (10)-(11) → Eq. (18)-(19))
# --------------------

s.t. Depot_Time{k in K}:
    s[k,0] = 0;

s.t. Time_Arc{k in K, i in V, j in N: i != j}:
    s[k,j] >= s[k,i] + Ttime[i,j] + O[i]
              - Mbig * (1 - x[k,i,j]);

s.t. Precedence_SC{i in R, j in C, k in K}:
    s[k,j] >= s[k,i] + Ttime[i,j] + O[i]
              - Mbig * (1 - y[i,j]);


# --------------------
# MAX ROUTE LENGTH
# --------------------

s.t. Max_Route_Length{k in K, i in N}:
    s[k,i] + O[i] + Ttime[i,0]
    <= L + Mbig * (1 - sum{j in V: j != i} x[k,i,j]);
