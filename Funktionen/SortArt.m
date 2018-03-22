function [MP] = SortArt(M,ArtR)
%
% [MP] = <strong>SortArt</strong>(M,ArtR)
%
% Sortiert eine Matrix / einen Vektor nach der Artikelreihenfolge.
%
% Parameter:
%   M: Matrix/Verktor
%   ArtR: Artikelreihenfolge
%   MP: Matrix/Verktor sortiert nach der Artikelreihenfolge


[m,n] = size(M);
MP = zeros(m,n);

for i = 1:m
    MP(i,:) = M(ArtR(i),:);
end

end

