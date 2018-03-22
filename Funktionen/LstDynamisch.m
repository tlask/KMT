function [AufOrder] = LstDynamisch(A,HZ,KZ,BZ,DL,SP,StartArtOrder,VerfOhneDL,ArtVerf,ArtVerfIndex)
%
% [AufOrder] = <strong>LST</strong>(A,HZ,KZ,BZ,ArtOrder)
%
% Auftragsreihenfolgeverfahren:
%   Anordnung nach aufsteigenden Pufferzeit.
%
% Parameter:
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten Stückzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftr=g Aj (j = 1...n)
%   HZ: Holzeit [ZE]
%   KZ: Kommissionierzeit [ZE/ME]
%   BZ: Bearbeitungszeit [ZE]
%   DL: Deadliine [ZE]
%   SP: Anzahl Stellplätze     
%   StartArtOrder: Artikelreihenfolge
%   VerfOhneDL: String zur Bestimmung des Auftragsreihenfolgeverfahrens,
%               das auf Aufträge mit unendlich großer Deadline anzuwenden ist
%   ArtVerf: String zur Bestimmung des Artikelreihenfolgeverfahrens.
%            Auswahlmöglichkeiten: "H","R" und "D"
%   ArtVerfIndex: gibt die Nummer des zu verwendenden Artikelreihenfolge- 
%                 verfahrens an (wird nur benötigt, falls ArtVerf == 'D')
%   AufOrder: Auftragsreihenfolge


%% Initialisierung

n = size(A,2);
AufOrder = zeros(1,n);
PositionTracker = 1:n;
AnzKeinDL = sum(isinf(DL)); % Anzahl an Aufträgen mit unendlich großer DL

%% Berechne die Pufferzeit (Slacktime) statisch

Aart = SortArt(A,StartArtOrder);
BZart = SortArt(BZ,StartArtOrder);
HZart = SortArt(HZ,StartArtOrder);
KZart = SortArt(KZ,StartArtOrder);
k = LetzterArtikel(Aart);

Cs = spezifiziertenFertigstellungszeitpunkt(BZart,k,Aart,HZart,KZart);
St = DL - Cs.'; % St = slack time

%% Teste auf den Sonderfall, dass die Anzahl der Stellplätze größer gleich der Anzahl an Aufträge mit endlicher Deadline ist (erspart Rechenzeit)

AartHelp = Aart; % AartHelp, DLHelp werden später zur dynamischen Bestimmung des nächstesn Auftrags benötigt
DLHelp = DL;     % AartHelp = Alle noch zu bearbeitenden Aufträge in Aart. DLHelp: die dazugehörigen Deadlines

if n - AnzKeinDL <= SP % Unterscheide den Sonderfall: SP ist kleiner als die Anzahl an Aufträge mit DL < Inf
    AufMitDL = (1:n).* ~(isinf(DL.')); % bestimme alle Aufträge, die eine Deadline haben
    AufMitDL(AufMitDL == 0) = [];
    
    AufOrder(1:length(AufMitDL)) = AufMitDL; % stelle die Aufträge mit Deadline auf die Stellplätze (Reihenfolge egal, da SP > #Aufträge mit DL < Inf
    
    KeinDL = (1:n).*isinf(DL.'); % speichere Aufträge mit DL == Inf in 'KeinDL'
    KeinDL(KeinDL==0) = [];
   
else
    %% Ordne nach aufsteigender statischer Pufferzeit (Slacktime) und nehme für X Stellplätze die ersten X Aufträge (mit der niedrigsten Pufferzeit)

    for i = 1:SP
        x = find(St==min(St),1); % Findet die Stelle, wo das Minimums ist; bei Mehreren wird das Erste gewählt
        St(x) = Inf; % Fügt an der Stelle des Minimums eine große positive Zahl ein
        AufOrder(i) = x;   % Stellt das Minimum an die i-te Stelle der Lösung
    end
    
    % Entferne die Aufträge aus AartHelp, DLHelp und PositionTracker, die 
    % auf die ersten Stellplätze gestellt werden:
    AartHelp(:,AufOrder(1:SP)) = []; 
    DLHelp(AufOrder(1:SP)) = [];
    PositionTracker(AufOrder(1:SP)) = [];
    
    
    %% Überprüfe, ob Aufträge mit unendlich großer Deadline vorhanden sind; falls ja: speichere diese in 'KeinDL'
    
    if AnzKeinDL > 0
        % bestimme deren Auftragsnummer
        KeinDL = (1:n).*isinf(DL.');
        KeinDL(KeinDL==0) = [];

        % help: an welcher Stelle der Matrix Aarthelp und DLhelp stehen die Aufträge mit unendlich großer Deadline?
        help = zeros(1,AnzKeinDL);
        for i=1:AnzKeinDL
            help(i) = find(PositionTracker == KeinDL(i)); 
        end

        % Entferne die Aufträge aus AartHelp und DLHelp, die eine unendlich 
        % große Deadline haben.
        AartHelp(:,help) = [];    
        DLHelp(help) = [];
        PositionTracker(help) = [];
        clear help
    end

    %% Ordne nach aufsteigender dynamischen Pufferzeit (Slacktime)

    [m,n] = size(A); % Anzahl der Artikel und Aufträge

    % Kommissionierbehälter (KB) im Kommissionierbereich
    % 0 = KB enthält noch nicht alle benötigten Artikel
    % 1 = KB enthält alle benötigten Artikel
    KBFertig = zeros(1,SP);

    khelp = k;
    k(1:SP)=khelp(AufOrder(1:SP));
    k(SP+1:end) = 0;
    clear khelp;

    AKB = Aart(:,AufOrder(1:SP)); % Angepasste Zuweisungsmatrix für die Aufträge im Kommissionierbereich
    AufKB = AufOrder(1:SP); % Aufträge (laut Auftragsreihenfolge) im Kommissionierbereich
    kAKB = k(1:SP); % Letzter Artikel für die Aufträge (laut Auftragsreihenfolge) im Kommissionierbereich

    p = 0; % Anzahl der fertiggestellten Aufträge

    switch ArtVerf

%%%
%%% HIERARCHISCH:
%%%

        case 'H'

            while p < n-AnzKeinDL % Bis alle Aufträge abgearbeitet sind
                
                % Da nur die Auftragsreihenfolge zählt, werden jetzt alle 
                % Artikel gleichzeitig geholt, bis der erste Auftrag im
                % Kommissionierbereich fertig gestellt ist:
                AKB(1:min(kAKB),:) = 0;
                
                % Die Aufträge die in diesem Schritt fertiggestellt werden, 
                % aus der weiteren Berechnung ausschließen und einen neuen
                % Kommissionierbehälter für einen neuen Auftrag bereitstellen
                for o = 1:SP
                    if ((sum(AKB(:,o))==0) && (KBFertig(o)==0))
                        p = p+1;
                        % Wenn noch genug Aufträge "da" sind wird die Reihenfolge der
                        % Aufträge um einen verschoben
                        if (p+SP) <= n-AnzKeinDL 
                            
                            % HIERARCHISCHE BESTIMMUNG des nächsten 
                            % Auftrages nach der verbleibenden Pufferzeit:
                            AufOrder(p+SP) = LstDynH(AKB,AartHelp,HZart,KZart,DLHelp,PositionTracker,o);

                            AKB(:,o) = AartHelp(:,find(PositionTracker == AufOrder(p+SP))); % stelle den Auftrag mit der kleinsten Pufferzeit auf den freien Platz im Kommissionierbereich
                            kAKB = LetzterArtikel(AKB);

                            AartHelp(:,find(PositionTracker == AufOrder(p+SP))) = [];       % Lösche den Auftrag mit der geringsten Pufferzeit aus der Matrix der noch zu bearbeitenden Aufträge
                            DLHelp(find(PositionTracker == AufOrder(p+SP))) = [];           % Lösche außerdem die zugehörige Deadline...
                            PositionTracker(find(PositionTracker == AufOrder(p+SP))) = [];  % ... und die "Auftragsnummer"

                            AufKB(o) = AufOrder(p+SP);    
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

%%%
%%% ROLLIEREND:
%%%
            
        case 'R'


            neuerstart  = 1; 
            letztArt = min(kAKB); 

            while p < n-AnzKeinDL % Bis alle Aufträge abgearbeitet sind
                
                
                 for i = 1:min(letztArt)
                            % q übersetzt die rollierende Artikelreihenfolge
                            % zu Beginn bei 1
                            q = mod(i + (neuerstart - 1), m);
                            if q == 0
                                q = m;
                            end
                            AKB(q,:) = zeros(1,SP);
                 end

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
                        p = p+1;
                        % Wenn noch genug Aufträge "da" sind wird die Reihenfolge der
                        % Aufträge um einen verschoben
                        if (p+SP) <= n-AnzKeinDL


                            % ROLLIERENDE BESTIMMUNG des nächsten Auftrages 
                            % nach der verbleibenden Pufferzeit:
                            AufOrder(p+SP) = LstDynR(AKB,AartHelp,HZart,KZart,DLHelp,PositionTracker,o,q);


                            AKB(:,o) = AartHelp(:,find(PositionTracker == AufOrder(p+SP))); % stelle den Auftrag mit der kleinsten Pufferzeit auf den freien Platz im Kommissionierbereich
                            kAKB = LetzterArtikel(AKB);

                            AartHelp(:,find(PositionTracker == AufOrder(p+SP))) = [];       % Lösche den Auftrag mit der geringsten Pufferzeit aus der Matrix der noch zu bearbeitenden Aufträge
                            DLHelp(find(PositionTracker == AufOrder(p+SP))) = [];           % Lösche außerdem die zugehörige Deadline...
                            PositionTracker(find(PositionTracker == AufOrder(p+SP))) = [];  % ... und die "Auftragsnummer"

                            AufKB(o) = AufOrder(p+SP);    
                            KBFertig(o) = 0;

                        else
                            % Ansonsten wird der Kommissionierbehälter auf 1 gesetzt,
                            % da er alle benötigten Artikel enthält
                            kAKB(o) = m; 
                            KBFertig(o) = 1;
                        end
                    end
                end
                % Die neueMatrix übersetzt die aktuellen Aufträge im KB 
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
            end
            
%%%
%%% DYNAMISCH:
%%%

        case 'D'
            
            while p < n-AnzKeinDL % Bis alle Aufträge abgearbeitet sind

                if p == 0 % Initialisierung: (p == 0 heißt, dass noch kein Auftrag abgeschlossen wurde)
                    AKB = A(:,AufKB);
                    % berechne für AKB die neue Artikelreihenfolge:
                    BZ = Bearbeitungszeit(AKB,HZ,KZ);
                    HA = Haufigkeit(AKB);
                    switch ArtVerfIndex
                        case 1
                            ArtOrder = [1:m]'; %#ok<*NBRAK> unterdrückt die Fehlermeldung, dass die Klammern überflüssig sind
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
                % letzten Artikel auf den letzten möglichen Aritkel ( = m):
                kAKB(find(kAKB == 0)) = m; %#ok<FNDSB>

                % Da nur die Auftragsreihenfolge zählt, werden jetzt alle 
                % Artikel gleichzeitig geholt, bis der erste Auftrag im
                % Kommissionierbereich fertig gestellt ist:
                AKB(1:min(kAKB),:) = 0;

                % Die Aufträge die in diesem Schritt fertiggestellt werden, 
                % aus der weiteren Berechnung ausschließen und einen neuen
                % Kommissionierbehälter für einen neuen Auftrag bereitstellen
                for o = 1:SP
                    if ((sum(AKB(:,o))==0) && (KBFertig(o)==0))
                        p = p+1;
                        % Wenn noch genug Aufträge "da" sind wird die Reihenfolge der
                        % Aufträge um einen verschoben
                        if (p+SP) <= n-AnzKeinDL
                            % bringe die Matrix AKB wieder in topologische 
                            % Artikelreihenfolge: 
                            
                            AKBtemp = AKB;
                            AKB(ArtOrder,:) = AKBtemp;
                            
                            % DYNAMISCHE BESTIMMUNG des nächsten Auftrages nach 
                            % der verbleibenden Pufferzeit:  
                            [AufOrder(p+SP),neueArtR] = LstDynD(AKB,A,HZ,KZ,DL,PositionTracker,o,ArtVerfIndex);

                            AKB(:,o) = A(:,AufOrder(p+SP)); % stelle den Auftrag mit der kleinsten Pufferzeit auf den freien Platz im Kommissionierbereich
                            AufKB(o) = AufOrder(p+SP);
                            PositionTracker(find(PositionTracker == AufOrder(p+SP))) = [];  % lösche aus dem Vektor der noch zu bearbeitenden Aufträge die Auftragsnummer des Auftrags, der jetzt bearbeitet wird
                            KBFertig(o) = 0;
                            % die Artikelreihenfolge wurde bereits in LstDynD
                            % mit berechnet:
                            ArtOrder = neueArtR;
                        else
                            % Ansonsten wird der Kommissionierbehälter auf 1 gesetzt,
                            % da er alle benötigten Artikel enthält
                            KBFertig(o) = 1;
                            ArtOrder = [1:m];
                        end
                    end
                end
            end
            
    end
end

%% Stelle die Aufträge mit unendlich großer Deadline hinten an und ordne sie nach einem anderen Verfahren

if AnzKeinDL > 0
    AufOrder(n-AnzKeinDL+1:n) = KeinDL;
    switch VerfOhneDL

       case 'Topo' % bestimme die Reihenfolge der Aufträge ohne DL nach topologischer Reihenfolge

           return; % Aufträge ohne Deadline sind bereits topologisch geordnet

       case 'MinSFSZ' % bestimme die Reihenfolge der Aufträge mit unendlich großer DL nach aufsteigendem spez. Fertigstellungszeitpunkt

           BZtemp = Bearbeitungszeit(A(:,KeinDL),HZ,KZ); % BZtemp: die aktualisierte Bearbeitungszeit der Teilmatrix, welche aus den Aufträgen ohne Deadline besteht.
           hilf = MinSFSZ(A(:,KeinDL),HZ,KZ,BZtemp,StartArtOrder); % Die Reihenfolge wird in der Variablen 'hilf' gespeichert
           clear BZtemp;

       case 'MaxSFSZ' % bestimme die Reihenfolge der Aufträge mit unendlich großer DL nach absteigendem spez. Fertigstellungszeitpunkt

           BZtemp = Bearbeitungszeit(A(:,KeinDL),HZ,KZ); % BZtemp: die aktualisierte Bearbeitungszeit der Teilmatrix, welche aus den Aufträgen ohne Deadline besteht.
           hilf = MaxSFSZ(A(:,KeinDL),HZ,KZ,BZtemp,StartArtOrder); % Die Reihenfolge wird in der Variablen 'hilf' gespeichert.
           clear BZtemp;
    end
    
    AufOrder(n-AnzKeinDL+1:n) = SortAuf(AufOrder(n-AnzKeinDL+1:n),hilf); % ordne den letzten Teil von AufOrder (den Teil mit unendlich großer DL) nach der Reihenfolge, die soeben bestimmt wurde (in 'hilf' gespeichert) --> der Teil von AufOrder ohne DL = dem nach der Auftragsreihenfolge 'hilf' geordneten Teil von AufOrder ohne DL
end

end
% der Zusatz 'auf' bedeutet: 'nach der Auftragsreihenfolge geordnet' Bsp.:
% Aauf = nach der Auftragsreihenfolge geordnete Zuweisungsmatrix A
% der Zusatz 'art' bedeutet: 'nach der Artikelreihenfolge geordnet'