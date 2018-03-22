function [C] = Fertigstellungszeitpunkt(BZP,k)
%
% [C] = <strong>Fertigstellungszeitpunkt</strong>(BZP,k)
%
% Ermittelt den Fertigstellungszeitpunkt der jeweiligen Aufträge.
%
% Parameter:
%   BZP: Nach Artikelreihefolge sortierte Bearbeitungszeit [ZE]
%   k: Reihenfolgeposition
%   C: Fertigstellungszeitpunkt


m = length(BZP);
n = size(k,2);
C = zeros(1,n);

for j = 1:m
    for i = 1:n
        if j <= k(i)
            C(i) = C(i)+BZP(j);
        end
    end
end


end

