function [Z,AufRver] = SFSZ(A,ArtR,AufR,BZ,HZ,KZ)
%
% [Z,AufRver] = <strong>SFSZ</strong>(A,ArtR,AufR,BZ,HZ,KZ)
%
% Zielfunktion ohne Stellplatzbegrenzung:
%   Diese Zielfunktion ist zur Minimierung der summierten spezifischen
%   Fertigstellungszeitpunkte der Aufträge. 
%   Dazu wird die Auftragsreihenfolge angepasst. 
%
% Parameter:
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten Stückzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   ArtR: Artikelreihenfolge
%   AufR: Auftragsreihenfolge
%   BZ: Bearbeitungszeit [ZE]
%   HZ: Holzeit [ZE]
%   KZ: Kommissionierzeit [ZE/ME]
%   Z: Zielfunktionswert
%   AufRver: neue Auftragsreihenfolge


Aart = SortArt(A,ArtR);
BZP = SortArt(BZ,ArtR);
HZart = SortArt(HZ,ArtR);
KZart = SortArt(KZ,ArtR);

k = LetzterArtikel(Aart);

Aartauf = SortAuf(Aart,AufR);

kauf = SortAuf(k,AufR);

Cs = spezifiziertenFertigstellungszeitpunkt(BZP,kauf,Aartauf,HZart,KZart);

Z1 = sum(Cs);


% Verbesserung
AufRver = Minsort(AufR,Cs);

Aartaufver = SortAuf(Aart,AufRver);

kaufver = SortAuf(k,AufRver);

Csver = spezifiziertenFertigstellungszeitpunkt(BZP,kaufver,Aartaufver,HZart,KZart);

Z2 = sum(Csver);



Z = [Z1 Z2];

end
