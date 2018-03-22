function [AufRver] = Maxsort(AufR,Cs)
%
% [AufRver] = <strong>Maxsort</strong>(AufR,Cs)
%
% Sortiert die Auftragreihenfolge nach dem maximalen spezifischen
% Fertigstellungszeitpunkt.
%
% Parameter:
%   AufR: Auftragsreihenfolge
%   Cs: spezifische Fertigstellungszeitpunkte
%   AufRver: Sortierte Auftragreihenfolge


n = length(Cs);
AufRver = zeros(1,n);

for i=1:n
    x = find(Cs==max(Cs),1,'first'); % Findet die Stelle, wo das Maximum ist; bei mehreren wird das erste gewählt
    Cs(x) = -1;
    AufRver(i) = AufR(x);
end

end

