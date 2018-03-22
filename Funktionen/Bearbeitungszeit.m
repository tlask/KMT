function [BZ] = Bearbeitungszeit(A,HZ,KZ)
%
% [BZ] = <strong>Bearbeitungszeit</strong>(A,HZ,KZ)
%
% Berechnet die Bearbeitungszeit aller Artikel.
%
% Parameter:
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten Stückzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   HZ: Holzeit [ZE]
%   KZ: Kommissionierzeit [ZE/ME]
%   BZ: Bearbeitungszeit [ZE]


m = length(HZ);
BZ = zeros(m,1);
KZsum = KZ.*sum(A,2); % sum(A,2) bewirkt das gleiche wie sum(A')';

for i = 1:m
    if KZsum(i)==0 %ÜberPrüfung auf Null Zeile
        BZ(i) = 0;
    else
        BZ(i) = HZ(i) + KZsum(i);  
    end
end

end

