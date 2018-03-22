function [Z,HolArtOrder,e] = gUFbS(A,HZ,KZ,SP,DL,ArtOrder,AufOrder,Gewichtung)
%
% [Z,HolArtOrder,e] = <strong>gUFbS</strong>(A,HZ,KZ,SP,ArtOrder,AufOrder)
%
% Zielfunktion mit Stellplatzbegrenzung:
%   Diese Zielfunktion ist zur Minimierung der summierten gewichteten 
%   Überschreitungen der Fertigstellungszeitpunkte der Aufträge, wobei die 
%   Anzahl der Stellplätze begrenzt ist.
%
% Parameter:
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten Stückzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   HZ: Holzeit [ZE]
%   KZ: Kommissionierzeit [ZE/ME]
%   SP: Anzahl Stellplätze
%   DL: Deadline
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
while p < n % Bis alle Aufträge abgearbeitet sind
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
    % Die Aufträge die in diesem Schritt fertiggestellt werden, 
    % aus der weiteren Berechnung ausschließen und einen neuen
    % Kommissionierbehälter für einen neuen Auftrag bereitstellen
    for o = 1:SP
        if ((sum(AKB(:,o))==0) && (KBFertig(o)==0))
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
end

%% Berechnung des Zielfunktionswertes

e = zeros(1,n); % e = Vektor der Überschreitungen in ZE
for i = 1:n
    %if C(i) - DL(i) > 0
        e(i) = C(i) - DL(i);
    %end
end

z = zeros(1,n); % Vektor der gewichteten Überschreitungen der Deadlines

for i = 1:n % gehe jeden Auftrag durch
    if e(i) > 0 % wenn eine Überschreitung der Deadline vorliegt...
        for j = 1:size(Gewichtung,2) % gehe die eingegebenen Grenzen durch
            if e(i) <= Gewichtung(2,j) % ist die Gewichtung kleiner gleich der aktuellen Grenze...
                z(i) = Gewichtung(1,j) * e(i); % ...berechne die gewichtete Überschreitung der Deadline mithilfe des eingegebenen Gewichts
                break;
            end
            if j == size(Gewichtung,2) % falls alle eingegebenen Grenzen überschritten wurden...
                z(i) = Gewichtung(3,1) * e(i); % berechne die gewichtete Überschreitung der Deadline mithilfe des eingegebenen Gewichts bei Überschreitung aller Grenzen
            end
        end
    end
end

Z = sum(z); % Summierte gewichtete Überschreitung der Deadlines

end