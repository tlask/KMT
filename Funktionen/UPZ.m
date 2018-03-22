function [Z] = UPZ(A,ArtR,BZ)
%
% [Z] = <strong>UPZ</strong>(A,ArtR,BZ)
%
% Zielfunktion ohne Stellplatzbegrenzung:
%   Diese Zielfunktion ist zur Minimierung der summierten 
%   Unproduktivzeiten der Aufträge.
%
% Parameter:
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten Stückzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   ArtR: Artikelreihenfolge
%   BZ: Bearbeitungszeit [ZE]
%   Z: Zielfunktionswert


Aart = SortArt(A,ArtR);
BZP = SortArt(BZ,ArtR);

ke = ErsterArtikel(Aart);
kl = LetzterArtikel(Aart);

CU = Unproduktivezeit(Aart,BZP,ke,kl);

Z = sum(CU);

end