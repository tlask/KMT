function [best,ArtR] = LstDynD (AKB,A,HZ,KZ,DL,PositionTracker,o,ArtVerf)
%
% [best] = <strong>LstDynH</strong>(AKB,AartHelp,HZart,KZart,DLHelp,Cbisher,PositionTracker,o)
%
% dynamische Bestimmung des n�chsten Auftrages nach der verbleibenden 
% Pufferzeit und bei dynamischem Artikelreihenfolgeverfahren.
%
% Parameter:
%   AKB: Angepasste Zuweisungsmatrix mit Auftr�gen im Kommissionierbereich
%   A: Zuweisungsmatrix
%   HZ: Holzeit [ZE]   
%   KZ: Kommissionierzeit [ZE/ME]
%   DL: Deadline-Vektor [ZE]
%   PositionTracker: Enth�lt die Information, welche Auftr�ge in A noch zu
%                    bearbeiten sind
%   o: Position des fertiggestellten, also auszutauschenden Auftrags in AKB
%   ArtVerf: Nummer des zu verwendenden Artikelreihenfolgeverfahrens
%   best: Auftragsnummer des n�chsten Auftrags
%   ArtR: dynamisch neu berechnete Artikelreihenfolge f�r Auftr�ge in AKB

StBest = Inf;
% betrachte nur die Auftr�ge, die in 'Positiontracker' stehen:
A = A(:,PositionTracker);
DL = DL(PositionTracker);
m = size(A,2); % Anzahl der noch zu bearbeitenden Auftr�ge

for i = 1:m % gehe alle verbleibenden zu bearbeitenden Auftr�ge durch
    % stelle den Auftrag auf den freigewordenen Stellplatz:
    AKB(:,o) = A(:,i);
    AKBtemp = AKB;
    % berechne die aktuelle Bearbeitungszeit sowie die H�ufigtkeit:
    BZtemp = Bearbeitungszeit(AKB,HZ,KZ);
    HAtemp = Haufigkeit(AKB);
    % berechnet die Artikelreihenfolge anhand der Matrix AKB neu:
    switch ArtVerf     
        case 1
            OrderArtikel = [1:length(AKB)]'; %#ok<*NBRAK> unterdr�ckt die Fehlermeldung, dass die Klammern �berfl�ssig sind
        case 2
            OrderArtikel = minBmaxH(HAtemp,BZtemp);
        case 3
            OrderArtikel = maxBmaxH(HAtemp,BZtemp);
        case 4
            OrderArtikel = minHtopo(HAtemp,BZtemp);
        case 5
            OrderArtikel = maxHtopo(HAtemp,BZtemp);
        case 6
            OrderArtikel = maxHminB(HAtemp,BZtemp);
        case 7
            OrderArtikel = maxHmaxB(HAtemp,BZtemp);
        case 8
            OrderArtikel = zenReihAufst(HAtemp);
        case 9
            OrderArtikel = zenReihAbst(HAtemp);
        case 10
            OrderArtikel = minAtopo(AKB);
        case 11
            OrderArtikel = minAminB(AKB,BZtemp);
        case 12
            OrderArtikel = minAmaxB(AKB,BZtemp);
        case 13
            OrderArtikel = minAminH(AKB,BZtemp);
        case 14
            OrderArtikel = minAmaxH(AKB,BZtemp);
        case 15
            OrderArtikel = maxAtopo(AKB);
        case 16
            OrderArtikel = maxAminB(AKB,BZtemp);
        case 17
            OrderArtikel = maxAmaxB(AKB,BZtemp);
        case 18
            OrderArtikel = maxAminH(AKB,HAtemp);
        case 19
            OrderArtikel = maxAmaxH(AKB,HAtemp);
    end
    
    % ordne nach neuer Artikelreihenfolge:
    AKBtemp = SortArt(AKBtemp,OrderArtikel);
    BZtemp = SortArt(BZtemp,OrderArtikel);
    HZtemp = SortArt(HZ,OrderArtikel);
    KZtemp = SortArt(KZ,OrderArtikel);
    ktemp = LetzterArtikel(AKBtemp);
    % Bestimme die spezifischen Fertigstellungszeitpunkte der Auftr�ge im 
    % Kommissionierbereich:
    Cstemp = spezifiziertenFertigstellungszeitpunkt(BZtemp,ktemp,AKBtemp,HZtemp,KZtemp);
    % berechne die Pufferzeit des aktuell dazugestellten Auftrags:
    Sttemp = DL(i) - Cstemp(o);
    
    if Sttemp < StBest
        best = PositionTracker(i);
        ArtR = OrderArtikel;
        StBest = Sttemp;
    end
end


end
