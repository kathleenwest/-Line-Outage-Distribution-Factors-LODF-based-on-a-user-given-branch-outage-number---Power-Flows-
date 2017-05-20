% Project # 2
% Kathleen Williams
% ECE 557


% Determines Topology of the System
[baseMVA, bus, gen, branch, area, gencost] = wscc9bus;

% Determines the Swing Bus
D = size(bus);
swingbus = -1;
for i=1:D(1)
    if bus(i,2) == 3;
        swingbus = bus(i,1);
    else
    end;
end;
% swingbus is now a global variable storing the reference bus

%--------------------------------------------------------------------------
% Plan for Branch Out of Service
%--------------------------------------------------------------------------

% Print the Branch Topology

    fprintf('\n=============================================');
    fprintf('\n|     Branch Setup Data                     |');
    fprintf('\n=============================================');
    fprintf('\n Branch # \t From Bus \t To Bus  \t');
    fprintf('\n -------- \t -------- \t -------- ');
for i=1:D(1)-1
    fprintf('\n \t%1.0f \t\t\t%1.0f \t\t\t%1.0f ', i, branch(i,1), branch(i,2));
end;
fprintf('\n');
fprintf('\n');

% Ask for a branch to be taken out of service and perform error checking

branchout = -1;
while branchout <= 0 || branchout > 9
branchout = input('Enter the branch number to be taken out of service:');
fprintf('\n');
fprintf('Your have chosen branch number: ');
fprintf('%1.0f', branchout);
fprintf(' to be out of service.');

    if branchout >=4 && branchout <= 9

    else
        fprintf('\n');
        fprintf('Your have chosen an invalid branch number: ');
        fprintf('\n');
        branchout = input('Enter the branch number to be taken out of service:');
        fprintf('\n');
        fprintf('Your have chosen branch number: ');
        fprintf('%1.0f', branchout);
        fprintf(' to be out of service.');
    end;
end;

% Make a new branch data based on the outaged branch

branchnew = branch;
branchnew(branchout,:)=[];

% branchnew now contains the eliminated branch

% Formulate branch info on out of service
D = size(branch);
branchout2 = [0 0 0];
for i=1:D(1)
    if i == branchout
      branchout2 = [i branch(i,1) branch(i,2)];    
    else
        
    end;
end;
branchout = branchout2;
%--------------------------------------------------------------------------
% Set-Up B-Prime Matrix 
%--------------------------------------------------------------------------

alg = 2; % BX Method
[Bp, Bpp] =  makeB(baseMVA, bus, branchnew, alg);

%--------------------------------------------------------------------------
% LODF Factors 
%--------------------------------------------------------------------------

[deltPflo,LODFvalues] = computeLODF(Bp, swingbus, branchout, branch);
fprintf('\n\n');


    fprintf('\n=============================================');
    fprintf('\n|    Line Outage Distribution Factors        |');
    fprintf('\n=============================================');
    fprintf('\n From Bus \tTo Bus   \tValue ');
    fprintf('\n -------- \t------ \t  --------');
    D = size(LODFvalues);
for i=1:D(1)
    fprintf('\n %1.0f \t\t\t%1.0f \t\t\t%6f', LODFvalues(i,2), LODFvalues(i,3), LODFvalues(i,4));
end;




%--------------------------------------------------------------------------
% Run a Fast-Decoupled Power Flow for the 9-Bus system
%--------------------------------------------------------------------------
options = mpoption('PF_ALG', 2);
[baseMVA, bus, gen, newbranch, success] = runpf('wscc9bus',options);


%--------------------------------------------------------------------------
% Post-Contingency Branch Flows
%--------------------------------------------------------------------------

branchtemp = [];
for i=1:9
    branchtemp(i,1) = i;
end;

% Determine the base MW flows taken at the FROM Bus
baseMW = [branchtemp newbranch(:,1) newbranch(:,2) newbranch(:,12)];

% Determines the branch flows
[newbranchflows] = determineBranchFlows2(LODFvalues, baseMW, branchout);
fprintf('\n\n');
    fprintf('\n=============================================');
    fprintf('\n|    Post-Contingency MW branch flows       |');
    fprintf('\n=============================================');
    fprintf('\n \tBranch   \tFrom Bus \t To Bus    \t  MW ');
    fprintf('\n \t-------- \t-------- \t---------  \t--------');
    D = size(newbranchflows);
for i=1:D(1)
    fprintf('\n \t\t%1.0f \t\t\t%1.0f \t\t\t%1.0f \t\t%6f', newbranchflows(i,1), newbranchflows(i,2), newbranchflows(i,3), newbranchflows(i,4));
end


