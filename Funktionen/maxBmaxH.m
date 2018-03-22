function [Order] = maxBmaxH(HA,BZ)
%
% [Order] = <strong>maxBmaxH</strong>(HA,BZ)
%
% Artikelreihenfolgeverfahren:
%   Anordnung nach maximaler Bearbeitungszeit und maximaler Häufigkeit
%
% Parameter:
%   HA: Häufigkeit der Artikel
%   BZ: Bearbeitungszeit [ZE]
%   Order: Artikelreihenfolge


m = length(BZ);
O1 = zeros(m,1);
O2 = zeros(m,1);

for i = 1:m
    x = find(HA==max(HA),1,'first');
    O1(i) = x;
    HA(x) = -1;
end

BZneu = SortArt(BZ,O1);

for i = 1:m
    x = find(BZneu==max(BZneu),1,'first');
    O2(i) = x;
    BZneu(x) = -1;
end

Order = SortArt(O1,O2);

end

