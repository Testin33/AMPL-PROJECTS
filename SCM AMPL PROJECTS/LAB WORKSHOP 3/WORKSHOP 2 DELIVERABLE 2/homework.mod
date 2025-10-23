param n;		
param m;		#estos son contadores de nuestras regiones

# declaration of sets
set I:= {1..n}; 
# this means that i will go till n
set J:= {1..m};
 
#now we declare the parameter that are gonna 
#be used in the calculations

#the parameters are strictly nonnegative

param f{I} >=0;
param c{I,J}>=0;
param d{J}>=0;
param cap{I}>=0;

#the new parameters for this model

#Holding cost parameter
param h{I}>=0;
#Minimmun inventory at facility i
param MinInv{I}>=0; 
#Safety Stock at facility i
param SS{I}>=0;

#declaration of decision variables

var y{i in I} binary;
var x{i in I,j in J} >= 0;
var s{i in I} >= 0;

#declaration of the objective function

minimize TotalCost : sum{i in I} f[i]*y[i] + sum{i in I,j in J} c[i,j]*x[i,j] + sum{i in I} h[i]*s[i];

#constraints

#demand satisfaction constraint

DemandSatisfaction {j in J}: sum {i in I} x[i,j] >= d[j]; 

#open-flow link constraint

OpenFlowLink {i in I, j in J}: x[i,j] <= d[j]*y[i];

#plant capacity 

CapacityPlant {i in I}: sum {j in J} x [i,j] <= cap[i]* y[i];

#safety stock

SafetyStock {i in I}: s[i] >= SS[i]*y[i];

#minimun Inventory

MinimunInventory {i in I} : s[i] >= MinInv[i]*y[i];






















