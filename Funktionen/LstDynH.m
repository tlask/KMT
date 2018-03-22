function [best] = LstDynH (AKB,AartHelp,HZart,KZart,DL,PositionTracker,o)
%
% [best] = <strong>LstDynH</strong>(AKB,AartHelp,HZart,KZart,DLHelp,Cbisher,PositionTracker,o)
%
% dynamische Bestimmung des n�chsten Auftrages nach der verbleibenden 
% Pufferzeit und bei hierarchischem Artikelreihenfolgeverfahren.
%
% Parameter:
%   AKB: Angepasste Zuweisungsmatrix f�r die Auftr�ge im Kommissionierbereich
%   AartHelp: Nach der Artikelreihenfolge sortierte Zuweisungsmatrix A ohne
%             die Auftr�ge ohne Deadline
%   HZart: Nach der Artikelreihenfolge sortierte Holzeit [ZE]   
%   KZart: Nach der Artikelreihenfolge sortierte Kommissionierzeit [ZE/ME]
%   DL: Deadline-Vektor ohne Auftr�ge mit unendlich gro�er Deadline[ZE]
%   PositionTracker: Enth�lt die Information, welche Auftr�ge in A noch zu
%                    bearbeiten sind
%   o: Position des fertiggestellten, also auszutauschenden Auftrags in AKB
%   best: Auftragsnummer des n�chsten Auftrags

StKandidat = Inf;
best = PositionTracker(1);

for i = 1:size(AartHelp,2)
    % stelle den Auftrag auf den freigewordenen Stellplatz:
    AKB(:,o) = AartHelp(:,i);                                                      
    ktemp = LetzterArtikel(AKB);
    BZtemp = Bearbeitungszeit(AKB,HZart,KZart);
    Cstemp = spezifiziertenFertigstellungszeitpunkt(BZtemp,ktemp,AKB,HZart,KZart);
    % berechne die Pufferzeit des aktuell dazugestellten Auftrags:
    Sttemp = DL(i) - Cstemp(o);
    
    if Sttemp < StKandidat
        best = PositionTracker(i);
        StKandidat = Sttemp;
    end
end

end
