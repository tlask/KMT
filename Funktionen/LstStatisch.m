function [AufOrder] = LstStatisch(A,HZ,KZ,BZ,DL,ArtOrder,VerfOhneDL)
%
% [AufOrder] = <strong>LstStatisch</strong>(A,HZ,KZ,BZ,DL,ArtOrder,VerfOhneDL)
%
% Auftragsreihenfolgeverfahren:
%   Anordnung nach aufsteigenden Pufferzeit.
%
% Parameter:
%
%   Eingabe:    A:  Zuweisungsmatrix (mxn Matrix) mit nachgefragten Stückzahlen [ME]
%                   von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%               HZ: Holzeit [ZE]
%               KZ: Kommissionierzeit [ZE/ME]
%               BZ: Bearbeitungszeit [ZE]
%               DL: Deadliine [ZE]
%               ArtOrder: Artikelreihenfolge
%               VerfOhneDL: String zur Bestimmung des Auftragsreihenfolgeverfahrens,
%                           das auf Aufträge ohne Deadline angewendet werden soll.
%   Ausgabe:    AufOrder: nach aufsteigender statischer Pufferzeit
%                         geordnete Auftragsreihenfolge

%% Initialisierung

n = size(A,2);
AufOrder=zeros(1,n);

%% Berechne die Pufferzeit (Slacktime)

Aart = SortArt(A,ArtOrder);
BZart = SortArt(BZ,ArtOrder);
HZart = SortArt(HZ,ArtOrder);
KZart = SortArt(KZ,ArtOrder);
k = LetzterArtikel(Aart);

Cs = spezifiziertenFertigstellungszeitpunkt(BZart,k,Aart,HZart,KZart);
St = DL - Cs.'; % St = slack time = Pufferzeit

%% Ordne nach auf-/absteigendem spez. Fertigstellungszeitpunkt bzw. topologisch (Sekundärkriterium)

switch VerfOhneDL
    case 'Topo'
        AufOrder = 1:n;
    case 'MinSFSZ'
        AufOrder = Minsort(1:1:n,Cs); % bestimme die Reihenfolge der Aufträge nach aufst. spez. Fertigstell.zeitp.
    case 'MaxSFSZ'
        AufOrder = Maxsort(1:1:n,Cs); % bestimme die Reihenfolge der Aufträge nach abst. spez. Fertigstell.zeitp.
end

%% Ordne nach aufsteigender Pufferzeit (Slacktime)

StHelp = SortAuf(St.',AufOrder); % StHelp = Slacktime-Vektor, geordnet nach auf-/absteigendem spez. Fertigstellungszeitp. bzw. topologisch
AufOrderSt = zeros(1,n); % AufOrderSt = Auftragsreihenfolge, geordnet nach aufsteigender Pufferzeit

for i = 1:size(A,2)
    x = find(StHelp==max(StHelp),1,'last'); % Findet die Stelle, wo das Maximum ist; bei Mehreren wird das Letzte gewählt
    StHelp(x) = -Inf; % Fügt an der Stelle des Maximums eine große negative Zahl ein
    AufOrderSt(n-i+1) = x; % Stellt das Maximum an die i-te Stelle der Lösung von hinten!
end

AufOrder = SortAuf(AufOrder,AufOrderSt);

end
%% alte Versionen

% %% Berechne die Pufferzeit (Slacktime)
% 
% Aart = SortArt(A,ArtOrder);
% BZart = SortArt(BZ,ArtOrder);
% HZart = SortArt(HZ,ArtOrder);
% KZart = SortArt(KZ,ArtOrder);
% k = LetzterArtikel(Aart);
% 
% Cs = spezifiziertenFertigstellungszeitpunkt(BZart,k,Aart,HZart,KZart);
% St = DL - Cs.'; % St = slack time
% 
% %% Ordne nach aufsteigender Pufferzeit (Slacktime)
% 
% StHelp = St;
% for i = 1:n
%     x = find(StHelp==min(StHelp),1);    % Findet die Stelle, wo das Minimums ist; bei Mehreren wird das Erste gewählt
%     StHelp(x) = Inf;                    % Fügt an der Stelle des Minimums eine große positive Zahl ein
%     AufOrder(i) = x;                    % Stellt das Minimum an die i-te Stelle der Lösung
% end
% clear StHelp;
% 
% %% Ermittle die Anzahl an Aufträgen ohne Deadline
% 
% AnzKeinDL = 0;
% for i = 1:n                            % for-Schleife überprüft, ob Aufträge ohne Deadline (DL == 0) vorhanden sind.
%     if Cs(i) + St(i) == 0                   % Wenn ein Auftrag in der AufR eine DL von 0 hat (zuvor wurde St = DL - Cs gerechnet)...
%         hilf = find(AufOrder==i);           %
%         for j = hilf:n-1                    %
%             AufOrder(j) = AufOrder(j+1);    % ...wird er aus der AufR entnommen und hinten angestellt
%         end                                 %
%         AufOrder(n) = i;                    %
%         clear hilf;                         %
%         AnzKeinDL = AnzKeinDL + 1;          %
%     end
% end
% 
% %% Falls Aufträge ohne Deadline gefunden wurden, ordne diese nach einem anderem Verfahren
% 
% 
% if AnzKeinDL > 0  % wenn es Aufträge ohne Deadline gibt...
%    
%     hilf = Minsort(AufOrder((n-AnzKeinDL+1):n),AufOrder((n-AnzKeinDL+1):n));    % Ordne den Teil der Auftragsreihenfolge ohne Deadline nach sich selbst --> aufsteigende Reihenfolge = topologisch
%     AufOrder((n-AnzKeinDL+1):n) = hilf;
%     Aauf = SortAuf(A,AufOrder);
% 
%     switch VerfOhneDL
%     case 'Topo'                                                                     % ...dann bestimme die Reihenfolge dieser Aufträge nach einem bereits bekannten Verfahren (hier: topologische Reihenfolge)
%         %hilf = Minsort(AufOrder((n-AnzKeinDL+1):n),AufOrder((n-AnzKeinDL+1):n));    % Ordne den Teil der Auftragsreihenfolge ohne Deadline nach sich selbst --> aufsteigende Reihenfolge = topologisch
%         %AufOrder((n-AnzKeinDL+1):n) = hilf;
%         return
%     case 'MinSFSZ'                                                          % ...dann bestimme die Reihenfolge dieser Aufträge nach einem bereits bekannten Verfahren (hier: nach aufst. spez. Fertigstell.zeitp.)
%         BZtemp = Bearbeitungszeit(Aauf(:,(n-AnzKeinDL+1):n),HZ,KZ);         % BZtemp: die aktualisierte Bearbeitungszeit der Teilmatrix, welche aus den Aufträgen ohne Deadline besteht.
%         hilf = MinSFSZ(Aauf(:,(n-AnzKeinDL+1):n),HZ,KZ,BZtemp,ArtOrder);    % Die Reihenfolge wird in der Variablen 'hilf' gespeichert.
%         clear BZtemp;
%     case 'MaxSFSZ'                                                          % ...dann bestimme die Reihenfolge dieser Aufträge nach einem bereits bekannten Verfahren (hier: nach abst. spez. Fertigstell.zeitp.)
%         BZtemp = Bearbeitungszeit(Aauf(:,(n-AnzKeinDL+1):n),HZ,KZ);         % BZtemp: die aktualisierte Bearbeitungszeit der Teilmatrix, welche aus den Aufträgen ohne Deadline besteht.
%         hilf = MaxSFSZ(Aauf(:,(n-AnzKeinDL+1):n),HZ,KZ,BZtemp,ArtOrder);    % Die Reihenfolge wird in der Variablen 'hilf' gespeichert.
%         clear BZtemp;                                                       % 
%     end
%     
%     AufOrder(n-AnzKeinDL+1:n) = SortAuf(AufOrder((n-AnzKeinDL+1):n),hilf); % Ordne den letzten Teil von AufOrder nach der Reihenfolge, die soeben bestimmt wurde (in 'hilf' gespeichert) --> der Teil von AufOrder ohne DL = dem nach der Auftragsreihenfolge 'hilf' geordneten Teil von AufOrder ohne DL
% end
% 
% %% Ermittle die Anzahl an Aufträgen ohne Deadline 
% 
% AnzKeinDL = 0;
% AufOhneDL = 0;
% PositionTracker = 1:n; %wird benötigt, falls Aufträge ohne Deadline existieren
% 
% for i = 1:n % for-Schleife überprüft, ob Aufträge ohne Deadline (DL == 0) vorhanden sind.
%     if DL(i) == Inf % wenn ein Auftrag in der AufR eine DL von 0 hat...  
%         AufOhneDL(AnzKeinDL+1) = i; % wird der Auftrag in der Variabloen 'AufOhneDL' gespeichert.
%         AnzKeinDL = AnzKeinDL + 1; % außerdem wird die Anzahl der Aufträge ohne DL festgehalten.
%     end
% end
% 
% %% Falls Aufträge ohne Deadline gefunden wurden, lösche diese aus der Zuweisungsmatrix A und ordne sie nach einem anderem Verfahren.
% 
% if AnzKeinDL > 0
%     
%     AOhneDL = A(:,AufOhneDL); % speichere die Aufträge ohne DL in einer separaten Matrix 'AOhneDL'
%     A(:,AufOhneDL) = [];  % lösche die Aufträge ohne Deadline aus der Matrix A
%     DL(AufOhneDL) = []; % lösche die zugehörigen Deadlines
%     PositionTracker(AufOhneDL) = []; % der PositionTracker zeigt an, welche Auftragsnummer die Aufträge in A haben (z.B.: 7 Aufträge, Auftrag 4 und 6 haben keine DL und werden aus A gelöscht --> Die Aufträge in A sind Auftrag 1,2,3,5 und 7. Diese Information wird in 'PositionTracker' gespeichert
%     switch VerfOhneDL
%         
%         case 'Topo' % bestimme die Reihenfolge der Aufträge ohne DL nach topologischer Reihenfolge
%             
%             hilf = 1:AnzKeinDL; % Die Reihenfolge wird in der Variablen 'hilf' gespeichert
%         
%         case 'MinSFSZ' % bestimme die Reihenfolge der Aufträge ohne DL nach aufsteigendem spez. Fertigstellungszeitpunkt
%             
%             BZtemp = Bearbeitungszeit(AOhneDL,HZ,KZ); % BZtemp: die aktualisierte Bearbeitungszeit der Teilmatrix, welche aus den Aufträgen ohne Deadline besteht.
%             hilf = MinSFSZ(AOhneDL,HZ,KZ,BZtemp,ArtOrder); % Die Reihenfolge wird in der Variablen 'hilf' gespeichert
%             clear BZtemp;
%         
%         case 'MaxSFSZ' % bestimme die Reihenfolge der Aufträge ohne DL nach absteigendem spez. Fertigstellungszeitpunkt
%             
%             BZtemp = Bearbeitungszeit(AOhneDL,HZ,KZ); % BZtemp: die aktualisierte Bearbeitungszeit der Teilmatrix, welche aus den Aufträgen ohne Deadline besteht.
%             hilf = MaxSFSZ(AOhneDL,HZ,KZ,BZtemp,ArtOrder); % Die Reihenfolge wird in der Variablen 'hilf' gespeichert.
%             clear BZtemp;
%     end
%     
%     AufOrder(n-AnzKeinDL+1:n) = SortAuf(AufOhneDL,hilf); % ordne den letzten Teil von AufOrder (den Teil ohne DL) nach der Reihenfolge, die soeben bestimmt wurde (in 'hilf' gespeichert) --> der Teil von AufOrder ohne DL = dem nach der Auftragsreihenfolge 'hilf' geordneten Teil von AufOrder ohne DL
% 
% end

% switch VerfOhneDL
%     case 'Topo'
%         AufOrder = 1:n;
%     case 'MinSFSZ'
%         AufOrder = Minsort(1:1:n,Cs); % bestimme die Reihenfolge der Aufträge nach aufst. spez. Fertigstell.zeitp.
%     case 'MaxSFSZ'
%         AufOrder = Maxsort(1:1:n,Cs); % bestimme die Reihenfolge der Aufträge nach abst. spez. Fertigstell.zeitp.
% end

% %% Finde heraus, ob Aufträge mit unendlich hoher Deadline existieren. Wenn  ja, ordne sie nach einem anderen Verfahren
% 
% AnzKeinDL = sum(isinf(DL));
% if AnzKeinDL > 0
%     
%    switch VerfOhneDL
%         
%         case 'Topo' % bestimme die Reihenfolge der Aufträge ohne DL nach topologischer Reihenfolge
%             
%             return; % Aufträge ohne Deadline sind bereits topologisch geordnet
%         
%         case 'MinSFSZ' % bestimme die Reihenfolge der Aufträge mit unendlich großer DL nach aufsteigendem spez. Fertigstellungszeitpunkt
%             
%             BZtemp = Bearbeitungszeit(A(:,n-AnzKeinDL+1:n),HZ,KZ); % BZtemp: die aktualisierte Bearbeitungszeit der Teilmatrix, welche aus den Aufträgen ohne Deadline besteht.
%             hilf = MinSFSZ(A(:,n-AnzKeinDL+1:n),HZ,KZ,BZtemp,ArtOrder); % Die Reihenfolge wird in der Variablen 'hilf' gespeichert
%             clear BZtemp;
%         
%         case 'MaxSFSZ' % bestimme die Reihenfolge der Aufträge mit unendlich großer DL nach absteigendem spez. Fertigstellungszeitpunkt
%             
%             BZtemp = Bearbeitungszeit(A(:,n-AnzKeinDL+1:n),HZ,KZ); % BZtemp: die aktualisierte Bearbeitungszeit der Teilmatrix, welche aus den Aufträgen ohne Deadline besteht.
%             hilf = MaxSFSZ(A(:,n-AnzKeinDL+1:n),HZ,KZ,BZtemp,ArtOrder); % Die Reihenfolge wird in der Variablen 'hilf' gespeichert.
%             clear BZtemp;
%             
%     end
%     
%     AufOrder(n-AnzKeinDL+1:n) = SortAuf(AufOrder(n-AnzKeinDL+1:n),hilf); % ordne den letzten Teil von AufOrder (den Teil ohne DL) nach der Reihenfolge, die soeben bestimmt wurde (in 'hilf' gespeichert) --> der Teil von AufOrder ohne DL = dem nach der Auftragsreihenfolge 'hilf' geordneten Teil von AufOrder ohne DL
% 
% end

% StHelp = St;
% for i = 1:size(A,2)
%     x = find(StHelp==min(StHelp),1);    % Findet die Stelle, wo das Minimums ist; bei Mehreren wird das Erste gewählt
%     StHelp(x) = Inf;                    % Fügt an der Stelle des Minimums eine große positive Zahl ein
%     AufOrder(i) = PositionTracker(x);   % Stellt das Minimum an die i-te Stelle der Lösung
% end
% clear StHelp;

% der Zusatz 'auf' bedeutet: 'nach der Auftragsreihenfolge geordnet' Bsp.:
% Aauf = nach der Auftragsreihenfolge geordnete 
% der Zusatz 'art' bedeutet: 'nach der Artikelreihenfolge geordnet'