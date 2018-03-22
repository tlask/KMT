function [AL] = AuftragsLaenge(A)
%
% [AL] = <strong>AuftragsLaenge</strong>(A)
%
% Berechnet die Auftragslänge.
%
% Parameter:
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten Stückzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   AL: Auftragslänge


[m,n] = size(A);
AL = zeros(1,n);

for j = 1:n
    for i = 1:m
        if A(i,j) > 0
            AL(j) = AL(j)+1;
        end
    end
end

end

