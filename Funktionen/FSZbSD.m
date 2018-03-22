function [HolArtOrder,AufKB,A,C,Auftrag_fertig] = FSZbSD(A,HZ,KZ,SP,ArtOrder,AufOrder,AufKB,HolArtOrder,C,Auftrag_fertig,Artikel_neu_berechnen)
%
% [Z,HolArtOrder] = <strong>FSZbS</strong> (A,HZ,KZ,SP,ArtOrder,AufOrder,AufKB,HolArtOrder,C,Auftrag_fertig,p,Artikel_neu_berechnen)
%
% Zielfunktion mit Stellplatzbegrenzung:
%   Diese Zielfunktion ist zur Minimierung der summierten 
%   Fertigstellungszeitpunkte der Aufträge, wobei die Anzahl der
%   Stellplätze begrenzt ist und ein dynamisches Wiederholprinzip 
%   für die Artikel verwendet wird. Das dynamische
%   Artikelreihenfolgeverfahren berechnet die Artikelreihenfolge bei jedem
%   fertiggestellten Auftrag, der seinen Stellplatz verlässt (falls n=1).
%   Das n kann in diesem Modell individuell angepasst werden.
%
% Parameter:
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten Stückzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   HZ: Holzeit [ZE]
%   KZ: Kommissionierzeit [ZE/ME]
%   SP: Anzahl Stellplätze
%   ArtOrder: Reihenfolge der Artikel
%   AufOrder: Reihenfolge der Aufträge
%   AufKB: Auftrag auf Kommissionierbereich (Stellplatzbegrenzung)
%   HolArtOrder: Artikelreihenfolge (ggf. mit Mehrfachholung)
%   C: Zielfunktionswert von jedem Auftrag
%   Auftrag_fertig: fertiggestellte Aufträge als Vektor gespeichert
%   p: Anzahl der fertiggestellten Aufträge
%   Artikel_neu_berechnen: Ab wann eine neue Artikelreihenfolge berechnet
%   werden soll

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

AKB = Aart(:,AufKB); % Angepasste Zuweisungsmatrix für die Aufträge
% im Kommissionierbereich

kAKB = k(1,AufKB); % Letzter Artikel für die Aufträge (laut Auftragsreihenfolge) im Kommissionierbereich

d = 1; % Index für die spätere Kommissionierreihenfolge der Artikel

neuerstart  = 1; % Index für die rollierende Artikelreihenfolge (neuer Startpunkt)

% Index des minimalen Fertigstellungszeitpunktes 
% der Aufträge im Kommissionierbereich
letztArt = min(kAKB(kAKB~=0)); 

n = 0; % im PopUp-Fenster 'Neue Artikelreihenfolgeberechnung' einzugebender Wert

if ~isequal(Auftrag_fertig,ones(1,size(A,2)))
    while n < Artikel_neu_berechnen % Solange in der Funktion bleiben, bis n mal der Auftrag getauscht wurde,
                                    % danach raus und neue Artikelreihenfolge berechnen
        Cbisher = 0; % Zielfunktionswert zu Beginn auf Null setzen

        for i = 1:min(letztArt)
            % q übersetzt die rollierende Artikelreihenfolge
            % zu Beginn bei 1
            q = mod(i + (neuerstart - 1), m);
            if q == 0
                q = m;
            end
            if sum(AKB(q,:)) > 0
                Cbisher = Cbisher + HZart(q) + KZart(q)*sum(AKB(q,:));
                if isempty(HolArtOrder)
                   HolArtOrder(d) = ArtOrder(q); 
                else
                   HolArtOrder(size(HolArtOrder,2)+1) = ArtOrder(q);
                end         
                A(HolArtOrder(size(HolArtOrder,2)),AufKB) = zeros(1,SP);
            end
            AKB(q,:) = zeros(1,SP);
         end

         C(1,~Auftrag_fertig) = C(1,~Auftrag_fertig) + Cbisher; % Auf die berechneten Werte draufaddieren (solange der Auftrag noch nicht fertig ist).

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
                % Wenn noch genug Aufträge "da" sind wird die Reihenfolge der
                % Aufträge um einen verschoben
                Auftrag_fertig(1,AufKB(1,o)) = true;
                if (sum(Auftrag_fertig)+SP) <= size(A,2)
                    % Finde den nächsten gültigen Auftrag, der noch nicht
                    % abgearbeitet wurde
                    v = 1;
                    while Auftrag_fertig(AufOrder(v)) || ~isempty(find(AufKB(1,:) == AufOrder(v), 1))
                           v = v + 1;
                    end
                    AKB(:,o) = Aart(:,AufOrder(v));
                    AufKB(o) = AufOrder(v);
                    kAKB(o) = k(v); 
                    KBFertig(o) = 0;
                    n = n + 1;
                else
                    Auftrag_fertig(1,AufKB(1,o)) = true;
                    % Ansonsten wird der Kommissionierbehälter auf 1 gesetzt,
                    % da er alle benötigten Artikel enthält
                    kAKB(o) = m; 
                    KBFertig(o) = 1;
                    n = n + 1;
                end
            end
        end

        % Die neue Matrix übersetzt die aktuellen Aufträge im KB 
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

        if Auftrag_fertig == ones(1,size(A,2)) % Solange Aufträge tauschen (siehe n) bis alle Aufträge erledigt sind
            break;
        end
    end
end

end