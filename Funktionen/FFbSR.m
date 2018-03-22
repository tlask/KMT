function [Z,HolArtOrder,C] = FFbSR(A,HZ,KZ,SP,ArtOrder,AufOrder)
%
% [Z,HolArtOrder] = <strong>FFbS</strong>(A,HZ,KZ,SP,ArtOrder,AufOrder)
%
% Zielfunktion mit Stellplatzbegrenzung:
%   Diese Zielfunktion ist zur Minimierung des maximalen 
%   Fertigstellungszeitpunktes der Aufträge, wobei die Anzahl der
%   Stellplätze begrenzt ist und ein Rollierendes Wiederholprinzip 
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


[m,n] = size(A);

Aart = SortArt(A,ArtOrder);
HZart = SortArt(HZ,ArtOrder);
KZart = SortArt(KZ,ArtOrder);

KBFertig = zeros(1,SP);

k = LetzterArtikel(Aart);
k = SortAuf(k,AufOrder);

AKB = Aart(:,AufOrder(1:SP)); % Aufträge im Kommissionierbereich
AufKB = AufOrder(1:SP); % Aufträge Nr. im Kommissionierbereich
kAKB = k(1:SP); % Letzter Artikel für die Aufträge im Kommissionierbereich

C = zeros(1,n);
Cbisher = 0;

p = 0;
d = 1;
neuerstart  = 1;
letztArt = min(kAKB);
while p < n
    for j = 1:min(letztArt)
            q = mod(j + (neuerstart - 1), m); % index der neuen rollierenden artikelreihenfolge übersetzen (zu beginn bei 1)
            if q == 0
                q = m;
            end
            if sum(AKB(q,:)) > 0
                Cbisher = Cbisher + HZart(q) + KZart(q)*sum(AKB(q,:));
                for i = AufKB(1:SP)
                    if sum(AKB(:,find(AufKB==i))) > 0   %#ok<FNDSB>
                        C(i) = Cbisher;
                    end
                end
                HolArtOrder(d) = ArtOrder(q);
                d = d+1;
            end
            AKB(q,:) = zeros(1,SP);
    end
        for o = 1:SP
            if ((sum(AKB(:,o))==0) && (KBFertig(o)==0))
                neuerstart = mod(q+1,m); 
                if neuerstart == 0
                    neuerstart = m;
                end
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
        neueMatrix(1:(m-(neuerstart-1)),:) = AKB(neuerstart:m,:);
        neueMatrix((m-(neuerstart-2)):m,:) = AKB(1:(neuerstart-1),:);
        letztArt = LetzterArtikel(neueMatrix);
        for i=1:SP
            if letztArt(i) == 0
                letztArt(i) = m + 1;
            end
        end
end

Z = max(C);

end