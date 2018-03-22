function [ HA ] = Haufigkeit(A)
%
% [HA] = <strong>Haufigkeit</strong>(A)
%
% Berechnet, in wie vielen Aufträgen ein Artikel gebraucht wird.
%
% Parameter:
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten Stückzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   HA: Häufigkeit der Artikel


[m,n] = size(A);
HA = zeros(m,1);

for i = 1:m
    for j = 1:n
        if A(i,j) > 0
            HA(i) = HA(i)+1;
        end
    end
end

end

