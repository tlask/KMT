function [AufOrder] = LstDynamisch(A,HZ,KZ,BZ,DL,SP,StartArtOrder,VerfOhneDL,ArtVerf,ArtVerfIndex)
%
% [AufOrder] = <strong>LST</strong>(A,HZ,KZ,BZ,ArtOrder)
%
% Auftragsreihenfolgeverfahren:
%   Anordnung nach aufsteigenden Pufferzeit.
%
% Parameter:
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten St�ckzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftr=g Aj (j = 1...n)
%   HZ: Holzeit [ZE]
%   KZ: Kommissionierzeit [ZE/ME]
%   BZ: Bearbeitungszeit [ZE]
%   DL: Deadliine [ZE]
%   SP: Anzahl Stellpl�tze     
%   StartArtOrder: Artikelreihenfolge
%   VerfOhneDL: String zur Bestimmung des Auftragsreihenfolgeverfahrens,
%               das auf Auftr�ge mit unendlich gro�er Deadline anzuwenden ist
%   ArtVerf: String zur Bestimmung des Artikelreihenfolgeverfahrens.
%            Auswahlm�glichkeiten: "H","R" und "D"
%   ArtVerfIndex: gibt die Nummer des zu verwendenden Artikelreihenfolge- 
%                 verfahrens an (wird nur ben�tigt, falls ArtVerf == 'D')
%   AufOrder: Auftragsreihenfolge


%% Initialisierung

n = size(A,2);
AufOrder = zeros(1,n);
PositionTracker = 1:n;
AnzKeinDL = sum(isinf(DL)); % Anzahl an Auftr�gen mit unendlich gro�er DL

%% Berechne die Pufferzeit (Slacktime) statisch

Aart = SortArt(A,StartArtOrder);
BZart = SortArt(BZ,StartArtOrder);
HZart = SortArt(HZ,StartArtOrder);
KZart = SortArt(KZ,StartArtOrder);
k = LetzterArtikel(Aart);

Cs = spezifiziertenFertigstellungszeitpunkt(BZart,k,Aart,HZart,KZart);
St = DL - Cs.'; % St = slack time

%% Teste auf den Sonderfall, dass die Anzahl der Stellpl�tze gr��er gleich der Anzahl an Auftr�ge mit endlicher Deadline ist (erspart Rechenzeit)

AartHelp = Aart; % AartHelp, DLHelp werden sp�ter zur dynamischen Bestimmung des n�chstesn Auftrags ben�tigt
DLHelp = DL;     % AartHelp = Alle noch zu bearbeitenden Auftr�ge in Aart. DLHelp: die dazugeh�rigen Deadlines

if n - AnzKeinDL <= SP % Unterscheide den Sonderfall: SP ist kleiner als die Anzahl an Auftr�ge mit DL < Inf
    AufMitDL = (1:n).* ~(isinf(DL.')); % bestimme alle Auftr�ge, die eine Deadline haben
    AufMitDL(AufMitDL == 0) = [];
    
    AufOrder(1:length(AufMitDL)) = AufMitDL; % stelle die Auftr�ge mit Deadline auf die Stellpl�tze (Reihenfolge egal, da SP > #Auftr�ge mit DL < Inf
    
    KeinDL = (1:n).*isinf(DL.'); % speichere Auftr�ge mit DL == Inf in 'KeinDL'
    KeinDL(KeinDL==0) = [];
   
else
    %% Ordne nach aufsteigender statischer Pufferzeit (Slacktime) und nehme f�r X Stellpl�tze die ersten X Auftr�ge (mit der niedrigsten Pufferzeit)

    for i = 1:SP
        x = find(St==min(St),1); % Findet die Stelle, wo das Minimums ist; bei Mehreren wird das Erste gew�hlt
        St(x) = Inf; % F�gt an der Stelle des Minimums eine gro�e positive Zahl ein
        AufOrder(i) = x;   % Stellt das Minimum an die i-te Stelle der L�sung
    end
    
    % Entferne die Auftr�ge aus AartHelp, DLHelp und PositionTracker, die 
    % auf die ersten Stellpl�tze gestellt werden:
    AartHelp(:,AufOrder(1:SP)) = []; 
    DLHelp(AufOrder(1:SP)) = [];
    PositionTracker(AufOrder(1:SP)) = [];
    
    
    %% �berpr�fe, ob Auftr�ge mit unendlich gro�er Deadline vorhanden sind; falls ja: speichere diese in 'KeinDL'
    
    if AnzKeinDL > 0
        % bestimme deren Auftragsnummer
        KeinDL = (1:n).*isinf(DL.');
        KeinDL(KeinDL==0) = [];

        % help: an welcher Stelle der Matrix Aarthelp und DLhelp stehen die Auftr�ge mit unendlich gro�er Deadline?
        help = zeros(1,AnzKeinDL);
        for i=1:AnzKeinDL
            help(i) = find(PositionTracker == KeinDL(i)); 
        end

        % Entferne die Auftr�ge aus AartHelp und DLHelp, die eine unendlich 
        % gro�e Deadline haben.
        AartHelp(:,help) = [];    
        DLHelp(help) = [];
        PositionTracker(help) = [];
        clear help
    end

    %% Ordne nach aufsteigender dynamischen Pufferzeit (Slacktime)

    [m,n] = size(A); % Anzahl der Artikel und Auftr�ge

    % Kommissionierbeh�lter (KB) im Kommissionierbereich
    % 0 = KB enth�lt noch nicht alle ben�tigten Artikel
    % 1 = KB enth�lt alle ben�tigten Artikel
    KBFertig = zeros(1,SP);

    khelp = k;
    k(1:SP)=khelp(AufOrder(1:SP));
    k(SP+1:end) = 0;
    clear khelp;

    AKB = Aart(:,AufOrder(1:SP)); % Angepasste Zuweisungsmatrix f�r die Auftr�ge im Kommissionierbereich
    AufKB = AufOrder(1:SP); % Auftr�ge (laut Auftragsreihenfolge) im Kommissionierbereich
    kAKB = k(1:SP); % Letzter Artikel f�r die Auftr�ge (laut Auftragsreihenfolge) im Kommissionierbereich

    p = 0; % Anzahl der fertiggestellten Auftr�ge

    switch ArtVerf

%%%
%%% HIERARCHISCH:
%%%

        case 'H'

            while p < n-AnzKeinDL % Bis alle Auftr�ge abgearbeitet sind
                
                % Da nur die Auftragsreihenfolge z�hlt, werden jetzt alle 
                % Artikel gleichzeitig geholt, bis der erste Auftrag im
                % Kommissionierbereich fertig gestellt ist:
                AKB(1:min(kAKB),:) = 0;
                
                % Die Auftr�ge die in diesem Schritt fertiggestellt werden, 
                % aus der weiteren Berechnung ausschlie�en und einen neuen
                % Kommissionierbeh�lter f�r einen neuen Auftrag bereitstellen
                for o = 1:SP
                    if ((sum(AKB(:,o))==0) && (KBFertig(o)==0))
                        p = p+1;
                        % Wenn noch genug Auftr�ge "da" sind wird die Reihenfolge der
                        % Auftr�ge um einen verschoben
                        if (p+SP) <= n-AnzKeinDL 
                            
                            % HIERARCHISCHE BESTIMMUNG des n�chsten 
                            % Auftrages nach der verbleibenden Pufferzeit:
                            AufOrder(p+SP) = LstDynH(AKB,AartHelp,HZart,KZart,DLHelp,PositionTracker,o);

                            AKB(:,o) = AartHelp(:,find(PositionTracker == AufOrder(p+SP))); % stelle den Auftrag mit der kleinsten Pufferzeit auf den freien Platz im Kommissionierbereich
                            kAKB = LetzterArtikel(AKB);

                            AartHelp(:,find(PositionTracker == AufOrder(p+SP))) = [];       % L�sche den Auftrag mit der geringsten Pufferzeit aus der Matrix der noch zu bearbeitenden Auftr�ge
                            DLHelp(find(PositionTracker == AufOrder(p+SP))) = [];           % L�sche au�erdem die zugeh�rige Deadline...
                            PositionTracker(find(PositionTracker == AufOrder(p+SP))) = [];  % ... und die "Auftragsnummer"

                            AufKB(o) = AufOrder(p+SP);    
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

%%%
%%% ROLLIEREND:
%%%
            
        case 'R'


            neuerstart  = 1; 
            letztArt = min(kAKB); 

            while p < n-AnzKeinDL % Bis alle Auftr�ge abgearbeitet sind
                
                
                 for i = 1:min(letztArt)
                            % q �bersetzt die rollierende Artikelreihenfolge
                            % zu Beginn bei 1
                            q = mod(i + (neuerstart - 1), m);
                            if q == 0
                                q = m;
                            end
                            AKB(q,:) = zeros(1,SP);
                 end

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
                        p = p+1;
                        % Wenn noch genug Auftr�ge "da" sind wird die Reihenfolge der
                        % Auftr�ge um einen verschoben
                        if (p+SP) <= n-AnzKeinDL


                            % ROLLIERENDE BESTIMMUNG des n�chsten Auftrages 
                            % nach der verbleibenden Pufferzeit:
                            AufOrder(p+SP) = LstDynR(AKB,AartHelp,HZart,KZart,DLHelp,PositionTracker,o,q);


                            AKB(:,o) = AartHelp(:,find(PositionTracker == AufOrder(p+SP))); % stelle den Auftrag mit der kleinsten Pufferzeit auf den freien Platz im Kommissionierbereich
                            kAKB = LetzterArtikel(AKB);

                            AartHelp(:,find(PositionTracker == AufOrder(p+SP))) = [];       % L�sche den Auftrag mit der geringsten Pufferzeit aus der Matrix der noch zu bearbeitenden Auftr�ge
                            DLHelp(find(PositionTracker == AufOrder(p+SP))) = [];           % L�sche au�erdem die zugeh�rige Deadline...
                            PositionTracker(find(PositionTracker == AufOrder(p+SP))) = [];  % ... und die "Auftragsnummer"

                            AufKB(o) = AufOrder(p+SP);    
                            KBFertig(o) = 0;

                        else
                            % Ansonsten wird der Kommissionierbeh�lter auf 1 gesetzt,
                            % da er alle ben�tigten Artikel enth�lt
                            kAKB(o) = m; 
                            KBFertig(o) = 1;
                        end
                    end
                end
                % Die neueMatrix �bersetzt die aktuellen Auftr�ge im KB 
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
            end
            
%%%
%%% DYNAMISCH:
%%%

        case 'D'
            
            while p < n-AnzKeinDL % Bis alle Auftr�ge abgearbeitet sind

                if p == 0 % Initialisierung: (p == 0 hei�t, dass noch kein Auftrag abgeschlossen wurde)
                    AKB = A(:,AufKB);
                    % berechne f�r AKB die neue Artikelreihenfolge:
                    BZ = Bearbeitungszeit(AKB,HZ,KZ);
                    HA = Haufigkeit(AKB);
                    switch ArtVerfIndex
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

                end

                % ordne AKB nach der aktuellen Artikelreihenfolge und bestimme
                % den letzten Artikel eines jeden Auftrags im
                % Kommissionierbereich:
                AKB = SortArt(AKB,ArtOrder);
                kAKB = LetzterArtikel(AKB);
                % falls ein fertiger Artikel in AKB ist (kAKB == 0), setze dessen
                % letzten Artikel auf den letzten m�glichen Aritkel ( = m):
                kAKB(find(kAKB == 0)) = m; %#ok<FNDSB>

                % Da nur die Auftragsreihenfolge z�hlt, werden jetzt alle 
                % Artikel gleichzeitig geholt, bis der erste Auftrag im
                % Kommissionierbereich fertig gestellt ist:
                AKB(1:min(kAKB),:) = 0;

                % Die Auftr�ge die in diesem Schritt fertiggestellt werden, 
                % aus der weiteren Berechnung ausschlie�en und einen neuen
                % Kommissionierbeh�lter f�r einen neuen Auftrag bereitstellen
                for o = 1:SP
                    if ((sum(AKB(:,o))==0) && (KBFertig(o)==0))
                        p = p+1;
                        % Wenn noch genug Auftr�ge "da" sind wird die Reihenfolge der
                        % Auftr�ge um einen verschoben
                        if (p+SP) <= n-AnzKeinDL
                            % bringe die Matrix AKB wieder in topologische 
                            % Artikelreihenfolge: 
                            
                            AKBtemp = AKB;
                            AKB(ArtOrder,:) = AKBtemp;
                            
                            % DYNAMISCHE BESTIMMUNG des n�chsten Auftrages nach 
                            % der verbleibenden Pufferzeit:  
                            [AufOrder(p+SP),neueArtR] = LstDynD(AKB,A,HZ,KZ,DL,PositionTracker,o,ArtVerfIndex);

                            AKB(:,o) = A(:,AufOrder(p+SP)); % stelle den Auftrag mit der kleinsten Pufferzeit auf den freien Platz im Kommissionierbereich
                            AufKB(o) = AufOrder(p+SP);
                            PositionTracker(find(PositionTracker == AufOrder(p+SP))) = [];  % l�sche aus dem Vektor der noch zu bearbeitenden Auftr�ge die Auftragsnummer des Auftrags, der jetzt bearbeitet wird
                            KBFertig(o) = 0;
                            % die Artikelreihenfolge wurde bereits in LstDynD
                            % mit berechnet:
                            ArtOrder = neueArtR;
                        else
                            % Ansonsten wird der Kommissionierbeh�lter auf 1 gesetzt,
                            % da er alle ben�tigten Artikel enth�lt
                            KBFertig(o) = 1;
                            ArtOrder = [1:m];
                        end
                    end
                end
            end
            
    end
end

%% Stelle die Auftr�ge mit unendlich gro�er Deadline hinten an und ordne sie nach einem anderen Verfahren

if AnzKeinDL > 0
    AufOrder(n-AnzKeinDL+1:n) = KeinDL;
    switch VerfOhneDL

       case 'Topo' % bestimme die Reihenfolge der Auftr�ge ohne DL nach topologischer Reihenfolge

           return; % Auftr�ge ohne Deadline sind bereits topologisch geordnet

       case 'MinSFSZ' % bestimme die Reihenfolge der Auftr�ge mit unendlich gro�er DL nach aufsteigendem spez. Fertigstellungszeitpunkt

           BZtemp = Bearbeitungszeit(A(:,KeinDL),HZ,KZ); % BZtemp: die aktualisierte Bearbeitungszeit der Teilmatrix, welche aus den Auftr�gen ohne Deadline besteht.
           hilf = MinSFSZ(A(:,KeinDL),HZ,KZ,BZtemp,StartArtOrder); % Die Reihenfolge wird in der Variablen 'hilf' gespeichert
           clear BZtemp;

       case 'MaxSFSZ' % bestimme die Reihenfolge der Auftr�ge mit unendlich gro�er DL nach absteigendem spez. Fertigstellungszeitpunkt

           BZtemp = Bearbeitungszeit(A(:,KeinDL),HZ,KZ); % BZtemp: die aktualisierte Bearbeitungszeit der Teilmatrix, welche aus den Auftr�gen ohne Deadline besteht.
           hilf = MaxSFSZ(A(:,KeinDL),HZ,KZ,BZtemp,StartArtOrder); % Die Reihenfolge wird in der Variablen 'hilf' gespeichert.
           clear BZtemp;
    end
    
    AufOrder(n-AnzKeinDL+1:n) = SortAuf(AufOrder(n-AnzKeinDL+1:n),hilf); % ordne den letzten Teil von AufOrder (den Teil mit unendlich gro�er DL) nach der Reihenfolge, die soeben bestimmt wurde (in 'hilf' gespeichert) --> der Teil von AufOrder ohne DL = dem nach der Auftragsreihenfolge 'hilf' geordneten Teil von AufOrder ohne DL
end

end
% der Zusatz 'auf' bedeutet: 'nach der Auftragsreihenfolge geordnet' Bsp.:
% Aauf = nach der Auftragsreihenfolge geordnete Zuweisungsmatrix A
% der Zusatz 'art' bedeutet: 'nach der Artikelreihenfolge geordnet'