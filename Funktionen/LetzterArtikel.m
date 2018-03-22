function [k] = LetzterArtikel(Aart)
%
% [k] = <strong>LetzterArtikel</strong>(Aart)
%
% Ermittelt f�r alle Auftr�ge die Reihenfolgeposition des Artikels, welcher
% den jeweiligen Auftrag abschlie�t.
%
% Parameter:
%   Aart: Zuweisungsmatrix A sortiert nach der Artikelreihenfolge
%   k: Reihenfolgeposition


[m,n] = size(Aart);
k = zeros(1,n);

 for j = 1:m
     for i = 1:n
        if sum(Aart(j:m,i)) > 0
            k(i) = j;
        end
    end
end

end

