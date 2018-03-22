function [aDA] = Deadsort(AufR,DL)
%
% [aDa] = <strong>Deadsort</strong>(AufR,DL)
%
% Sortiert eine Auftragreihenfolge nach aufsteigender Deadline. Auftr�ge
% ohne Deadline werden ans Ende der Auftragsreihenfolge gestellt.
%
% Parameter:
%
%   Eingabe:    AufR:       Auftragsreihenfolge
%               DL:         Deadlines [ZE]
%   Ausgabe:    aDA:        nach aufsteigender Deadline sortierte Auftragsreihenfolge
%               AnzKeinDL:  Anzahl der Auftr�ge ohne Deadline

%% Initialisierung

n = length(AufR);
aDA = zeros(1,n);

%% Ordne die Auftragsreihenfolge nach aufsteigender Deadline

DLtemp = DL;                            
for i = 1:n
    x = find(DLtemp==max(DLtemp),1,'last');    % Findet die Stelle, wo das Maximum ist; bei mehrere wird das Letzte gew�hlt.
    DLtemp(x) = -Inf;    % F�gt an der Stelle des Maximums eine sehr kleine Zahl ein (-Inf).
    aDA(n-i+1) = AufR(x);   % Stellt das Maximum an die i-te Stelle der L�sung (von hinten!).
end
clear DLtemp;

%% alte Versionen:
% DLtemp = DL;                            
% for i = 1:n
%     x = find(DLtemp==min(DLtemp),1);    % Findet die Stelle, wo das Minimum ist; bei mehrere wird das Erste gew�hlt
%     
%     if DLtemp(x) == Inf     % Falls die Deadline an dieser Stelle == Inf ist, sind alle Auftr�ge ohne Deadline geordnet und die Schleife kann verlassen werden
%         break
%     end
%     DLtemp(x) = Inf;    % F�gt an der Stelle des Minimums eine sehr gro�e Zahl ein (Inf)
%     aDA(i) = AufR(x);   % Stellt das Minimum an die i-te Stelle der L�sung
% end
% clear DLtemp;

% %% Falls Auftr�ge ohne Deadline existieren, bestimme deren Anzahl und stelle diese ans Ende der Auftragsreihenfolge
% 
% for i = 1:n
%    
%     if DL(i) == Inf % wenn ein Auftrag in der AufR eine DL von Inf hat...  
%        
%         AufOhneDL(AnzKeinDL+1) = i; % wird der Auftrag in der Variablen 'AufOhneDL' gespeichert.
%         AnzKeinDL = AnzKeinDL + 1;  % au�erdem wird die Anzahl der Auftr�ge ohne DL festgehalten.
%     end 
% end
% 
% aDA(n-AnzKeinDL+1:n)=AufOhneDL; % Stelle die Auftr�ge ohne Deadline ('AufOhneDL') ans Ende der Auftragsserie
% 
% % Anmerkung: Auftr�ge mit einer unendlich gro�en Deadline sind somit
% % automatisch in topologischer Reihenfolge!


%% Alte Version

% DLtemp = DL;                            
% for i = 1:n                             % 
%     x = find(DLtemp==max(DLtemp),1);    % Findet die Stelle, wo das Maximum ist; bei mehrere wird das Erste gew�hlt, allerdings ist es f�r die Ausgabe das Letzte (siehe Z.23)
%     DLtemp(x) = -1;                     % F�gt an der Stelle des Maximums eine negative Zahl ein
%     aDA(n-i+1) = AufR(x);               % Stellt das Maximum an die i-te Stelle der L�sung (von Hinten!)
% end                                     % ACHTUNG: Durch Zeile 23 wird bei mehreren Maxima in DL f�r die Ausgabe das letzte gew�hlt!
% clear DLtemp;


% for i = 1:n                     % for-Schleife �berpr�ft, ob Auftr�ge ohne Deadline (DL == 0) vorhanden sind.
%     if DL(aDA(1)) == 0          % Wenn der erste Auftrag in der AufR eine DL von 0 hat...
%         help1 = aDA(1);         %%
%         for j = 1:n-1           %
%             aDA(j) = aDA(j+1);  % ...wird er aus der AufR vorne entnommen und hinten angestellt
%         end                     %
%         aDA(n) = help1;         %
%         clear help1;            %%
%         AnzKeinDL = AnzKeinDL + 1;
%     else                        % falls der erste Auftrag in der AufR eine DL hat (DL != 0),
%         break;                  % haben durch die for-Schleife in Z.18ff automatisch auch alle anderen Auftr�ge eine DL
%     end                         % -> weitere �berpr�fung ist nicht notwendig
% end

end