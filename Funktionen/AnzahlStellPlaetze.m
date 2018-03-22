function [CA] = AnzahlStellPlaetze(m,ke,kl)
%
% [CA] = <strong>AnzahlStellPlaetze</strong>(m,ke,kl)
%
% Ermittelt die Stellplatzzeit der jeweiligen Aufträge. 
%
% Parameter:
%   m: Anzahl der Artikel
%   ke: Reihenfolgeposition des Start-Artikels
%   kl: Reihenfolgeposition des End-Artikels
%   CA: Anzahl Stellplätze


n = size(kl,2);
CAA = zeros(1,m);

for j = 1:m
    for i = 1:n
        if ((ke(i) <= j) && (j <= kl(i)))
            CAA(j) = CAA(j)+1;
        end
    end
end

CA = max(CAA);


end