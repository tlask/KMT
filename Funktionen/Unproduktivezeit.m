function [CU] = Unproduktivezeit(Aart,BZP,ke,kl)
% 
% [best,bestOrder,AnzVerg,AnzVerb,AnzNach] = <strong>T2FSPZ</strong>(StartZ,StartOrder,A,BZ)
%
% Ermittelt die Unproduktivezeit der jeweiligen Aufträge.
%
% Parameter:
%   Aart: Nach der Artikelreihenfolge sortierte Zuweisungsmatrix
%   BZP: Nach der Artikelreihefolge sortierte Bearbeitungszeit [ZE]
%   ke: Reihenfolgeposition des Start-Artikels
%   kl: Reihenfolgeposition des End-Artikels
%   CU: Unproduktivzeit


m = length(BZP);
n = size(kl,2);
CU = zeros(1,n);

for j = 1:m
    for i = 1:n
        if ((ke(i) <= j) && (j <= kl(i)) && (Aart(j,i) == 0))
            CU(i) = CU(i)+BZP(j);
        end
    end
end


end
