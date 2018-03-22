function [Z] = ASP(A,ArtR)
%
% [Z] = <strong>ASP</strong>(A,ArtR)
%
% Zielfunktion ohne Stellplatzbegrenzung:
%   Diese Zielfunktion ist zur Minimierung der Anzahl der Stellplatze f�r 
%   die Auftr�ge.
%
% Parameter:
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten St�ckzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   ArtR: Artikelreihenfolge
%   Z: Zielfunktionswert


m = size(A,1);

Aart = SortArt(A,ArtR);

ke = ErsterArtikel(Aart);
kl = LetzterArtikel(Aart);

CA = AnzahlStellPlaetze(m,ke,kl);

Z = CA;

end


