function [AnzAusNeu] = speichern(Titel,Ausgabe,AusgabedateiExcel,AnzAus,AusgabedateiMat)
%
% [AnzAusNeu] = <strong>speichern</strong>(Titel,Ausgabe,AusgabedateiExcel,AnzAus,AusgabedateiMat)
% 
% Speichert die Daten in einer XLSX-Datei und in einer MAT-Datei ab.
%
% Parameter:
%   Titel: �berschriften der zu speichernden Daten
%   Ausgabe: die zu speichernden Daten
%   AusgabedateiExcel: Name der XLSX-Datei
%   AnzAus: Tabellenblattnummer
%   AusgabedateiMat: Name der MAT-Datei
%   AnzAusNeu: n�chste Tabellenblattnummer


warten = msgbox('Speichervorgang l�uft...','Info');
warten_elem = get(warten,'Children');
set(warten_elem,'Visible','off'); % OK-Button l�schen (geht noch nicht)


aus = size(Ausgabe,1);

for i=1:aus
    if strcmp(Ausgabe{i,3},'<html><body bgcolor="#00CC07">0</body></html>')
        Ausgabe{i,3} = 0;
    end
end

Ausgabepath = 'Ausgabe/';

AusgabeExcel = [Ausgabepath AusgabedateiExcel];

% Pr�fen ob die xlsx-Datei existiert
if exist(AusgabeExcel) > 0 %#ok<EXIST> unterdr�ckt die Fehlermeldung
    % im ersten Durchlauf pr�fen, ab wo das Excel Dokument beschrieben werde sollte
    if AnzAus == 1
        [status,sheets] = xlsfinfo(AusgabeExcel); %#ok<ASGLU> unterdr�ckt die Fehlermeldung, dass die Variable status nicht benutzt wird
        AnzAus = str2double(sheets{end}(8:end)) + 1; % Zu den bereits bestehenden Tabellenbl�tter wird eins dazu genommen
    end
end
% In der xlsx-Datei speichern
status_t = xlswrite(AusgabeExcel,Titel,AnzAus,'A1');
status_d = xlswrite(AusgabeExcel,Ausgabe,AnzAus,'A2');

% In der mat-Datei speichern
AusgabeMat = [Ausgabepath AusgabedateiMat];
Daten = [Titel ; Ausgabe]; %#ok<NASGU> unterdr�ckt die Fehlermeldung, dass die Variable Daten nicht genutzt wird
save(AusgabeMat,'Daten')

if status_t == 0 || status_d == 0
    errordlg('Speichern der Datei fehlgeschlagen.','Speicher Fehler') 
end

if status_t == 1 || status_d == 1
    msgbox(['Die Daten wurden in der Datei ' AusgabedateiExcel ' in dem Tabellenblatt ' int2str(AnzAus) ' und in der Datei ' AusgabedateiMat ' gespeichert'],'Info') 
end

AnzAusNeu = AnzAus+1; % Z�hlt hoch damit immer ein neus Tabellenblatt beschrieben wird

delete(warten); % Damit das 'Bitte warten' Fenster geschlossen wird


end