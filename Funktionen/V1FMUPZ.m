function [best,bestOrder,AnzVerg,AnzVerb,AnzNach] = V1FMUPZ(StartZ,StartOrder,A,BZ)
% 
% [best,bestOrder,AnzVerg,AnzVerb,AnzNach] = <strong>V1FMUPZ</strong>(StartZ,StartOrder,A,BZ)
%
% Verbesserungsverfahren f�r Zielfunktion ohne Stellplatzbegrenzung:
%   Bei dem Verbesserungsverfahren '1-Verschieben First' wird systematisch
%   ein Artikel an die Position eines anderen Artikels verschoben, wodurch 
%   eine verbesserte Artikelreihenfolge entstehen soll. Da es sich um 
%   '1-Verschieben First' handelt wird die erstbeste Verbesserungen gew�hlt.
%   Das Verfahren wird auf die Zielfunktion Minimierung der maximalen 
%   Unproduktivzeit der Auftr�ge angewendet.
%
% Parameter:
%   StartZ: Zu verbessernder Zielfunktionswert
%   StartOrder: Zu verbessernde Artikelreihenfolge
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten St�ckzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   BZ: Bearbeitungszeit [ZE]
%   best: bester Zielfunktionswert
%   bestOrder: beste Artikelreihenfolge
%   AnzVerg: Anzahl Vergleiche bis beste L�sung
%   AnzVerb: Anzahl Verbeserungen
%   AnzNach: Anzahl Nachbarn


m = size(A,1);

AnzNach = (m*(m-1))/2;
AnzVerg = -AnzNach;
AnzVerb = 0;

best = StartZ;
bestOrder = StartOrder;

t1 = 1;
while t1 <= (m-1)
    t2 = t1+1;
    while t2 <= m
        testOrder = bestOrder;
        testOrder(t1:(t2-1)) = bestOrder((t1+1):t2);
        testOrder(t2) = bestOrder(t1);
        test = MUPZ(A,testOrder,BZ); % neuen Zielfunktionswert berechnen
        AnzVerg = AnzVerg+1;
        if test < best
            bestOrder = testOrder;
            best = test;
            t1 = 1;
            t2 = 1;
            AnzVerb = AnzVerb+1;
        end
        t2 = t2+1;
    end
    t1 = t1+1;
end
    
end