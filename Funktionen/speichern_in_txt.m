function speichern_in_txt(Dateiname,SpeicherPfad,File,SP,SP_ja_nein,Ziel,ArtikelVerfahren,AuftragsVerfahren,VerbesserungsVerfahren,Plus_Abbruchbed,Ab_zeit_str,Ab_prozent2_str,Ab_prozent3_str,Ab_vergl_str)
%
% <strong>speichern_in_txt</strong>(Dateiname,SpeicherPfad,File,SP,SP_ja_nein,Ziel,ArtikelVerfahren,AuftragsVerfahren,VerbesserungsVerfahren,Plus_Abbruchbed,Ab_zeit_str,Ab_prozent2_str,Ab_prozent3_str,Ab_vergl_str)
% 
% Speichert die Eckdaten für den Testlauf in einer TXT-Datei. 
% Zu den Eckdaten zählen:
% - Auftragsserie
% - Stellplatzbegrenzung
% - Zielfunktion
% - Verfahren
% - zusätzliche Abbruchbedingungen der Verbsserungsverfahren
% 
%
% Parameter:
%   Dateiname: Name der zu speichernden TXT-Datei
%   SpeicherPfad: Pfad, wo die Datei gespeichert werden soll
%   File: Dateiname der Auftragsserie
%   SP: Stellplatzbegrenzung
%   SP_ja_nein: gibt an, ob die Stellplätze begrenzt sind
%   Ziel: Zielfunktion
%   ArtikelVerfahren: gibt an, welche Artikelreihenfolgeverfahren durchlaufen werden
%   AuftragsVerfahren: gibt an, welche Auftragsreihenfolgeverfahren durchlaufen werden
%   VerbesserungsVerfahren: gibt an, welche Verbesserungsverfahren durchlaufen werden
%   Plus_Abbruchbed: gibt an, ob zusätzliche Abbruchbedingungen der
%                    Verbesserungsvefrahren aktiv sind
%   Ab_zeit_str: maximale Rechenzeit (1. Abbruchbedingung)
%   Ab_prozent2_str: relative Verbesserung von der Startlösung zur
%                    gewünschten Lösung (2. Abbruchbedingung)
%   Ab_prozent3_str: relative Verbesserung innerhalb der letzten
%                    Ab_vergl_str Vergleiche (3. Abbruchbedingung)
%   Ab_vergl_str: maximale Anzahl Vergleiche (3. Abbruchbedingung) 


str2save = {'Auftragsserie'
['File = ' File '.mat']
' '
'Stellplatzbegrenzung (SPG)'
['SP = ' num2str(SP)]
['SP_ja_nein = ' num2str(SP_ja_nein) '    1 = Mit SPG / -1 = Ohne SPG']
' '
'Zielfunktion'
['Ziel = ' num2str(Ziel)]
' '
'Artikelreihenfolgeverfahren'
'1 = Verfahren wird durchlaufen / 0 = Verfahren wird nicht durchlaufen'
['ArtikelVerfahren = [' num2str(ArtikelVerfahren(1)) '      Anordnung in topologischer Reihenfolge']
['                    ' num2str(ArtikelVerfahren(2)) '      Anordnung nach min. Bearbeitungzeit und max. Häufigkeit (minBmaxH)']
['                    ' num2str(ArtikelVerfahren(3)) '      Anordnung nach max. Bearbeitungzeit und max. Häufigkeit (maxBmaxH)']
['                    ' num2str(ArtikelVerfahren(4)) '      Anordnung nach min. Häufigkeit und topologischer Reihenfolge (minHtopo)']
['                    ' num2str(ArtikelVerfahren(5)) '      Anordnung nach max. Häufigkeit und topologischer Reihenfolge (maxHtopo)']
['                    ' num2str(ArtikelVerfahren(6)) '      Anordnung nach max. Häufigkeit und min. Bearbeitungszeit (maxHminB)']
['                    ' num2str(ArtikelVerfahren(7)) '      Anordnung nach max. Häufigkeit und max. Bearbeitungszeit (maxHmaxB)']
['                    ' num2str(ArtikelVerfahren(8)) '      Anordnung in zentrierter Reihenfolge aufsteigend (zenReihAufst)']
['                    ' num2str(ArtikelVerfahren(9)) '      Anordnung in zentrierter Reihenfolge absteigend (zenReihAbst)']
['                    ' num2str(ArtikelVerfahren(10)) '      Anordnung nach min. Auftragslänge und topologischer Reihenfolge (minAtopo)']
['                    ' num2str(ArtikelVerfahren(11)) '      Anordnung nach min. Auftragslänge und min. Bearbeitungszeit (minAminB)']
['                    ' num2str(ArtikelVerfahren(12)) '      Anordnung nach min. Auftragslänge und max. Bearbeitungszeit (minAmaxB)']
['                    ' num2str(ArtikelVerfahren(13)) '      Anordnung nach min. Auftragslänge und min. Häufigkeit (minAminH)']
['                    ' num2str(ArtikelVerfahren(14)) '      Anordnung nach min. Auftragslänge und max. Häufigkeit (minAmaxH)']
['                    ' num2str(ArtikelVerfahren(15)) '      Anordnung nach max. Auftragslänge und topologischer Reihenfolge (maxAtopo)']
['                    ' num2str(ArtikelVerfahren(16)) '      Anordnung nach max. Auftragslänge und min. Bearbeitungszeit (maxAminB)']
['                    ' num2str(ArtikelVerfahren(17)) '      Anordnung nach max. Auftragslänge und max. Bearbeitungszeit (maxAmaxB)']
['                    ' num2str(ArtikelVerfahren(18)) '      Anordnung nach max. Auftragslänge und min. Häufigkeit (maxAminH)']
['                    ' num2str(ArtikelVerfahren(19)) ']     Anordnung nach max. Auftragslänge und max. Häufigkeit (maxAmaxH)']
' '
'Auftragsreihenfolgeverfahren (nur für Zielfunktionen mit SPG) (es muss mindestens eins ausgewählt sein)'
'1 = Verfahren wird durchlaufen / 0 = Verfahren wird nicht durchlaufen'
['AuftragsVerfahren = [' num2str(AuftragsVerfahren(1)) '      Anordnung der Aufträge in topologischer Reihenfolge']
['                     ' num2str(AuftragsVerfahren(2)) '      Anordnung nach aufsteigenden spez. Fertigstellungszeitpunkten (MinSFSZ)']
['                     ' num2str(AuftragsVerfahren(3)) ']     Anordnung nach absteigenden spez. Fertigstellungszeitpunkten (MaxSFSZ)']
' '
'Verbesserungsverfahren (nur für Zielfunktionen ohne Stellplatzbegrenzung)'
'1 = Verfahren wird durchlaufen / 0 = Verfahren wird nicht durchlaufen'
['VerbesserungsVerfahren = [' num2str(VerbesserungsVerfahren(1)) '      2-Tausch First']
['                          ' num2str(VerbesserungsVerfahren(2)) '      2-Tausch Best']
['                          ' num2str(VerbesserungsVerfahren(3)) '      1-Verschieben First']
['                          ' num2str(VerbesserungsVerfahren(4)) '      1-Verschieben Best']
['                          ' num2str(VerbesserungsVerfahren(5)) '      Drehung First']
['                          ' num2str(VerbesserungsVerfahren(6)) ']     Drehung Best']
' '
'Zusätzliche Abbruchbedingungen der Verbesserungsverfahren'
['Plus_Abbruchbed = ' num2str(Plus_Abbruchbed) '    true (1) = mit zusätzlichen Ab / false (0) = ohne zusätzliche Ab']
' '
'1. Abbruchbedingung: Rechenzeit von Ab_zeit_str Minuten'
['Ab_zeit_str = ' Ab_zeit_str]
' '
'2. Abbruchbedingung: Zielfunktionswertverbesserung ausgehend vom'
'Artikelreihenfolgeverfahren um Ab_prozent2_str Prozent'
['Ab_prozent2_str = ' Ab_prozent2_str]
' '
'3. Abbruchbedingung: Zielfunktionswertverbesserung von weniger als'
'Ab_prozent3_str Prozent in den letzten Ab_vergl_str Vergleichen'
['Ab_prozent3_str = ' Ab_prozent3_str]
['Ab_vergl_str = ' Ab_vergl_str]};



fid = fopen([SpeicherPfad Dateiname '.txt'],'wt');
for i = 1:length(str2save)
    fprintf(fid,[str2save{i} '\n']);
end
fclose(fid); 

end