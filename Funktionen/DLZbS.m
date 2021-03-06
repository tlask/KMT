function [Z,HolArtOrder,C] = DLZbS(A,HZ,KZ,SP,ArtOrder,AufOrder)
%
% [Z,HolArtOrder] = <strong>DLZbS</strong>(A,HZ,KZ,SP,ArtOrder,AufOrder)
%
% Zielfunktion mit Stellplatzbegrenzung:
%   Diese Zielfunktion ist zur Minimierung der summierten 
%   Durchlaufzeiten der Auftr�ge, wobei die Anzahl der
%   Stellpl�tze begrenzt ist.
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


[m,n] = size(A);

Aart = SortArt(A,ArtOrder);
HZart = SortArt(HZ,ArtOrder);
KZart = SortArt(KZ,ArtOrder);

KBFertig = zeros(1,SP);

k = LetzterArtikel(Aart);
k = SortAuf(k,AufOrder);

AKB = Aart(:,AufOrder(1:SP)); % Auftr�ge im Kommissionierbereich
AufKB = AufOrder(1:SP); % Auftr�ge Nr. im Kommissionierbereich
kAKB = k(1:SP); % Letzter Artikel f�r die Auftr�ge im Kommissionierbereich

C = zeros(1,n);

p = 0;
d = 1;
while p < n % Bis alle Auftr�ge abgearbeitet sind
    for j = 1:min(kAKB)
        if sum(AKB(j,:)) > 0
            for i = AufKB(1:SP)
                if sum(AKB(:,find(AufKB==i))) > 0 %#ok<FNDSB>
                    C(i) = C(i) + HZart(j) + KZart(j)*sum(AKB(j,:));
                end
            end
            HolArtOrder(d) = ArtOrder(j); %#ok<AGROW>
            d = d+1;
        end
        AKB(j,:) = zeros(1,SP);
    end
    for o = 1:SP
        if ((sum(AKB(:,o))==0) && (KBFertig(o)==0))
            p = p+1;
            if (p+SP) <= n
                AKB(:,o) = Aart(:,AufOrder(p+SP));
                AufKB(o) = AufOrder(p+SP);
                kAKB(o) = k(p+SP); 
                KBFertig(o) = 0;
            else
                kAKB(o) = m; 
                KBFertig(o) = 1;
            end
        end
    end
end

Z=sum(C);

end