function [best,bestOrder,AnzVerg,AnzVerb,AnzNach,ArtikelOrder] = tauschLite(StartOrder,A,HZ,KZ,SP,DL,ArtOrder,ZFname,Gewichtung,index)

% [best,bestOrder,AnzVerg,AnzVerb,AnzNach] = <strong>T2FFSZ</strong>(StartZ,StartOrder,A,BZ)
%
% Verbesserungsverfahren f�r Zielfunktion mit Stellplatzbegrenzung und Deadline:
%
% Parameter:
%   StartZ: Zu verbessernder Zielfunktionswert
%   StartOrder: Zu verbessernde Auftragsreihenfolge
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten St�ckzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   BZ: Bearbeitungszeit [ZE]
%   DL: Deadline
%   ZFname: Name der Zielfunktion, auf die 'insertDL' angewendet werden
%   soll
%   best: bester Zielfunktionswert
%   bestOrder: beste Artikelreihenfolge
%   AnzVerg: Anzahl Vergleiche bis beste L�sung
%   AnzVerb: Anzahl Verbeserungen
%   AnzNach: Anzahl Nachbarn

% Hinweis: der Befehl 'break' verl�sst die aktuelle for-Schleife. Bei
% verschachtelten for-Schleifen wird nur die innerste for-Schleife
% verlassen

%% Initialisierung

n = size(A,2);
p = 2; % gibt an, wie oft pro Auftrag mit Versp�tung versucht werden soll, diesen weiter vorne in der Auftragsreihenfolge einzuf�gen
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
% Berechne die Pufferzeit (slack-time = st = DL - C):
st = -e;
st(find(st < 0)) = 0;
st = SortAuf(st,StartOrder);

% Bestimme die Versp�tungen der Auftr�ge e: 
e = SortAuf(e,StartOrder);
e(find(e < 0)) = 0;

AnzNach = (n*(n-1))/2;
AnzVerg = 0;
AnzVerb = 0;

bestOrder = StartOrder;
if isempty(find(e > 0,1)) % wenn im Vektor der Versp�tungen keine Versp�tung auftaucht: 
    keineVerbmoegl = true; % keine Verbesserung m�glich = true
else
    keineVerbmoegl = false; % keine Verbesserung m�glich = false
end

%% Verbesserung

while keineVerbmoegl == false % solange theoretisch noch eine Verbesserung mit dem Verfahren m�glich ist...
    
    verbGef = false; % Verbesserung gefunden = false
    AufVersp = find(e ~= 0); % Vektor der Auftr�ge mit Versp�tung. (5,7) bedeutet z.B., dass der 5. und der 7. Auftrag in der Auftragsreihenfolge eine Versp�tung hat, NICHT aber dass Auftrag 5 und 7 Versp�tung aufweisen!!!
    
    
    % falls es keine Versp�tungen gibt ist auch keine Verbesserung (mehr) m�glich
    if isempty(AufVersp) 
        keineVerbmoegl = true;
    end
    
    for i = 1:length(AufVersp) % f�r jeden Auftrag mit Versp�tung f�hre durch:
        
        %testOrder = bestOrder;
        % Bestimme die Pufferzeit der Auftr�ge, die in der 
        % Auftragsreihenfolge VOR dem aktuellen Auftrag stehen. W�hle p 
        % Auftr�ge mit den gr��ten Pufferzeiten aus und bestimme deren
        % Position in der Auftragsreihenfolge best.
        tempST = st(1:AufVersp(i)-1);
        for j = 1:p
            if length(tempST)>=j
            
                testOrder = bestOrder;
                kandidatPos = find(tempST == max(tempST),1,'first');
                tempST(kandidatPos) = -Inf;
                testOrder(kandidatPos) = bestOrder(AufVersp(i));
                testOrder(AufVersp(i)) = bestOrder(kandidatPos);

                % berechne den Zielfunktionswert von testOrder:
                % (und als Zusatz die dazugeh�rige Artikelreihenfolge 
                % 'testArtOrder' und den Vektor der �berschreitungen der 
                % Deadlines 'testE')
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
                    % bestimme den neuen Pufferzeit-Vektor
                    st = -testE;
                    st(find(st < 0)) = 0;
                    st = SortAuf(st,testOrder);
                    
                    % bestimme den neuen Vektor der Deadline-�berschreitung
                    testE(find(testE < 0)) = 0;
                    testE = SortAuf(testE,testOrder);
                    e = testE;
                    
                    best = testZ;
                    bestOrder = testOrder;
                    ArtikelOrder = testArtOrder;
                    AnzVerb = AnzVerb + 1;
                    verbGef = true;
                    
                    % falls das neue best einen Zielfunktionswert von 0 hat
                    % ist eine 'optimale' L�sung gefunden worden und keine 
                    % weitere Verbesserung m�glich:
                    if best == 0 
                        keineVerbmoegl = true;
                    end
                    
                    % breche den Versuch ab, mit diesem Auftrag noch eine
                    % Verbesserung zu erreichen:
                    break % verl�sst die aktuelle for-Schleife
                    
                end
            end
        end
        
        % falls eine Verbesserung gefunden wurde, fange von vorne an
        if verbGef 
            break
        end
        
        % falls alle Auftr�ge mit Versp�tung erfolglos verbessert wurden,
        % ist mit diesem Verfahren keine Verbesserung m�glich
        if i == length(AufVersp) 
            keineVerbmoegl = true;
        end
        
    end % end von for
    
end % end von while

end