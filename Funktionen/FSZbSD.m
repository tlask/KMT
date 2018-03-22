function [HolArtOrder,AufKB,A,C,Auftrag_fertig] = FSZbSD(A,HZ,KZ,SP,ArtOrder,AufOrder,AufKB,HolArtOrder,C,Auftrag_fertig,Artikel_neu_berechnen)
%
% [Z,HolArtOrder] = <strong>FSZbS</strong> (A,HZ,KZ,SP,ArtOrder,AufOrder,AufKB,HolArtOrder,C,Auftrag_fertig,p,Artikel_neu_berechnen)
%
% Zielfunktion mit Stellplatzbegrenzung:
%   Diese Zielfunktion ist zur Minimierung der summierten 
%   Fertigstellungszeitpunkte der Auftr�ge, wobei die Anzahl der
%   Stellpl�tze begrenzt ist und ein dynamisches Wiederholprinzip 
%   f�r die Artikel verwendet wird. Das dynamische
%   Artikelreihenfolgeverfahren berechnet die Artikelreihenfolge bei jedem
%   fertiggestellten Auftrag, der seinen Stellplatz verl�sst (falls n=1).
%   Das n kann in diesem Modell individuell angepasst werden.
%
% Parameter:
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten St�ckzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   HZ: Holzeit [ZE]
%   KZ: Kommissionierzeit [ZE/ME]
%   SP: Anzahl Stellpl�tze
%   ArtOrder: Reihenfolge der Artikel
%   AufOrder: Reihenfolge der Auftr�ge
%   AufKB: Auftrag auf Kommissionierbereich (Stellplatzbegrenzung)
%   HolArtOrder: Artikelreihenfolge (ggf. mit Mehrfachholung)
%   C: Zielfunktionswert von jedem Auftrag
%   Auftrag_fertig: fertiggestellte Auftr�ge als Vektor gespeichert
%   p: Anzahl der fertiggestellten Auftr�ge
%   Artikel_neu_berechnen: Ab wann eine neue Artikelreihenfolge berechnet
%   werden soll

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

AKB = Aart(:,AufKB); % Angepasste Zuweisungsmatrix f�r die Auftr�ge
% im Kommissionierbereich

kAKB = k(1,AufKB); % Letzter Artikel f�r die Auftr�ge (laut Auftragsreihenfolge) im Kommissionierbereich

d = 1; % Index f�r die sp�tere Kommissionierreihenfolge der Artikel

neuerstart  = 1; % Index f�r die rollierende Artikelreihenfolge (neuer Startpunkt)

% Index des minimalen Fertigstellungszeitpunktes 
% der Auftr�ge im Kommissionierbereich
letztArt = min(kAKB(kAKB~=0)); 

n = 0; % im PopUp-Fenster 'Neue Artikelreihenfolgeberechnung' einzugebender Wert

if ~isequal(Auftrag_fertig,ones(1,size(A,2)))
    while n < Artikel_neu_berechnen % Solange in der Funktion bleiben, bis n mal der Auftrag getauscht wurde,
                                    % danach raus und neue Artikelreihenfolge berechnen
        Cbisher = 0; % Zielfunktionswert zu Beginn auf Null setzen

        for i = 1:min(letztArt)
            % q �bersetzt die rollierende Artikelreihenfolge
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
                % Wenn noch genug Auftr�ge "da" sind wird die Reihenfolge der
                % Auftr�ge um einen verschoben
                Auftrag_fertig(1,AufKB(1,o)) = true;
                if (sum(Auftrag_fertig)+SP) <= size(A,2)
                    % Finde den n�chsten g�ltigen Auftrag, der noch nicht
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
                    % Ansonsten wird der Kommissionierbeh�lter auf 1 gesetzt,
                    % da er alle ben�tigten Artikel enth�lt
                    kAKB(o) = m; 
                    KBFertig(o) = 1;
                    n = n + 1;
                end
            end
        end

        % Die neue Matrix �bersetzt die aktuellen Auftr�ge im KB 
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

        if Auftrag_fertig == ones(1,size(A,2)) % Solange Auftr�ge tauschen (siehe n) bis alle Auftr�ge erledigt sind
            break;
        end
    end
end

end