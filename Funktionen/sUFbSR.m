function [Z,HolArtOrder,e] = sUFbSR(A,HZ,KZ,SP,DL,ArtOrder,AufOrder)
%
% [Z,HolArtOrder,e] = <strong>sUFbSR</strong>(A,HZ,KZ,SP,ArtOrder,AufOrder)
%
% Zielfunktion mit Stellplatzbegrenzung:
%   Diese Zielfunktion ist zur Minimierung der schlimmsten
%   Überschreitung der Fertigstellungszeitpunkte der Aufträge, wobei die 
%   Anzahl der Stellplätze begrenzt ist und ein rollierendes Wiederholprinzip 
%   für die Artikel verwendet wird.
%
% Parameter:
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten Stückzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   HZ: Holzeit [ZE]
%   KZ: Kommissionierzeit [ZE/ME]
%   SP: Anzahl Stellplätze
%   ArtOrder: Reihenfolge der Artikel
%   AufOrder: Reihenfolge der Aufträge
%   Z: Zielfunktionswert
%   HolArtOrder: Artikelreihenfolge (ggf. mit Mehrfachholung)
%   e: Vektor der Überschreitungen der Deadlines [ZE]

[m,n] = size(A); % Anzahl der Artikel und Aufträge

% Die Veränderung der Artikelreihenfolge zieht
% eine Veränderung der Zuweisungsmatrix mit sich
Aart = SortArt(A,ArtOrder); % Sortieren der Zuweisungsmatrix 
HZart = SortArt(HZ,ArtOrder); % Sortieren der Holzeiten
KZart = SortArt(KZ,ArtOrder); % Sortieren der Kommissionierzeiten

% Kommissionierbehälter (KB) im Kommissionierbereich
% 0 = KB enthält noch nicht alle benötigten Artikel
% 1 = KB enthält alle benötigten Artikel
KBFertig = zeros(1,SP);

k = LetzterArtikel(Aart); % Letzter Artikel für die Aufträge
k = SortAuf(k,AufOrder); % Letzter Artikel für die Aufträge (laut Auftragsreihenfolge)

AKB = Aart(:,AufOrder(1:SP)); % Angepasste Zuweisungsmatrix für die Aufträge
% im Kommissionierbereich
AufKB = AufOrder(1:SP); % Aufträge (laut Auftragsreihenfolge) im Kommissionierbereich
kAKB = k(1:SP); % Letzter Artikel für die Aufträge (laut Auftragsreihenfolge) im Kommissionierbereich

C = zeros(1,n); % Fertigstellungszeitpunkte der Aufträge
Cbisher = 0; % bisherige Fertigstellungszeitpunkte der Aufträge

p = 0; % Anzahl der fertiggestellten Aufträge
d = 1; % Index für die spätere Kommissionierreihenfolge der Artikel

neuerstart  = 1; % Index für die rollierende Artikelreihenfolge (neuer Startpunkt)

% Index des minimalen Fertigstellungszeitpunktes 
% der Aufträge im Kommissionierbereich
letztArt = min(kAKB); 

while p < n % Bis alle Aufträge abgearbeitet sind
 for i = 1:min(letztArt)
            % q übersetzt die rollierende Artikelreihenfolge
            % zu Beginn bei 1
            q = mod(i + (neuerstart - 1), m);
            if q == 0
                q = m;
            end
            if sum(AKB(q,:)) > 0
                Cbisher = Cbisher + HZart(q) + KZart(q)*sum(AKB(q,:));
                for j = AufKB(1:SP)
                    if sum(AKB(:,find(AufKB==j))) > 0 %#ok<FNDSB>
                        C(j) = Cbisher;
                    end
                end
                HolArtOrder(d) = ArtOrder(q); 
                d=d+1;           
            end
            AKB(q,:) = zeros(1,SP);
 end
        
        % Die Aufträge die in diesem Schritt fertiggestellt werden, 
        % aus der weiteren Berechnung ausschließen und einen neuen
        % Kommissionierbehälter für einen neuen Auftrag bereitstellen
        for o = 1:SP
            if ((sum(AKB(:,o))==0) && (KBFertig(o)==0))
                % Beginne im nächsten Schritt bei dem Artikel, 
                % der nach dem folgt, bei dem ein Auftrag fertiggestellt
                % wurde
                neuerstart = mod(q+1,m); 
                if neuerstart == 0
                    neuerstart = m;
                end
                p = p+1;
                % Wenn noch genug Aufträge "da" sind wird die Reihenfolge der
                % Aufträge um einen verschoben
                if (p+SP) <= n
                    AKB(:,o) = Aart(:,AufOrder(p+SP));
                    AufKB(o) = AufOrder(p+SP);
                    kAKB(o) = k(p+SP); 
                    KBFertig(o) = 0;
                else
                    % Ansonsten wird der Kommissionierbehälter auf 1 gesetzt,
                    % da er alle benötigten Artikel enthält
                    kAKB(o) = m; 
                    KBFertig(o) = 1;
                end
            end
        end
        % Die neueMatrix übersetzt die aktuellen Aufträge im KB 
        % in die rollierende Reihenfolge
        neueMatrix(1:(m-(neuerstart-1)),:) = AKB(neuerstart:m,:);
        neueMatrix((m-(neuerstart-2)):m,:) = AKB(1:(neuerstart-1),:);
        letztArt = LetzterArtikel(neueMatrix);
        
        % Bei abgeschlossenen Aufträgen den minimalen Endzeitpunkt (0)
        % nicht beachten, sondern so erhöhen, dass abgeschlossene Aufträge
        % nicht fälschlich erneut ausgewählt werden.
        for i=1:SP
            if letztArt(i) == 0
                letztArt(i) = m + 1;
            end
        end
end

e = zeros(1,n); % e = Vektor der Überschreitungen in ZE
for i = 1:n
    %if C(i) - DL(i) > 0
        e(i) = C(i) - DL(i); % Beachte: Hat ein Auftrag 'DL' == 'Inf', so ist e == '-Inf'
    %end
end

Z = 0; % schlimmste Überschreitungen der Deadline
for i = 1:n 
    if e(i) > 0 && e(i) > Z % für jeden Auftrag, dessen Überschreitung des
        Z = e(i);           % Fertigstellungszeitpunkts e(i) > 0 ist UND
    end                     % dessen Überschreitung des Fertigstellungs-
end                         % zeitpunkts e(i) größer ist als die bisher
                            % Größte wird der Zielfunktionswert Z auf e(i)
end                         % gesetzt.