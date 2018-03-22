function [Z] = MUPZ(A,ArtR,BZ)
%
% [Z] = <strong>MUPZ</strong>(A,ArtR,BZ)
%
% Zielfunktion ohne Stellplatzbegrenzung:
%   Diese Zielfunktion ist zur Minimierung der maximalen 
%   Unproduktivzeit der Auftr�ge.
%
% Parameter:
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten St�ckzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   ArtR: Artikelreihenfolge
%   BZ: Bearbeitungszeit [ZE]
%   Z: Zielfunktionswert


Aart = SortArt(A,ArtR);
BZP = SortArt(BZ,ArtR);

ke = ErsterArtikel(Aart);
kl = LetzterArtikel( Aart);

CU = Unproduktivezeit(Aart,BZP,ke,kl);

Z = max(CU);

end