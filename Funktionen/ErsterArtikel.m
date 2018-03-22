function [k] = ErsterArtikel(Aart)
%
% [k] = <strong>ErsterArtikel</strong>(Aart)
%
% Ermittelt f�r alle Auftr�ge die Reihenfolgeposition des Artikels, welcher
% den jeweiligen Auftrag er�ffnet.
%
% Parameter:
%   Aart: Zuweisungsmatrix A sortiert nach der Artikelreihenfolge
%   k: Reihenfolgeposition


[m,n] = size(Aart);
k = ones(1,n);

for j = 1:m
    for i = 1:n
        if sum(Aart(1:j,i)) == 0
            k(i) = k(i)+1;
        end
    end
end

end