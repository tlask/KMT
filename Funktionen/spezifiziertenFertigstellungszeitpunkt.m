function [Cs] = spezifiziertenFertigstellungszeitpunkt(BZP,kauf,Aartauf,HZart,KZart)
%
% [Cs] = <strong>spezifiziertenFertigstellungszeitpunkt</strong>(BZP,kauf,Aartauf,HZart,KZart)
% 
% Ermittelt den spezifischen Fertigstellungszeitpunkt der jeweiligen
% Aufträge.
%
% Parameter:
%   BZP: Nach der Artikelreihefolge sortierte Bearbeitungszeit [ZE]
%   kauf: Reihenfolgeposition
%   Aartauf: Nach der Artikelreihenfolge und der Auftragsreihenfolge
%            sortierte Zuweisungsmatrix
%   HZart: Nach der Artikelreihenfolge sortierte Holzeit [ZE] 
%   KZart: Nach der Artikelreihenfolge sortierte Kommissionierzeit [ZE/ME]
%   Cs: spezifische Fertigstellungszeitpunkte


[m,n] = size(Aartauf);
Cs = zeros(1,n);

for j = 1:m
    for i = 1:n
        if j < kauf(i)
            Cs(i) = Cs(i)+BZP(j);
        end
        if j == kauf(i)
            Cs(i) = Cs(i)+HZart(j)+KZart(j).*sum(Aartauf(j,1:i));
        end
    end
end


end
