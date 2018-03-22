function [best,bestOrder,AnzVerg,AnzVerb,AnzNach] = D2BFSZ(StartZ,StartOrder,A,BZ)
% 
% [best,bestOrder,AnzVerg,AnzVerb,AnzNach] = <strong>D2BFSZ</strong>(StartZ,StartOrder,A,BZ)
%
% Verbesserungsverfahren für Zielfunktion ohne Stellplatzbegrenzung:
%   Bei dem Verbesserungsverfahren 'Drehung Best' werden systematisch zwei
%   Artikel ausgewählt die eine Teilkette bilden. Diese Teilkette wird
%   einmal gedreht, wodurch eine verbesserte Artikelreihenfolge entstehen
%   soll. Da es sich um 'Drehung Best' handelt wird die beste aller
%   Verbesserungen gewählt.
%   Das Verfahren wird auf die Zielfunktion Minimierung der summierten 
%   Fertigstellungszeitpunkte der Aufträge angewendet.
%
% Parameter:
%   StartZ: Zu verbessernder Zielfunktionswert
%   StartOrder: Zu verbessernde Artikelreihenfolge
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten Stückzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   BZ: Bearbeitungszeit [ZE]
%   best: bester Zielfunktionswert
%   bestOrder: beste Artikelreihenfolge
%   AnzVerg: Anzahl Vergleiche bis beste Lösung
%   AnzVerb: Anzahl Verbeserungen
%   AnzNach: Anzahl Nachbarn


m = size(A,1);

AnzNach = (m*(m-1))/2;
AnzVerg = -AnzNach;
AnzVerb = 0;

best = StartZ;
bestOrder = StartOrder;

testbest = best;
testbestOrder = bestOrder;

verb = true;

while verb == true
    t1 = 1;
    while t1 <= (m-1)
        t2 = t1+1;
        while t2 <= m
            testOrder = bestOrder;
            testOrder(t1:t2) = bestOrder(t2:-1:t1);
            test = FSZ(A,testOrder,BZ); % neuen Zielfunktionswert berechnen
            AnzVerg = AnzVerg+1;
            if test < testbest
                testbestOrder = testOrder;
                testbest = test;
            end
            t2 = t2+1;
        end
        t1 = t1+1;
    end
    if testbest == best
        verb = false;
    else
        best = testbest;
        bestOrder = testbestOrder;
        AnzVerb = AnzVerb+1;
    end
end

end