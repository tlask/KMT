function [AnzAusNeu,Ausgabe] = speichern_plus(Titel,Ausgabe,RechenzeitGesamt,SpeicherPfad,AusgabedateiExcel,AnzAus,AusgabedateiMat)
%
% [AnzAusNeu,Ausgabe] = <strong>speichern_plus</strong>(Titel,Ausgabe,RechenzeitGesamt,SpeicherPfad,AusgabedateiExcel,AnzAus,AusgabedateiMat)
% 
% Speichert die Daten in einer XLSX-Datei und in einer MAT-Datei ab.
%
% Parameter:
%   Titel: Überschriften der zu speichernden Daten
%   Ausgabe: die zu speichernden Daten
%   RechenzeitGesamt: Rechenzeit um alle Verfahren zu berechnen
%   SpeicherPfad: Pfad in dem die Dateien gespeichert werden sollen
%   AusgabedateiExcel: Name der XLSX-Datei
%   AnzAus: Tabellenblattnummer
%   AusgabedateiMat: Name der MAT-Datei
%   AnzAusNeu: nächste Tabellenblattnummer
%   Ausgabe: die gespeichernden Daten (ohne Farbe)


% warten = msgbox('Speichervorgang läuft...','Info');
% warten_elem = get(warten,'Children');
% set(warten_elem,'Visible','off'); % OK-Button löschen (geht noch nicht)

aus = size(Ausgabe,1);

for i=1:aus
    if strcmp(Ausgabe{i,3},'<html><body bgcolor="#00CC07">0</body></html>')
        Ausgabe{i,3} = 0;
    end
end

AusgabeExcel = [SpeicherPfad AusgabedateiExcel];

% Prüfen ob die xlsx-Datei existiert
if exist(AusgabeExcel) > 0 %#ok<EXIST> unterdrückt die Fehlermeldung
    % im ersten Durchlauf prüfen, ab wo das Excel Dokument beschrieben werde sollte
    if AnzAus == 1
        [status,sheets] = xlsfinfo(AusgabeExcel); %#ok<ASGLU> unterdrückt die Fehlermeldung, dass die Variable status nicht benutzt wird
        AnzAus = str2double(sheets{end}(8:end)) + 1; % Zu den bereits bestehenden Tabellenblätter wird eins dazu genommen
    end
end

zelle = ['A' num2str(size(Ausgabe,1)+3)];

% In der xlsx-Datei speichern
status_t = xlswrite(AusgabeExcel,Titel,AnzAus,'A1');
status_d = xlswrite(AusgabeExcel,Ausgabe,AnzAus,'A2');
status_r = xlswrite(AusgabeExcel,{'Gesamte Rechenzeit:',RechenzeitGesamt},AnzAus,zelle);

% In der mat-Datei speichern
AusgabeMat = [SpeicherPfad AusgabedateiMat];
Daten = [Titel ; Ausgabe]; %#ok<NASGU> unterdrückt die Fehlermeldung, dass die Variable Daten nicht genutzt wird
save(AusgabeMat,'Daten','RechenzeitGesamt')

if status_t == 0 || status_d == 0 || status_r == 0
    errordlg('Speichern der Datei fehlgeschlagen.','Speicher Fehler') 
end

% if status_t == 1 || status_d == 1 || status_r == 1
%     msgbox(['Die Daten wurden in der Datei ' AusgabedateiExcel ' in dem Tabellenblatt ' int2str(AnzAus) ' und in der Datei ' AusgabedateiMat ' gespeichert'],'Info') 
% end

AnzAusNeu = AnzAus+1; % Zählt hoch damit immer ein neus Tabellenblatt beschrieben wird

% delete(warten); % Damit das 'Bitte warten' Fenster geschlossen wird


end