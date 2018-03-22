function [Order] = zenReihAbst(HA)
% 
% [Order] = <strong>zenReihAbst</strong>(HA)
%
% Artikelsortierungsverfahren: 
%   Anordnung nach zum Zentrum absteigender Häufigkeit
%
% Parameter:
%   HA: Häufigkeit der Artikel
%   Order: Artikelreihenfolge


m = length(HA);

Order = zeros(m,1);

AnzArtikelM1 = floor(m/2);

HA_M1 = HA(1:AnzArtikelM1);
HA_M2 = HA((AnzArtikelM1+1):m);

% Alle Artikel aus der ersten Menge werden absteigend nach der Häufigkeit sortiert
for i = 1:AnzArtikelM1
	x = find(HA_M1==max(HA_M1),1,'first');
    Order(i) = x;
    HA_M1(x) = -1;
end

% Alle Artikel aus der ersten Menge werden aufsteigend nach der Häufigkeit sortiert
for i = m:-1:AnzArtikelM1+1
	x = find(HA_M2==max(HA_M2),1,'last');
    Order(i) = x+AnzArtikelM1;
    HA_M2(x) = -1;
end


end