function [Z] = FF(A,ArtR,BZ)
%
% [Z] = <strong>FF</strong>(A,ArtR,BZ)
%
% Zielfunktion ohne Stellplatzbegrenzung:
%   Diese Zielfunktion ist zur Minimierung des maximalen 
%   Fertigstellungszeitpunktes der Auftr�ge.
%
% Parameter:
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten St�ckzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   ArtR: Artikelreihenfolge
%   BZ: Bearbeitungszeit [ZE]
%   Z: Zielfunktionswert



BZP = SortArt(BZ,ArtR);

% Aart = SortArt(A,ArtR);
% k = LetzterArtikel(Aart);
% C = Fertigstellungszeitpunkt(BZP,k);
% Z = max(C);

% max(C) ist das gleiche wie sum(BZP)
% Somit ist die Artikelreihenfolge irrelevant
% und statt der oberen 4 Zielen gen�gt die folgende:

Z = sum(BZP);

end