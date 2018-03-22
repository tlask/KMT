function [best,bestOrder,bestAufOrder,AnzVerg,AnzVerb,AnzNach] = D2FSFSZ(StartZ,StartOrder,StartAufOrder,A,BZ,HZ,KZ)
% 
% [best,bestOrder,bestAufOrder,AnzVerg,AnzVerb,AnzNach] = <strong>D2FSFSZ</strong>(StartZ,StartOrder,StartAufOrder,A,BZ,HZ,KZ)
%
% Verbesserungsverfahren für Zielfunktion ohne Stellplatzbegrenzung:
%   Bei dem Verbesserungsverfahren 'Drehung First' werden systematisch zwei
%   Artikel ausgewählt die eine Teilkette bilden. Diese Teilkette wird
%   einmal gedreht, wodurch eine verbesserte Artikelreihenfolge entstehen
%   soll. Da es sich um 'Drehung First' handelt wird die erstbeste
%   Verbesserungen gewählt.
%   Das Verfahren wird auf die Zielfunktion Minimierung der summierten 
%   spezifischen Fertigstellungszeitpunkte der Aufträge angewendet.
%
% Parameter:
%   StartZ: Zu verbessernder Zielfunktionswert
%   StartOrder: Zu verbessernde Artikelreihenfolge
%   StartAufOrder: Zu verbessernde Auftragsreihenfolge
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten Stückzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   BZ: Bearbeitungszeit [ZE]
%   HZ: Holzeit [ZE]
%   KZ: Kommissionierzeit [ZE/ME]
%   best: bester Zielfunktionswert
%   bestOrder: beste Artikelreihenfolge
%   bestAufOrder: beste Auftragsreihenfolge
%   AnzVerg: Anzahl Vergleiche bis beste Lösung
%   AnzVerb: Anzahl Verbeserungen
%   AnzNach: Anzahl Nachbarn


m = size(A,1);

AnzNach = (m*(m-1))/2;
AnzVerg = -AnzNach;
AnzVerb = 0;

best = StartZ;
bestOrder = StartOrder;
bestAufOrder = StartAufOrder;

t1 = 1;
while t1 <= (m-1)
	t2 = t1+1;
    while t2 <= m
        testOrder = bestOrder;
        testOrder(t1:t2) = bestOrder(t2:-1:t1);
        [test,AufOrder] = SFSZ(A,testOrder,bestAufOrder,BZ,HZ,KZ); % neuen Zielfunktionswert berechnen
        AnzVerg = AnzVerg+1;
        if test(2) < best
            bestOrder = testOrder;
            bestAufOrder = AufOrder;
            best = test(2);
            t1 = 1;
            t2 = 1;
            AnzVerb = AnzVerb+1;
        end
        t2 = t2+1;
    end
    t1 = t1+1;
end

end