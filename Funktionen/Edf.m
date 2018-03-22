function [aDA] = Edf(A,HZ,KZ,BZ,DL,ArtOrder,VerfOhneDL)
%
% [aDA] = <strong>Edf</strong>(A,DL)
%
% Auftragsreihenfolgeverfahren:
% 
% Sortiert die Auftragsreihenfolge nach aufsteigender Deadline. Au�erdem
% werden Auftr�ge ohne Deadline am Ende der Auftragsreihenfolge nach
% eigenen Kriterien sortiert.
%
% Parameter:
%
%   Eingabe:    A:  Zuweisungsmatrix (mxn Matrix) mit nachgefragten St�ckzahlen [ME]
%                   von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%               HZ: Holzeit [ZE]
%               KZ: Kommissionierzeit [ZE/ME]
%               BZ: Bearbeitungszeit [ZE]
%               DL: Deadlines [ZE]
%               ArtOrder: Artikelreihenfolge
%               VerfOhneDL: String zur Bestimmung des Auftragsreihenfolgeverfahrens,
%                           das auf Auftr�ge ohne Deadline angewendet werden soll.
%                           M�gliche Strings: "Topo", "MinSFSZ", "MaxSFSZ"
%   Ausgabe:    aDA: nach aufsteigender Deadline sortierte Auftragsreihenfolge

%% Initialisierung

n = size(A,2);
aDA  = zeros(1,n);

%% Ordne nach auf-/absteigendem spez. Fertigstellungszeitpunkt bzw. topologisch (Sekund�rkriterium)

switch VerfOhneDL
    case 'Topo'
        aDA = 1:n; % bestimme die Reihenfolge der Auftr�ge topologisch
    case 'MinSFSZ'
        aDA = MinSFSZ(A,HZ,KZ,BZ,ArtOrder); % bestimme die Reihenfolge der Auftr�ge nach aufst. spez. Fertigstell.zeitp.
    case 'MaxSFSZ'
        aDA = MaxSFSZ(A,HZ,KZ,BZ,ArtOrder); % bestimme die Reihenfolge der Auftr�ge nach abst. spez. Fertigstell.zeitp.
end

%% Sortiere die Auftragsreihenfolge nach aufsteigender Deadline

DLtemp = SortAuf(DL.',aDA); % DLtemp: nach Sekund�rkriterium sortierter Vektor der Deadlines
aDAtemp = Deadsort(1:n,DLtemp); % aDAtemp: nach aufsteigender Deadline sortierter Vektor der Deadlines 
aDA = SortAuf(aDA,aDAtemp); % Sortiere den nach Sekund�rkriterium sortierten Vektor der Auftr�ge nach aDA temp

%% alte Versionen:
%
%%Falls Auftr�ge ohne Deadline gefunden wurden, ordne diese nach einem anderem Verfahren
%
% AnzKeinDL = sum(isinf(DL)); % AnzDL = Anzahl an Auftr�gen ohne Deadline
% if AnzKeinDL > 0  % wenn es Auftr�ge ohne Deadline gibt...
% %     n = size(A,2);
% %     hilf = Minsort(aDA((n-AnzKeinDL+1):n),aDA((n-AnzKeinDL+1):n));  % ...dann bestimme die Reihenfolge dieser Auftr�ge topologisch
% %     aDA((n-AnzKeinDL+1):n) = hilf;  
%     %Aauf = SortAuf(A,aDA); % ordne die Zuweisungsmatrix A nach der Auftragsreihenfolge
%     
%     switch VerfOhneDL
%         case 'Topo'
%             return
%         case 'MinSFSZ'
%             BZaktuell = Bearbeitungszeit(A(:,(n-AnzKeinDL+1):n),HZ,KZ);  %BZaktuell berechnet die neuen Bearbeitungszeiten, wenn nur die Auftr�ge ohne DL betrachtet werden
%             AufOhneDL = MinSFSZ(A(:,(n-AnzKeinDL+1):n),HZ,KZ,BZaktuell,ArtOrder); % ...dann bestimme die Reihenfolge dieser Auftr�ge nach aufst. spez. Fertigstell.zeitp.
%             clear BZaktuell;
%         case 'MaxSFSZ'
%             BZaktuell = Bearbeitungszeit(A(:,(n-AnzKeinDL+1):n),HZ,KZ);  %BZaktuell berechnet die neuen Bearbeitungszeiten, wenn nur die Auftr�ge ohne DL betrachtet werden
%             AufOhneDL = MaxSFSZ(A(:,(n-AnzKeinDL+1):n),HZ,KZ,BZaktuell,ArtOrder); % ...dann bestimme die Reihenfolge dieser Auftr�ge nach abst. spez. Fertigstell.zeitp.
%             clear BZaktuell;
%     end
%     
%     aDA(n-AnzKeinDL+1:n) = SortAuf(aDA((n-AnzKeinDL+1):n),AufOhneDL); % ordne den Teil der Auftragsserie ohne Deadline nach der soeben bestimmten Reihenfolge ('hilf') 
%     
% end

% hilf = Reihenfolge, in der die Auftr�ge, die keine Deadline besitzen, angeordnet werden sollen.
% aDAhilf = nach der Reihenfolge, die in "hilf" bestimmt wurde, angeordnete Auftr�ge.
% for-Schleife = �berschreibt die Auftr�ge ohne Deadline in der Ausgabevariable "aDA" mit den Auftr�gen in "aDAhilf".
end