function [Order] = maxHtopo(HA,BZ)
%
% [Order] = <strong>maxHtopo</strong>(HA,BZ)
%
% Artikelreihenfolgeverfahren:
%   Anordnung nach maximaler H�ufigkeit und topologischer Reihenfolge
%
% Parameter:
%   HA: H�ufigkeit der Artikel
%   BZ: Bearbeitungszeit [ZE]
%   Order: Artikelreihenfolge


m = length(BZ);
O1 = zeros(m,1);

for i=1:m
    x = find(HA==max(HA),1,'first');
    O1(i) = x;
    HA(x) = -1;
end

Order = O1;

end

