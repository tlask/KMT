function [AufOrder] = MinSFSZ(A,HZ,KZ,BZ,ArtOrder)
%
% [AufOrder] = <strong>MinSFSZ</strong>(A,HZ,KZ,BZ,ArtOrder)
%
% Auftragsreihenfolgeverfahren:
%   Anordnung nach aufsteigenden spezifischen Fertigstellungszeitpunkten
%
% Parameter:
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten St�ckzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   HZ: Holzeit [ZE]
%   KZ: Kommissionierzeit [ZE/ME]
%   BZ: Bearbeitungszeit [ZE]
%   ArtOrder: Artikelreihenfolge
%   AufOrder: Auftragsreihenfolge


n = size(A,2);
Aart = SortArt(A,ArtOrder);
BZart = SortArt(BZ,ArtOrder);
HZart = SortArt(HZ,ArtOrder);
KZart = SortArt(KZ,ArtOrder);

k = LetzterArtikel(Aart);


Cs = spezifiziertenFertigstellungszeitpunkt(BZart,k,Aart,HZart,KZart);

AufOrder = Minsort(1:1:n,Cs);

end