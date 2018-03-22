function [Z,HolArtOrder,e] = sUFbSR(A,HZ,KZ,SP,DL,ArtOrder,AufOrder)
%
% [Z,HolArtOrder,e] = <strong>sUFbSR</strong>(A,HZ,KZ,SP,ArtOrder,AufOrder)
%
% Zielfunktion mit Stellplatzbegrenzung:
%   Diese Zielfunktion ist zur Minimierung der schlimmsten
%   �berschreitung der Fertigstellungszeitpunkte der Auftr�ge, wobei die 
%   Anzahl der Stellpl�tze begrenzt ist und ein rollierendes Wiederholprinzip 
%   f�r die Artikel verwendet wird.
%
% Parameter:
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten St�ckzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   HZ: Holzeit [ZE]
%   KZ: Kommissionierzeit [ZE/ME]
%   SP: Anzahl Stellpl�tze
%   ArtOrder: Reihenfolge der Artikel
%   AufOrder: Reihenfolge der Auftr�ge
%   Z: Zielfunktionswert
%   HolArtOrder: Artikelreihenfolge (ggf. mit Mehrfachholung)
%   e: Vektor der �berschreitungen der Deadlines [ZE]

[m,n] = size(A); % Anzahl der Artikel und Auftr�ge

% Die Ver�nderung der Artikelreihenfolge zieht
% eine Ver�nderung der Zuweisungsmatrix mit sich
Aart = SortArt(A,ArtOrder); % Sortieren der Zuweisungsmatrix 
HZart = SortArt(HZ,ArtOrder); % Sortieren der Holzeiten
KZart = SortArt(KZ,ArtOrder); % Sortieren der Kommissionierzeiten

% Kommissionierbeh�lter (KB) im Kommissionierbereich
% 0 = KB enth�lt noch nicht alle ben�tigten Artikel
% 1 = KB enth�lt alle ben�tigten Artikel
KBFertig = zeros(1,SP);

k = LetzterArtikel(Aart); % Letzter Artikel f�r die Auftr�ge
k = SortAuf(k,AufOrder); % Letzter Artikel f�r die Auftr�ge (laut Auftragsreihenfolge)

AKB = Aart(:,AufOrder(1:SP)); % Angepasste Zuweisungsmatrix f�r die Auftr�ge
% im Kommissionierbereich
AufKB = AufOrder(1:SP); % Auftr�ge (laut Auftragsreihenfolge) im Kommissionierbereich
kAKB = k(1:SP); % Letzter Artikel f�r die Auftr�ge (laut Auftragsreihenfolge) im Kommissionierbereich

C = zeros(1,n); % Fertigstellungszeitpunkte der Auftr�ge
Cbisher = 0; % bisherige Fertigstellungszeitpunkte der Auftr�ge

p = 0; % Anzahl der fertiggestellten Auftr�ge
d = 1; % Index f�r die sp�tere Kommissionierreihenfolge der Artikel

neuerstart  = 1; % Index f�r die rollierende Artikelreihenfolge (neuer Startpunkt)

% Index des minimalen Fertigstellungszeitpunktes 
% der Auftr�ge im Kommissionierbereich
letztArt = min(kAKB); 

while p < n % Bis alle Auftr�ge abgearbeitet sind
 for i = 1:min(letztArt)
            % q �bersetzt die rollierende Artikelreihenfolge
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
        
        % Die Auftr�ge die in diesem Schritt fertiggestellt werden, 
        % aus der weiteren Berechnung ausschlie�en und einen neuen
        % Kommissionierbeh�lter f�r einen neuen Auftrag bereitstellen
        for o = 1:SP
            if ((sum(AKB(:,o))==0) && (KBFertig(o)==0))
                % Beginne im n�chsten Schritt bei dem Artikel, 
                % der nach dem folgt, bei dem ein Auftrag fertiggestellt
                % wurde
                neuerstart = mod(q+1,m); 
                if neuerstart == 0
                    neuerstart = m;
                end
                p = p+1;
                % Wenn noch genug Auftr�ge "da" sind wird die Reihenfolge der
                % Auftr�ge um einen verschoben
                if (p+SP) <= n
                    AKB(:,o) = Aart(:,AufOrder(p+SP));
                    AufKB(o) = AufOrder(p+SP);
                    kAKB(o) = k(p+SP); 
                    KBFertig(o) = 0;
                else
                    % Ansonsten wird der Kommissionierbeh�lter auf 1 gesetzt,
                    % da er alle ben�tigten Artikel enth�lt
                    kAKB(o) = m; 
                    KBFertig(o) = 1;
                end
            end
        end
        % Die neueMatrix �bersetzt die aktuellen Auftr�ge im KB 
        % in die rollierende Reihenfolge
        neueMatrix(1:(m-(neuerstart-1)),:) = AKB(neuerstart:m,:);
        neueMatrix((m-(neuerstart-2)):m,:) = AKB(1:(neuerstart-1),:);
        letztArt = LetzterArtikel(neueMatrix);
        
        % Bei abgeschlossenen Auftr�gen den minimalen Endzeitpunkt (0)
        % nicht beachten, sondern so erh�hen, dass abgeschlossene Auftr�ge
        % nicht f�lschlich erneut ausgew�hlt werden.
        for i=1:SP
            if letztArt(i) == 0
                letztArt(i) = m + 1;
            end
        end
end

e = zeros(1,n); % e = Vektor der �berschreitungen in ZE
for i = 1:n
    %if C(i) - DL(i) > 0
        e(i) = C(i) - DL(i); % Beachte: Hat ein Auftrag 'DL' == 'Inf', so ist e == '-Inf'
    %end
end

Z = 0; % schlimmste �berschreitungen der Deadline
for i = 1:n 
    if e(i) > 0 && e(i) > Z % f�r jeden Auftrag, dessen �berschreitung des
        Z = e(i);           % Fertigstellungszeitpunkts e(i) > 0 ist UND
    end                     % dessen �berschreitung des Fertigstellungs-
end                         % zeitpunkts e(i) gr��er ist als die bisher
                            % Gr��te wird der Zielfunktionswert Z auf e(i)
end                         % gesetzt.