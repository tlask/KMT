function [Z] = FSZ(A,ArtR,BZ)
%
% [Z] = <strong>FSZ</strong>(A,ArtR,BZ)
%
% Zielfunktion ohne Stellplatzbegrenzung:
%   Diese Zielfunktion ist zur Minimierung der summierten 
%   Fertigstellungszeitpunkte der Aufträge.
%
% Parameter:
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten Stückzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   ArtR: Artikelreihenfolge
%   BZ: Bearbeitungszeit [ZE]
%   Z: Zielfunktionswert


Aart = SortArt(A,ArtR);
BZP = SortArt(BZ,ArtR);

k = LetzterArtikel(Aart);

C = Fertigstellungszeitpunkt(BZP,k);

Z = sum(C);

end

