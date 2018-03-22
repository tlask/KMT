function [Z,HolArtOrder,e] = gUFbS(A,HZ,KZ,SP,DL,ArtOrder,AufOrder,Gewichtung)
%
% [Z,HolArtOrder,e] = <strong>gUFbS</strong>(A,HZ,KZ,SP,ArtOrder,AufOrder)
%
% Zielfunktion mit Stellplatzbegrenzung:
%   Diese Zielfunktion ist zur Minimierung der summierten gewichteten 
%   �berschreitungen der Fertigstellungszeitpunkte der Auftr�ge, wobei die 
%   Anzahl der Stellpl�tze begrenzt ist.
%
% Parameter:
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten St�ckzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   HZ: Holzeit [ZE]
%   KZ: Kommissionierzeit [ZE/ME]
%   SP: Anzahl Stellpl�tze
%   DL: Deadline
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
while p < n % Bis alle Auftr�ge abgearbeitet sind
    for i = 1:min(kAKB)
        if sum(AKB(i,:)) > 0
            Cbisher = Cbisher + HZart(i) + KZart(i)*sum(AKB(i,:));
            for j = AufKB(1:SP)
                if sum(AKB(:,find(AufKB==j))) > 0 %#ok<FNDSB>
                    C(j) = Cbisher;
                end
            end
            HolArtOrder(d) = ArtOrder(i); %#ok<AGROW>
            d=d+1;
        end
        AKB(i,:) = zeros(1,SP);
    end
    % Die Auftr�ge die in diesem Schritt fertiggestellt werden, 
    % aus der weiteren Berechnung ausschlie�en und einen neuen
    % Kommissionierbeh�lter f�r einen neuen Auftrag bereitstellen
    for o = 1:SP
        if ((sum(AKB(:,o))==0) && (KBFertig(o)==0))
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
end

%% Berechnung des Zielfunktionswertes

e = zeros(1,n); % e = Vektor der �berschreitungen in ZE
for i = 1:n
    %if C(i) - DL(i) > 0
        e(i) = C(i) - DL(i);
    %end
end

z = zeros(1,n); % Vektor der gewichteten �berschreitungen der Deadlines

for i = 1:n % gehe jeden Auftrag durch
    if e(i) > 0 % wenn eine �berschreitung der Deadline vorliegt...
        for j = 1:size(Gewichtung,2) % gehe die eingegebenen Grenzen durch
            if e(i) <= Gewichtung(2,j) % ist die Gewichtung kleiner gleich der aktuellen Grenze...
                z(i) = Gewichtung(1,j) * e(i); % ...berechne die gewichtete �berschreitung der Deadline mithilfe des eingegebenen Gewichts
                break;
            end
            if j == size(Gewichtung,2) % falls alle eingegebenen Grenzen �berschritten wurden...
                z(i) = Gewichtung(3,1) * e(i); % berechne die gewichtete �berschreitung der Deadline mithilfe des eingegebenen Gewichts bei �berschreitung aller Grenzen
            end
        end
    end
end

Z = sum(z); % Summierte gewichtete �berschreitung der Deadlines

end