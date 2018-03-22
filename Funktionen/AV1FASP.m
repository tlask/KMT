function [best,Abbruchbed,bestOrder,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AV1FASP(StartZ,StartOrder,A,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent_A2,Ab_prozent_A3,Ab_verg)
% 
% [best,Abbruchbed,bestOrder,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = <strong>AV1FASP</strong>(StartZ,StartOrder,A,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent_A2,Ab_prozent_A3,Ab_verg)
%
% Verbesserungsverfahren f�r Zielfunktion ohne Stellplatzbegrenzung:
%   Bei dem Verbesserungsverfahren '1-Verschieben First' wird systematisch
%   ein Artikel an die Position eines anderen Artikels verschoben, wodurch 
%   eine verbesserte Artikelreihenfolge entstehen soll. Da es sich um 
%   '1-Verschieben First' handelt wird die erstbeste Verbesserungen gew�hlt.
%   Das Verfahren wird auf die Zielfunktion Minimierung der Anzahl der 
%   Stellplatze f�r die Auftr�ge angewendet.
%   Au�erdem gibt es bis zu drei zus�tzliche Abbruchbedingungen. Die erste
%   Abbruchbedingung lautet, dass eine maximale Rechenzeit nicht
%   �berschritten werden soll. Die zweite Abbruchbedingung gibt an, dass
%   dieses Verfahren eine bestimmte relative Verbesserung zum
%   urspr�nglichen Zielfunktionswert erreichen soll und dann abbricht. Die
%   letzte Bedingung f�hrt zum Abbruch des Verfahrens, wenn der
%   Zielfunktionswert sich innerhalb einer vorgegebenen Anzahl von
%   Vergleichen um weniger als einen bestimmten Wert verbessert.
%
% Parameter:
%   StartZ: Zu verbessernder Zielfunktionswert
%   StartOrder: Zu verbessernde Artikelreihenfolge
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten St�ckzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   Abbruchbed1: bool f�r die erste Abbruchbedingung
%                -> Rechenzeit
%   Abbruchbed2: bool f�r die zweite Abbruchbedingung
%                -> Verbesserung um Ab_prozent_A2 von der Startl�sung
%   Abbruchbed3: bool f�r die dritte Abbruchbedingung
%                -> Verbesserung um Ab_prozent_A3 von der Startl�sung 
%                   innerhalb von Ab_verg Vergleichen
%   Ab_zeit: maximale Rechenzeit
%   Ab_prozent_A2: relative Verbesserung von der Startl�sung zur
%                  gew�nschten L�sung
%   Ab_prozent_A3: relative Verbesserung innerhalb der letzten
%                  Ab_verg Vergleiche
%   Ab_verg: maximale Anzahl Vergleiche 
%   best: bester Zielfunktionswert
%   Abbruchbed: gibt an, bei welcher Abbruchbedingung das Verfahren
%               abgebrochen ist
%   bestOrder: beste Artikelreihenfolge
%   AnzVergIns: Anzahl Vergleiche insgesamt
%   AnzVergBest: Anzahl Vergleiche bis zur besten L�sung
%   AnzVerb: Anzahl Verbeserungen
%   AnzNach: Anzahl Nachbarn


tic;
 
m = size(A,1);

AnzNach = (m*(m-1))/2;
AnzVergBest = 0; % Anzahl Vergleiche bis die beste L�sung gefunden wurde
AnzVergHelp = 0; % Anzahl der Vergleiche von der bisher besten L�sung bis zur aktuellen L�sung
AnzVerb = 0;

best = StartZ;
bestOrder = StartOrder;
 
Abbruchbed = 0; % Das Verfahren wurde durch keine Abbruchbedingung gestoppt
 
% F�r die erste Abbruchbedingung
if Abbruchbed1 == true
    Ab_zeit_sek = Ab_zeit*60; % Rechenzeit wurde in Minuten eingegeben aber in Sekunden gemessen
end
zeit = 0; % Aktuell ben�tigte Rechenzeit
% F�r die zweite Abbruchbedingung
AnzVergIns = 0; % Anzahl Vergleiche die das Verfahren insgesamt macht
RelProzent_A2 = 100 * ((StartZ-best) / best); % Relative Verbesserung von der Startl�sung zum aktuellen Wert
% F�r die dritte Abbruchbedingung
if Abbruchbed3 == true
    ZVerg = StartZ*ones(Ab_verg,1); % Zielfunktionswerte des letzten Vergleiche
    RelProzent_A3 = 100 * ((ZVerg(1)-ZVerg(end)) / ZVerg(end)); % Relative Verbesserung innerhlab der letzten Vergleiche
end

t1 = 1;
while t1 <= (m-1)
    % Abbruchbedingungen
    zeit = zeit + toc;
    tic;
    if Abbruchbed1 == true && zeit >= Ab_zeit_sek
        Abbruchbed = 1;
        zeit = zeit + toc;
        return % Aus der Funktion springen
    end
    if Abbruchbed2 == true && RelProzent_A2 >= Ab_prozent_A2
        Abbruchbed = 2;
        zeit = zeit + toc;
        return % Aus der Funktion springen
    end
    if Abbruchbed3 == true && (AnzVergIns >= Ab_verg && RelProzent_A3 < Ab_prozent_A3) 
        Abbruchbed = 3;
        zeit = zeit + toc;
        return % Aus der Funktion springen
    end
 
	t2 = t1+1;
    
    while t2 <= m
        % Abbruchbedingungen
        zeit = zeit + toc;
        tic;
        if Abbruchbed1 == true && zeit >= Ab_zeit_sek
            Abbruchbed = 1;
            zeit = zeit + toc;
            return % Aus der Funktion springen
        end
        if Abbruchbed2 == true && RelProzent_A2 >= Ab_prozent_A2
            Abbruchbed = 2;
            zeit = zeit + toc;
            return % Aus der Funktion springen
        end
        if Abbruchbed3 == true && (AnzVergIns >= Ab_verg && RelProzent_A3 < Ab_prozent_A3) 
            Abbruchbed = 3;
            zeit = zeit + toc;
            return % Aus der Funktion springen
        end
        
    	testOrder = bestOrder;
        testOrder(t1:(t2-1)) = bestOrder((t1+1):t2);
        testOrder(t2) = bestOrder(t1);
        test = ASP(A,testOrder); % neuen Zielfunktionswert berechnen
        AnzVergHelp = AnzVergHelp+1;
        AnzVergIns = AnzVergIns+1;
        if test < best
            bestOrder = testOrder;
            best = test;
            t1 = 1;
            t2 = 1;
            AnzVerb = AnzVerb+1;
            RelProzent_A2 = 100 * ((StartZ-best) / best); % aktualisieren
            AnzVergBest = AnzVergBest + AnzVergHelp - 1; % -1 wegen dem aktuellen Vergleich
            AnzVergHelp = 1;
        end
        if Abbruchbed3 == true
            ZVerg = [ZVerg(2:end) ; best]; % Zielfunktionswerte anpassen
            RelProzent_A3 = 100 * ((ZVerg(1)-ZVerg(end)) / ZVerg(end)); % aktualisieren
        end
        t2 = t2+1;
    end
    t1 = t1+1;
end
 
zeit = zeit + toc; %#ok<*NASGU>

end