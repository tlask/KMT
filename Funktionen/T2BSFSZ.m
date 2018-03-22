function [best,bestOrder,bestAufOrder,AnzVerg,AnzVerb,AnzNach] = T2BSFSZ(StartZ,StartOrder,StartAufOrder,A,BZ,HZ,KZ)
% 
% [best,bestOrder,bestAufOrder,AnzVerg,AnzVerb,AnzNach] = <strong>T2BSFSZ</strong>(StartZ,StartOrder,StartAufOrder,A,BZ,HZ,KZ)
%
% Verbesserungsverfahren f�r Zielfunktion ohne Stellplatzbegrenzung:
%   Bei dem Verbesserungsverfahren '2-Tausch Best' werden systematisch zwei
%   Artikel miteinander vertauscht, wodurch eine verbesserte 
%   Artikelreihenfolge entstehen soll. Da es sich um '2-Tausch Best' 
%   handelt wird die beste aller Verbesserungen gew�hlt.
%   Das Verfahren wird auf die Zielfunktion Minimierung der summierten 
%   spezifischen Fertigstellungszeitpunkte der Auftr�ge angewendet.
%
% Parameter:
%   StartZ: Zu verbessernder Zielfunktionswert
%   StartOrder: Zu verbessernde Artikelreihenfolge
%   StartAufOrder: Zu verbessernde Auftragsreihenfolge
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten St�ckzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   BZ: Bearbeitungszeit [ZE]
%   HZ: Holzeit [ZE]
%   KZ: Kommissionierzeit [ZE/ME]
%   best: bester Zielfunktionswert
%   bestOrder: beste Artikelreihenfolge
%   bestAufOrder: beste Auftragsreihenfolge
%   AnzVerg: Anzahl Vergleiche bis beste L�sung
%   AnzVerb: Anzahl Verbeserungen
%   AnzNach: Anzahl Nachbarn


m = size(A,1);

AnzNach = (m*(m-1))/2;
AnzVerg = -AnzNach;
AnzVerb = 0;

best = StartZ;
bestOrder = StartOrder;
bestAufOrder = StartAufOrder;

testbest = best;
testbestOrder = bestOrder;
testbestAufOrder = bestAufOrder;

verb = true;

while verb == true
    t1 = 1;
    while t1 <= (m-1)
        t2 = t1+1;
        while t2 <= m
            testOrder = bestOrder;
            testOrder(t1) = bestOrder(t2);
            testOrder(t2) = bestOrder(t1);
            [test,testAufOrder] = SFSZ(A,testOrder,bestAufOrder,BZ,HZ,KZ); % neuen Zielfunktionswert berechnen
            AnzVerg = AnzVerg+1;
            if test(2) < testbest
                testbestOrder = testOrder;
                testbestAufOrder = testAufOrder;
                testbest = test(2);
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
        bestAufOrder = testbestAufOrder;
        AnzVerb = AnzVerb+1;
    end
end

end
