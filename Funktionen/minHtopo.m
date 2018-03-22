function [Order] = minHtopo(HA,BZ)
%
% [Order] = <strong>minHtopo</strong>(HA,BZ)
%
% Artikelreihenfolgeverfahren:
%   Anordnung nach minimaler Häufigkeit und topologischer Reihenfolge
%
% Parameter:
%   HA: Haufigkeit der Artikel
%   BZ: Bearbeitungszeit [ZE]
%   Order: Artikelreihenfolge


m = length(BZ);
O1 = zeros(m,1);

for i=m:-1:1
    x = find(HA==max(HA),1,'last');
    O1(i) = x;
    HA(x) = -1;
end

Order = O1;

end