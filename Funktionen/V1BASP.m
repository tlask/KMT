function [best,bestOrder,AnzVerg,AnzVerb,AnzNach] = V1BASP(StartZ,StartOrder,A)
% 
% [best,bestOrder,AnzVerg,AnzVerb,AnzNach] = <strong>V1BASP</strong>(StartZ,StartOrder,A)
%
% Verbesserungsverfahren für Zielfunktion ohne Stellplatzbegrenzung:
%   Bei dem Verbesserungsverfahren '1-Verschieben Best' wird systematisch
%   ein Artikel an die Position eines anderen Artikels verschoben, wodurch 
%   eine verbesserte Artikelreihenfolge entstehen soll. Da es sich um 
%   '1-Verschieben Best' handelt wird die beste aller Verbesserungen gewählt.
%   Das Verfahren wird auf die Zielfunktion Minimierung der Anzahl der 
%   Stellplatze für die Aufträge angewendet.
%
% Parameter:
%   StartZ: Zu verbessernder Zielfunktionswert
%   StartOrder: Zu verbessernde Artikelreihenfolge
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten Stückzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
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
            testOrder(t1:(t2-1)) = bestOrder((t1+1):t2);
            testOrder(t2) = bestOrder(t1);
            test = ASP(A,testOrder); % neuen Zielfunktionswert berechnen
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