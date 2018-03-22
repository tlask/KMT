function [best] = LstDynR (AKB,AartHelp,HZart,KZart,DL,PositionTracker,o,r)
%
% [best] = <strong>LstDynH</strong>(AKB,AartHelp,HZart,KZart,DLHelp,Cbisher,PositionTracker,o)
%
% dynamische Bestimmung des nächsten Auftrages nach der verbleibenden 
% Pufferzeit und bei rollierendem Artikelreihenfolgeverfahren.
%
% Parameter:
%   AKB: Angepasste Zuweisungsmatrix für die Aufträge im Kommissionierbereich
%   AartHelp: Nach der Artikelreihenfolge sortierte Zuweisungsmatrix A ohne
%             die Aufträge ohne Deadline
%   HZart: Nach der Artikelreihenfolge sortierte Holzeit [ZE]   
%   KZart: Nach der Artikelreihenfolge sortierte Kommissionierzeit [ZE/ME]
%   DL: Deadline-Vektor ohne Aufträge mit unendlich großer Deadline[ZE]
%   PositionTracker: Enthält die Information, welche Aufträge in A noch zu
%                    bearbeiten sind
%   o: Position des fertiggestellten, also auszutauschenden Auftrags in AKB
%   r: Position in der rollierenden Artikelreihenfolge
%   best: Auftragsnummer des nächsten Auftrags

n = length(HZart); % n entspricht der Anzahl an Artikeln
StKandidat = Inf;
naechsterArt = mod(r,n)+1; % berechnet, welcher Artikel als nächstes geliefert wird. length(AartHelp) entspricht der Anzahl an möglichen Artikeln

% stelle 'AKB','AartHelp','HZart' und 'KZart' um, sodass die Zeile mit dem 
% nächsten zu holenden Artikel in der 1. Zeile steht (rollierend!):            
for i = 1:naechsterArt-1
    help = AKB(1,:);
    AKB(1:(n-1),:) = AKB(2:n,:);
    AKB(n,:) = help;
    
    help = AartHelp(1,:);
    AartHelp(1:(n-1),:) = AartHelp(2:n,:);
    AartHelp(n,:) = help;
    
    help = HZart(1);
    HZart(1:(n-1)) = HZart(2:n);
    HZart(n) = help;
    
    help = KZart(1);
    KZart(1:(n-1)) = KZart(2:n);
    KZart(n) = help;
end


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
