function [best,Abbruchbed,bestOrder,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,ArtikelOrder,zeit] = insertDLA(StartOrder,A,HZ,KZ,SP,DL,ArtOrder,ZFname,Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl,index)

% [best,bestOrder,AnzVerg,AnzVerb,AnzNach] = <strong>T2FFSZ</strong>(StartZ,StartOrder,A,BZ)
%
% Verbesserungsverfahren für Zielfunktion mit Stellplatzbegrenzung und Deadline:
%
% Parameter:
%   StartZ: Zu verbessernder Zielfunktionswert
%   StartOrder: Zu verbessernde Auftragsreihenfolge
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten Stückzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   BZ: Bearbeitungszeit [ZE]
%   DL: Deadline
%   ZFname: Name der Zielfunktion, auf die 'insertDL' angewendet werden
%   soll
%   Abbruchbed1: bool für die erste Abbruchbedingung
%                -> Rechenzeit
%   Abbruchbed2: bool für die zweite Abbruchbedingung
%                -> Verbesserung um Ab_prozent_A2 von der Startlösung
%   Abbruchbed3: bool für die dritte Abbruchbedingung
%                -> Verbesserung um Ab_prozent_A3 von der Startlösung 
%                   innerhalb von Ab_verg Vergleichen
%   Ab_zeit: maximale Rechenzeit
%   Ab_prozent_A2: relative Verbesserung von der Startlösung zur
%                  gewünschten Lösung
%   Ab_prozent_A3: relative Verbesserung innerhalb der letzten
%                  Ab_verg Vergleiche
%   Ab_verg: maximale Anzahl Vergleiche 
%   best: bester Zielfunktionswert
%   Abbruchbed: gibt an, bei welcher Abbruchbedingung das Verfahren
%               abgebrochen ist
%   best: bester Zielfunktionswert
%   bestOrder: beste Artikelreihenfolge
%   AnzVerg: Anzahl Vergleiche bis beste Lösung
%   AnzVerb: Anzahl Verbeserungen
%   AnzNach: Anzahl Nachbarn

% Hinweis: der Befehl 'break' verlässt die aktuelle for-Schleife. Bei
% verschachtelten for-Schleifen wird nur die innerste for-Schleife
% verlassen

%% Initialisierung

tic;

n = size(A,2);
p = 2; % gibt an, wie oft pro Auftrag mit Verspätung versucht werden soll, diesen weiter vorne in der Auftragsreihenfolge einzufügen

switch ZFname
case 'FSZbS'
        [best,ArtikelOrder,C] = FSZbS(A,HZ,KZ,SP,ArtOrder,StartOrder);
        e = C - DL';
    case 'FSZbSR'
        [best,ArtikelOrder,C] = FSZbSR(A,HZ,KZ,SP,ArtOrder,StartOrder);
        e = C - DL';
    case 'FFbS'
        [best,ArtikelOrder,C] = FFbS(A,HZ,KZ,SP,ArtOrder,StartOrder);
        e = C - DL';
    case 'FFbSR'
        [best,ArtikelOrder,C] = FFbSR(A,HZ,KZ,SP,ArtOrder,StartOrder);
        e = C - DL';
    case 'DLZbS'
        [best,ArtikelOrder,C] = DLZbS(A,HZ,KZ,SP,ArtOrder,StartOrder);
        e = C - DL';
    case 'DLZbSR'
        [best,ArtikelOrder,C] = DLZbSR(A,HZ,KZ,SP,ArtOrder,StartOrder);
        e = C - DL';
    case 'AUFbS'
        [best,ArtikelOrder,e] = AUFbS(A,HZ,KZ,SP,DL,ArtOrder,StartOrder);
    case 'AUFbSR'
        [best,ArtikelOrder,e] = AUFbSR(A,HZ,KZ,SP,DL,ArtOrder,StartOrder);
    case 'AUFbSD'
        [best,ArtikelOrder,e] = AUFbSD(A,HZ,KZ,SP,DL,ArtOrder,StartOrder,index);
    case 'UdFbS'
        [best,ArtikelOrder,e] = UdFbS(A,HZ,KZ,SP,DL,ArtOrder,StartOrder);
    case 'UdFbSR' 
        [best,ArtikelOrder,e] = UdFbSR(A,HZ,KZ,SP,DL,ArtOrder,StartOrder);
    case 'UdFbSD' 
        [best,ArtikelOrder,e] = UdFbSD(A,HZ,KZ,SP,DL,ArtOrder,StartOrder,index);
    case 'sUFbS'
        [best,ArtikelOrder,e] = sUFbS(A,HZ,KZ,SP,DL,ArtOrder,StartOrder);
    case 'sUFbSR'
        [best,ArtikelOrder,e] = sUFbSR(A,HZ,KZ,SP,DL,ArtOrder,StartOrder);
    case 'sUFbSD'
        [best,ArtikelOrder,e] = sUFbSD(A,HZ,KZ,SP,DL,ArtOrder,StartOrder,index);
    case 'dUFbS'
        [best,ArtikelOrder,e] = dUFbS(A,HZ,KZ,SP,DL,ArtOrder,StartOrder);
    case 'dUFbSR'
        [best,ArtikelOrder,e] = dUFbSR(A,HZ,KZ,SP,DL,ArtOrder,StartOrder);
    case 'dUFbSD'
        [best,ArtikelOrder,e] = dUFbSD(A,HZ,KZ,SP,DL,ArtOrder,StartOrder,index);
    case 'gUFbS'
        [best,ArtikelOrder,e] = gUFbS(A,HZ,KZ,SP,DL,ArtOrder,StartOrder,Gewichtung);
    case 'gUFbSR'
        [best,ArtikelOrder,e] = gUFbSR(A,HZ,KZ,SP,DL,ArtOrder,StartOrder,Gewichtung);
    case 'gUFbSD'
        [best,ArtikelOrder,e] = gUFbSD(A,HZ,KZ,SP,DL,ArtOrder,StartOrder,Gewichtung,index);
end
e(find(e < 0)) = 0;
e = SortAuf(e,StartOrder);

AnzNach = (n*(n-1))/2;
AnzVergBest = 0; % Anzahl Vergleiche bis die beste Lösung gefunden wurde
AnzVergHelp = 0; % Anzahl der Vergleiche von der bisher besten Lösung bis zur aktuellen Lösung
AnzVerb = 0;
StartZ = best;

bestOrder = StartOrder;
if isempty(find(e > 0,1)) % wenn im Vektor der Verspätungen keine Verspätung auftaucht: 
    keineVerbmoegl = true; % keine Verbesserung möglich = true
else
    keineVerbmoegl = false; % keine Verbesserung möglich = false
end

Abbruchbed = 0; % Das Verfahren wurde durch keine Abbruchbedingung gestoppt

% Für die erste Abbruchbedingung
if Abbruchbed1 == true
    Ab_zeit_sek = Ab_zeit*60; % Rechenzeit wurde in Minuten eingegeben aber in Sekunden gemessen
end
zeit = 0; % Aktuell benötigte Rechenzeit
% Für die zweite Abbruchbedingung
AnzVergIns = 0; % Anzahl Vergleiche die das Verfahren insgesamt macht
RelProzent_A2 = 100 * ((StartZ-best) / StartZ); % Relative Verbesserung (aktueller Wert / Startlösung)
% Für die dritte Abbruchbedingung
if Abbruchbed3 == true
    ZVerg = StartZ*ones(Ab_vergl,1); % Zielfunktionswerte des letzten Vergleiche
    RelProzent_A3 = 100 * ((ZVerg(1)-ZVerg(end)) / ZVerg(end)); % Relative Verbesserung innerhlab der letzten Vergleiche
end

%% Verbesserung

while keineVerbmoegl == false % solange theoretisch noch eine Verbesserung mit dem Verfahren möglich ist...
    
    % Abbruchbedingungen
    zeit = zeit + toc;
    tic;
    if Abbruchbed1 == true && zeit >= Ab_zeit_sek
        Abbruchbed = 1;
        zeit = zeit + toc;
        return % Aus der Funktion springen
    end
    if Abbruchbed2 == true && RelProzent_A2 >= Ab_prozent2
        Abbruchbed = 2;
        zeit = zeit + toc;
        return % Aus der Funktion springen
    end
    if Abbruchbed3 == true && (AnzVergIns >= Ab_vergl && RelProzent_A3 < Ab_prozent3) 
        Abbruchbed = 3;
        zeit = zeit + toc(timer);
        return % Aus der Funktion springen
    end
    
    verbGef = false; % Verbesserung gefunden = false
    AufVersp = find(e ~= 0); % Vektor der Aufträge mit Verspätung. (5,7) bedeutet z.B., dass der 5. und der 7. Auftrag in der Auftragsreihenfolge eine Verspätung hat, NICHT aber dass Auftrag 5 und 7 Verspätung aufweisen!!!
    
    % falls es keine Verspätungen gibt ist auch keine Verbesserung (mehr) möglich
    if isempty(AufVersp) 
        keineVerbmoegl = true;
    end
    
    for i = 1:length(AufVersp) % für jeden Auftrag mit Verspätung führe durch:
        for j = 1:p
            
                % Abbruchbedingungen
                zeit = zeit + toc;
                tic;
                if Abbruchbed1 == true && zeit >= Ab_zeit_sek
                    Abbruchbed = 1;
                    zeit = zeit + toc;
                    return % Aus der Funktion springen
                end
                if Abbruchbed2 == true && RelProzent_A2 >= Ab_prozent2
                    Abbruchbed = 2;
                    zeit = zeit + toc;
                    return % Aus der Funktion springen
                end
                if Abbruchbed3 == true && (AnzVergIns >= Ab_vergl && RelProzent_A3 < Ab_prozent3) 
                    Abbruchbed = 3;
                    zeit = zeit + toc;
                    return % Aus der Funktion springen
                end
            
            testOrder = bestOrder;
            if AufVersp(i) - j > 0 % wenn der Auftrag um j nach vorne verschoben werden kann (was z.B. nicht geht, falls der 2. Auftrag eine Verspätung hat und 3 Aufträge nach vorne geschoben werden soll):
                
                % Bestimme die aktuelle testOrder
                testOrder(AufVersp(i) - j) = bestOrder(AufVersp(i)); % schiebe den Auftrag mit Verspätug j Felder nach vorne
                for k = 1:j 
                    testOrder(AufVersp(i) - j + k) = bestOrder(AufVersp(i) - j + k - 1); % auf die Felder nach dem Feld, auf dem jetzt der Auftrag mit Verspätung steht, stelle die Aufträge, die bis jetzt auf dem jeweiligen Feld davor standen. (blaa= bla+k ;blaaa = blaa-1)
                end
                
                % Berechne den Zielfunktionswert der aktuellen testOrder
                switch ZFname
                   case 'FSZbS'
                        [testZ,testArtOrder,testC] = FSZbS(A,HZ,KZ,SP,ArtOrder,testOrder);
                        testE = testC - DL';
                    case 'FSZbSR'
                        [testZ,testArtOrder,testC] = FSZbSR(A,HZ,KZ,SP,ArtOrder,testOrder);
                        testE = testC - DL';
                    case 'FFbS'
                        [testZ,testArtOrder,testC] = FFbS(A,HZ,KZ,SP,ArtOrder,testOrder);
                        testE = testC - DL';
                    case 'FFbSR'
                        [testZ,testArtOrder,testC] = FFbSR(A,HZ,KZ,SP,ArtOrder,testOrder);
                        testE = testC - DL';
                    case 'DLZbS'
                        [testZ,testArtOrder,testC] = DLZbS(A,HZ,KZ,SP,ArtOrder,testOrder);
                        testE = testC - DL';
                    case 'DLZbSR'
                        [testZ,testArtOrder,testC] = DLZbSR(A,HZ,KZ,SP,ArtOrder,testOrder);
                        testE = testC - DL';
                    case 'AUFbS'
                        [testZ,testArtOrder,testE] = AUFbS(A,HZ,KZ,SP,DL,ArtOrder,testOrder);
                    case 'AUFbSR'
                        [testZ,testArtOrder,testE] = AUFbSR(A,HZ,KZ,SP,DL,ArtOrder,testOrder);
                    case 'AUFbSD'
                        [testZ,testArtOrder,testE] = AUFbSD(A,HZ,KZ,SP,DL,ArtOrder,testOrder,index);
                    case 'UdFbS'
                        [testZ,testArtOrder,testE] = UdFbS(A,HZ,KZ,SP,DL,ArtOrder,testOrder);
                    case 'UdFbSR' 
                        [testZ,testArtOrder,testE] = UdFbSR(A,HZ,KZ,SP,DL,ArtOrder,testOrder);
                    case 'UdFbSD' 
                        [testZ,testArtOrder,testE] = UdFbSD(A,HZ,KZ,SP,DL,ArtOrder,testOrder,index);
                    case 'sUFbS'
                        [testZ,testArtOrder,testE] = sUFbS(A,HZ,KZ,SP,DL,ArtOrder,testOrder);
                    case 'sUFbSR'
                        [testZ,testArtOrder,testE] = sUFbSR(A,HZ,KZ,SP,DL,ArtOrder,testOrder);
                     case 'sUFbSD'
                        [testZ,testArtOrder,testE] = sUFbSD(A,HZ,KZ,SP,DL,ArtOrder,testOrder,index);
                    case 'dUFbS'
                        [testZ,testArtOrder,testE] = dUFbS(A,HZ,KZ,SP,DL,ArtOrder,testOrder);
                    case 'dUFbSR'
                        [testZ,testArtOrder,testE] = dUFbSR(A,HZ,KZ,SP,DL,ArtOrder,testOrder);
                    case 'dUFbSD'
                        [testZ,testArtOrder,testE] = dUFbSD(A,HZ,KZ,SP,DL,ArtOrder,testOrder,index);
                    case 'gUFbS'
                        [testZ,testArtOrder,testE] = gUFbS(A,HZ,KZ,SP,DL,ArtOrder,testOrder,Gewichtung);
                    case 'gUFbSR'
                        [testZ,testArtOrder,testE] = gUFbSR(A,HZ,KZ,SP,DL,ArtOrder,testOrder,Gewichtung);
                    case 'gUFbSD'
                        [testZ,testArtOrder,testE] = gUFbSD(A,HZ,KZ,SP,DL,ArtOrder,testOrder,Gewichtung,index);
                end

                % Vergleiche, ob der Zielfunktionswert der testOrder besser
                % ist als der bisher Beste:
                AnzVergHelp = AnzVergHelp+1;
                AnzVergIns = AnzVergIns+1;
                if testZ < best
                    best = testZ;
                    testE(find(testE < 0)) = 0;
                    testE = SortAuf(testE,testOrder);
                    e = testE;
                    bestOrder = testOrder;
                    ArtikelOrder = testArtOrder;
                    AnzVerb = AnzVerb + 1;
                    verbGef = true;
                    if best == 0 % falls das neue best einen Zielfunktionswert von 0 hat, ist die 'optimale' Lösung gefunden worden und keine weitere Verbesserung möglich.
                        keineVerbmoegl = true;
                    end
                    
                    % Abbruchbedingungen
                    RelProzent_A2 = 100 * ((StartZ-best) / StartZ); % aktualisieren
                    AnzVergBest = AnzVergBest + AnzVergHelp - 1; % -1 wegen dem aktuellen Vergleich
                    AnzVergHelp = 1;
                    if Abbruchbed3 == true
                        ZVerg = [ZVerg(2:end) ; best]; % Zielfunktionswerte anpassen            
                        RelProzent_A3 = 100 * ((ZVerg(1)-ZVerg(end)) / ZVerg(1)); % aktualisieren
                    end
                    
                    % breche den Versuch ab, mit diesem Auftrag eine
                    % weitere Verbesserung zu erreichen:
                    break 
                end
            else % wenn der Auftrag nicht um j nach vorne verschoben werden kann (z.B. wenn der 2. Auftrag eine Verspätung hat und 3 Aufträge nach vorne geschoben werden soll)...
                break % breche den Versuch ab, diesen Auftrag zu verbessern und mache mit dem nächsten weiter (i wird um 1 erhöht)
            end
        end
        
        % falls eine Verbesserung gefunden wurde, fange von vorne an
        if verbGef 
            break
        end
        
        % falls alle Aufträge mit Verspätung erfolglos verbessert wurden,
        % ist mit diesem Verfahren keine Verbesserung möglich
        if i == length(AufVersp) 
            keineVerbmoegl = true;
        end
        
    end % end von for
    
end % end von while

zeit = zeit + toc; %#ok<*NASGU>

end