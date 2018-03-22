function [best,bestOrder,AnzVerg,AnzVerb,AnzNach,ArtikelOrder] = insertDL(StartOrder,A,HZ,KZ,SP,DL,ArtOrder,ZFname,Gewichtung,index)

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
%   best: bester Zielfunktionswert
%   bestOrder: beste Artikelreihenfolge
%   AnzVerg: Anzahl Vergleiche bis beste Lösung
%   AnzVerb: Anzahl Verbeserungen
%   AnzNach: Anzahl Nachbarn

% Hinweis: der Befehl 'break' verlässt die aktuelle for-Schleife. Bei
% verschachtelten for-Schleifen wird nur die innerste for-Schleife
% verlassen

%% Initialisierung

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
AnzVerg = 0; % = -AnzNach;
AnzVerb = 0;

bestOrder = StartOrder;
if isempty(find(e > 0)) % wenn im Vektor der Verspätungen keine Verspätung auftaucht: 
    keineVerbmoegl = true; % keine Verbesserung möglich = true
else
    keineVerbmoegl = false; % keine Verbesserung möglich = false
end

%% Verbesserung

while keineVerbmoegl == false % solange theoretisch noch eine Verbesserung mit dem Verfahren möglich ist...
    
    verbGef = false; % Verbesserung gefunden = false
    AufVersp = find(e ~= 0); % Vektor der Aufträge mit Verspätung. (5,7) bedeutet z.B., dass der 5. und der 7. Auftrag in der Auftragsreihenfolge eine Verspätung hat, NICHT aber dass Auftrag 5 und 7 Verspätung aufweisen!!!
    
    % falls es keine Verspätungen gibt ist auch keine Verbesserung (mehr) möglich
    if isempty(AufVersp) 
        keineVerbmoegl = true;
    end
    
    for i = 1:length(AufVersp) % für jeden Auftrag mit Verspätung führe durch:
        for j = 1:p
            if j == 1
                testOrder = bestOrder;
            end
            if AufVersp(i) - j > 0 % wenn der Auftrag um j nach vorne verschoben werden kann (was z.B. nicht geht, falls der 2. Auftrag eine Verspätung hat und 3 Aufträge nach vorne geschoben werden soll):
                
                % Bestimme die aktuelle testOrder
                testOrder(AufVersp(i) - j) = bestOrder(AufVersp(i));
                testOrder(AufVersp(i) - j + 1) = bestOrder(AufVersp(i) - j);
                
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
                AnzVerg = AnzVerg + 1;
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
                    break % breche den Versuch ab, mit diesem Auftrag eine weitere Verbesserung zu erreichen
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

end