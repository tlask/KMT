function [MP] = SortAuf(M,AufR)
%
% [MP] = <strong>SortAuf</strong>(M,AufR)
%
% Sortiert eine Matrix / einen Vektor nach der Auftragsreihenfolge.
%
% Parameter:
%   M: Matrix/Verktor
%   AufR: Auftragsreihenfolge
%   MP: Matrix/Verktor sortiert nach der Auftragsreihenfolge


[m,n] = size(M);
MP = zeros(m,n);

for i = 1:n
    MP(:,i) = M(:,AufR(i));
end

end