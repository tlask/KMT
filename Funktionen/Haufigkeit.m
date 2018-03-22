function [ HA ] = Haufigkeit(A)
%
% [HA] = <strong>Haufigkeit</strong>(A)
%
% Berechnet, in wie vielen Auftr�gen ein Artikel gebraucht wird.
%
% Parameter:
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten St�ckzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   HA: H�ufigkeit der Artikel


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

