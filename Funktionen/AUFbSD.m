function [Z,HolArtOrder,e] = AUFbSD(A,HZ,KZ,SP,DL,ArtOrder,AufOrder,index)
%
% [Z,HolArtOrder] = <strong>FSZbS</strong>(A,HZ,KZ,SP,ArtOrder,AufOrder)
%
% Zielfunktion mit Stellplatzbegrenzung:
%   Diese Zielfunktion ist zur Minimierung der Anzahl an �berschreitungen
%   der Fertigstellungszeitpunkte der Auftr�ge, wobei die Anzahl der
%   Stellpl�tze begrenzt ist.
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
%   index: index zur Bestimmung der Artikelreihenfolge
%   Z: Zielfunktionswert
%   HolArtOrder: Artikelreihenfolge (ggf. mit Mehrfachholung)
%   e: Vektor der �berschreitungen der Deadlines [ZE]

[m,n] = size(A); % Anzahl der Artikel und Auftr�ge

% Die Ver�nderung der Artikelreihenfolge zieht
% eine Ver�nderung der Zuweisungsmatrix mit sich
Aart = SortArt(A,ArtOrder); % Sortieren der Zuweisungsmatrix 

% Kommissionierbeh�lter (KB) im Kommissionierbereich
% 0 = KB enth�lt noch nicht alle ben�tigten Artikel
% 1 = KB enth�lt alle ben�tigten Artikel
KBFertig = zeros(1,SP);

AKB = Aart(:,AufOrder(1:SP)); % Angepasste Zuweisungsmatrix f�r die Auftr�ge
% im Kommissionierbereich
AufKB = AufOrder(1:SP); % Auftr�ge (laut Auftragsreihenfolge) im Kommissionierbereich

C = zeros(1,n); % Fertigstellungszeitpunkte der Auftr�ge
Cbisher = 0; % bisherige Fertigstellungszeitpunkte der Auftr�ge

p = 0; % Anzahl der fertiggestellten Auftr�ge
d = 1; % Index f�r die sp�tere Kommissionierreihenfolge der Artikel
while p < n % Bis alle Auftr�ge abgearbeitet sind
    
    % bringe AKB zur�ck in topologische Artikelreihenfolge:
    AKBtemp = AKB;
    for i = 1:m
        AKB(ArtOrder(i),:) = AKBtemp(i,:);
    end
    clear AKBtemp;
    % berechne f�r AKB die neue Artikelreihenfolge:
    BZ = Bearbeitungszeit(AKB,HZ,KZ);
    HA = Haufigkeit(AKB);
    switch index
        case 1
            ArtOrder = [1:m]'; %#ok<*NBRAK> unterdr�ckt die Fehlermeldung, dass die Klammern �berfl�ssig sind
        case 2
            ArtOrder = minBmaxH(HA,BZ);
        case 3
            ArtOrder = maxBmaxH(HA,BZ);
        case 4
            ArtOrder = minHtopo(HA,BZ);
        case 5
            ArtOrder = maxHtopo(HA,BZ);
        case 6
            ArtOrder = maxHminB(HA,BZ);
        case 7
            ArtOrder = maxHmaxB(HA,BZ);
        case 8
            ArtOrder = zenReihAufst(HA);
        case 9
            ArtOrder = zenReihAbst(HA);
        case 10
            ArtOrder = minAtopo(AKB);
        case 11
            ArtOrder = minAminB(AKB,BZ);
        case 12
            ArtOrder = minAmaxB(AKB,BZ);
        case 13
            ArtOrder = minAminH(AKB,HA);
        case 14
            ArtOrder = minAmaxH(AKB,HA);
        case 15
            ArtOrder = maxAtopo(AKB);
        case 16
            ArtOrder = maxAminB(AKB,BZ);
        case 17
            ArtOrder = maxAmaxB(AKB,BZ);
        case 18
            ArtOrder = maxAminH(AKB,HA);
        case 19
            ArtOrder = maxAmaxH(AKB,HA);
    end
    % ordne alles nach der neuen Artikelreihenfolge:
    Aart = SortArt(A,ArtOrder);
    HZart = SortArt(HZ,ArtOrder); % Sortieren der Holzeiten
    KZart = SortArt(KZ,ArtOrder); % Sortieren der Kommissionierzeiten
    AKB = SortArt(AKB,ArtOrder);
    kAKB = LetzterArtikel(AKB);
    % falls ein fertiger Artikel in AKB ist (kAKB == 0), setze dessen
    % letzten Artikel auf den letzten m�glichen Aritkel ( = m):
    kAKB(find(kAKB == 0)) = m; %#ok<FNDSB>
    
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
                KBFertig(o) = 0;
            else
                % Ansonsten wird der Kommissionierbeh�lter auf 1 gesetzt,
                % da er alle ben�tigten Artikel enth�lt
                KBFertig(o) = 1;
            end
        end
    end
end

e = zeros(1,n); % e = Vektor der �berschreitungen in ZE
for i = 1:n
    e(i) = C(i) - DL(i); % Beachte: Hat ein Auftrag 'DL' == 'Inf', so ist e == '-Inf'
end

Z = 0; % Anzahl an �berschreitungen der Deadline
for i = 1:n 
    if e(i) > 0    % F�r jeden Auftrag, dessen �berschreitung des Fertig-
        Z = Z + 1; % stellungszeitpunkts e(i) > 0 ist wird der Ziel-
    end            % funktionswert Z um 1 erh�ht.
end 

end