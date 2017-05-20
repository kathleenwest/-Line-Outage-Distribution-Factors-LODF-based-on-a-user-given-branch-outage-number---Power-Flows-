function [deltPflo,LODFvalues] = computeLODF(Bp, swingbus, branchout, branch)
%computeLODF    Computes the Line Outage Distribution Factors
% Description: Computes the LODF (line outage distribution factors) on each
% branch 
% Inputs: Admittance Matrix (with the swing bus), swingbus identifier, a
% 1X3 matrix called branchout [branchno frombus tobus], and the branch
% matrix given from wcc9bus
% Outputs: deltPlflo is the LODF matrix without the outage bus eliminated
% LODFvalues contain the final values for the effect of a branch outage on
% all other branches

%------------------------------------
% Formulate the P Matrix
%------------------------------------

D = size(Bp);
P = zeros(D(1),1);
for i=1:D(1)
    if i == branchout(1,2) % Add +1 to the from bus
        P(i,1) = 1;
    else
        if i == branchout(1,3) % Add -1 to the to bus
          P(i,1) = -1;
        else
        end;
    end;
end;


% Reduce the matrix for the swing bus

Ptemp = zeros(D(1)-1,1);

for i=1:D(1)
    if i < swingbus
        Ptemp(i,1) = P(i,1) ;
    else
        if i > swingbus
          Ptemp(i-1,1) = P(i,1);
        else
        end;
    end;
    
end;
P = Ptemp;

%--------------------------------------------------------------------------
% Set-Up B-Prime Matrix Minus Swing Bus
%--------------------------------------------------------------------------

bprimematrixnoswing = zeros(8,8);

for i=1:9
    for j = 1:9
     if (i ~= swingbus & j ~= swingbus)    
        if (i < swingbus & j < swingbus)
          bprimematrixnoswing(i,j) = Bp(i,j);  
        else
            if (i > swingbus & j < swingbus)  
                bprimematrixnoswing(i-1,j) = Bp(i,j); 
              else
                  if (i < swingbus & j > swingbus)   
                   bprimematrixnoswing(i,j-1) = Bp(i,j); 
                  else
                       if (i > swingbus & j > swingbus)  
                          bprimematrixnoswing(i-1,j-1) = Bp(i,j);
                       else
                       end;
                   end;                  
                end;
            end;
        end;
     end;

end;
% bprimematrixnoswing holds the matrix with the swing bus removed


%----------------------------------------------------
% Solve for the Theta Values
%----------------------------------------------------
% P = B'*Theta

% Computes the Theta Matrix
thetavalues = bprimematrixnoswing\P;
D = size(thetavalues);
thetavalues2 = zeros(D(1)+1,1);
for i=1:D(1)+1
    if i < swingbus
        thetavalues2(i,1) = thetavalues(i,1);
    else
        if i > swingbus
         thetavalues2(i,1) = thetavalues(i-1,1);  
        else
            if i == swingbus
              thetavalues2(i,1) = 0;  
            else
            end;
        end;
    end;
end;

% this holds all the delta thetas for each bus including the zero value for
% the swing bus
thetavalues = thetavalues2;
D = size(thetavalues);
thetavalues2 = zeros(D(1),2);
for i=1:D(1)
    for j=1:2
        if j==1
         thetavalues2(i,j) = i;    
        else
          thetavalues2(i,j) = thetavalues(i,1);  
        end;
    end;
end;

thetavalues = thetavalues2;
%----------------------------------------------------
% Calculates the LODF's
%----------------------------------------------------

% Find the Branch Series Reactance
D = size(branch);
branchr = [branch(:,1) zeros(D(1),1) branch(:,2) zeros(D(1),1) branch(:,4)];
D = size(branchr);
F = size(thetavalues);
LODFvalues = [branchr zeros(D(1),1)];

% This part assigns the theta values to the columns corresponding to the
% branch t, from
for i=1:D(1)
    for m=1:F(1)
        if LODFvalues(i,1) == thetavalues(m,1)  
             LODFvalues(i,2) = thetavalues(m,2);  
        else
                    if LODFvalues(i,3) == thetavalues(m,1)  
                        LODFvalues(i,4) = thetavalues(m,2);  
                    else   
                    end;     
        end;   
    end;
    
end;

% This calculates the LODF in the final column

D = size(LODFvalues);

for i=1:D(1)
    LODFvalues(i,6) = (LODFvalues(i,2) - LODFvalues(i,4))/LODFvalues(i,5);
end;

%-----------------------------------------------------------------------
% Final Results
%-----------------------------------------------------------------------

% This is the LODF (nbranch x 1) vector per the assignment
deltPflo = [LODFvalues(:,6)];
i = [1 2 3 4 5 6 7 8 9]';

% This is the LODF (nbranch x 3) including the from bus, to bus, and LODF
LODFvalues = [i LODFvalues(:,1) LODFvalues(:,3) LODFvalues(:,6) ];

LODFvalues(branchout(1),4) = -1;

return;