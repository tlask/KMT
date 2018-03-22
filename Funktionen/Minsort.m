function [AufRver] = Minsort(AufR,Cs)
%
% [AufRver] = <strong>Minsort</strong>(AufR,Cs)
%
% Sortiert die Auftragreihenfolge nach dem minimalen spezifischen
% Fertigstellungszeitpunkt.
%
% Parameter:
%   AufR: Auftragsreihenfolge
%   Cs: spezifische Fertigstellungszeitpunkte
%   AufRver: Sortierte Auftragreihenfolge


n = length(Cs);
AufRver = zeros(1,n);

for i = n:-1:1
    x = find(Cs==max(Cs),1,'last'); % Findet die Stelle, wo das Maximum ist; bei mehrere wird das letzte gewählt
    Cs(x) = -1;                     % Im Nachhinein ist es bei Gleichheit der topologisch erste Auftrag 
    AufRver(i) = AufR(x);
end

end

