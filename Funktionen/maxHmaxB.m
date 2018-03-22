function [Order] = maxHmaxB(HA,BZ)
%
% [Order] = <strong>maxHmaxB</strong>(HA,BZ)
%
% Artikelreihenfolgeverfahren:
%   Anordnung nach maximaler Häufigkeit und maximaler Bearbeitungszeit
%
% Parameter:
%   HA: Häufigkeit der Artikel
%   BZ: Bearbeitungszeit [ZE]
%   Order: Artikelreihenfolge


m = length(BZ);
O1 = zeros(m,1);
O2 = zeros(m,1);

for i = 1:m
    x = find(BZ==max(BZ),1,'first');
    O1(i) = x;
    BZ(x) = -1;
end

Hneu = SortArt(HA,O1);

for i=1:m
    x = find(Hneu==max(Hneu),1,'first');
    O2(i) = x;
    Hneu(x) = -1;
end

Order = SortArt(O1,O2);

end

