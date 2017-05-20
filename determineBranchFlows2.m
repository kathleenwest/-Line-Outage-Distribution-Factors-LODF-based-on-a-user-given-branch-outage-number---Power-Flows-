function [newbranchflows] = determineBranchFlows2(LODFvalues, baseMW, branchout)
%determineBranchFlows2    Computes the Post-Contingency Branch Flows
% Description: Computes the Post-Contingency Branch Flows for a particular
% branch being outaged
% Inputs: LODFvalues (matrix of branch number, from bus, to bus, and LODF factor), a
% 1X3 matrix called branchout [branchno frombus tobus], and the baseMW or
% pre-contingency branch flows
% Outputs: newbranchflows contains the branch number , from bus, to bus,
% and the post-contingency branch flow

D = size(baseMW);

% Determine the MW of the branchout

for i=1:D(1)
    if i == branchout(1,1);
     branchMW = baseMW(i,4);
    else
    end;
end;

newbranch = zeros(D(1),D(2));
for i=1:D(1)
    newbranchflows(i,1) = baseMW(i,1);
    newbranchflows(i,2) = baseMW(i,2);
    newbranchflows(i,3) = baseMW(i,3);
    newbranchflows(i,4) = baseMW(i,4) + LODFvalues(i,4)*branchMW;
end;

for i=1:D(1)
    if i == branchout(1,1)
        newbranchflows(i,4) = 0;
    else
    end;
end;

return;