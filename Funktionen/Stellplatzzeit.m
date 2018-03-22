function [CP] = Stellplatzzeit(BZP,ke,kl)
%
% [CP] = <strong>Stellplatzzeit</strong>(BZP,ke,kl)
%
% Ermittelt die Stellplatzzeit der jeweiligen Aufträge. 
%
% Parameter:
%   BZP: Nach der Artikelreihefolge sortierte Bearbeitungszeit [ZE]
%   ke: Reihenfolgeposition des Start-Artikels
%   kl: Reihenfolgeposition des End-Artikels
%   CP: Stellplatzzeit


m = length(BZP);
n = size(kl,2);
CP = zeros(1,n);

for j = 1:m
    for i = 1:n
        if ((ke(i) <= j) && (j <= kl(i)))
            CP(i) = CP(i)+BZP(j);
        end
    end
end


end