# -Line-Outage-Distribution-Factors-LODF-based-on-a-user-given-branch-outage-number---Power-Flows-

Project Blog Article link here: https://portfolio.katiegirl.net/2018/07/31/lineoutagedistributionfactors/


The project required the computation of the Line Outage Distribution Factors (LODF) based on a user given branch outage number using the fast-decoupled XB version.  The LODF values were used to approximate the post-contingency branch flows based on a pre-contingency branch flow and the base branch flow before the contingency. The AC power flows were compared with the DC method for the MW and MVA flows.  Source code is provided in the same WinZip file for the functions calculating the LODF values and the approximated post-contingency branch flows.

Conclusions:

I started the program flow by writing code to determine the swing bus, since it plays a valuable part in the calculation of line outage distribution factors, and reducing the B prime matrix. The main program prints out a listing of each branch number, from bus, to bus and asks for the user input of a branch outage number. The program will test for only branch outages on 4, 5,6,7,8 or 9 and loop for more requests until the user enters an acceptable number. After the selected branch number is chosen for the branch outage, the wcc9bus branch data is copied to a new matrix and the corresponding row of the branch outage is removed. The B-prime matrix is then formed from the new branch matrix with the branch outage row missing. 

The main program then makes a call to the LODF function. The LODF function (computeLODF.m) solves the "[newB']deltaTheta=deltaP" system given the branch outaged, the wcc9bus branch data, and the B-prime matrix.  It returns the LODFvalues matrix which contains the branch number, from bus, to bus, and the LODF factor. The main program then prints these results in the MATLAB window.

A fast-decoupled power flow is then run with the wcc9bus and the pre-contingency branch flows are saved for use in determining the post-contingency branch flows in the baseMW matrix. The DetermineBranchFlows2 function requires the baseMW matrix with the pre-contingency branch flows, a matrix with the branch being outaged, and the LODF values. The function returns the post-contingency branch flows as a matrix newbranchflows. The post-contingency branch flows are then printed on the MATLAB workspace. 

The MW post-contingency branch flows calculated from LODF (Fast-Decoupled) were then compared to MW flows using Newton’s method for each possible branch outage. The MVA values were also compared to the MW values. The results are included in this document in table form. This document also displayed the MATLAB screen results for each branch outage. Results were the LODF factors and the post-contingency branch flows. 



