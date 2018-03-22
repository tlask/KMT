function KMT(varargin) %VARiable ARGuments IN

clc % Command Window leeren

global fig A counter_AufR HZ KZ DL hui Ziel Loese Verb VerbDL OrderArtikel Zielfunktionswert AufRneu Auf AufRest Art ArtR ArtD SP SP_ja_nein DL_ja_nein DL_enabled DL_alle Ausgabe AusgabeVerb Titel Gewichtung AnzAusZoSPG AnzAusZoSPGmV AnzAusZmSPG AnzAusZmSPGundDL AnzAusZmSPGundDLVerb Plus_Abbruchbed Artikel_neu_berechnen str_auftrag tmp_new 



% Unterverzeichnisse zum relativen Path anhängen
addpath(genpath('.\Funktionen\'));
addpath(genpath('.\Auftragsserien(mat-Dateien)\'));


Schriftgroesse1 = 7;
SchriftgroesseLeiste = 6;
SchriftgroesseFehler = 100;

AnzAusZmSPGundDL = 1;
AnzAusZmSPGundDLVerb = 1;


% Anzahl der Artikelreihenfolgeverfahren
% 1. Anordnung in topologischer Reihenfolge
% 2. Anordnung nach minimaler Bearbeitungzeit und maximaler Häufigkeit (minBmaxH)
% 3. Anordnung nach maximaler Bearbeitungzeit und maximaler Häufigkeit (maxBmaxH)
% 4. Anordnung nach minimaler Häufigkeit und topologischer ReCihenfolge (minHtopo)
% 5. Anordnung nach maximaler Häufigkeit und topologischer Reihenfolge (maxHtopo)
% 6. Anordnung nach maximaler Häufigkeit und minimaler Bearbeitungszeit (maxHminB)
% 7. Anordnung nach maximaler Häufigkeit und maximaler Bearbeitungszeit (maxHmaxB)
% 8. Anordnung nach zum Zentrum aufsteigender Häufigkeit (zenReihAufst)
% 9. Anordnung nach zum Zentrum absteigender Häufigkeit (zenReihAbst)
% 10. Anordnung nach minimaler Auftragslänge und topologischer Reihenfolge (minAtopo)
% 11. Anordnung nach minimaler Auftragslänge und minimaler Bearbeitungszeit (minAminB)
% 12. Anordnung nach minimaler Auftragslänge und maximaler Bearbeitungszeit (minAmaxB)
% 13. Anordnung nach minimaler Auftragslänge und minimaler Häufigkeit (minAminH)
% 14. Anordnung nach minimaler Auftragslänge und maximaler Häufigkeit (minAmaxH)
% 15. Anordnung nach maximaler Auftragslänge und topologischer Reihenfolge (maxAtopo)
% 16. Anordnung nach maximaler Auftragslänge und minimaler Bearbeitungszeit (maxAminB)
% 17. Anordnung nach maximaler Auftragslänge und maximaler Bearbeitungszeit (maxAmaxB)
% 18. Anordnung nach maximaler Auftragslänge und minimaler Häufigkeit (maxAminH)
% 19. Anordnung nach maximaler Auftragslänge und maximaler Häufigkeit (maxAmaxH)

AnzArtikelVerfahren = 19;

ArtikelVerfahrenNamen = {'Anordnung in topologischer Reihenfolge';
                         'Anordnung nach min. Bearbeitungzeit und max. Häufigkeit';
                         'Anordnung nach max. Bearbeitungzeit und max. Häufigkeit';
                         'Anordnung nach min. Häufigkeit und topologischer Reihenfolge';
                         'Anordnung nach max. Häufigkeit und topologischer Reihenfolge';
                         'Anordnung nach max. Häufigkeit und min. Bearbeitungszeit';
                         'Anordnung nach max. Häufigkeit und max. Bearbeitungszeit';
                         'Anordnung nach zum Zentrum aufsteigender Häufigkeit';
                         'Anordnung nach zum Zentrum absteigender Häufigkeit';
                         'Anordnung nach min. Auftragslänge und topologischer Reihenfolge';
                         'Anordnung nach min. Auftragslänge und min. Bearbeitungszeit';
                         'Anordnung nach min. Auftragslänge und max. Bearbeitungszeit';
                         'Anordnung nach min. Auftragslänge und min. Häufigkeit';
                         'Anordnung nach min. Auftragslänge und max. Häufigkeit';
                         'Anordnung nach max. Auftragslänge und topologischer Reihenfolge';
                         'Anordnung nach max. Auftragslänge und min. Bearbeitungszeit';
                         'Anordnung nach max. Auftragslänge und max. Bearbeitungszeit';
                         'Anordnung nach max. Auftragslänge und min. Häufigkeit';
                         'Anordnung nach max. Auftragslänge und max. Häufigkeit'};

% Anzahl der Verbesserungsverfahren (nur für Zielfunktionen ohne Stellplatzbegrenzung)
% 1. 2-Tausch First
% 2. 2-Tausch Best
% 3. 1-Verschieben First
% 4. 1-Verschieben Best
% 5. Drehung First
% 6. Drehung Best
AnzVerbesserungsVerfahren = 6;

% Anzahl der Auftragsreihenfolgeverfahren (nur für Zielfunktionen mit Stellplatzbegrenzung)
% 1. Anordnung der Aufträge in topologischer Reihenfolge
% 2. Anordnung nach aufsteigenden spez. Fertigstellungszeitpunkten
% 3. Anordnung nach absteigenden spez. Fertigstellungszeitpunkten
AnzAuftragsVerfahren = 3;

% Anzahl der Auftragsreihenfolgeverfahren (nur für Zielfunktionen mit Stellplatzbegrenzung)
% 1. Anordnung der Aufträge in topologischer Reihenfolge
% 2. Anordnung nach aufsteigender Deadline
% 3. Anordnung nach aufsteigender Pufferzeit (statisch)
% 4. Anordnung nach aufsteigender Pufferzeit (dynamisch)
AnzAuftragsVerfahrenMitDL = 4;

AuftragsVerfahrenNamenMitDL = {'Anordnung der Aufträge in topologischer Reihenfolge';
                               'Anordnung nach aufsteigender Deadline';
                               'Anordnung nach aufsteigender Pufferzeit (statisch)';
                               'Anordnung nach aufsteigender Pufferzeit (dynamisch)'};

% Anzahl der Verbesserungsverfahren für Zielfunktionen mit Deadline
% 1. weiß noch nicht
% 2. Platzhalter
% 3. Platzhalter
AnzVerbesserungsVerfahrenDL = 2;

VerbesserungsVerfahrenDLNamen = {'Insert';
                                 '2-Tausch Lite'};
                           
if nargin == 0 % Keine Eingabeparameter
    close all

    fig = figure('NumberTitle','off',...
                 'name','KMT',...
                 'Resize','on',...
                 'Units','normalized',...
                 'MenuBar','None',...
                 'Position',[0,0,1,0.948]); % Figure geht über den ganzen Desktop
                %'Position',[0.1,0.15,0.8,0.7]); % Figure ist nur in der mitte vom Desktop

    fig_menu = uimenu('Label','Hilfe');
     
    uimenu(fig_menu,'Label','Handbuch','Callback','!Dokumentation\KMT_Handbuch.pdf');
    uimenu(fig_menu,'Label','Masterarbeit Nehab','Callback','!Dokumentation\Masterarbeit_nehab.pdf');
    uimenu(fig_menu,'Label','Masterarbeit Lye','Callback','!Dokumentation\Masterarbeit_lye.pdf');
    uimenu(fig_menu,'Label','Bachelorarbeit Wolkow','Callback','!Dokumentation\Bachelorarbeit_Wolkow.pdf');
    uimenu(fig_menu,'Label','Projekt Ala Cilgin Gola','Callback','!Dokumentation\Projekt_Ala_Cilgin_Gola.pdf');
    
    uimenu('Label','Schließen',... 
           'Callback','close KMT');
       
    AnzAusZoSPG = 1; % Anzahl der Tabellenblätter für die Ausgabe (Zielfunktionen ohne SPG)
    AnzAusZoSPGmV = 1; % Anzahl der Tabellenblätter für die Ausgabe (Zielfunktionen ohne SPG mit Verbesserung)
    AnzAusZmSPG = 1; % Anzahl der Tabellenblätter für die Ausgabe (Zielfunktionen mit SPG)

    
    % Für die Leiste oben, bei welchem Punkt man gerade ist
    hui(100) = uicontrol('Style','text',...
                         'Units','normalized',...
                         'FontSize',SchriftgroesseLeiste,...
                         'FontUnits','normalized',...
                         'HorizontalAlignment','left',... % Damit der Text linksbündig ist
                         'Position',[.05 .9 .9 .05],...
                         'String','Auftragsserie');
    
    % Infobutton (Für jede Seite)               
    hui(103) = uicontrol('Style','push',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'HorizontalAlignment','left',... % Damit der Text linksbündig ist
                         'Position',[.9 .95 .1 .05],...
                         'String','Info',...
                         'Callback','KMT InfoAuftragsserie');
    
                      
    % Für die erste Seite
    hui(200) = uicontrol('Style','text',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'HorizontalAlignment','left',... % Damit der Text linksbündig ist
                         'Position',[.05 .7 .2 .05],...
                         'String','Bestehende Auftragsserie');

    hui(201) = uicontrol('Style','push',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'Position',[.210 .71 .12 .05],...
                         'String','laden',...
                         'CallBack','KMT Auftrag');

    hui(202) = uicontrol('Style','text',...
                         'Units','normalized',... 
                         'FontSize',Schriftgroesse1,...                  
                         'FontUnits','normalized',...
                         'HorizontalAlignment','left',... % Damit der Text linksbündig ist      
                         'Position',[.372 .7 .4 .05]);
                     
	hui(203) = uicontrol('Style','text',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'HorizontalAlignment','left',... % Damit der Text linksbündig ist
                         'Position',[.57 .7 .17 .05],...
                         'String','Anzahl der Artikel:');

    hui(204) = uicontrol('Style','text',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'Position',[.7 .7 .05 .05]);

    hui(205) = uicontrol('Style','text',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'HorizontalAlignment','left',... % Damit der Text linksbündig ist
                         'Position',[.57 .65 .17 .05],...
                         'String','Anzahl der Aufträge:');

    hui(206) = uicontrol('Style','text',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'Position',[.7 .65 .05 .05]);
                   
	hui(207) = uicontrol('Style','text',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'HorizontalAlignment','left',... % Damit der Text linksbündig ist
                         'Position',[.05 .5 .5 .05],...
                         'String','Auftragsserie mit einzugebenden Werten zufällig erzeugen');

    hui(208) = uicontrol('Style','push',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'Position',[.78 .51 .1 .05],...
                         'String','erzeugen',...
                         'CallBack','KMT AuftragErzeugen');

    hui(209) = uicontrol('Style','text',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'HorizontalAlignment','left',... % Damit der Text linksbündig ist
                         'Position',[.47 .5 .17 .05],...
                         'String','Anzahl der Artikel:');

    hui(210) = uicontrol('Style','edit',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'Position',[.6 .51 .05 .05]);

    hui(211) = uicontrol('Style','text',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'HorizontalAlignment','left',... % Damit der Text linksbündig ist
                         'Position',[.47 .45 .17 .05],...
                         'String','Anzahl der Aufträge:');

    hui(212) = uicontrol('Style','edit',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'Position',[.6 .46 .05 .05]);

    hui(213) = uicontrol('Style','text',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'HorizontalAlignment','left',... % Damit der Text linksbündig ist
                         'Position',[.47 .4 .17 .05],...
                         'String','Dichte der Matrix:');
 
    hui(214) = uicontrol('Style','edit',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'Position',[.6 .41 .05 .05]);   
 
    hui(215) = uicontrol('Style','text',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'HorizontalAlignment','left',... % Damit der Text linksbündig ist
                         'Position',[.47 .35 .35 .05],...
                         'String','Intervall der Zufallswerte der Matrix:');

    hui(216) = uicontrol('Style','edit',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'Position',[.78 .36 .05 .05]);  
 
    hui(217) = uicontrol('Style','edit',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'Position',[.83 .36 .05 .05]);      

    hui(218) = uicontrol('Style','text',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'HorizontalAlignment','left',...  % Damit der Text linksbündig ist
                         'Position',[.47 .3 .35 .05],...
                         'String','Intervall der Zufallswerte der Holzeiten:');

    hui(219) = uicontrol('Style','edit',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'Position',[.78 .31 .05 .05]);  
 
    hui(220) = uicontrol('Style','edit',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'Position',[.83 .31 .05 .05]);

    hui(221) = uicontrol('Style','text',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'HorizontalAlignment','left',...  % Damit der Text linksbündig ist
                         'Position',[.47 .25 .4 .05],...
                         'String','Intervall der Zufallswerte der Kommissionierzeiten:');

    hui(222) = uicontrol('Style','edit',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'Position',[.78 .26 .05 .05]);  
 
    hui(223) = uicontrol('Style','edit',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'Position',[.83 .26 .05 .05]);

    hui(224) = uicontrol('Style','text',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'HorizontalAlignment','left',... % Damit der Text linksbündig ist
                         'Position',[.05 .25 .3 .05],...
                         'String','Zufällig erzeugte Auftragsserie');

    hui(225) = uicontrol('Style','push',...
                         'Enable','off',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'Position',[.240 .26 .12 .05],...
                         'String','speichern',...
                         'CallBack','KMT SpeicherAuftrag');

    hui(226) = uicontrol('Style','push',...
                         'Enable','off',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'Position',[.05 .1 .15 .05],...
                         'String','ändern',...
                         'CallBack','KMT AenderAuftrag');  
                    
    hui(227) = uicontrol('Style','push',...
                         'Enable','off',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'Position',[.8 .1 .15 .05],...
                         'String','weiter',...
                         'CallBack','KMT WeiterSeite1'); 
    
    hui(228) = uicontrol('Style','text',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'HorizontalAlignment','left',...  % Damit der Text linksbündig ist
                         'Position',[.67 .43 0.1 .05],...
                         'String',{'Häufigkeit DL:'});
                     
    hui(229) = uicontrol('Style','popupmenu',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'Position',[.78 .43 .1 .05],...
                         'String',{'keine','wenige','mittel','viele','alle'});                 
                     
    hui(230) = uicontrol('Style','text',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'HorizontalAlignment','left',...  % Damit der Text linksbündig ist
                         'Position',[.47 .20 .4 .05],...
                         'String','Intervall der Zufallswerte der Deadlines (DL):');

    hui(231) = uicontrol('Style','edit',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'Position',[.78 .21 .05 .05]);  
 
    hui(232) = uicontrol('Style','edit',...
                         'Units','normalized',...
                         'FontSize',Schriftgroesse1,...
                         'FontUnits','normalized',...
                         'Position',[.83 .21 .05 .05]);
                     
    % Für die zweite Seite                
    hui(300) = uicontrol('Style','text',...
                        'Visible','off','Enable','inactive',... % Damit es auf der ersten Seite nicht zu sehen ist
                        'Units','normalized',...
                        'FontSize',Schriftgroesse1,...
                        'FontUnits','normalized',...
                        'HorizontalAlignment','left',... % Damit der Text linksbündig ist
                        'Position',[.08 .65 .2 .05],...
                        'String','Stellplatzbegrenzung:');

    hui(301) = uicontrol('Style','push',...
                        'Visible','off','Enable','inactive',... % Damit es auf der ersten Seite nicht zu sehen ist
                        'Units','normalized',...
                        'FontSize',Schriftgroesse1,...
                        'FontUnits','normalized',...
                        'Position',[.25 .65 .1 .05],... %.3
                        'String','Ja',...
                        'CallBack','KMT StellplatzberenzungJa');
  
    hui(302) = uicontrol('Style','text',...
                        'Visible','off','Enable','inactive',... % Damit es auf der ersten Seite nicht zu sehen ist
                        'Units','normalized',...
                        'FontSize',Schriftgroesse1,...
                        'FontUnits','normalized',...
                        'HorizontalAlignment','left',... % Damit der Text linksbündig ist
                        'Position',[.7 .65 .2 .05],...  %.45
                        'String','Anzahl der Stellplätze:');

    hui(303) = uicontrol('Style','edit',...
                        'Visible','off','Enable','inactive',... % Damit es auf der ersten Seite nicht zu sehen ist
                        'Units','normalized',...
                        'FontSize',Schriftgroesse1,...
                        'FontUnits','normalized',...
                        'Position',[.85 .65 .05 .05]);  %.6
              
    hui(304) = uicontrol('Style','push',...
                        'Visible','off','Enable','inactive',... % Damit es auf der ersten Seite nicht zu sehen ist
                        'Units','normalized',...
                        'FontSize',Schriftgroesse1,...
                        'FontUnits','normalized',...
                        'Position',[.40 .65 .1 .05],...  %.3 .55
                        'String','Nein',...
                        'CallBack','KMT StellplatzberenzungNein');

    hui(305) = uicontrol('Style','push',...
                        'Visible','off','Enable','inactive',... % Damit es auf der ersten Seite nicht zu sehen ist
                        'Units','normalized',...
                        'FontSize',Schriftgroesse1,...
                        'FontUnits','normalized',...
                        'Position',[.55 .65 .1 .05],... %.3 .45
                        'String','ändern',...
                        'CallBack','KMT StellplatzberenzungAendern');

    hui(306) = uicontrol('Style','push',...
                        'Visible','off','Enable','inactive',... % Damit es auf der ersten Seite nicht zu sehen ist
                        'Units','normalized',...
                        'FontSize',Schriftgroesse1,...
                        'FontUnits','normalized',...
                        'Position',[.8 .1 .15 .05],...
                        'String','weiter',...
                        'CallBack','KMT WeiterSeite2');     
                    
    hui(307) = uicontrol('Style','push',...
                        'Visible','off','Enable','inactive',... % Damit es auf der ersten Seite nicht zu sehen ist
                        'Units','normalized',...
                        'FontSize',Schriftgroesse1,...
                        'FontUnits','normalized',...
                        'Position',[.05 .1 .15 .05],...
                        'String','zurück',...
                        'CallBack','KMT ZurueckSeite2');
                    
    hui(308) = uicontrol('Style','text',...
                        'Visible','off','Enable','inactive',... % Damit es auf der ersten Seite nicht zu sehen ist
                        'Units','normalized',...
                        'FontSize',Schriftgroesse1,...
                        'FontUnits','normalized',...
                        'HorizontalAlignment','left',... % Damit der Text linksbündig ist
                        'Position',[.08 .5 .2 .05],...
                        'String','Deadline:');
	
    hui(309) = uicontrol('Style','push',...
                        'Visible','off','Enable','inactive',... % Damit es auf der ersten Seite nicht zu sehen ist
                        'Units','normalized',...
                        'FontSize',Schriftgroesse1,...
                        'FontUnits','normalized',...
                        'Position',[.25 .5 .1 .05],... %.3
                        'String','Ja',...
                        'CallBack','KMT DeadlineJa');
                    
    hui(310) = uicontrol('Style','push',...
                        'Visible','off','Enable','inactive',... % Damit es auf der ersten Seite nicht zu sehen ist
                        'Units','normalized',...
                        'FontSize',Schriftgroesse1,...
                        'FontUnits','normalized',...
                        'Position',[.40 .5 .1 .05],...  %.3 .55
                        'String','Nein',...
                        'CallBack','KMT DeadlineNein');
                    
    hui(311) = uicontrol('Style','push',...
                        'Visible','off','Enable','inactive',... % Damit es auf der ersten Seite nicht zu sehen ist
                        'Units','normalized',...
                        'FontSize',Schriftgroesse1,...
                        'FontUnits','normalized',...
                        'Position',[.55 .5 .1 .05],... %.3 .45
                        'String','ändern',...
                        'CallBack','KMT DeadlineAendern');   
                    
    % Für die dritte Seite  
    hui(400) = uicontrol('Style','text',...
                        'Visible','off','Enable','inactive',... % Damit es auf den vorherigen Seiten nicht zu sehen ist
                        'Units','normalized',...
                        'FontSize',Schriftgroesse1,...
                        'FontUnits','normalized',...
                        'HorizontalAlignment','left',...  % Damit der Text linksbündig ist
                        'Position',[.08 .6 .2 .05],...
                        'String','Zielfunktion:');    
                        
    % Zielfunktionsauswahl ohne Stellplatzbegrenzung                    
	hui(401) = uicontrol('Style','popupmenu',...
                        'Visible','off','Enable','inactive',... % Damit es auf den vorherigen Seiten nicht zu sehen ist
                        'Units','normalized',... 
                        'FontSize',Schriftgroesse1,...
                        'FontUnits','normalized',...
                        'Position',[.3 .6 .5 .05],...
                        'String',...
                        ['min! sum. Fertigstellungszeitpunkte|',...
                         'min! max. Fertigstellungszeitpunkt|',...
                         'min! sum. spez. Fertigstellungszeitpunkte|',...                         
                         'min! sum. Unproduktivzeiten|',...
                         'min! max. Unproduktivzeit|',...                         
                         'min! sum. Stellplatzzeiten|',...
                         'min! Anzahl Stellplätze']);
                
    % Zielfunktionsauswahl mit Stellplatzbegrenzung                
    hui(402) = uicontrol('Style','popupmenu',...
                        'Visible','off','Enable','inactive',... % Damit es auf den vorherigen Seiten nicht zu sehen ist
                        'Units','normalized',... 
                        'FontSize',Schriftgroesse1,...
                        'FontUnits','normalized',...
                        'Position',[.3 .6 .5 .05],...
                        'String',...
                        ['min! sum. Fertigstellungszeitpunkte mit Stellplatzbegrenzung|',...
                         'min! max. Fertigstellungszeitpunkt mit Stellplatzbegrenzung|',...
                         'min! sum. Durchlaufzeiten mit Stellplatzbegrenzung']);  
                           
    hui(403) = uicontrol('Style','popupmenu',...
                        'Visible','off','Enable','inactive',... % Damit es auf den vorherigen Seiten nicht zu sehen ist
                        'Units','normalized',... 
                        'FontSize',Schriftgroesse1,...
                        'FontUnits','normalized',...
                        'Position',[.3 .6 .5 .05],...
                        'String',...
                        ['min! sum. Fertigstellungszeitpunkte mit Stellplatzbegrenzung|',...
                         'min! max. Fertigstellungszeitpunkt mit Stellplatzbegrenzung|',...
                         'min! sum. Durchlaufzeiten mit Stellplatzbegrenzung|',...
                         'min! sum. Anzahl an Überschreitung der Deadlines|',...
                         'min! sum. Überschreitung der Deadlines|',...
                         'min! max. Überschreitung der Deadlines|',...
                         'min! durchschnittl. Überschreitung der Deadlines|',...
                         'min! sum. gewichtete Überschreitung der Deadlines']);  
                  
    hui(404) = uicontrol('Style','push',...
                        'Visible','off','Enable','inactive',... % Damit es auf den vorherigen Seiten nicht zu sehen ist
                        'Units','normalized',...
                        'FontSize',Schriftgroesse1,...
                        'FontUnits','normalized',...
                        'Position',[.8 .1 .15 .05],...
                        'String','weiter',...
                        'CallBack','KMT ZielfunktionAuswahl');  
                    
    hui(405) = uicontrol('Style','push',...
                        'Visible','off','Enable','inactive',... % Damit es auf der ersten Seite nicht zu sehen ist
                        'Units','normalized',...
                        'FontSize',Schriftgroesse1,...
                        'FontUnits','normalized',...
                        'Position',[.05 .1 .15 .05],...
                        'String','zurück',...
                        'CallBack','KMT ZurueckSeite3');
                    
 
                             
else
    
    switch varargin{:}
            
            
        case 'InfoAuftragsserie'

            Text = ['Es kann eine bestehende Auftragsserie geladen oder eine Auftragsserie zufällig erzeugt werden.',...
                    ' Es können mit dem Button „laden“ nur Auftragsserien geladen werden, die zuvor als MAT–Dateien',...
                    ' mit den Eingabeparamtern W, H und K gespeichert wurden.',...
                    ' Um eine Auftragsserie zufällig zu erzeugen, muss bei der Eingabe der Werte auf',...
                    ' Verschiedenes geachtet werden. Als Dichte wird das Verhältnis zwischen Null- und',...
                    ' Nichtnullelementen in der Matrix bezeichnet; sie liegt im Intervall (0;1].',...
                    ' Der eingegebene Wert für die Dichte wird als',...
                    ' Richtwert angesehen, die tatsächliche Dichte kann davon leicht abweichen.',...
                    ' Es ist darauf zu achten, dass beim Intervall der Zufallswerte kein Nachkommaanteil gebildet',...
                    ' wird, wenn ganzzahlige Werte angeben werden. Dementsprechend wird z. B. 5.00',...
                    ' eingegeben, wenn Zufallswerte mit zwei Nachkommastellen gewünscht sind. Nach',...
                    ' dem Eingeben aller benötigten Werte wird durch das Anklicken des Buttons „erzeugen“',...
                    ' eine zufällige Auftragsserie generiert.']; 

            helpdlg(Text,'Information');
        
        
        case 'InfoStellplatzbegrenzung'

            Text = ['Es wird die Wahl zwischen einer und keiner Stellplatzbegrenzung getroffen,',...
                    ' wodurch der weitere Verlauf des Programms bestimmt wird.',...
                    ' Entscheidet man sich für eine Stellplatzbegrenzung,',... 
                    ' klickt man auf den Button „Ja“ und gibt daraufhin die Anzahl der Stellplätze ein.',...
                    ' Hierdurch wird die Wahl zwischen einer und keiner Berücksichtigung der Deadline ermöglicht.',...
                    ' Die Anzahl der Stellplätze muss unabhängig von dieser Wahl festgelegt werden. ',...
                    ' Die Anzahl der Stellplätze muss ganzzahlig und positiv sein und darf die Anzahl der Aufträge nicht überschreiten.',... 
                    ' Wird die Anzahl der Aufträge als Wert angegeben, liegt keine echte Stellplatzbegrenzung vor.',... 
                    ' Mit dem Button „Nein“ gibt man an, dass keine Stellplatzbegrenzung vorliegt.']; 

            helpdlg(Text,'Information');
        
        
        case 'InfoZielfunktion'

            if DL_ja_nein == -1
                 Text = ['Aus dem Pop-Up-Menü ist die gewünschte Zielfunktion auszuwählen.',... 
                        ' Eine ausführliche Beschreibung der Zielfunktionen befindet sich in Kapitel 5 der Masterarbeit Lye.',... 
                        ' Durch das Anklicken des Menüpunkts „Hilfe“ wird die Masterarbeit geöffnet.']; 

                 helpdlg(Text,'Information');
            else
                Text = ['Aus dem Pop-Up-Menü ist die gewünschte Zielfunktion auszuwählen.',... 
                        ' Eine ausführliche Beschreibung der Zielfunktionen befindet sich in Kapitel 6 der Masterarbeit Nehab.',... 
                        ' Durch das Anklicken des Menüpunkts „Hilfe“ wird die Masterarbeit geöffnet.']; 

                helpdlg(Text,'Information');
            end
        
        case 'InfoArtikelreihenfolgeverfahren'

            if DL_ja_nein == -1
                Text = ['Aus den 19 verschiedenen Artikelreihenfolgeverfahren ist über Checkboxen mindestens ein Verfahren auszuwählen.',... 
                        ' Zur Auswahl aller Artikelreihenfolgeverfahren kann der Button „alle auswählen“ genutzt werden.',... 
                        ' Mit dem Button „keins auswählen“ wird die gesamte Auswahl wieder aufgehoben.',...  
                        ' Eine ausführliche Beschreibung der Artikelreihenfolgeverfahren befindet sich in Abschnitt 6.1 der Masterarbeit Lye.',... 
                        ' Desweiteren befindet sich eine Beschreibung der Auswahl einer dynamischen  Artikelreihenfolge in der Ausarbeitung Projekt.',...
                        ' Durch das Anklicken des Menüpunkts „Hilfe“ können die erwähnten Ausarbeitungen geöffnet werden.', ...
                        ' Hinweis: Durch das Auswählen einer dynamischen Artikelreihenfolgeverfahren, wird ein PopUp-Fenster geöffnet,',...
                        ' indem der User die Möglichkeit hat, das Bestimmen der Artikelreihenfolge zu beeinflussen. Weitere Informationen entnehmen Sie der Ausarbeitung Projekt.']; 
                
                helpdlg(Text,'Information');
            else
                Text = ['Aus den 19 verschiedenen Artikelreihenfolgeverfahren ist über Checkboxen mindestens ein Verfahren auszuwählen.',... 
                        ' Zur Auswahl aller Artikelreihenfolgeverfahren kann der Button „alle auswählen“ genutzt werden.',... 
                        ' Mit dem Button „keins auswählen“ wird die gesamte Auswahl wieder aufgehoben.',...  
                        ' Eine ausführliche Beschreibung der Artikelreihenfolgeverfahren befindet sich in Abschnitt 6.1 der Masterarbeit Lye.',... 
                        ' Desweiteren befindet sich eine Beschreibung der Auswahl einer dynamischen  Artikelreihenfolge in der Ausarbeitung Projekt.',...
                        ' Durch das Anklicken des Menüpunkts „Hilfe“ können die erwähnten Ausarbeitungen geöffnet werden.', ...
                        ' Hinweis: Durch das Auswählen einer dynamischen Artikelreihenfolgeverfahren, wird ein PopUp-Fenster geöffnet,',...
                        ' indem der User die Möglichkeit hat, das Bestimmen der Artikelreihenfolge zu beeinflussen. Weitere Informationen entnehmen Sie der Ausarbeitung Projekt.']; 

                helpdlg(Text,'Information');
            end
        
        case 'InfoLoesungArt' % Ohne SPG

            Text = ['Die Ergebnisse der Artikelreihenfolgeverfahren werden in der Tabelle aufgeführt.',... 
                    ' In der ersten Spalte werden die zuvor ausgewählten Artikelreihenfolgeverfahren angeben.',...  
                    ' Der Zielfunktionswert zu der zuvor ausgewählten Zielfunktion wird in der zweiten Spalte aufgeführt.',... 
                    ' Daraufhin wird in der dritten Spalte die relative Abweichung zu der besten Lösung angegeben.',...  
                    ' Als beste Lösung wird in diesem Zusammenhang der geringste Zielfunktionswert bezeichnet.',...  
                    ' Die beste Lösung hat somit eine relative Abweichung von 0 % und wird grün hinterlegt.',...  
                    ' In der nächsten Spalte ist die benötigte Rechenzeit in Sekunden angegeben.',...  
                    ' Die letzte Spalte gibt die ermittelte Artikelreihenfolge an.',...  
                    ' Für die Zielfunktion „Minimierung der summierten spezifischen Fertigstellungszeitpunkte“',... 
                    ' weist die Tabelle eine weitere Spalte auf, welche die ermittelte Auftragsreihenfolge',... 
                    ' angibt. Durch das Anklicken des Buttons „speichern“ werden die Ergebnisse sowohl in einer MAT–Datei als',... 
                    ' auch in einer XLSX–Datei gespeichert.']; 

            helpdlg(Text,'Information');
        
        
        case 'InfoVerbesserung' % Ohne SPG

            Text = ['Über Checkboxen ist mindestens ein Artikelreihenfolgeverfahren auszugewählt, worauf die Verbesserungsverfahren angewandt werden sollen.',... 
                    ' Dabei werden nur die Artikelreihenfolgeverfahren aufgelistet, welche zuvor ausgewählt wurden.',...  
                    ' Die Artikelreihenfolgeverfahren, die einen Zielfunktionswert von null erzielt haben, werden ausgegraut und',... 
                    ' sind nicht auswählbar. Der kleinstmögliche Zielfunktionswert kann per se nicht verbessert werden.'];  

            helpdlg(Text,'Information');
        
        
        case 'InfoVerbesserungsverfahren' % Ohne SPG

            Text = ['Aus den 6 verschiedenen Verbesserungsverfahren ist über Checkboxen mindestens ein Verfahren auszuwählen.',... 
                    ' Zur Auswahl aller Verbesserungsverfahren kann der Button „alle auswählen“ genutzt werden.',... 
                    ' Mit dem Button „keins auswählen“ wird die gesamte Auswahl wieder aufgehoben.',...  
                    ' Da die Berechnung der Verbesserungsverfahren relativ lange dauern kann, ist es möglich, dass zusätzliche',... 
                    ' Abbruchbedingungen berücksichtigt werden. Durch das Anklicken des Buttons „Mit zusätzlichen Abbruchbedingungen“',... 
                    ' wird der ausgegraute Teil geschwärzt und eingabebereit. Daraufhin muss mindestens',... 
                    ' eine zusätzliche Abbruchbedingung für die Verbesserungsverfahren angegeben werden.',... 
                    ' Eine ausführliche Beschreibung der Verbesserungsverfahren und der zusätzlichen Abbruchbedingungen befindet sich in der Masterarbeit Lye.',... 
                    ' Durch das Anklicken des Menüpunkts „Hilfe“ wird die Masterarbeit geöffnet.']; 

            helpdlg(Text,'Information');
        
        
        case 'InfoLoesungVerb' % Ohne SPG

            Text = ['Die Ergebnisse der Verbesserungsverfahren werden in der Tabelle aufgeführt.',... 
                    ' In der ersten Spalte werden die Artikelreihenfolgeverfahren',...
                    ' mit den darauf angewandten Verbesserungsverfahren in Blöcken zusammengefasst angegeben.',...
                    ' Die nächste Spalte gibt den Zielfunktionswert für alle Verfahren an.',... 
                    ' Die dritte Spalte beinhaltet die relative Abweichung zu der besten Lösung.',... 
                    ' In diesem Zusammenhang wird der geringste Zielfunktionswert von der Menge aller Verfahren als',...
                    ' beste Lösung bezeichnet. Erneut ist die beste Lösung grün hinterlegt. In den nächsten',...
                    ' beiden Spalten werden die absolute und relative Abweichung des Zielfunktionswertes',...
                    ' von dem Ergebnis des Verbesserungsverfahrens zu der Startlösung, also dem Ergebnis',...
                    ' des Artikelreihenfolgeverfahrens, angegeben. Die sechste Spalte beinhaltet die Anzahl',...
                    ' der Vergleiche, bis die beste Lösung gefunden wird. Das Verbesserungsverfahren',...
                    ' benötigt N weitere Vergleiche zur Prüfung, ob dies wirklich die beste Lösung in der',...
                    ' Nachbarschaft ist. Die Anzahl der Nachbarn ist in der achten Spalte angegeben. Der',...
                    ' siebten Spalte ist die Anzahl der Verbesserungen zu entnehmen. In den letzten zwei,',...
                    ' ggf. drei Spalten ist erneut die benötigte Rechenzeit in Sekunden, die ermittelte',... 
                    ' Artikelreihenfolge und die ermittelte Auftragsreihenfolge angegeben.',10,10, 'Werden',...
                    ' bei den Verbesserungsverfahren zusätzliche Abbruchbedingungen berücksichtigt,',... 
                    ' enthält die Tabelle zwischen der fünften und sechsten Spalte zwei zusätzliche',...
                    ' Spalten. In der ersten zusätzlichen Spalte wird angegeben, welche Abbruchbedingung',...
                    ' zum Abbruch des Verbesserungsverfahren geführt hat. Dabei steht der Wert 0 für',...
                    ' einen kompletten Durchlauf des Verbesserungsverfahrens. Die Werte 1, 2 und 3 geben',...
                    ' die eingetretene zusätzliche Abbruchbedingung an.',... 
                    ' Die zweite zusätzliche Spalte beinhaltet die Anzahl der insgesamt durchgeführten',...
                    ' Vergleiche im Verbesserungsverfahren.',...
                    ' Durch das Anklicken des Buttons „speichern“ werden die Ergebnisse sowohl in einer MAT–Datei als',... 
                    ' auch in einer XLSX–Datei gespeichert.']; 

            helpdlg(Text,'Information');
        
        
        case 'InfoAuftragsreihenfolgeverfahren' % Mit SPG

            if DL_ja_nein == -1
                
                Text = ['Aus den 3 verschiedenen Auftragsreihenfolgeverfahren ist über Checkboxen mindestens ein Verfahren auszuwählen.',... 
                        ' Zur Auswahl aller Auftragsreihenfolgeverfahren kann der Button „alle auswählen“ genutzt werden.',... 
                        ' Mit dem Button „keins auswählen“ wird die gesamte Auswahl wieder aufgehoben.',...  
                        ' Eine ausführliche Beschreibung der Auftragsreihenfolgeverfahren befindet sich in Abschnitt 6.2 der Masterarbeit Lye.',... 
                        ' Durch das Anklicken des Menüpunkts „Hilfe“ wird die Masterarbeit geöffnet.']; 
                
                helpdlg(Text,'Information');
            else
                Text = ['Aus den verschiedenen Auftragsreihenfolgeverfahren ist über Checkboxen mindestens ein Verfahren auszuwählen.',... 
                        ' Zur Auswahl aller Auftragsreihenfolgeverfahren kann der Button „alle auswählen“ genutzt werden.',... 
                        ' Mit dem Button „keins auswählen“ wird die gesamte Auswahl wieder aufgehoben. Nachdem die Auswahl durch "OK" bestätigt wurde, ',...  
                        ' muss mindestens ein Auftragsreihenfolgeveerfahren für Aufträge mit unendlich hoher bzw. gleicher Deadline gewählt werden. ',...
                        ' Eine ausführliche Beschreibung der Auftragsreihenfolgeverfahren befindet sich in Abschnitt 7 der Masterarbeit Nehab.',... 
                        ' Durch das Anklicken des Menüpunkts „Hilfe“ wird die Masterarbeit geöffnet.']; 
                
                helpdlg(Text,'Information');
            end
            
        
        
        case 'InfoLoesungArtAuf' % Mit SPG

            Text = ['Die Ergebnisse der Artikel- und Auftragsreihenfolgeverfahren werden in der Tabelle aufgeführt.',... 
                    ' Die erste Spalte beinhaltet die Verfahren. Dabei werden alle Artikelreihenfolgeverfahren, die',... 
                    ' jeweils zusammen mit einem Auftragsreihenfolgeverfahren genutzt werden, in einem',... 
                    ' Block zusammengefasst. Der Zielfunktionswert ist in der nächsten Spalte angegeben.',... 
                    ' Die dritte Spalte enthält die relative Abweichung zu der besten Lösung. Als beste',... 
                    ' Lösung wird in diesem Zusammenhang der geringste Zielfunktionswert bezeichnet,',... 
                    ' der aufgrund der ermittelten Artikel- und Auftragsreihenfolgen erzielt wird. In der',... 
                    ' vierten Spalte wird die benötigte Rechenzeit der Verfahren in Sekunden angegeben.',... 
                    ' Die beiden letzten Spalten beinhalten die ermittelte Artikel- und Auftragsreihenfolge.'];

            helpdlg(Text,'Information');
            
        case 'InfoVerbesserungMitDL' % Mit SPG
            
            Text = ['Über Checkboxen ist mindestens ein Auftragsreihenfolgeverfahren auszugewählt, worauf die Verbesserungsverfahren angewandt werden sollen.',... 
                    ' Dabei werden nur die Auftragsreihenfolgeverfahren aufgelistet, welche zuvor ausgewählt wurden.'];

            helpdlg(Text,'Information');
            
        case 'InfoArtVerbesserungMitDL' % Mit SPG
            
            Text = ['Über Checkboxen ist mindestens ein Artikelreihenfolgeverfahren auszugewählt, worauf die Verbesserungsverfahren angewandt werden sollen.',... 
                    ' Dabei werden nur die Artikelreihenfolgeverfahren aufgelistet, welche zuvor ausgewählt wurden.'];

            helpdlg(Text,'Information');
            
        case 'InfoVerbesserungsverfahrenMitDL'
            
            Text = ['Aus den beiden Verbesserungsverfahren ist über Checkboxen mindestens ein Verfahren auszuwählen.',... 
                    ' Zur Auswahl aller Verbesserungsverfahren kann der Button „alle auswählen“ genutzt werden.',... 
                    ' Mit dem Button „keins auswählen“ wird die gesamte Auswahl wieder aufgehoben.',...  
                    ' Da die Berechnung der Verbesserungsverfahren relativ lange dauern kann, ist es möglich, dass zusätzliche',... 
                    ' Abbruchbedingungen berücksichtigt werden. Durch das Anklicken des Buttons „Mit zusätzlichen Abbruchbedingungen“',... 
                    ' wird der ausgegraute Teil geschwärzt und eingabebereit. Daraufhin muss mindestens',... 
                    ' eine zusätzliche Abbruchbedingung für die Verbesserungsverfahren angegeben werden.',... 
                    ' Eine ausführliche Beschreibung der Verbesserungsverfahren und der zusätzlichen Abbruchbedingungen befindet sich in der Masterarbeit Nehab.',... 
                    ' Durch das Anklicken des Menüpunkts „Hilfe“ wird die Masterarbeit geöffnet.'];
            
                helpdlg(Text,'Information');
            
        case 'InfoLoesungVerbMitDL'
                
            Text = ['Die Ergebnisse der Verbesserungsverfahren werden in der Tabelle aufgeführt.',... 
                    ' In der ersten Spalte werden die Artikelreihenfolgeverfahren',...
                    ' mit den darauf angewandten Verbesserungsverfahren in Blöcken zusammengefasst angegeben.',...
                    ' Die nächste Spalte gibt den Zielfunktionswert für alle Verfahren an.',... 
                    ' Die dritte Spalte beinhaltet die relative Abweichung zu der besten Lösung.',... 
                    ' In diesem Zusammenhang wird der geringste Zielfunktionswert von der Menge aller Verfahren als',...
                    ' beste Lösung bezeichnet. Erneut ist die beste Lösung rot hinterlegt. In den nächsten',...
                    ' beiden Spalten werden die absolute und relative Abweichung des Zielfunktionswertes',...
                    ' von dem Ergebnis des Verbesserungsverfahrens zu der Startlösung, also dem Ergebnis',...
                    ' des Artikelreihenfolgeverfahrens, angegeben. Die sechste Spalte beinhaltet die Anzahl',...
                    ' der Vergleiche, bis die beste Lösung gefunden wird. Die Anzahl der Nachbarn ist in der',...
                    ' achten Spalte angegeben. Der siebten Spalte ist die Anzahl der Verbesserungen zu entnehmen.',...
                    '  In den letzten drei Spalten ist erneut die benötigte Rechenzeit in Sekunden, die ermittelte',... 
                    ' Artikelreihenfolge und die ermittelte Auftragsreihenfolge angegeben.',10,10, 'Werden',...
                    ' bei den Verbesserungsverfahren zusätzliche Abbruchbedingungen berücksichtigt,',... 
                    ' enthält die Tabelle zwischen der fünften und sechsten Spalte zwei zusätzliche',...
                    ' Spalten. In der ersten zusätzlichen Spalte wird angegeben, welche Abbruchbedingung',...
                    ' zum Abbruch des Verbesserungsverfahren geführt hat. Dabei steht der Wert 0 für',...
                    ' einen kompletten Durchlauf des Verbesserungsverfahrens. Die Werte 1, 2 und 3 geben',...
                    ' die eingetretene zusätzliche Abbruchbedingung an.',... 
                    ' Die zweite zusätzliche Spalte beinhaltet die Anzahl der insgesamt durchgeführten',...
                    ' Vergleiche im Verbesserungsverfahren.',...
                    ' Durch das Anklicken des Buttons „speichern“ werden die Ergebnisse sowohl in einer MAT–Datei als',... 
                    ' auch in einer XLSX–Datei gespeichert.'];
            
                helpdlg(Text,'Information');
                
        % Für die erste Seite
        case 'Auftrag'

            [filename1, pathname1] = uigetfile('*.mat','Auftragsserie laden','.\Auftragsserien(mat-Dateien)\'); % Öffnet den Ordner, damit eine mat Datei ausgewählt werden kann
            if filename1 ~= 0 % Wenn man auf Abbrechen gedrückt hat, dann hat filename1 den Wert Null
                
                if strcmp(filename1(end-3:end),'.mat') % Prüfen, ob eine MAT-Datein gewählt wurde
                    
                    DL = 0;
                    load([pathname1 filename1]);

                    % Eingabeparameter an die internen Parameter anpassen
                    A = W; %#ok<*NODEF>
                    HZ = H;
                    KZ = K;
                    clear W H K

                    FehlerImAuftrag = FehlerhafterAuftrag(A,HZ,KZ);

                    if FehlerImAuftrag
                        errordlg('Die Auftragsserie ist Fehlerhaft.','Eingabe Fehler') 
                    else
                        [m,n] = size(A);

                        set(hui(201),'String','geladen','Style', 'text','Position',[.210 .7 .12 .05]);
                        set(hui(202),'String',filename1);
                        set(hui(204),'String',m);
                        set(hui(206),'String',n);
                        set(hui(207:225),'Enable','off');
                        set(hui(228:232),'Enable','off');
                        set(hui(201),'Value',0); % grau
                        set(hui(226:227),'Enable','on');
                    end
                else
                    errordlg('Es können ausschließlich MAT-Dateien geladen werden.','Eingabe Fehler') 
                end
            end
            


        case 'AuftragErzeugen'

            % Strings in numerische Werte umwandeln
            m_str = get(hui(210),'String');
            m = str2double(m_str);
            n_str = get(hui(212),'String');
            n = str2double(n_str);
            dichte_str = get(hui(214),'String');
            dichte = str2double(dichte_str);
            mat_int1_str = get(hui(216),'String');
            mat_int1 = str2double(mat_int1_str);
            mat_int2_str = get(hui(217),'String');
            mat_int2 = str2double(mat_int2_str);
            hz_int1_str = get(hui(219),'String');
            hz_int1 = str2double(hz_int1_str);
            hz_int2_str = get(hui(220),'String');
            hz_int2 = str2double(hz_int2_str);
            kz_int1_str = get(hui(222),'String');
            kz_int1 = str2double(kz_int1_str);
            kz_int2_str = get(hui(223),'String');
            kz_int2 = str2double(kz_int2_str);
            dl_menge = get(hui(229),'Value');
            dl_int1_str = get(hui(231),'String');
            dl_int1 = str2double(dl_int1_str);
            dl_int2_str = get(hui(232),'String');
            dl_int2 = str2double(dl_int2_str);

            % Prüfung wie viele Nachkommastellen die Werte für die Zufallszahlen der
            % Intervallgrenzen haben
            nachk_mat_int1 = Nachkommastelle(mat_int1_str);
            nachk_mat_int2 = Nachkommastelle(mat_int2_str);
            nachk_hz_int1 = Nachkommastelle(hz_int1_str);
            nachk_hz_int2 = Nachkommastelle(hz_int2_str);
            nachk_kz_int1 = Nachkommastelle(kz_int1_str);
            nachk_kz_int2 = Nachkommastelle(kz_int2_str);
            nachk_dl_int1 = Nachkommastelle(dl_int1_str);
            nachk_dl_int2 = Nachkommastelle(dl_int2_str);
            
            % Fehlerabfragen
            if m <= 0 || round(m) ~= m || ...
               n <= 0 || round(n) ~= n || ...
               dichte <= 0 || dichte > 1 || isnan(dichte) || ...
               mat_int1 < 0 || mat_int2 < 0 || mat_int1 > mat_int2 || ...
               isnan(mat_int1) || isnan(mat_int2) || ...
               hz_int1 < 0 || hz_int2 < 0 || hz_int1 > hz_int2 || ...
               isnan(hz_int1) || isnan(hz_int2) || ...
               kz_int1 < 0 || kz_int2 < 0 || kz_int1 > kz_int2 || ...
               isnan(kz_int1) || isnan(kz_int2) || ...
               dl_menge ~= 1 && (dl_int1 < 0 || dl_int2 < 0 || ...
               dl_int1 < 0 || dl_int2 < 0 || dl_int1 > dl_int2 || ...
               isnan(dl_int1) || isnan(dl_int2) || ... 
               nachk_dl_int1 > 0 || nachk_dl_int2 > 0) || ...
               nachk_mat_int1 > 0 || nachk_mat_int2 > 0 || ...
               nachk_hz_int1 > 3 || nachk_hz_int2 > 3 || ...
               nachk_kz_int1 > 3 || nachk_kz_int2 > 3
           
                if m <= 0 || round(m) ~= m
                    errordlg('Die Anzahl der Artikel muss positiv und ganzzahlig sein.','Eingabe Fehler') 
                end
                if n <= 0 || round(n) ~= n
                    errordlg('Die Anzahl der Aufträge muss positiv und ganzzahlig sein.','Eingabe Fehler') 
                end
                if dichte <= 0 || dichte > 1 || isnan(dichte)
                    errordlg('Die Dichte der Zuweisungsmatrix muss aus dem Intervall (0,1] sein.','Eingabe Fehler') 
                end
                if mat_int1 < 0 || mat_int2 < 0 || mat_int1 > mat_int2 || isnan(mat_int1) || isnan(mat_int2) || nachk_mat_int1 > 0 || nachk_mat_int2 > 0
                    errordlg(sprintf('Der Wert für den Beginn des Intervalls der Zufallswerte der Matrix darf nicht größer sein als der Wert für das Intervallende. \nAußerdem dürfen die Werte keine Nachkommastellen aufweisen und müssen nichtnegativ sein.'),'Eingabe Fehler') 
                end
                if hz_int1 < 0 || hz_int2 < 0 || hz_int1 > hz_int2 || isnan(hz_int1) || isnan(hz_int2) || nachk_hz_int1 > 3 || nachk_hz_int2 > 3
                    errordlg(sprintf('Der Wert für den Beginn des Intervalls der Zufallswerte der Holzeiten darf nicht größer sein als der Wert für das Intervallende. \nAußerdem dürfen die Werte nicht mehr als drei Nachkommastellen aufweisen und müssen nichtnegativ sein.'),'Eingabe Fehler') 
                end
                if kz_int1 < 0 || kz_int2 < 0 || kz_int1 > kz_int2 || isnan(kz_int1) || isnan(kz_int2) || nachk_kz_int1 > 3 || nachk_kz_int2 > 3
                    errordlg(sprintf('Der Wert für den Beginn des Intervalls der Zufallswerte der Kommissionierzeiten darf nicht größer sein als der Wert für das Intervallende. \nAußerdem dürfen die Werte nicht mehr als drei Nachkommastellen aufweisen und müssen nichtnegativ sein.'),'Eingabe Fehler') 
                end
                if dl_menge ~= 1 && (dl_int1 < 0 || dl_int2 < 0 || dl_int1 > dl_int2 || isnan(dl_int1) || isnan(dl_int2) || nachk_dl_int1 > 0 || nachk_dl_int2 > 0)
                    errordlg(sprintf('Der Wert für den Beginn des Intervalls der Zufallswerte der Deadlines darf nicht größer sein als der Wert für das Intervallende. \nAußerdem dürfen die Werte keine Nachkommastellen aufweisen und müssen nichtnegativ sein.'),'Eingabe Fehler') 
                end
                set(hui(208),'CallBack', 'KMT AuftragErzeugen');
            else
                if dl_menge > 1
                    [A,HZ,KZ,DL] = ZufaelligeZuweisungsmatrix(m,n,dichte,mat_int1,mat_int2,hz_int1,hz_int2,kz_int1,kz_int2,nachk_hz_int1,nachk_hz_int2,nachk_kz_int1,nachk_kz_int2,dl_menge,dl_int1,dl_int2,nachk_dl_int1,nachk_dl_int2);
                else
                    [A,HZ,KZ,DL] = ZufaelligeZuweisungsmatrix(m,n,dichte,mat_int1,mat_int2,hz_int1,hz_int2,kz_int1,kz_int2,nachk_hz_int1,nachk_hz_int2,nachk_kz_int1,nachk_kz_int2,dl_menge);
                end
                set(hui(200:206),'Enable','off');
                set(hui(208),'Value',0); % grau
                set(hui(208),'String','erzeugt','Style','text','Position',[.78 .5 .1 .05]);
                set(hui(210),'Style','text','Position',[.6 .5 .05 .05]);
                set(hui(212),'Style','text','Position',[.6 .45 .05 .05]);
                set(hui(214),'Style','text','Position',[.6 .4 .05 .05]);
                set(hui(216),'Style','text','Position',[.78 .35 .05 .05]);
                set(hui(217),'Style','text','Position',[.83 .35 .05 .05]);
                set(hui(219),'Style','text','Position',[.78 .3 .05 .05]);
                set(hui(220),'Style','text','Position',[.83 .3 .05 .05]);
                set(hui(222),'Style','text','Position',[.78 .25 .05 .05]);
                set(hui(223),'Style','text','Position',[.83 .25 .05 .05]);
                set(hui(231),'Style','text','Position',[.78 .2 .05 .05]);
                set(hui(232),'Style','text','Position',[.83 .2 .05 .05]);
                set(hui(225:227),'Enable','on');
                anz_dl = get(hui(229),'Value');
                set(hui(229),'Style','text','Position',[.78 .43 .05 .05]);
                switch anz_dl
                    case 1
                        set(hui(229),'String','keine');
                    case 2
                        set(hui(229),'String','wenige');
                    case 3
                        set(hui(229),'String','mittel');
                    case 4
                        set(hui(229),'String','viele');
                    case 5
                        set(hui(229),'String','alle');
                end
            end


        case 'AenderAuftrag'

            set(hui(200:224),'Enable','on');
            set(hui(228:232),'Enable','on');
            set(hui(201),'String','laden','Style','push','Position',[.210 .71 .12 .05]);
            set(hui(202),'String',' ');
            set(hui(204:2:206),'String',' ');
            set(hui(208),'String','erzeugen','Style','push','Position',[.78 .51 .1 .05]);
            set(hui(210),'Style','edit','Position',[.6 .51 .05 .05]);
            set(hui(212),'Style','edit','Position',[.6 .46 .05 .05]);
            set(hui(214),'Style','edit','Position',[.6 .41 .05 .05]);
            set(hui(216),'Style','edit','Position',[.78 .36 .05 .05]);
            set(hui(217),'Style','edit','Position',[.83 .36 .05 .05]);
            set(hui(219),'Style','edit','Position',[.78 .31 .05 .05]);
            set(hui(220),'Style','edit','Position',[.83 .31 .05 .05]);
            set(hui(222),'Style','edit','Position',[.78 .26 .05 .05]);
            set(hui(223),'Style','edit','Position',[.83 .26 .05 .05]);
            set(hui(231),'Style','edit','Position',[.78 .21 .05 .05]);
            set(hui(232),'Style','edit','Position',[.83 .21 .05 .05]);
            set(hui(225:227),'Enable','off');
            set(hui(229),'Style','popupmenu','Position',[.78 .43 .1 .05],...
                     'String',{'keine','wenige','mittel','viele','alle'});

        case 'SpeicherAuftrag'
            
            [filename2, pathname2] = uiputfile({'*.mat','MAT-files (*.mat)'},'Auftragsserie speichern','.\Auftragsserien(mat-Dateien)\ZufälligeAuftragsserie.mat');
            if filename2 ~= 0 % Wenn man auf Abbrechen gedrückt hat, dann hat filename den Wert Null
                savefile = fullfile(pathname2,filename2);
                
                % Eingabeparameter an die internen Parameter anpassen
                W = A;
                H = HZ;
                K = KZ;
                save(savefile,'W','H','K','DL');
            end

            
        case 'WeiterSeite1'

            set(hui(100),'String','Auftragsserie   >   Stellplatzbegrenzung und Deadline');
            set(hui(103),'Callback','KMT InfoStellplatzbegrenzung');
            
            set(hui(200:232),'Visible','off','Enable','inactive');
            set(hui(300:301),'Visible','on','Enable','on');
            set(hui(302:303),'Visible','on','Enable','off');
            set(hui(304),'Visible','on','Enable','on');
            set(hui(305:306),'Visible','on','Enable','off');
            set(hui(306),'BackgroundColor','default');
            set(hui(307:308),'Visible','on','Enable','on');
            set(hui(309:311),'Visible','on','Enable','off','Style','push');
            
            set(hui(301),'Style','push'); % Wenn man zwischendurch wieder auf der ersten Seite war,
            set(hui(303),'Style','edit'); % dann muss man die Stellplätze noch mal aktualisieren
            set(hui(304),'Style','push');


        % Für die zweite Seite    
        case 'StellplatzberenzungJa'

            SP_ja_nein = 1; % Ja
            
            set(hui(301),'Value',0); % grau            
            set(hui(301),'Style','text');
            set(hui(302:303),'Enable','on');
            set(hui(304),'Enable','off'); 
            set(hui(305),'Enable','on');
            set(hui(309:310),'Enable','on');

        case 'StellplatzberenzungNein'   

            SP_ja_nein = -1; % Nein
            SP = -1; % Zur Ermittung, welche Zielfunktionen angeboten werden
            DL_ja_nein = -1; %ohne Deadline
            
            set(hui(301:303),'Enable','off');
            set(hui(304),'Value',0); % grau
            set(hui(304),'Style','text'); 
            set(hui(305:306),'Enable','on'); 
            set(hui(306),'BackgroundColor','g');
            
        case 'StellplatzberenzungAendern'  

            SP_ja_nein = 0; % Neutral
            DL_ja_nein = 0; 
            
            set(hui(301),'Enable','on','Style','push');
            set(hui(302:303),'Enable','off');
            set(hui(304),'Enable','on','Style','push');
            set(hui(305:306),'Enable','off');
            set(hui(306),'BackgroundColor','default');
            set(hui(309:310),'Enable','off','Style','push');
            set(hui(311),'Enable','off');
            
        case 'DeadlineJa'
            
            DL_ja_nein = 1; % Ja
            SP_ja_nein = 1;
            
            set(hui(306),'Enable','on');
            set(hui(306),'BackgroundColor','g');
            set(hui(309),'Value',0); % grau
            set(hui(309),'Style','text');
            set(hui(310),'Enable','off'); 
            set(hui(311),'Enable','on');
            
        case 'DeadlineNein'
            
            DL_ja_nein = -1; % Nein
            SP_ja_nein = 1;
            
            set(hui(306),'Enable','on');
            set(hui(306),'BackgroundColor','g');
            set(hui(310),'Value',0); % grau
            set(hui(310),'Style','text');
            set(hui(309),'Enable','off'); 
            set(hui(311),'Enable','on');
            
        case 'DeadlineAendern' 
            
            DL_ja_nein = 0; % Neutral
            
            set(hui(306),'Enable','off','BackgroundColor','default');
            set(hui(309:310),'Enable','on','Style','push');
            set(hui(311),'Enable','off');
            
        case 'WeiterSeite2'

            if DL_ja_nein == 1 && length(DL) < size(A,2)            % Überprüft, ob alle Aufträgen eine Deadline zugewiesen ist. 
               temp = length(DL);                                   % Sollte das nicht der Fall sein, wird diesen Aufträgen 
               if length(DL) == 1 && DL == 0
                   DL = Inf;
               end
               for i=1:size(A,2)-temp                               % eine Deadline von 0 zugewiesen (= keine Deadline)
                   DL(temp+i) = Inf;
               end
               DL = DL.';
               clear temp;
               Text = ['In der von Ihnen gewählte Auftragsserie',...
                       ' existieren Aufträge, denen keine',...
                       ' Deadline zugewiesen ist. Diese Aufträgen'...
                       ' werden im weiteren Verlauf so behandelt,',...
                       ' als hätten sie keine Deadline.'];

               helpdlg(Text,'Information');
            end

            if SP_ja_nein == 1
                % Strings in numerische Werte umwandeln
                SP_str = get(hui(303),'String');
                SP = str2double(SP_str);

                n=size(A,2); % Damit n bekannt ist

                % Fehlerabfragen
                if SP <= 0 || round(SP) ~= SP || SP > n
                    errordlg(sprintf('Die Anzahl der Stellplätze muss positiv und ganzzahlig sein. \nAußerdem darf der Wert nicht die Anzahl der Aufträge überschreiten.'),'Eingabe Fehler') 

                    set(hui(306),'CallBack','KMT WeiterSeite2');
                else
                    set(hui(301),'Style','text');
                    set(hui(303:304),'Style','text'); 
                    set(hui(304),'Enable','off');
                    set(hui(305:306),'Enable','on');   

                    set(hui(100),'String','Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion');
                    set(hui(103),'Callback','KMT InfoZielfunktion');
                    set(hui(300:311),'Visible','off','Enable','inactive');
                    set(hui(400),'Visible','on','Enable','on');

                    if SP < 0 % ohne Stellplatzbegrenzung
                        set(hui(401),'Visible','on','Enable','on');
                    else % mit Stellplatzbegrenzung

                        if DL_ja_nein < 0 %ohne Deadline
                            set(hui(402),'Visible','on','Enable','on');
                        else %mit Deadline (hui(403)
                            set(hui(403),'Visible','on','Enable','on');
                        end
                    end

                    set(hui(404:405),'Visible','on','Enable','on');
                end
            else
                set(hui(100),'String','Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion');
                set(hui(103),'Callback','KMT InfoZielfunktion');
                set(hui(300:311),'Visible','off','Enable','inactive');
                set(hui(400),'Visible','on','Enable','on');

                if SP < 0 % ohne Stellplatzbegrenzung
                    set(hui(401),'Visible','on','Enable','on');
                else % mit Stellplatzbegrenzung
                    if DL_ja_nein < 0 %ohne Deadline
                        set(hui(402),'Visible','on','Enable','on');
                    else %mit Deadline (hui(403))
                        set(hui(403),'Visible','on','Enable','on');
                    end
                end

                set(hui(404:405),'Visible','on','Enable','on');
            end
            
        case 'ZurueckSeite2'

            set(hui(100),'String','Auftragsserie');
            set(hui(103),'Callback','KMT InfoAuftragsserie');
            
            if strcmp(get(hui(208),'String'),'erzeugen')
                set(hui(200:207),'Visible','on','Enable','on');
                set(hui(207:225),'Visible','on','Enable','off');
                set(hui(228:232),'Visible','on','Enable','off');
            else
                set(hui(200:207),'Visible','on','Enable','off');
                set(hui(207:225),'Visible','on','Enable','on');
                set(hui(228:232),'Visible','on','Enable','on');
            end

            set(hui(226:227),'Visible','on','Enable','on');
            set(hui(300:311),'Visible','off','Enable','inactive');


        % Für die dritte Seite        
        case 'ZielfunktionAuswahl'

            [m,n] = size(A);
            OrderArtikel = zeros(m,AnzArtikelVerfahren);
            Zielfunktionswert = zeros(AnzArtikelVerfahren,1);
            
            if SP < 0% ohne Stellplatzbegrenzung
                AufRneu = zeros(AnzArtikelVerfahren,n);
                Loese = zeros(1,AnzArtikelVerfahren);
                Verb = zeros(1,AnzVerbesserungsVerfahren);
                Ziel = get(hui(401),'Value');
                tmp_value = get(hui(401),'Value');
                tmp_string = get(hui(401),'String');
                KMT VerfahrenOhneSPG;         
            else % mit Stellplatzbegrenzung
                if DL_ja_nein < 0 %ohne Deadline
                    Art = zeros(1,AnzArtikelVerfahren);
                    ArtR = zeros(1,AnzArtikelVerfahren);
                    ArtD = zeros(1,AnzArtikelVerfahren);
                    Auf = zeros(1,AnzAuftragsVerfahren);
                    Ziel = get(hui(402),'Value');
                    tmp_value = get(hui(402),'Value');
                    tmp_string = get(hui(402),'String');
                    KMT ArtikelVerfahrenMitSPG; 
                else 
                    Art = zeros(1,AnzArtikelVerfahren);
                    ArtR = zeros(1,AnzArtikelVerfahren);
                    ArtD = zeros(1,AnzArtikelVerfahren);
                    Auf = zeros(1,AnzAuftragsVerfahrenMitDL);
                    AufRest = zeros(1,AnzAuftragsVerfahren);
                    VerbDL = zeros(1,AnzAuftragsVerfahren);
                    Ziel = get(hui(403),'Value');
                    tmp_value = get(hui(403),'Value');
                    tmp_string = get(hui(403),'String');
                    if tmp_string(Ziel,:) == 'min! sum. gewichtete Überschreitung der Deadlines           '
                        Text = ['Sie haben die Zielfunktion',...
                        ' "min! sum. gewichtete Überschreitung der',...
                        ' Deadlines" ausgewählt. Bitte geben Sie die',...
                        ' durch ein Leerzeichen getrennten Gewichte'...
                        ' und die dazugehörigen Grenzen (in ZE) ein.'...
                        ' Achten Sie darauf, dass die Anzahl der Gewichte',...
                        ' mit der Anzahl der Grenzen übereinstimmt.',...
                        ' Zugelassene sind Zahlen >= 0']; 
                        temp_box = msgbox(Text,'Information','help');
                        set(temp_box,'Units','normalized');
                        set(temp_box,'Position',[.39,.67,.225,.11]);

                        Gewichtung = inputdlg({'Gewichte','Grenzen','Gewicht bei Überschreitung aller Grenzen'},' Input ',...
                                               [1 30; 1 30; 1 30],{'1 3','5 20','10'});
                       
                        if (isempty(Gewichtung)) % Wenn der 'Cancel'-Button betätigt wurde, breche ab und kehre zur Zielfunktionsauswahlseite zurück
                            delete (temp_box);
                            return
                        end
                        
                        weights = str2num(Gewichtung{1,1}); % wandle die erste Zeile von 'Gewichtung' in einen Vektor um (Gewichte)
                        limits = str2num(Gewichtung{2,1}); % wandle die zweite Zeile von 'Gewichtung' in einen Vektor um (Grenzen)
                        overlimitweight = str2num(Gewichtung{3,1});
                        
                        if isempty(weights) % sollten dabei leere Vektoren herauskommen, weise ihnen den Wert 0 zu (zur Bearbeitung in nächster if-Verzweigung) 
                            weights = 0;
                        end
                        if isempty(limits)
                            limits = 0;
                        end
                        if isempty(overlimitweight)
                            overlimitweight = 0;
                        end
                        
                        if length(weights) > length(limits) % sollte einer der beiden Vektoren kürzer sein als der andere, wird der kürzere auf die Länge des längeren gebracht und mit NaNs gefüllt
                            limits(1:length(weights)) = NaN;
                        elseif length(weights) < length(limits)
                            weights(1:length(limits)) = NaN;
                        end
                        
                        if ~isempty(find(weights <= 0)) % sollte in einem der beiden Vektoren eine Zahl <= 0 sein, fülle ihn mit NaNs 
                            weights(1:length(weights)) = NaN;
                        end
                        if ~isempty(find(limits <= 0))
                            limits(1:length(limits)) = NaN;
                        end
                        if ~isempty(find(overlimitweight <= 0))
                            overlimitweight = NaN;
                        end
                        
                        if ~(length(overlimitweight) == 1) % sollte für das Gewicht bei Überschreitung aller Grenzen etwas anderes als EINE Zahl eingegeben worden sein: NaN
                            overlimitweight(1:length(weights)) = NaN;
                        end
                        
                        if length(weights) > 1 % fülle den Vektor der Gewichte bei Überschreitung mit Nullen (damit die Dimension passt)
                            if isnan(overlimitweight(1))
                                overlimitweight(2:length(weights)) = NaN;
                            else
                                overlimitweight(2:length(weights)) = 0;
                            end 
                        end

                        Gewichtung = [weights;limits;overlimitweight]; % füge die Vektoren der Gewichte und Grenzen zusammen in 'Gewichtung'. Ist jetzt keine cell-Array mehr, sondern eine Matrix,

                        while sum(isnan(Gewichtung)) > 0 % solang irgendwo in 'Gewichtung' ein NaN steht liegt eine falsche Eingabe vor

                            Gewichtung = inputdlg({'Gewichte','Grenzen','Gewicht bei Überschreitung aller Grenzen'},' ',... % es wird zur erneuten Eingabe aufgefordert
                                             [1 30; 1 30; 1 30],{'1 3','5 20','10'});

                            if (isempty(Gewichtung)) % gleicher Teil wie oben; bei 'Cancel' breche ab
                                delete (temp_box);
                                return
                            end            
                                         
                            weights = (str2num(Gewichtung{1,1}));
                            limits = (str2num(Gewichtung{2,1}));
                            overlimitweight = str2num(Gewichtung{3,1});
                        
                            if isempty(weights) % sollten dabei leere Vektoren herauskommen, weise ihnen den Wert 0 zu (zur Bearbeitung in nächster if-Verzweigung) 
                                weights = 0;
                            end
                            if isempty(limits)
                                limits = 0;
                            end
                            if isempty(overlimitweight)
                                overlimitweight = 0;
                            end

                            if length(weights) > length(limits) % sollte einer der beiden Vektoren kürzer sein als der andere, wird der kürzere auf die Länge des längeren gebracht und mit NaNs gefüllt
                                limits(1:length(weights)) = NaN;
                            elseif length(weights) < length(limits)
                                weights(1:length(limits)) = NaN;
                            end

                            if ~isempty(find(weights <= 0)) % sollte in einem der beiden Vektoren eine Zahl <= 0 sein, fülle ihn mit NaNs 
                                weights(1:length(weights)) = NaN;
                            end
                            if ~isempty(find(limits <= 0))
                                limits(1:length(limits)) = NaN;
                            end
                            if ~isempty(find(overlimitweight <= 0))
                                overlimitweight = NaN;
                            end
                            
                            if ~(length(overlimitweight) == 1) % sollte für das Gewicht bei Überschreitung aller Grenzen etwas anderes als EINE Zahl eingegeben worden sein: NaN
                                overlimitweight(1:length(weights)) = NaN;
                            end
                            
                            if length(weights) > 1 % fülle den Vektor der Gewichte bei Überschreitung mit Nullen (damit die Dimension passt)
                                if isnan(overlimitweight(1))
                                    overlimitweight(2:length(weights)) = NaN;
                                else
                                    overlimitweight(2:length(weights)) = 0;
                                end 
                            end

                            Gewichtung = [weights;limits;overlimitweight]; % füge die Vektoren der Gewichte und Grenzen zusammen in 'Gewichtung'. Ist jetzt keine cell-Array mehr, sondern eine Matrix,

                        end

                        delete (temp_box);
                    
                    end
                    
                    KMT ArtikelVerfahrenMitSPGUndDL;
                end  
            end

            set(hui(100),'String',['Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion: ' tmp_string(tmp_value,:) '   >   Artikelreihenfolgeverfahren']);
            set(hui(103),'Callback','KMT InfoArtikelreihenfolgeverfahren');
            set(hui(400:405),'Visible','off','Enable','inactive');


       case 'ZurueckSeite3'

           set(hui(100),'String','Auftragsserie   >   Stellplatzbegrenzung und Deadline');
           set(hui(103),'Callback','KMT InfoStellplatzbegrenzung');
           set(hui(400:405),'Visible','off','Enable','inactive');

           KMT WeiterSeite1;      
            

%% Zielfunktionen Ohne Stellplatzbegrenzung

        case 'VerfahrenOhneSPG'
            
            PositionCheckbox = [.08 .71 .44 .05;
                                .08 .66 .44 .05;
                                .08 .61 .44 .05;
                                .08 .56 .44 .05;
                                .08 .51 .44 .05;
                                .08 .46 .44 .05;
                                .08 .41 .44 .05;
                                .08 .36 .44 .05;
                                .08 .31 .44 .05;
                                .52 .71 .44 .05;
                                .52 .66 .44 .05;
                                .52 .61 .44 .05;
                                .52 .56 .44 .05;
                                .52 .51 .44 .05;
                                .52 .46 .44 .05;
                                .52 .41 .44 .05;
                                .52 .36 .44 .05;
                                .52 .31 .44 .05;
                                .52 .26 .44 .05];

            hui(1000) = uicontrol('Style','text',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'HorizontalAlignment','center',...  % Damit der Text mittig ist
                                  'Position',[0 .75 1 .05],...
                                  'String','Artikelreihenfolgeverfahren:');

           for i = 1:length(ArtikelVerfahrenNamen)
            	hui(i+1000) = uicontrol('Style','checkbox',...
                                        'Units','normalized',...
                                        'FontSize',Schriftgroesse1,...
                                        'FontUnits','normalized',...
                                        'Position',PositionCheckbox(i,:),...
                                        'Value',Loese(i),...
                                        'String',ArtikelVerfahrenNamen{i});
                                    

            end
            
            hui(1020) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.8 .1 .15 .05],...
                                  'String','lösen',...
                                  'CallBack','KMT LösungOhneSPG');

            hui(1021) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.05 .1 .15 .05],...
                                  'String','zurück',...
                                  'CallBack','KMT BackZiel'); 

            hui(1022) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.55 .1 .15 .05],...
                                  'String','alle auswählen',...
                                  'CallBack','KMT AlleVerfahrenOhneSPG');

            hui(1023) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.3 .1 .15 .05],...
                                  'String','keins auswählen',...
                                  'CallBack','KMT KeineVerfahrenOhneSPG'); 


        case 'LösungOhneSPG'
            
            Loese = [get(hui(1001),'Value')
                     get(hui(1002),'Value')
                     get(hui(1003),'Value')
                     get(hui(1004),'Value')
                     get(hui(1005),'Value')
                     get(hui(1006),'Value')
                     get(hui(1007),'Value')
                     get(hui(1008),'Value')
                     get(hui(1009),'Value')
                     get(hui(1010),'Value')
                     get(hui(1011),'Value')
                     get(hui(1012),'Value')
                     get(hui(1013),'Value')
                     get(hui(1014),'Value')
                     get(hui(1015),'Value')
                     get(hui(1016),'Value')
                     get(hui(1017),'Value')
                     get(hui(1018),'Value')
                     get(hui(1019),'Value')]; 
                 
            SummeLoese = sum(Loese);     
                 
            if SummeLoese == 0 
                errordlg('Bitte wählen Sie mindestens ein Artikelreihenfolgeverfahren aus.','Fehler')
            else
                tmp_value = get(hui(401),'Value');
                tmp_string = get(hui(401),'String');
                set(hui(100),'String',['Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion: ' tmp_string(tmp_value,:) '   >   Artikelreihenfolgeverfahren   >   Lösung']);
                set(hui(103),'Callback','KMT InfoLoesungArt'); 
                set(hui(1000:1023),'Visible','off','Enable','inactive'); 

                Info_waitbar = waitbar(0,'Berechnung läuft...','Name','Information',...
                                       'CreateCancelBtn',...
                                       'setappdata(gcbf,''canceling'',1)');   
                children_info = get(Info_waitbar, 'children'); % Cancel Button
                set(children_info(1), 'String', 'abbrechen')   % umbennenen
                setappdata(Info_waitbar,'canceling',0)
                waitbar(0,Info_waitbar,'Berechnung läuft...')
                
                [m,n] = size(A);
                BZ = Bearbeitungszeit(A,HZ,KZ);
                HA = Haufigkeit(A);
                AufR = 1:n; % Topologische Auftragsreihenfolge
                Zielfunktionswertgesamt = [0 0];
                Rechenzeit = 0;
                
                if Ziel == 3
                    Data = cell(SummeLoese,5);
                else
                    Data = cell(SummeLoese,4);
                end     
                
                steps = SummeLoese;
                
                % Die Rechenzeit für das erste Verfahren ist langsamer als die anderen
                % Deswegen das Verfahren einmal durchlaufen lassen
                tic
                switch Ziel 
                    case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte
                        LoeschMich1 = FSZ(A,[1:m]',BZ); %#ok<*NASGU>
                    case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt
                        LoeschMich1 = FF(A,[1:m]',BZ);    
                    case 3 % Zielfunktion: min! sum. spez. Fertigstellungszeitpunkte
                        [LoeschMich2,LoeschMich3] = SFSZ(A,[1:m]',AufR,BZ,HZ,KZ);
                    case 4 % Zielfunktion: min! sum. Unproduktivzeiten
                        LoeschMich1 = UPZ(A,[1:m]',BZ);
                    case 5 % Zielfunktion: min! max. Unproduktivzeit
                        LoeschMich1 = MUPZ(A,[1:m]',BZ);
                    case 6 % Zielfunktion: min! sum. Stellplatzzeiten
                        LoeschMich1 = SPZ(A,[1:m]',BZ);
                    case 7 % Zielfunktion: min! Anzahl Stellplätze
                        LoeschMich1 = ASP(A,[1:m]');
                end
                clear LoeschMich*
                Time = toc;
                
                i = 1;
                for index = 1:length(ArtikelVerfahrenNamen)
                    if Loese(index) == 1
                        tic % Rechenzeit beginnen

                        switch index
                            case 1
                                OrderArtikel(:,i) = [1:m]'; %#ok<*NBRAK> unterdrückt die Fehlermeldung, dass die Klammern überflüssig sind
                            case 2
                                OrderArtikel(:,i) = minBmaxH(HA,BZ);
                            case 3
                                OrderArtikel(:,i) = maxBmaxH(HA,BZ);
                            case 4
                                OrderArtikel(:,i) = minHtopo(HA,BZ);
                            case 5
                                OrderArtikel(:,i) = maxHtopo(HA,BZ);
                            case 6
                                OrderArtikel(:,i) = maxHminB(HA,BZ);
                            case 7
                                OrderArtikel(:,i) = maxHmaxB(HA,BZ);
                            case 8
                                OrderArtikel(:,i) = zenReihAufst(HA);
                            case 9
                                OrderArtikel(:,i) = zenReihAbst(HA);
                            case 10
                                OrderArtikel(:,i) = minAtopo(A);
                            case 11
                                OrderArtikel(:,i) = minAminB(A,BZ);
                            case 12
                                OrderArtikel(:,i) = minAmaxB(A,BZ);
                            case 13
                                OrderArtikel(:,i) = minAminH(A,HA);
                            case 14
                                OrderArtikel(:,i) = minAmaxH(A,HA);
                            case 15
                                OrderArtikel(:,i) = maxAtopo(A);
                            case 16
                                OrderArtikel(:,i) = maxAminB(A,BZ);
                            case 17
                                OrderArtikel(:,i) = maxAmaxB(A,BZ);
                            case 18
                                OrderArtikel(:,i) = maxAminH(A,HA);
                            case 19
                                OrderArtikel(:,i) = maxAmaxH(A,HA);
                        end
                                
                        switch Ziel 
                            case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte
                                Zielfunktionswert(i) = FSZ(A,OrderArtikel(:,i),BZ);
                                
                            case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt
                                Zielfunktionswert(i) = FF(A,OrderArtikel(:,i),BZ);    

                            case 3 % Zielfunktion: min! sum. spez. Fertigstellungszeitpunkte
                                [Zielfunktionswertgesamt,AufRneu(i,:)] = SFSZ(A,OrderArtikel(:,i),AufR,BZ,HZ,KZ);
                                Zielfunktionswert(i) = Zielfunktionswertgesamt(2); % Zielfunktionswertgesamt ist ein 2-dim Vektor, wobei der zweite Wert die Verbesserung ist
                           
                            case 4 % Zielfunktion: min! sum. Unproduktivzeiten
                                Zielfunktionswert(i) = UPZ(A,OrderArtikel(:,i),BZ);

                            case 5 % Zielfunktion: min! max. Unproduktivzeit
                                Zielfunktionswert(i) = MUPZ(A,OrderArtikel(:,i),BZ);

                            case 6 % Zielfunktion: min! sum. Stellplatzzeiten
                                Zielfunktionswert(i) = SPZ(A,OrderArtikel(:,i),BZ);

                            case 7 % Zielfunktion: min! Anzahl Stellplätze
                                Zielfunktionswert(i) = ASP(A,OrderArtikel(:,i));
                        end

                        Rechenzeit = toc; % Rechenzeit stoppen

                        if Ziel == 3
                            Data(i,:) = {ArtikelVerfahrenNamen{index},Zielfunktionswert(i),Rechenzeit,int2str(OrderArtikel(:,i)'),int2str(AufRneu(i,:))};
                        else
                            Data(i,:) = {ArtikelVerfahrenNamen{index},Zielfunktionswert(i),Rechenzeit,int2str(OrderArtikel(:,i)')};
                        end

                        if getappdata(Info_waitbar,'canceling')
                            delete(Info_waitbar)
                            KMT VerfahrenOhneSPG  
                        else
                            waitbar(i/steps,Info_waitbar,'Berechnung läuft...')
                        end

                        i = i+1;
                    end
                end 
                
                % Die Güte der Zielfunktionswerte mit in Data aufnehmen
                Abweichung_rel = RelativeAbweichung(Zielfunktionswert(1:SummeLoese,:));
                Data = [Data(:,1:2) Abweichung_rel Data(:,3:end)];

                delete(Info_waitbar)
                
                Ausgabe = Data;
                if Ziel == 3
                    Titel = {'Verfahren','Zielfunktionswert','Abweichung (%)','Rechenzeit (s)','Artikelreihenfolge','Auftragsreihenfolge'};
                    hui(1024) = uitable('Data',Data,...
                                        'Units','normalized',...
                                        'FontSize',Schriftgroesse1,...
                                        'FontUnits','normalized',...
                                        'ColumnFormat',{'char','char','char','char','char','char'},...
                                        'ColumnName',Titel,...
                                        'ColumnWidth',{600 'auto' 100 120 500 500},...
                                        'ColumnEditable',[false false false false false false],...
                                        'RowName',[],...
                                        'Position',[0 0.25 1 0.6]); % je kleiner die Höhe vom Fenster desto kleiner die Schrift
                else
                    Titel = {'Verfahren','Zielfunktionswert','Abweichung (%)','Rechenzeit (s)','Artikelreihenfolge'};
                    hui(1024) = uitable('Data',Data,...
                                        'Units','normalized',...
                                        'FontSize',Schriftgroesse1,...
                                        'FontUnits','normalized',...
                                        'ColumnFormat',{'char','char','char','char','char'},...
                                        'ColumnName',Titel,...
                                        'ColumnWidth',{600 'auto' 100 120 700},...
                                        'ColumnEditable',[false false false false false],...
                                        'RowName',[],...
                                        'Position',[0 0.25 1 0.6]); 
                end
                
                hui(1025) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.05 .1 .15 .05],...
                                      'String','zurück',...
                                      'CallBack','KMT BackVerfahrenOhneSPG'); 
                                  
                hui(1026) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.3 .1 .15 .05],...
                                      'String','Neustart',...
                                      'CallBack','KMT'); 
                                  
                hui(1027) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.55 .1 .15 .05],...
                                      'String','speichern',...
                                      'CallBack','KMT SpeicherZoSPG');

                hui(1028) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.8 .1 .15 .05],...
                                      'String','verbessern',...
                                      'CallBack','KMT ArtikelAuswahlVerbesserungOhneSPG');
            end
            
            
        case 'ArtikelAuswahlVerbesserungOhneSPG'
            tmp_value = get(hui(401),'Value');
            tmp_string = get(hui(401),'String');
            set(hui(100),'String',['Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion: ' tmp_string(tmp_value,:) '   >   Artikelreihenfolgeverfahren   >   Lösung   >   Verbesserung']);
            set(hui(103),'Callback','KMT InfoVerbesserung');
            set(hui(1024:1028),'Visible','off','Enable','inactive');
            
            PositionCheckbox = [.08 .71 .44 .05;
                                .08 .66 .44 .05;
                                .08 .61 .44 .05;
                                .08 .56 .44 .05;
                                .08 .51 .44 .05;
                                .08 .46 .44 .05;
                                .08 .41 .44 .05;
                                .08 .36 .44 .05;
                                .08 .31 .44 .05;
                                .52 .71 .44 .05;
                                .52 .66 .44 .05;
                                .52 .61 .44 .05;
                                .52 .56 .44 .05;
                                .52 .51 .44 .05;
                                .52 .46 .44 .05;
                                .52 .41 .44 .05;
                                .52 .36 .44 .05;
                                .52 .31 .44 .05;
                                .52 .26 .44 .05];
                   
            j = 1;            
            
            for i = 1:length(ArtikelVerfahrenNamen)
                if Loese(i) == 1
                    hui(1033+j) = uicontrol('Style','checkbox',...
                                            'Units','normalized',...
                                            'FontSize',Schriftgroesse1,...
                                            'FontUnits','normalized',...
                                            'String',ArtikelVerfahrenNamen{i},...
                                            'Position',PositionCheckbox(j,:));
                    if Zielfunktionswert(j) == 0
                        set(hui(1033+j),'Enable','off') % Wenn der Zielfunktionswert schon Null ist braucht ja kein Verbesserungsverfahren angewandt werden
                    end
                    j = j+1;
                end
            end
                   
            hui(1029) = uicontrol('Style','text',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'HorizontalAlignment','center',...  % Damit der Text linksbündig ist
                                  'Position',[0 .75 1 .05],...
                                  'String','Artikelreihenfolgeverfahren wählen worauf Verbesserungsverfahren angewendet werden sollen:');

            hui(1030) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.05 .1 .15 .05],...
                                  'String','zurück',...
                                  'CallBack','KMT BackLösungOhneSPG'); 

            hui(1031) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.8 .1 .15 .05],...
                                  'String','weiter',...
                                  'CallBack','KMT VerbesserungOhneSPG');

            hui(1032) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.55 .1 .15 .05],...
                                  'String','alle auswählen',...
                                  'CallBack','KMT AlleErVerOhneSPG'); 

            hui(1033) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.3 .1 .15 .05],...
                                  'String','keins auswählen',...
                                  'CallBack','KMT KeineErVerOhneSPG');
            

        case 'VerbesserungOhneSPG' 
            
            Data = get(hui(1024),'Data');
            z = size(Data,1);

            % Prüfen wie viele Verfahren verbessert werden sollen 
            SumArtikelVerfahrenVerbessern = 0;
            for i=1:z
                SumArtikelVerfahrenVerbessern = SumArtikelVerfahrenVerbessern+get(hui(1033+i),'Value');
            end

            if SumArtikelVerfahrenVerbessern == 0 
                errordlg('Bitte wählen Sie die Artikelreihenfolgeverfahren aus die im nächsten Schritt, mit den entsprechenden Verfahren, verbessert werden.','Fehler')
            else
                tmp_value = get(hui(401),'Value');
                tmp_string = get(hui(401),'String');
                set(hui(100),'String',['Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion: ' tmp_string(tmp_value,:) '   >   Artikelreihenfolgeverfahren   >   Lösung   >   Verbesserung   >   Verbesserungsverfahren']);
                set(hui(103),'Callback','KMT InfoVerbesserungsverfahren');
                set(hui(1029:(1033+sum(Loese))),'Visible','off','Enable','inactive');
                
                Plus_Abbruchbed = false; % Keine zusätzlichen Abbruchbedingungen der Verbesserungsverfahren

                hui(1055) = uicontrol('Style','text',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'HorizontalAlignment','left',...  % Damit der Text linksbündig ist
                                      'Position',[.08 .6 .15 .05],...
                                      'String','Verbesserungsverfahren:');

                hui(1056) = uicontrol('Style','checkbox',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.24 .61 .15 .05],...
                                      'Value',Verb(1),...
                                      'String','2-Tausch First');

                hui(1057) = uicontrol('Style','checkbox',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.24 .56 .15 .05],...
                                      'Value',Verb(2),...
                                      'String','2-Tausch Best');

                hui(1058) = uicontrol('Style','checkbox',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.24 .51 .15 .05],...
                                      'Value',Verb(3),...
                                      'String','1-Verschieben First');

                hui(1059) = uicontrol('Style','checkbox',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.24 .46 .15 .05],...
                                      'Value',Verb(4),...
                                      'String','1-Verschieben Best');

                hui(1060) = uicontrol('Style','checkbox',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.24 .41 .15 .05],...
                                      'Value',Verb(5),...
                                      'String','Drehung First');

                hui(1061) = uicontrol('Style','checkbox',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.24 .36 .15 .05],...
                                      'Value',Verb(6),...
                                      'String','Drehung Best');
                                 
                hui(1062) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.48 .6 .245 .05],...
                                      'String','Mit zusätzlichen Abbruchbedingungen',...
                                      'CallBack','KMT Abbruchbedingungen');
                                  
                hui(1063) = uicontrol('Style','text',...
                                      'Enable','off',... % Ausgrauen
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'HorizontalAlignment','left',...  % Damit der Text linksbündig ist
                                      'Position',[.48 .5 .15 .05],...
                                      'String','1. Rechenzeit von');
                                  
                hui(1064) = uicontrol('Style','edit',...                     
                                      'Enable','off',... % Ausgrauen
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.585 .51 .05 .05]);
                                  
                hui(1065) = uicontrol('Style','text',...
                                      'Enable','off',... % Ausgrauen
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'HorizontalAlignment','left',...  % Damit der Text linksbündig ist
                                      'Position',[.64 .5 .25 .05],...
                                      'String','Minuten');
                                  
                hui(1066) = uicontrol('Style','text',...
                                      'Enable','off',... % Ausgrauen
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'HorizontalAlignment','left',...  % Damit der Text linksbündig ist
                                      'Position',[.48 .45 .5 .05],...
                                      'String','2. Zielfunktionswertverbesserung ausgehend vom Artikelreihenfolgeverfahren');
                                  
                hui(1067) = uicontrol('Style','text',...
                                      'Enable','off',... % Ausgrauen
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'HorizontalAlignment','left',...  % Damit der Text linksbündig ist
                                      'Position',[.495 .4 .5 .05],...
                                      'String','um ');
                                  
                hui(1068) = uicontrol('Style','edit',... 
                                      'Enable','off',... % Ausgrauen
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.52 .41 .05 .05]);
                                  
                hui(1069) = uicontrol('Style','text',...
                                      'Enable','off',... % Ausgrauen
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'HorizontalAlignment','left',...  % Damit der Text linksbündig ist
                                      'Position',[.575 .4 .3 .05],...
                                      'String','%');
                                  
                hui(1070) = uicontrol('Style','text',...
                                      'Enable','off',... % Ausgrauen
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'HorizontalAlignment','left',...  % Damit der Text linksbündig ist
                                      'Position',[.48 .35 .3 .05],...
                                      'String','3. Zielfunktionswertverbesserung von weniger als ');
                                  
                hui(1071) = uicontrol('Style','edit',... 
                                      'Enable','off',... % Ausgrauen
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.76 .36 .05 .05]);
                                  
                hui(1072) = uicontrol('Style','text',...
                                      'Enable','off',... % Ausgrauen
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'HorizontalAlignment','left',...  % Damit der Text linksbündig ist
                                      'Position',[.815 .35 .3 .05],...
                                      'String','% in den letzten');
                                  
                hui(1073) = uicontrol('Style','edit',... 
                                      'Enable','off',... % Ausgrauen
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.495 .31 .05 .05]);
                                  
                hui(1074) = uicontrol('Style','text',...
                                      'Enable','off',... % Ausgrauen
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'HorizontalAlignment','left',...  % Damit der Text linksbündig ist
                                      'Position',[.55 .3 .3 .05],...
                                      'String','Vergleichen');

                hui(1075) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.8 .1 .15 .05],...
                                      'String','lösen',...
                                      'CallBack','KMT LösungVerbesserungOhneSPG');

                hui(1076) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.05 .1 .15 .05],...
                                      'String','zurück',...
                                      'CallBack','KMT BackArtikelVerbOhneSPG'); 

                hui(1077) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.55 .1 .15 .05],...
                                      'String','alle auswählen',...
                                      'CallBack','KMT AlleVerbOhneSPG');

                hui(1078) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.3 .1 .15 .05],...
                                      'String','keins auswählen',...
                                      'CallBack','KMT KeineVerbOhneSPG');
            end


        case 'Abbruchbedingungen'
            
            set(hui(1063:1074),'Enable','on');
            Plus_Abbruchbed = true; % Zusätzlichen Abbruchbedingungen der Verbesserungsverfahren

        
        case 'LösungVerbesserungOhneSPG'

            Verb = [get(hui(1056),'Value')
                    get(hui(1057),'Value')
                    get(hui(1058),'Value')
                    get(hui(1059),'Value')
                    get(hui(1060),'Value')
                    get(hui(1061),'Value')];
                
            SummeVerb = sum(Verb);   

            fehler = false; % Kein Fehler
                
            if SummeVerb == 0 
                errordlg('Bitte wählen Sie mindestens ein Verbesserungsverfahren aus.','Fehler')
                fehler = true;
            end
                    
            if Plus_Abbruchbed == true
                % Prüfen, ob eine der drei Abbruchbedingungen
                % korrekt eingegeben wurde

                % Strings in numerische Werte umwandeln
                Ab_zeit_str = get(hui(1064),'String');
                Ab_zeit = str2double(Ab_zeit_str);
                Ab_prozent2_str = get(hui(1068),'String');
                Ab_prozent2 = str2double(Ab_prozent2_str);
                Ab_prozent3_str = get(hui(1071),'String');
                Ab_prozent3 = str2double(Ab_prozent3_str);
                Ab_vergl_str = get(hui(1073),'String');
                Ab_vergl = str2double(Ab_vergl_str);
                
                if isempty(Ab_zeit_str) && isempty(Ab_prozent2_str) && isempty(Ab_prozent3_str) && isempty(Ab_vergl_str)
                    errordlg('Bitte geben Sie mindestens eine zusätzliche Abbruchbedingung an.','Eingabe Fehler') 
                    fehler = true;
                else
                    if ~isempty(Ab_zeit_str) && (isnan(Ab_zeit) || Ab_zeit <= 0)
                        errordlg('Die maximal zu benötigende Rechenzeit muss positiv sein.','Eingabe Fehler') 
                        fehler = true;
                    end
                    if ~isempty(Ab_prozent2_str) && (isnan(Ab_prozent2) || Ab_prozent2 <= 0 || Ab_prozent2 >= 100)
                        errordlg('Die prozentuale Zielfunktionswertverbesserung des Verbesserungsverfahren gegenüber dem Artikelreihenfolgeverfahren muss aus dem Intervall (0,100) sein, d.h. zwischen 0 und 100 % liegen.','Eingabe Fehler') 
                        fehler = true;
                    end
                    if ( (~isempty(Ab_prozent3_str) && (isnan(Ab_prozent3) || Ab_prozent3 <= 0 || Ab_prozent3 >= 100)) ...
                            || (~isempty(Ab_vergl_str) && (isnan(Ab_vergl) || Ab_vergl <= 0 || round(Ab_vergl) ~= Ab_vergl)) ) ...
                            || xor(isempty(Ab_prozent3_str),isempty(Ab_vergl_str)) 
                        errordlg('Die Anzahl der Vergleiche muss positiv und ganzzahlig sein. Außerdem muss die prozentuale Zielfunktionswertverbesserung des Verbesserungsverfahren innerhalb der eingegebenen Anzahl der Vergleiche aus dem Intervall (0,100) sein, d.h. zwischen 0 und 100 % liegen.','Eingabe Fehler') 
                        fehler = true;
                    end
                end
            end
                
            tmp_value = get(hui(401),'Value');
            tmp_string = get(hui(401),'String');
            if fehler == false % Wenn kein Eingabefehler aufgetreten ist, beginne mit der Berechnung
                set(hui(100),'String',['Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion: ' tmp_string(tmp_value,:) '   >   Artikelreihenfolgeverfahren   >   Lösung   >   Verbesserung   >   Verbesserungsverfahren   >   Lösung']);
                set(hui(103),'Callback','KMT InfoLoesungVerb');
                set(hui(1055:1078),'Visible','off','Enable','inactive');

                Info_waitbar = waitbar(0,'Berechnung läuft...','Name','Information',...
                                       'CreateCancelBtn',...
                                       'setappdata(gcbf,''canceling'',1)');
                children_info = get(Info_waitbar, 'children'); % Cancel Button
                set(children_info(1), 'String', 'abbrechen')   % umbennenen
                setappdata(Info_waitbar,'canceling',0)
                waitbar(0,Info_waitbar,'Berechnung läuft...')

                Data = get(hui(1024),'Data');
                z = size(Data,1);

                BZ = Bearbeitungszeit(A,HZ,KZ);

                % Prüfen wie viele Verfahren verbessert werden sollen 
                SumArtikelVerfahrenVerbessern = 0;
                for i=1:z
                    SumArtikelVerfahrenVerbessern = SumArtikelVerfahrenVerbessern+get(hui(1033+i),'Value');
                end
                
                steps = SumArtikelVerfahrenVerbessern*(SummeVerb);
                step = 0;
                
                
                if Plus_Abbruchbed == false % Ohne zusätzliche Abbruchbedingungen

                    
                    % Damit sich die Größe von DataVerb nicht in jedem Schleifendurchlauf ändert
                    if Ziel == 3 
                        DataVerb = cell(SumArtikelVerfahrenVerbessern*(SummeVerb+1),10);
                    else
                        DataVerb = cell(SumArtikelVerfahrenVerbessern*(SummeVerb+1),9);
                    end

                    j = 1;
                    for i = 1:z
                        if get(hui(1033+i),'Value') == 1
                            v = 1;

                            DataVerb(j,:) = [Data(i,1:2) ' ' ' ' ' ' ' ' ' ' Data(i,4:end)];

                            if Verb(1) == 1
                                step = step + 1;

                                tic % Rechenzeit beginnen

                                switch Ziel 
                                    case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = T2FFSZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ);

                                    case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = T2FFF(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ);

                                    case 3 % Zielfunktion: min! sum. spez. Fertigstellungszeitpunkte
                                        [ZielfunktionswertVerb,OrderArtikelVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach] = T2FSFSZ(Zielfunktionswert(i),OrderArtikel(:,i),AufRneu(i,:),A,BZ,HZ,KZ); 

                                    case 4 % Zielfunktion: min! sum. Unproduktivzeiten
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = T2FUPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ); 

                                    case 5 % Zielfunktion: min! max. Unproduktivzeit            
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = T2FMUPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ);                   

                                    case 6 % Zielfunktion: Zielfunktion: min! sum. Stellplatzzeiten
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = T2FSPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ); 

                                    case 7 % Zielfunktion: min! Anzahl Stellplätze
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = T2FASP(Zielfunktionswert(i),OrderArtikel(:,i),A); 
                                end

                                RechenzeitVerb = toc;

                                absolutVerb = Zielfunktionswert(i)-ZielfunktionswertVerb;
                                relativVerb = 100 * (absolutVerb / ZielfunktionswertVerb);

                                if Ziel == 3
                                    DataVerb(j+v,:) = {'---2-Tausch First',ZielfunktionswertVerb,absolutVerb,relativVerb,AnzVerg,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArtikelVerb'),int2str(OrderAuftragVerb)};
                                else
                                    DataVerb(j+v,:) = {'---2-Tausch First',ZielfunktionswertVerb,absolutVerb,relativVerb,AnzVerg,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArtikelVerb')};
                                end

                                if getappdata(Info_waitbar,'canceling')
                                    delete(Info_waitbar)
                                    KMT VerbesserungOhneSPG                        
                                end
                                % Report current estimate in the waitbar's message field
                                waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                                v = v+1;
                            end

                            if Verb(2) == 1
                                step = step + 1;

                                tic % Rechenzeit beginnen

                                switch Ziel 
                                    case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = T2BFSZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ); 

                                    case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = T2BFF(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ); 

                                    case 3 % Zielfunktion: min! sum. spez. Fertigstellungszeitpunkte
                                        [ZielfunktionswertVerb,OrderArtikelVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach] = T2BSFSZ(Zielfunktionswert(i),OrderArtikel(:,i),AufRneu(i,:),A,BZ,HZ,KZ); 

                                    case 4 % Zielfunktion: min! sum. Unproduktivzeiten
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = T2BUPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ); 

                                    case 5 % Zielfunktion: min! max. Unproduktivzeit
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = T2BMUPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ); 

                                    case 6 % Zielfunktion: min! sum. Stellplatzzeiten
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = T2BSPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ); 

                                    case 7 % Zielfunktion: min! Anzahl Stellplätze
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = T2BASP(Zielfunktionswert(i),OrderArtikel(:,i),A);
                                end

                                RechenzeitVerb = toc;

                                absolutVerb = Zielfunktionswert(i)-ZielfunktionswertVerb;
                                relativVerb = 100 * (absolutVerb / ZielfunktionswertVerb);

                                if Ziel == 3
                                    DataVerb(j+v,:) = {'---2-Tausch Best',ZielfunktionswertVerb,absolutVerb,relativVerb,AnzVerg,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArtikelVerb'),int2str(OrderAuftragVerb)};
                                else
                                    DataVerb(j+v,:) = {'---2-Tausch Best',ZielfunktionswertVerb,absolutVerb,relativVerb,AnzVerg,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArtikelVerb')};
                                end

                                if getappdata(Info_waitbar,'canceling')
                                    delete(Info_waitbar)
                                    KMT VerbesserungOhneSPG                        
                                end
                                % Report current estimate in the waitbar's message field
                                waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                                v = v+1;
                            end

                            if Verb(3)==1  
                                step = step + 1;

                                tic % Rechenzeit beginnen

                                switch Ziel 
                                    case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = V1FFSZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ); 

                                    case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = V1FFF(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ); 

                                    case 3 % Zielfunktion: min! sum. spez. Fertigstellungszeitpunkte
                                        [ZielfunktionswertVerb,OrderArtikelVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach] = V1FSFSZ(Zielfunktionswert(i),OrderArtikel(:,i),AufRneu(i,:),A,BZ,HZ,KZ); 

                                    case 4 % Zielfunktion: Zielfunktion: min! sum. Unproduktivzeiten
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = V1FUPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ); 

                                    case 5 % Zielfunktion: min! max. Unproduktivzeit
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = V1FMUPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ); 

                                    case 6 % Zielfunktion: min! sum. Stellplatzzeiten
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = V1FSPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ);

                                    case 7 % Zielfunktion: min! Anzahl Stellplätze
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = V1FASP(Zielfunktionswert(i),OrderArtikel(:,i),A);
                                end                            

                                RechenzeitVerb = toc;

                                absolutVerb = Zielfunktionswert(i)-ZielfunktionswertVerb;
                                relativVerb = 100 * (absolutVerb / ZielfunktionswertVerb);

                                if Ziel == 3
                                    DataVerb(j+v,:) = {'---1-Verschieben First',ZielfunktionswertVerb,absolutVerb,relativVerb,AnzVerg,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArtikelVerb'),int2str(OrderAuftragVerb)};
                                else
                                    DataVerb(j+v,:) = {'---1-Verschieben First',ZielfunktionswertVerb,absolutVerb,relativVerb,AnzVerg,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArtikelVerb')};
                                end

                                if getappdata(Info_waitbar,'canceling')
                                    delete(Info_waitbar)
                                    KMT VerbesserungOhneSPG                        
                                end
                                % Report current estimate in the waitbar's message field
                                waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                                v = v+1;
                            end

                            if Verb(4) == 1
                                step = step + 1;

                                tic % Rechenzeit beginnen

                                switch Ziel 
                                    case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte                 
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = V1BFSZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ); 

                                    case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt         
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = V1BFF(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ); 

                                    case 3 % Zielfunktion: min! sum. spez. Fertigstellungszeitpunkte
                                        [ZielfunktionswertVerb,OrderArtikelVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach] = V1BSFSZ(Zielfunktionswert(i),OrderArtikel(:,i),AufRneu(i,:),A,BZ,HZ,KZ); 

                                    case 4 % Zielfunktion: min! sum. Unproduktivzeiten
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = V1BUPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ);

                                    case 5 % Zielfunktion: min! max. Unproduktivzeit
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = V1BMUPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ);  

                                    case 6 % Zielfunktion: min! sum. Stellplatzzeiten
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = V1BSPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ); 

                                    case 7 % Zielfunktion: min! Anzahl Stellplätze
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = V1BASP(Zielfunktionswert(i),OrderArtikel(:,i),A); 
                                end

                                RechenzeitVerb = toc;

                                absolutVerb = Zielfunktionswert(i)-ZielfunktionswertVerb;
                                relativVerb = 100 * (absolutVerb / ZielfunktionswertVerb);

                                if Ziel == 3
                                    DataVerb(j+v,:) = {'---1-Verschieben Best',ZielfunktionswertVerb,absolutVerb,relativVerb,AnzVerg,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArtikelVerb'),int2str(OrderAuftragVerb)};
                                else
                                    DataVerb(j+v,:) = {'---1-Verschieben Best',ZielfunktionswertVerb,absolutVerb,relativVerb,AnzVerg,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArtikelVerb')};
                                end

                                if getappdata(Info_waitbar,'canceling')
                                    delete(Info_waitbar)
                                    KMT VerbesserungOhneSPG                        
                                end
                                % Report current estimate in the waitbar's message field
                                waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                               v = v+1;
                            end

                            if Verb(5) == 1
                                step = step + 1;

                                tic % Rechenzeit beginnen

                                switch Ziel 
                                    case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = D2FFSZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ); 

                                    case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = D2FFF(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ); 

                                    case 3 % Zielfunktion: min! sum. spez. Fertigstellungszeitpunkte
                                        [ZielfunktionswertVerb,OrderArtikelVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach] = D2FSFSZ(Zielfunktionswert(i),OrderArtikel(:,i),AufRneu(i,:),A,BZ,HZ,KZ); 

                                    case 4 % Zielfunktion: min! sum. Unproduktivzeiten
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = D2FUPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ); 

                                    case 5 % Zielfunktion: min! max. Unproduktivzeit
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = D2FMUPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ);  

                                    case 6 % Zielfunktion: min! sum. Stellplatzzeiten
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = D2FSPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ);

                                    case 7 % Zielfunktion: min! Anzahl Stellplätze
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = D2FASP(Zielfunktionswert(i),OrderArtikel(:,i),A);
                                end

                                RechenzeitVerb = toc;

                                absolutVerb = Zielfunktionswert(i)-ZielfunktionswertVerb;
                                relativVerb = 100 * (absolutVerb / ZielfunktionswertVerb);

                                if Ziel == 3
                                    DataVerb(j+v,:) = {'---Drehung First',ZielfunktionswertVerb,absolutVerb,relativVerb,AnzVerg,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArtikelVerb'),int2str(OrderAuftragVerb)};
                                else
                                    DataVerb(j+v,:) = {'---Drehung First',ZielfunktionswertVerb,absolutVerb,relativVerb,AnzVerg,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArtikelVerb')};
                                end

                                if getappdata(Info_waitbar,'canceling')
                                    delete(Info_waitbar)
                                    KMT VerbesserungOhneSPG                        
                                end
                                % Report current estimate in the waitbar's message field
                                waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                                v = v+1;
                            end

                            if Verb(6) == 1
                                step = step + 1;

                                tic % Rechenzeit beginnen

                                switch Ziel 
                                    case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = D2BFSZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ); 

                                    case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = D2BFF(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ); 

                                    case 3 % Zielfunktion: min! sum. spez. Fertigstellungszeitpunkte
                                        [ZielfunktionswertVerb,OrderArtikelVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach] = D2BSFSZ(Zielfunktionswert(i),OrderArtikel(:,i),AufRneu(i,:),A,BZ,HZ,KZ); 

                                    case 4 % Zielfunktion: min! sum. Unproduktivzeiten
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = D2BUPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ); 

                                    case 5 % Zielfunktion: min! max. Unproduktivzeit
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = D2BMUPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ); 

                                    case 6 % Zielfunktion: min! sum. Stellplatzzeiten
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = D2BSPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ);

                                    case 7 % Zielfunktion: min! Anzahl Stellplätze
                                        [ZielfunktionswertVerb,OrderArtikelVerb,AnzVerg,AnzVerb,AnzNach] = D2BASP(Zielfunktionswert(i),OrderArtikel(:,i),A); 
                                end

                                RechenzeitVerb = toc;

                                absolutVerb = Zielfunktionswert(i)-ZielfunktionswertVerb;
                                relativVerb = 100 * (absolutVerb / ZielfunktionswertVerb);

                                if Ziel == 3
                                    DataVerb(j+v,:) = {'---Drehung Best',ZielfunktionswertVerb,absolutVerb,relativVerb,AnzVerg,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArtikelVerb'),int2str(OrderAuftragVerb)};
                                else
                                    DataVerb(j+v,:) = {'---Drehung Best',ZielfunktionswertVerb,absolutVerb,relativVerb,AnzVerg,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArtikelVerb')};
                                end

                                if getappdata(Info_waitbar,'canceling')
                                    delete(Info_waitbar)
                                    KMT VerbesserungOhneSPG                        
                                end
                                % Report current estimate in the waitbar's message field
                                waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                                v = v+1;
                            end                    
                            j = j+v;
                        end
                    end

                    % Die Güte der Zielfunktionswerte mit in Data aufnehmen
                    AlleZielfunktionswerte = cell2mat(DataVerb(:,2));
                    Abweichung_rel = RelativeAbweichung(AlleZielfunktionswerte);

                    DataVerb = [DataVerb(:,1:2) Abweichung_rel DataVerb(:,3:end)];

                    delete(Info_waitbar)

                    Ausgabe = DataVerb;

                    if Ziel == 3
                        Titel = {'Verfahren','Zielfunktionswert','Abweichung (%)','Absolute Verbesserung','Relative Verbesserung (%)','Anz. Vergleiche bis Best','Anz. Verbesserungen','Anz. Nachbarn','Rechenzeit (s)','Artikelreihenfolge','Auftragsreihenfolge' };  

                        hui(1079) = uitable('Data',DataVerb,...
                                            'Units','normalized',...
                                            'FontSize',Schriftgroesse1,...
                                            'FontUnits','normalized',...
                                            'ColumnFormat',{'char','char','char','char','char','char','char','char','char','char','char'},...
                                            'ColumnName',Titel,...
                                            'ColumnWidth',{600 'auto' 100 'auto' 'auto' 'auto' 'auto' 'auto' 120 500 500},...
                                            'ColumnEditable',[false false false false false false false false false false false],...
                                            'RowName',[],...
                                            'Position',[0 0.25 1 0.6]); 
                    else
                        Titel = {'Verfahren','Zielfunktionswert','Abweichung (%)','Absolute Verbesserung','Relative Verbesserung (%)','Anz. Vergleiche bis Best','Anz. Verbesserungen','Anz. Nachbarn','Rechenzeit (s)','Artikelreihenfolge'};

                        hui(1079) = uitable('Data',DataVerb,...
                                            'Units','normalized',...
                                            'FontSize',Schriftgroesse1,...
                                            'FontUnits','normalized',...
                                            'ColumnFormat',{'char','char','char','char','char','char','char','char','char','char'},...
                                            'ColumnName',Titel,...
                                            'ColumnWidth',{600 'auto' 100 'auto' 'auto' 'auto' 'auto' 'auto' 120 500},...
                                            'ColumnEditable',[false false false false false false false false false false],...
                                            'RowName',[],...
                                            'Position',[0 0.25 1 0.6]);                     
                    end
                    
                    
                else % Mit zusätzlichen Abbruchbedingungen
                    
                    
                    % Prüfen welche Abbruchbedingungen eingestellt wurden 
                    Abbruchbed1 = false;
                    Abbruchbed2 = false;
                    Abbruchbed3 = false;
                    
                    if ~isempty(Ab_zeit_str)
                        Abbruchbed1 = true; % Abbruchbedingung 1 ist aktiviert
                    end
                    if ~isempty(Ab_prozent2_str)
                        Abbruchbed2 = true; % Abbruchbedingung 2 ist aktiviert
                    end
                    if ~isempty(Ab_prozent3_str) && ~isempty(Ab_vergl_str)
                        Abbruchbed3 = true; % Abbruchbedingung 3 ist aktiviert
                    end
                    
                    
                    % Damit sich die Größe von DataVerb nicht in jedem Schleifendurchlauf ändert
                    if Ziel == 3 
                        DataVerb = cell(SumArtikelVerfahrenVerbessern*(SummeVerb+1),12);
                    else
                        DataVerb = cell(SumArtikelVerfahrenVerbessern*(SummeVerb+1),11);
                    end

                    j = 1;
                    for i = 1:z
                        if get(hui(1033+i),'Value') == 1
                            v = 1;

                            if Ziel == 3
                                DataVerb(j,:) = [Data(i,1:2) ' ' ' ' ' ' ' ' ' ' ' ' ' ' Data(i,4:end)];
                            else
                                DataVerb(j,:) = [Data(i,1:2) ' ' ' ' ' ' ' ' ' ' ' ' ' ' Data(i,4:end)];
                            end

                            if Verb(1) == 1
                                step = step + 1;

                                tic % Rechenzeit beginnen

                                switch Ziel 
                                    case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AT2FFSZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AT2FFF(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 3 % Zielfunktion: min! sum. spez. Fertigstellungszeitpunkte
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AT2FSFSZ(Zielfunktionswert(i),OrderArtikel(:,i),AufRneu(i,:),A,BZ,HZ,KZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 4 % Zielfunktion: min! sum. Unproduktivzeiten
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AT2FUPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 5 % Zielfunktion: min! max. Unproduktivzeit            
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AT2FMUPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);                  

                                    case 6 % Zielfunktion: Zielfunktion: min! sum. Stellplatzzeiten
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AT2FSPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 7 % Zielfunktion: min! Anzahl Stellplätze
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AT2FASP(Zielfunktionswert(i),OrderArtikel(:,i),A,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);
                                end

                                RechenzeitVerb = toc;

                                absolutVerb = Zielfunktionswert(i)-ZielfunktionswertVerb;
                                relativVerb = 100 * (absolutVerb / ZielfunktionswertVerb);

                                if Ziel == 3
                                    DataVerb(j+v,:) = {'---2-Tausch First',ZielfunktionswertVerb,absolutVerb,relativVerb,Abbruchbed,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArtikelVerb'),int2str(OrderAuftragVerb)};
                                else
                                    DataVerb(j+v,:) = {'---2-Tausch First',ZielfunktionswertVerb,absolutVerb,relativVerb,Abbruchbed,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArtikelVerb')};
                                end

                                if getappdata(Info_waitbar,'canceling')
                                    delete(Info_waitbar)
                                    KMT VerbesserungOhneSPG                        
                                end
                                % Report current estimate in the waitbar's message field
                                waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                                v = v+1;
                            end

                            if Verb(2) == 1
                                step = step + 1;

                                tic % Rechenzeit beginnen

                                switch Ziel 
                                    case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AT2BFSZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AT2BFF(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 3 % Zielfunktion: min! sum. spez. Fertigstellungszeitpunkte
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AT2BSFSZ(Zielfunktionswert(i),OrderArtikel(:,i),AufRneu(i,:),A,BZ,HZ,KZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 4 % Zielfunktion: min! sum. Unproduktivzeiten
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AT2BUPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 5 % Zielfunktion: min! max. Unproduktivzeit
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AT2BMUPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 6 % Zielfunktion: min! sum. Stellplatzzeiten
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AT2BSPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 7 % Zielfunktion: min! Anzahl Stellplätze
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AT2BASP(Zielfunktionswert(i),OrderArtikel(:,i),A,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);
                                end

                                RechenzeitVerb = toc;

                                absolutVerb = Zielfunktionswert(i)-ZielfunktionswertVerb;
                                relativVerb = 100 * (absolutVerb / ZielfunktionswertVerb);

                                if Ziel == 3
                                    DataVerb(j+v,:) = {'---2-Tausch Best',ZielfunktionswertVerb,absolutVerb,relativVerb,Abbruchbed,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArtikelVerb'),int2str(OrderAuftragVerb)};
                                else
                                    DataVerb(j+v,:) = {'---2-Tausch Best',ZielfunktionswertVerb,absolutVerb,relativVerb,Abbruchbed,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArtikelVerb')};
                                end

                                if getappdata(Info_waitbar,'canceling')
                                    delete(Info_waitbar)
                                    KMT VerbesserungOhneSPG                        
                                end
                                % Report current estimate in the waitbar's message field
                                waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                                v = v+1;
                            end

                            if Verb(3)==1  
                                step = step + 1;

                                tic % Rechenzeit beginnen

                                switch Ziel 
                                    case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AV1FFSZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AV1FFF(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 3 % Zielfunktion: min! sum. spez. Fertigstellungszeitpunkte
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AV1FSFSZ(Zielfunktionswert(i),OrderArtikel(:,i),AufRneu(i,:),A,BZ,HZ,KZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 4 % Zielfunktion: Zielfunktion: min! sum. Unproduktivzeiten
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AV1FUPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 5 % Zielfunktion: min! max. Unproduktivzeit
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AV1FMUPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 6 % Zielfunktion: min! sum. Stellplatzzeiten
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AV1FSPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 7 % Zielfunktion: min! Anzahl Stellplätze
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AV1FASP(Zielfunktionswert(i),OrderArtikel(:,i),A,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);
                                end                            

                                RechenzeitVerb = toc;

                                absolutVerb = Zielfunktionswert(i)-ZielfunktionswertVerb;
                                relativVerb = 100 * (absolutVerb / ZielfunktionswertVerb);

                                if Ziel == 3
                                    DataVerb(j+v,:) = {'---1-Verschieben First',ZielfunktionswertVerb,absolutVerb,relativVerb,Abbruchbed,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArtikelVerb'),int2str(OrderAuftragVerb)};
                                else
                                    DataVerb(j+v,:) = {'---1-Verschieben First',ZielfunktionswertVerb,absolutVerb,relativVerb,Abbruchbed,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArtikelVerb')};
                                end

                                if getappdata(Info_waitbar,'canceling')
                                    delete(Info_waitbar)
                                    KMT VerbesserungOhneSPG                        
                                end
                                % Report current estimate in the waitbar's message field
                                waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                                v = v+1;
                            end

                            if Verb(4) == 1
                                step = step + 1;

                                tic % Rechenzeit beginnen

                                switch Ziel 
                                    case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte                 
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AV1BFSZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt         
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AV1BFF(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 3 % Zielfunktion: min! sum. spez. Fertigstellungszeitpunkte
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AV1BSFSZ(Zielfunktionswert(i),OrderArtikel(:,i),AufRneu(i,:),A,BZ,HZ,KZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 4 % Zielfunktion: min! sum. Unproduktivzeiten
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AV1BUPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 5 % Zielfunktion: min! max. Unproduktivzeit
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AV1BMUPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);  

                                    case 6 % Zielfunktion: min! sum. Stellplatzzeiten
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AV1BSPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 7 % Zielfunktion: min! Anzahl Stellplätze
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AV1BASP(Zielfunktionswert(i),OrderArtikel(:,i),A,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);
                                end

                                RechenzeitVerb = toc;

                                absolutVerb = Zielfunktionswert(i)-ZielfunktionswertVerb;
                                relativVerb = 100 * (absolutVerb / ZielfunktionswertVerb);

                                if Ziel == 3
                                    DataVerb(j+v,:) = {'---1-Verschieben Best',ZielfunktionswertVerb,absolutVerb,relativVerb,Abbruchbed,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArtikelVerb'),int2str(OrderAuftragVerb)};
                                else
                                    DataVerb(j+v,:) = {'---1-Verschieben Best',ZielfunktionswertVerb,absolutVerb,relativVerb,Abbruchbed,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArtikelVerb')};
                                end

                                if getappdata(Info_waitbar,'canceling')
                                    delete(Info_waitbar)
                                    KMT VerbesserungOhneSPG                        
                                end
                                % Report current estimate in the waitbar's message field
                                waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                               v = v+1;
                            end

                            if Verb(5) == 1
                                step = step + 1;

                                tic % Rechenzeit beginnen

                                switch Ziel 
                                    case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AD2FFSZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AD2FFF(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 3 % Zielfunktion: min! sum. spez. Fertigstellungszeitpunkte
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AD2FSFSZ(Zielfunktionswert(i),OrderArtikel(:,i),AufRneu(i,:),A,BZ,HZ,KZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 4 % Zielfunktion: min! sum. Unproduktivzeiten
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AD2FUPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 5 % Zielfunktion: min! max. Unproduktivzeit
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AD2FMUPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 6 % Zielfunktion: min! sum. Stellplatzzeiten
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AD2FSPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 7 % Zielfunktion: min! Anzahl Stellplätze
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AD2FASP(Zielfunktionswert(i),OrderArtikel(:,i),A,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);
                                end

                                RechenzeitVerb = toc;

                                absolutVerb = Zielfunktionswert(i)-ZielfunktionswertVerb;
                                relativVerb = 100 * (absolutVerb / ZielfunktionswertVerb);

                                if Ziel == 3
                                    DataVerb(j+v,:) = {'---Drehung First',ZielfunktionswertVerb,absolutVerb,relativVerb,Abbruchbed,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArtikelVerb'),int2str(OrderAuftragVerb)};
                                else
                                    DataVerb(j+v,:) = {'---Drehung First',ZielfunktionswertVerb,absolutVerb,relativVerb,Abbruchbed,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArtikelVerb')};
                                end

                                if getappdata(Info_waitbar,'canceling')
                                    delete(Info_waitbar)
                                    KMT VerbesserungOhneSPG                        
                                end
                                % Report current estimate in the waitbar's message field
                                waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                                v = v+1;
                            end

                            if Verb(6) == 1
                                step = step + 1;

                                tic % Rechenzeit beginnen

                                switch Ziel 
                                    case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AD2BFSZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AD2BFF(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl); 

                                    case 3 % Zielfunktion: min! sum. spez. Fertigstellungszeitpunkte
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AD2BSFSZ(Zielfunktionswert(i),OrderArtikel(:,i),AufRneu(i,:),A,BZ,HZ,KZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 4 % Zielfunktion: min! sum. Unproduktivzeiten
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AD2BUPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 5 % Zielfunktion: min! max. Unproduktivzeit
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AD2BMUPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl); 

                                    case 6 % Zielfunktion: min! sum. Stellplatzzeiten
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AD2BSPZ(Zielfunktionswert(i),OrderArtikel(:,i),A,BZ,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                    case 7 % Zielfunktion: min! Anzahl Stellplätze
                                        [ZielfunktionswertVerb,Abbruchbed,OrderArtikelVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach] = AD2BASP(Zielfunktionswert(i),OrderArtikel(:,i),A,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);
                                end

                                RechenzeitVerb = toc;

                                absolutVerb = Zielfunktionswert(i)-ZielfunktionswertVerb;
                                relativVerb = 100 * (absolutVerb / ZielfunktionswertVerb);

                                if Ziel == 3
                                    DataVerb(j+v,:) = {'---Drehung Best',ZielfunktionswertVerb,absolutVerb,relativVerb,Abbruchbed,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArtikelVerb'),int2str(OrderAuftragVerb)};
                                else
                                    DataVerb(j+v,:) = {'---Drehung Best',ZielfunktionswertVerb,absolutVerb,relativVerb,Abbruchbed,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArtikelVerb')};
                                end

                                if getappdata(Info_waitbar,'canceling')
                                    delete(Info_waitbar)
                                    KMT VerbesserungOhneSPG                        
                                end
                                % Report current estimate in the waitbar's message field
                                waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                                v = v+1;
                            end                    
                            j = j+v;
                        end
                    end

                    % Die Güte der Zielfunktionswerte mit in Data aufnehmen
                    AlleZielfunktionswerte = cell2mat(DataVerb(:,2));
                    Abweichung_rel = RelativeAbweichung(AlleZielfunktionswerte);

                    DataVerb = [DataVerb(:,1:2) Abweichung_rel DataVerb(:,3:end)];

                    delete(Info_waitbar)

                    Ausgabe = DataVerb;

                    if Ziel == 3
                        Titel = {'Verfahren','Zielfunktionswert','Abweichung (%)','Absolute Verbesserung','Relative Verbesserung (%)','Abbruchbedingung','Anz. Vergleiche insgesamt','Anz. Vergleiche bis Best','Anz. Verbesserungen','Anz. Nachbarn','Rechenzeit (s)','Artikelreihenfolge','Auftragsreihenfolge' };  

                        hui(1079) = uitable('Data',DataVerb,...
                                            'Units','normalized',...
                                            'FontSize',Schriftgroesse1,...
                                            'FontUnits','normalized',...
                                            'ColumnFormat',{'char','char','char','char','char','char','char','char','char','char','char','char','char'},...
                                            'ColumnName',Titel,...
                                            'ColumnWidth',{600 'auto' 100 'auto' 'auto' 'auto' 'auto' 'auto' 'auto' 'auto' 120 500 500},...
                                            'ColumnEditable',[false false false false false false false false false false false false false],...
                                            'RowName',[],...
                                            'Position',[0 0.25 1 0.6]); 
                    else
                        Titel = {'Verfahren','Zielfunktionswert','Abweichung (%)','Absolute Verbesserung','Relative Verbesserung (%)','Abbruchbedingung','Anz. Vergleiche insgesamt','Anz. Vergleiche bis Best','Anz. Verbesserungen','Anz. Nachbarn','Rechenzeit (s)','Artikelreihenfolge'};

                        hui(1079) = uitable('Data',DataVerb,...
                                            'Units','normalized',...
                                            'FontSize',Schriftgroesse1,...
                                            'FontUnits','normalized',...
                                            'ColumnFormat',{'char','char','char','char','char','char','char','char','char','char','char','char'},...
                                            'ColumnName',Titel,...
                                            'ColumnWidth',{600 'auto' 100 'auto' 'auto' 'auto' 'auto' 'auto' 'auto' 'auto' 120 500},...
                                            'ColumnEditable',[false false false false false false false false false false false false],...
                                            'RowName',[],...
                                            'Position',[0 0.25 1 0.6]);                     
                    end
                end

                hui(1080) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.55 .1 .15 .05],...
                                      'String','speichern',...
                                      'CallBack','KMT SpeicherZoSPGmV');

                hui(1081) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.05 .1 .15 .05],...
                                      'String','zurück',...
                                      'CallBack','KMT BackVerbesserungOhneSPG');

                hui(1082) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.3 .1 .15 .05],...
                                      'String','Neustart',...
                                      'CallBack','KMT');

                hui(1083) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.8 .1 .15 .05],...
                                      'String','schließen',...
                                      'CallBack','close');
            end
            
            
        case 'SpeicherZoSPG' % Für Zielfunktionen ohne SPG
            
            AusgabedateiExcel = 'AusgabeZielfunktionOhneSPG.xlsx';
            AusgabedateiMat = 'AusgabeZielfunktionOhneSPG.mat';
            [AnzAusZoSPG] = speichern(Titel,Ausgabe,AusgabedateiExcel,AnzAusZoSPG,AusgabedateiMat);
            

        case 'SpeicherZoSPGmV' % Für Zielfunktionen ohne SPG mit Verbesserung
            
            AusgabedateiExcel = 'AusgabeZielfunktionOhneSPGMitVerbesserung.xlsx';
            AusgabedateiMat = 'AusgabeZielfunktionOhneSPGMitVerbesserung.mat';
            [AnzAusZoSPGmV] = speichern(Titel,Ausgabe,AusgabedateiExcel,AnzAusZoSPGmV,AusgabedateiMat);
        
        
        case 'BackZiel'

            set(hui(100),'String','Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion');
            set(hui(103),'Callback','KMT InfoZielfunktion');
            set(hui(400:401),'Visible','on','Enable','on');
            set(hui(404:405),'Visible','on','Enable','on');
            set(hui(1000:1023),'Visible','off','Enable','inactive');  
            

        case 'BackVerfahrenOhneSPG'
            tmp_value = get(hui(401),'Value');
            tmp_string = get(hui(401),'String');
            set(hui(100),'String',['Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion: ' tmp_string(tmp_value,:) '   >   Artikelreihenfolgeverfahren']);
            set(hui(103),'Callback','KMT InfoArtikelreihenfolgeverfahren');
            set(hui(1000:1023),'Visible','on','Enable','on');
            set(hui(1024:1028),'Visible','off','Enable','inactive'); 


        case 'BackLösungOhneSPG'
            tmp_value = get(hui(401),'Value');
            tmp_string = get(hui(401),'String');
            set(hui(100),'String',['Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion: ' tmp_string(tmp_value,:) '   >   Artikelreihenfolgeverfahren   >   Lösung']);
            set(hui(103),'Callback','KMT InfoLoesungArt');
            set(hui(1024:1028),'Visible','on','Enable','on');
            set(hui(1029:(1033+sum(Loese))),'Visible','off','Enable','inactive'); 


        case 'BackArtikelVerbOhneSPG'
            tmp_value = get(hui(401),'Value');
            tmp_string = get(hui(401),'String');
            set(hui(100),'String',['Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion: ' tmp_string(tmp_value,:) '   >   Artikelreihenfolgeverfahren   >   Lösung   >   Verbesserung']);
            set(hui(103),'Callback','KMT InfoVerbesserung');
            set(hui(1029:1033+sum(Loese)),'Visible','on','Enable','on'); 
            % Die Verfahren ausgrauen bei denen der Zielfunktionswert schon Null ist
            j = 0; % bis sum(Loese)
            for i = 1:length(ArtikelVerfahrenNamen)
                if Loese(i) == 1 % Wenn das Verfahren gelöst werden soll
                    j = j+1; % dann muss j erhöht werden
                    if Zielfunktionswert(j) == 0 % um zu prüfen, ob der passende
                        % Zielfunktionswert Null ist
                        set(hui(1033+j),'Enable','off') % ist er Null, wird er ausgegraut
                    end
                end
            end
            set(hui(1055:1078),'Visible','off','Enable','inactive');
            
            
        case 'BackVerbesserungOhneSPG'
            tmp_value = get(hui(401),'Value');
            tmp_string = get(hui(401),'String');
            set(hui(100),'String',['Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion: ' tmp_string(tmp_value,:) '   >   Artikelreihenfolgeverfahren   >   Lösung   >   Verbesserung   >   Verbesserungsverfahren']); 
            set(hui(103),'Callback','KMT InfoVerbesserungsverfahren');
            set(hui(1055:1062),'Visible','on','Enable','on');
            if Plus_Abbruchbed == true
                set(hui(1063:1074),'Visible','on','Enable','on');
            else
                set(hui(1063:1074),'Visible','on','Enable','off');
            end
            set(hui(1075:1078),'Visible','on','Enable','on');
            set(hui(1079:1083),'Visible','off','Enable','inactive')
                        

        case 'AlleVerfahrenOhneSPG'

            set(hui(1000:1023),'Visible','off','Enable','inactive'); 
            Loese = ones(1,AnzArtikelVerfahren);  
            KMT VerfahrenOhneSPG;


        case 'KeineVerfahrenOhneSPG'

            set(hui(1000:1023),'Visible','off','Enable','inactive'); 
            Loese = zeros(1,AnzArtikelVerfahren);
            KMT VerfahrenOhneSPG


        case 'AlleErVerOhneSPG'

            for i=(1033+1):(1033+sum(Loese))
                if strcmp(get(hui(i),'Enable'),'on')
                    set(hui(i),'Value',1);
                end
            end


        case 'KeineErVerOhneSPG'

            set(hui(1033+1:(1033+sum(Loese))),'Value',0);


        case 'AlleVerbOhneSPG'

            set(hui(1055:1078),'Visible','off','Enable','inactive');
            Verb = ones(1,AnzVerbesserungsVerfahren);  
            KMT VerbesserungOhneSPG;


        case 'KeineVerbOhneSPG'

            set(hui(1055:1078),'Visible','off','Enable','inactive');
            Verb = zeros(1,AnzVerbesserungsVerfahren);  
            KMT VerbesserungOhneSPG;








%% Zielfunktionen mit Stellplatzbegrenzung und ohne Deadline

        case 'ArtikelVerfahrenMitSPG'

            PositionCheckbox1 = [.08 .71 .44 .05;
                                .08 .66 .44 .05;
                                .08 .61 .44 .05;
                                .08 .56 .44 .05;
                                .08 .51 .44 .05;
                                .08 .46 .44 .05;
                                .08 .41 .44 .05;
                                .08 .36 .44 .05;
                                .08 .31 .44 .05;
                                .54 .71 .44 .05;
                                .54 .66 .44 .05;
                                .54 .61 .44 .05;
                                .54 .56 .44 .05;
                                .54 .51 .44 .05;
                                .54 .46 .44 .05;
                                .54 .41 .44 .05;
                                .54 .36 .44 .05;
                                .54 .31 .44 .05;
                                .54 .26 .44 .05];
                            
           PositionCheckbox2 = [.06 .71 .02 .05;
                                .06 .66 .02 .05;
                                .06 .61 .02 .05;
                                .06 .56 .02 .05;
                                .06 .51 .02 .05;
                                .06 .46 .02 .05;
                                .06 .41 .02 .05;
                                .06 .36 .02 .05;
                                .06 .31 .02 .05;
                                .52 .71 .02 .05;
                                .52 .66 .02 .05;
                                .52 .61 .02 .05;
                                .52 .56 .02 .05;
                                .52 .51 .02 .05;
                                .52 .46 .02 .05;
                                .52 .41 .02 .05;
                                .52 .36 .02 .05;
                                .52 .31 .02 .05;
                                .52 .26 .02 .05]; 
                            
           PositionCheckbox3 = [.04 .71 .02 .05;
                                .04 .66 .02 .05;
                                .04 .61 .02 .05;
                                .04 .56 .02 .05;
                                .04 .51 .02 .05;
                                .04 .46 .02 .05;
                                .04 .41 .02 .05;
                                .04 .36 .02 .05;
                                .04 .31 .02 .05;
                                .50 .71 .02 .05;
                                .50 .66 .02 .05;
                                .50 .61 .02 .05;
                                .50 .56 .02 .05;
                                .50 .51 .02 .05;
                                .50 .46 .02 .05;
                                .50 .41 .02 .05;
                                .50 .36 .02 .05;
                                .50 .31 .02 .05;
                                .50 .26 .02 .05];  

            hui(2000) = uicontrol('Style','text',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'HorizontalAlignment','center',...  % Damit der Text mittig ist
                                  'Position',[0 .82 1 .05],...
                                  'String','Artikelreihenfolgeverfahren:');
                              
            hui(3030) = uicontrol('Style','text',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'HorizontalAlignment','center',...  % Damit der Text mittig ist
                                  'Position',[0.04 .78 0.01 .05],...
                                  'String','D');
                              
            hui(3031) = uicontrol('Style','text',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'HorizontalAlignment','center',...  % Damit der Text mittig ist
                                  'Position',[0.06 .78 0.01 .05],...
                                  'String','R');
                              
            hui(3032) = uicontrol('Style','text',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'HorizontalAlignment','center',...  % Damit der Text mittig ist
                                  'Position',[0.08 .78 0.01 .05],...
                                  'String','H');
                              
            hui(3033) = uicontrol('Style','text',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'HorizontalAlignment','center',...  % Damit der Text mittig ist
                                  'Position',[0.50 .75 0.01 .05],...
                                  'String','D');
                              
            hui(3034) = uicontrol('Style','text',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'HorizontalAlignment','center',...  % Damit der Text mittig ist
                                  'Position',[0.52 .75 0.01 .05],...
                                  'String','R');
                              
            hui(3035) = uicontrol('Style','text',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'HorizontalAlignment','center',...  % Damit der Text mittig ist
                                  'Position',[0.54 .75 0.01 .05],...
                                  'String','H');     
                              
            hui(3036) = uicontrol('Style','checkbox',...
                                    'Units','normalized',...
                                    'FontSize',Schriftgroesse1,...
                                    'FontUnits','normalized',...
                                    'Position',[0.04 .75 0.02 .05],...
                                    'String','',...
                                    'Callback','KMT AlleDynamisch');
                                
            hui(3037) = uicontrol('Style','checkbox',...
                                    'Units','normalized',...
                                    'FontSize',Schriftgroesse1,...
                                    'FontUnits','normalized',...
                                    'Position',[0.06 .75 0.02 .05],...
                                    'String','',...
                                    'Callback','KMT AlleRollierend');
                                
            hui(3038) = uicontrol('Style','checkbox',...
                                    'Units','normalized',...
                                    'FontSize',Schriftgroesse1,...
                                    'FontUnits','normalized',...
                                    'Position',[0.08 .75 0.02 .05],...
                                    'String','',...
                                    'Callback','KMT AlleHierarchisch');

            for i = 1:length(ArtikelVerfahrenNamen)
            	hui(i+2000) = uicontrol('Style','checkbox',...
                                        'Units','normalized',...
                                        'FontSize',Schriftgroesse1,...
                                        'FontUnits','normalized',...
                                        'Position',PositionCheckbox1(i,:),...
                                        'Value',Art(i),...
                                        'String',ArtikelVerfahrenNamen{i});
                                    
            	hui(i+3000) = uicontrol('Style','checkbox',...
                                        'Units','normalized',...
                                        'FontSize',Schriftgroesse1,...
                                        'FontUnits','normalized',...
                                        'Position',PositionCheckbox2(i,:),...
                                        'Value',ArtR(i));
                                    
                hui(i+4000) = uicontrol('Style','checkbox',...
                                        'Units','normalized',...
                                        'FontSize',Schriftgroesse1,...
                                        'FontUnits','normalized',...
                                        'Position',PositionCheckbox3(i,:),...
                                        'Value',ArtD(i));
            end
            
            hui(2020) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.8 .1 .15 .05],...
                                  'String','weiter',...
                                  'CallBack','KMT AuftragVerfahrenMitSPG');

            hui(2021) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.05 .1 .15 .05],...
                                  'String','zurück',...
                                  'CallBack','KMT BackAnzStellPlatzMitSPG'); 

            hui(2022) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.55 .1 .15 .05],...
                                  'String','alle auswählen',...
                                  'CallBack','KMT AlleArtikelVerfahrenMitSPG');

            hui(2023) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.3 .1 .15 .05],...
                                  'String','keins auswählen',...
                                  'CallBack','KMT KeineArtikelVerfahrenMitSPG'); 


        case 'AuftragVerfahrenMitSPG'

            Art = [get(hui(2001),'Value')
                   get(hui(2002),'Value')
                   get(hui(2003),'Value')
                   get(hui(2004),'Value')
                   get(hui(2005),'Value')
                   get(hui(2006),'Value')
                   get(hui(2007),'Value')
                   get(hui(2008),'Value')
                   get(hui(2009),'Value')
                   get(hui(2010),'Value')
                   get(hui(2011),'Value')
                   get(hui(2012),'Value')
                   get(hui(2013),'Value')
                   get(hui(2014),'Value')
                   get(hui(2015),'Value')
                   get(hui(2016),'Value')
                   get(hui(2017),'Value')
                   get(hui(2018),'Value')
                   get(hui(2019),'Value')];
               
            ArtR = [get(hui(3001),'Value')
                   get(hui(3002),'Value')
                   get(hui(3003),'Value')
                   get(hui(3004),'Value')
                   get(hui(3005),'Value')
                   get(hui(3006),'Value')
                   get(hui(3007),'Value')
                   get(hui(3008),'Value')
                   get(hui(3009),'Value')
                   get(hui(3010),'Value')
                   get(hui(3011),'Value')
                   get(hui(3012),'Value')
                   get(hui(3013),'Value')
                   get(hui(3014),'Value')
                   get(hui(3015),'Value')
                   get(hui(3016),'Value')
                   get(hui(3017),'Value')
                   get(hui(3018),'Value')
                   get(hui(3019),'Value')];
               
             ArtD = [get(hui(4001),'Value')
                   get(hui(4002),'Value')
                   get(hui(4003),'Value')
                   get(hui(4004),'Value')
                   get(hui(4005),'Value')
                   get(hui(4006),'Value')
                   get(hui(4007),'Value')
                   get(hui(4008),'Value')
                   get(hui(4009),'Value')
                   get(hui(4010),'Value')
                   get(hui(4011),'Value')
                   get(hui(4012),'Value')
                   get(hui(4013),'Value')
                   get(hui(4014),'Value')
                   get(hui(4015),'Value')
                   get(hui(4016),'Value')
                   get(hui(4017),'Value')
                   get(hui(4018),'Value')
                   get(hui(4019),'Value')];
               
            if isempty(tmp_new)
                if ~isempty(find(ArtD(:,1) == 1,1)) % Fehlerabfangung für PopUp-Fenster 'Neue Artikelreihenfolgeberechnung'
                    Artikel_neu_berechnen = inputdlg('Bitte geben Sie eine gültige Zahl ein, nach wie vielen fertigen Auftraegen die Artikelreihenfolge neu berechnet werden soll.',...
                                                     'Neue Artikelreihenfolgeberechnung', [1 55],{'1'});

                    if ~isempty(Artikel_neu_berechnen)
                       Artikel_neu_berechnen = str2double(Artikel_neu_berechnen{1});       
                    else
                       Artikel_neu_berechnen = NaN;
                    end

                    while Artikel_neu_berechnen > size(A,2) || ...
                          isnan(Artikel_neu_berechnen) || ...
                          round(Artikel_neu_berechnen) ~= Artikel_neu_berechnen || ...
                          Artikel_neu_berechnen < 1

                          Artikel_neu_berechnen = inputdlg('Bitte geben Sie eine gültige Zahl ein, nach wie vielen fertigen Auftraegen die Artikelreihenfolge neu berechnet werden soll. Hinweis: Positive ganze Zahlen sind nur möglich!',...
                                                     'Neue Artikelreihenfolgeberechnung', [1 55],{'1'});

                          if ~isempty(Artikel_neu_berechnen)                       
                             Artikel_neu_berechnen = str2double(Artikel_neu_berechnen{1});  
                          else
                             Artikel_neu_berechnen = NaN;
                          end
                    end

                    str_auftrag = questdlg('Es wurde min. ein dynamisches Verfahren ausgewaehlt. Welches Verfahren möchten Sie verwenden?',...
                                           'Online/Offline Verfahren', ...
                                           'online','offline','offline');
                    while isempty(str_auftrag)
                         str_auftrag = questdlg('Es wurde min. ein dynamisches Verfahren ausgewaehlt. Welches Verfahren möchten Sie verwenden?',...
                                           'Online/Offline Verfahren', ...
                                           'online','offline','offline');
                    end
                end
            end
            tmp_new = [];
            
            if sum(Art)+sum(ArtR)+sum(ArtD) == 0
                errordlg('Bitte wählen Sie mindestens ein Artikelreihenfolgeverfahren aus.','Fehler')
            else
                tmp_value = get(hui(402),'Value');
                tmp_string = get(hui(402),'String');
                set(hui(100),'String',['Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion: ' tmp_string(tmp_value,:) '   >   Artikelreihenfolgeverfahren   >   Auftragsreihenfolgeverfahren']); 
                set(hui(103),'Callback','KMT InfoAuftragsreihenfolgeverfahren');
                set(hui(2000:2023),'Visible','off','Enable','inactive'); 
                set(hui(3001:3019),'Visible','off','Enable','inactive'); 
                set(hui(4001:4019),'Visible','off','Enable','inactive');
                set(hui(3030:3038),'Visible','off','Enable','inactive');
           
                hui(2024) = uicontrol('Style','text',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'HorizontalAlignment','left',...  % Damit der Text linksbündig ist
                                      'Position',[.08 .6 .5 .05],...
                                      'String','Auftragsreihenfolgeverfahren:');

                hui(2025) = uicontrol('Style','checkbox',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.28 .61 .6 .05],...
                                      'Value',Auf(1),...
                                      'String','Anordnung in topologischer Reihenfolge');

                hui(2026) = uicontrol('Style','checkbox',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.28 .56 .6 .05],...
                                      'Value',Auf(2),...
                                      'String','Anordnung nach aufsteigenden spez. Fertigstellungszeitpunkten');

                hui(2027) = uicontrol('Style','checkbox',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.28 .51 .6 .05],...
                                      'Value',Auf(3),...
                                      'String','Anordnung nach absteigenden spez. Fertigstellungszeitpunkten');

                hui(2028) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.8 .1 .15 .05],...
                                      'String','lösen',...
                                      'CallBack','KMT LöseMitSPG');

                hui(2029) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.05 .1 .15 .05],...
                                      'String','zurück',...
                                      'CallBack','KMT BackArtikelVerfahrenMitSPG'); 

                hui(2030) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.55 .1 .15 .05],...
                                      'String','alle auswählen',...
                                      'CallBack','KMT AlleAuftragVerfahrenMitSPG');

                hui(2031) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.3 .1 .15 .05],...
                                      'String','keins auswählen',...
                                      'CallBack','KMT KeineAuftragVerfahrenMitSPG');
            end


        case 'LöseMitSPG'

            Auf = [get(hui(2025),'Value')
                   get(hui(2026),'Value')
                   get(hui(2027),'Value')];

            if sum(Auf) == 0
                errordlg('Bitte wählen Sie mindestens ein Auftragsreihenfolgeverfahren aus.','Fehler')
            else
                tmp_value = get(hui(402),'Value');
                tmp_string = get(hui(402),'String');
                set(hui(100),'String',['Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion: ' tmp_string(tmp_value,:) '   >   Artikelreihenfolgeverfahren   >   Auftragsreihenfolgeverfahren   >   Lösung']);
                set(hui(103),'Callback','KMT InfoLoesungArtAuf');
                set(hui(2024:2031),'Visible','off','Enable','inactive');  
                
                Info_waitbar = waitbar(0,'Berechnung läuft...','Name','Information',...
                                       'CreateCancelBtn',...
                                       'setappdata(gcbf,''canceling'',1)');
                children_info = get(Info_waitbar, 'children'); % Cancel Button
                set(children_info(1), 'String', 'abbrechen')   % umbennenen
                setappdata(Info_waitbar,'canceling',0)   
                waitbar(0,Info_waitbar,'Berechnung läuft...')
                
                steps = sum(Auf)*(sum(Art)+sum(ArtR)+sum(ArtD));
                step = 0;

                [m,n] = size(A);
                BZ = Bearbeitungszeit(A,HZ,KZ);
                HA = Haufigkeit(A);
                
                Data = cell(sum(Auf)*(sum(Art)+sum(ArtR)+sum(ArtD)+1),5);
                Platzhalter = cell(1,4);
                
                % Die Rechenzeit für das erste Verfahren ist langsamer als die anderen
                % Deswegen das Verfahren einmal durchlaufen lassen
                tic
                OrderAuftrag = MinSFSZ(A,HZ,KZ,BZ,[1:m]');
                OrderAuftrag = MaxSFSZ(A,HZ,KZ,BZ,[1:m]');
                switch Ziel 
                    case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte mit Stellplatzbegrenzung
                        [LoeschMich1,LoeschMich2] = FSZbS(A,HZ,KZ,SP,[1:m]',[1:n]); %#ok<*ASGLU>
                    case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt mit Stellplatzbegrenzung
                        [LoeschMich1,LoeschMich2] = FFbS(A,HZ,KZ,SP,[1:m]',[1:n]);
                    case 3 % Zielfunktion: min! sum. Durchlaufzeiten mit Stellplatzbegrenzung
                        [LoeschMich1,LoeschMich2] = DLZbS(A,HZ,KZ,SP,[1:m]',[1:n]);
                end
                clear LoeschMich*
                save_zufallszahl = [];
                
                Time = toc;

                x = 1;
                for i = 1:3
                    if get(hui(2024+i),'Value') == 1
                        Data(x,:) = [get(hui(2024+i),'String') Platzhalter];
                        x = x+1;

                        for index = 1:length(ArtikelVerfahrenNamen)
                            if Art(index) == 1
                                
                                BZ = Bearbeitungszeit(A,HZ,KZ);
                                HA = Haufigkeit(A);
                                 
                                step = step + 1;

                                tic % Rechenzeit beginnen

                                switch index
                                    case 1
                                        OrderArtikel = [1:m]'; %#ok<*NBRAK> unterdrückt die Fehlermeldung, dass die Klammern überflüssig sind
                                    case 2
                                        OrderArtikel = minBmaxH(HA,BZ);
                                    case 3
                                        OrderArtikel = maxBmaxH(HA,BZ);
                                    case 4
                                        OrderArtikel = minHtopo(HA,BZ);
                                    case 5
                                        OrderArtikel = maxHtopo(HA,BZ);
                                    case 6
                                        OrderArtikel = maxHminB(HA,BZ);
                                    case 7
                                        OrderArtikel = maxHmaxB(HA,BZ);
                                    case 8
                                        OrderArtikel = zenReihAufst(HA);
                                    case 9
                                        OrderArtikel = zenReihAbst(HA);
                                    case 10
                                        OrderArtikel = minAtopo(A);
                                    case 11
                                        OrderArtikel = minAminB(A,BZ);
                                    case 12
                                        OrderArtikel = minAmaxB(A,BZ);
                                    case 13
                                        OrderArtikel = minAminH(A,HA);
                                    case 14
                                        OrderArtikel = minAmaxH(A,HA);
                                    case 15
                                        OrderArtikel = maxAtopo(A);
                                    case 16
                                        OrderArtikel = maxAminB(A,BZ);
                                    case 17
                                        OrderArtikel = maxAmaxB(A,BZ);
                                    case 18
                                        OrderArtikel = maxAminH(A,HA);
                                    case 19
                                        OrderArtikel = maxAmaxH(A,HA);
                                end

                                if i == 1
                                    OrderAuftrag = [1:n];
                                end
                                if i == 2
                                    OrderAuftrag = MinSFSZ(A,HZ,KZ,BZ,OrderArtikel);
                                end
                                if i == 3
                                    OrderAuftrag = MaxSFSZ(A,HZ,KZ,BZ,OrderArtikel);
                                end

                                switch Ziel 
                                    case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte mit Stellplatzbegrenzung
                                        [Zielfunktionswert,GesamtHolArtOrder] = FSZbS(A,HZ,KZ,SP,OrderArtikel,OrderAuftrag);

                                    case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt mit Stellplatzbegrenzung
                                        [Zielfunktionswert,GesamtHolArtOrder] = FFbS(A,HZ,KZ,SP,OrderArtikel,OrderAuftrag);

                                    case 3 % Zielfunktion: min! sum. Durchlaufzeiten mit Stellplatzbegrenzung
                                        [Zielfunktionswert,GesamtHolArtOrder] = DLZbS(A,HZ,KZ,SP,OrderArtikel,OrderAuftrag);
                                end

                                Rechenzeit = toc; % Rechenzeit stoppen

                                Data(x,:) = {['---' ArtikelVerfahrenNamen{index} ' (Hierarchisch)'],Zielfunktionswert,Rechenzeit,int2str(GesamtHolArtOrder),int2str(OrderAuftrag)};

                                if getappdata(Info_waitbar,'canceling')
                                    delete(Info_waitbar)
                                    tmp_new = 1;
                                    KMT AuftragVerfahrenMitSPG                        
                                end
                                % Report current estimate in the waitbar's message field
                                waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                                x = x+1;
                            end
                       
                            if ArtR(index) == 1
                                
                                BZ = Bearbeitungszeit(A,HZ,KZ);
                                HA = Haufigkeit(A);
                                
                                step = step + 1;

                                tic % Rechenzeit beginnen

                                switch index
                                    case 1
                                        OrderArtikel = [1:m]'; %#ok<*NBRAK> unterdrückt die Fehlermeldung, dass die Klammern überflüssig sind
                                    case 2
                                        OrderArtikel = minBmaxH(HA,BZ);
                                    case 3
                                        OrderArtikel = maxBmaxH(HA,BZ);
                                    case 4
                                        OrderArtikel = minHtopo(HA,BZ);
                                    case 5
                                        OrderArtikel = maxHtopo(HA,BZ);
                                    case 6
                                        OrderArtikel = maxHminB(HA,BZ);
                                    case 7
                                        OrderArtikel = maxHmaxB(HA,BZ);
                                    case 8
                                        OrderArtikel = zenReihAufst(HA);
                                    case 9
                                        OrderArtikel = zenReihAbst(HA);
                                    case 10
                                        OrderArtikel = minAtopo(A);
                                    case 11
                                        OrderArtikel = minAminB(A,BZ);
                                    case 12
                                        OrderArtikel = minAmaxB(A,BZ);
                                    case 13
                                        OrderArtikel = minAminH(A,HA);
                                    case 14
                                        OrderArtikel = minAmaxH(A,HA);
                                    case 15
                                        OrderArtikel = maxAtopo(A);
                                    case 16
                                        OrderArtikel = maxAminB(A,BZ);
                                    case 17
                                        OrderArtikel = maxAmaxB(A,BZ);
                                    case 18
                                        OrderArtikel = maxAminH(A,HA);
                                    case 19
                                        OrderArtikel = maxAmaxH(A,HA);
                                end

                                if i == 1
                                    OrderAuftrag = [1:n];
                                end
                                if i == 2
                                    OrderAuftrag = MinSFSZ(A,HZ,KZ,BZ,OrderArtikel);
                                end
                                if i == 3
                                    OrderAuftrag = MaxSFSZ(A,HZ,KZ,BZ,OrderArtikel);
                                end

                                switch Ziel 
                                    case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte mit Stellplatzbegrenzung
                                        [Zielfunktionswert,GesamtHolArtOrder] = FSZbSR(A,HZ,KZ,SP,OrderArtikel,OrderAuftrag);

                                    case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt mit Stellplatzbegrenzung
                                        [Zielfunktionswert,GesamtHolArtOrder] = FFbSR(A,HZ,KZ,SP,OrderArtikel,OrderAuftrag);

                                    case 3 % Zielfunktion: min! sum. Durchlaufzeiten mit Stellplatzbegrenzung
                                        [Zielfunktionswert,GesamtHolArtOrder] = DLZbSR(A,HZ,KZ,SP,OrderArtikel,OrderAuftrag);
                                end

                                Rechenzeit = toc; % Rechenzeit stoppen

                                Data(x,:) = {['---' ArtikelVerfahrenNamen{index} ' (Rollierend)'],Zielfunktionswert,Rechenzeit,int2str(GesamtHolArtOrder),int2str(OrderAuftrag)};

                                if getappdata(Info_waitbar,'canceling')
                                    delete(Info_waitbar)
                                    tmp_new = 1;
                                    KMT AuftragVerfahrenMitSPG                        
                                end
                                % Report current estimate in the waitbar's message field
                                waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                                x = x+1;
                            end
                            
                            % Überprüfe, ob Zufallszahlen schon generiert
                            % wurden
                            
                            q = 1;
                            
                            % Überprüfe, ob schon Zufallszahlen erstellt
                            % worden sind
                            if isempty(save_zufallszahl)
                               save_zufallszahl = [];
                               
                               % Bestimme neue Zufallszahlen
                               create_zufall = true;
                            else
                                
                               % Bestimme keine neuen Zufallszahlen
                               create_zufall = false;
                            end
                            
                            if ArtD(index) == 1
                                
                                step = step + 1;

                                tic % Rechenzeit beginnen
                                
                                [m,n] = size(A);
                                
                                GesamtHolArtOrder = []; % Vektor, welche Artikel geholt werden sollen
                                
                                % Überprüfe, ob die online oder offline
                                % Methode angewendet wird
                                if strcmp(str_auftrag,'online')
                                    % Überprüfung, ob eine neue Zufallszahl
                                    % bestimmt werden soll oder die
                                    % nächsten genommen werden sollen
                                    if create_zufall
                                        zufallszahl =  randi([SP n],1,1); % Bestimme eine Zufallszahl
                                        save_zufallszahl = [save_zufallszahl zufallszahl];
                                    else
                                        zufallszahl = save_zufallszahl(q); % Nehme die nächste Zufallszahl
                                        q = q + 1;
                                    end
                                    tmp_A = A(:,[1:zufallszahl]); % Bestimme die Matrix
                                    C = zeros(1,zufallszahl); % Zielfunktionswert von jedem einzelnen Auftrag
                                    Auftrag_fertig = []; % Hilfsvektor, ob ein Auftrag abgearbeitet wurde
                                    Auftrag_fertig(1,zufallszahl) = false; 
                                elseif strcmp(str_auftrag,'offline')
                                    tmp_A = A; % temporäre Matrix 
                                    C = zeros(1,n); % Zielfunktionswert von jedem einzelnen Auftrag
                                    Auftrag_fertig = []; % Hilfsvektor, ob ein Auftrag abgearbeitet wurde
                                    Auftrag_fertig(1,n) = false;
                                end
                                
                                bestimme_auftrag = false; % Hilfsvariable, um Auftrag zu bestimmen
                                
                                bestimmte_ersten_auftrag = true; % Hilfsvariable, um den allerersten Auftrag zu bestimmen
                                
                                while ~isequal(tmp_A,zeros(m,n)) || size(A,2) ~= size(tmp_A,2)% Überprüfung ob tmp_A = 0 Matrix
                                    
                                    if ~bestimme_auftrag % Das erste Mal wird eine Auftragsreihenfolge zu der ganzen Matrix bestimmt
                                        
                                        BZ = Bearbeitungszeit(tmp_A,HZ,KZ);
                                        HA = Haufigkeit(tmp_A);
                                        
                                        switch index
                                            case 1
                                                OrderArtikel = [1:m]'; %#ok<*NBRAK> unterdrückt die Fehlermeldung, dass die Klammern überflüssig sind
                                            case 2
                                                OrderArtikel = minBmaxH(HA,BZ);
                                            case 3
                                                OrderArtikel = maxBmaxH(HA,BZ);
                                            case 4
                                                OrderArtikel = minHtopo(HA,BZ);
                                            case 5
                                                OrderArtikel = maxHtopo(HA,BZ);
                                            case 6
                                                OrderArtikel = maxHminB(HA,BZ);
                                            case 7
                                                OrderArtikel = maxHmaxB(HA,BZ);
                                            case 8
                                                OrderArtikel = zenReihAufst(HA);
                                            case 9
                                                OrderArtikel = zenReihAbst(HA);
                                            case 10
                                                OrderArtikel = minAtopo(tmp_A);
                                            case 11
                                                OrderArtikel = minAminB(tmp_A,BZ);
                                            case 12
                                                OrderArtikel = minAmaxB(tmp_A,BZ);
                                            case 13
                                                OrderArtikel = minAminH(tmp_A,HA);
                                            case 14
                                                OrderArtikel = minAmaxH(tmp_A,HA);
                                            case 15
                                                OrderArtikel = maxAtopo(tmp_A);
                                            case 16
                                                OrderArtikel = maxAminB(tmp_A,BZ);
                                            case 17
                                                OrderArtikel = maxAmaxB(tmp_A,BZ);
                                            case 18
                                                OrderArtikel = maxAminH(tmp_A,HA);
                                            case 19
                                                OrderArtikel = maxAmaxH(tmp_A,HA);
                                        end
                                    
                                        %  Auswahl der Auftragsreihenfolgefunktionen
                                        if i == 1
                                            OrderAuftrag = [1:size(tmp_A,2)];
                                        end
                                        if i == 2
                                            OrderAuftrag = MinSFSZ(tmp_A,HZ,KZ,BZ,OrderArtikel);
                                        end
                                        if i == 3
                                            OrderAuftrag = MaxSFSZ(tmp_A,HZ,KZ,BZ,OrderArtikel);
                                        end
                                        
                                        if bestimmte_ersten_auftrag
                                           AufKB = OrderAuftrag(1:SP); % Aufträge (laut Auftragsreihenfolge) im Kommissionierbereich
                                           bestimmte_ersten_auftrag = false; % Setze Variable auf false, da ein Auftrag bestimmt wurde
                                        end
                                        
                                        bestimme_auftrag = true; % Auftragsreihenfolge wurde bestimmt
                                    
                                    end
                                    
                                    % Überprüfe, ob die online-Methode
                                    % ausgewäht wurde
                                    if strcmp(str_auftrag,'online')
                                        
                                        % Gehe den Vektor AufKB durch
                                        for k = 1 : size(AufKB,2)
                                            
                                           % Überprüfe, ob der Auftrag in
                                           % AufKB schon erledigt wurde
                                           if Auftrag_fertig(1,AufKB(1,k))
                                               
                                              % Bestimme einen neuen
                                              % Auftrag für den Platz, der
                                              % schon erledigt wurde
                                              for j = 1 : size(OrderAuftrag,2)
                                                  if isempty(find(OrderAuftrag(1,j) == AufKB(1,:),1)) && ~Auftrag_fertig(1,OrderAuftrag(1,j))
                                                      
                                                     % Setze den neuen
                                                     % Auftrag
                                                     AufKB(1,k) = OrderAuftrag(1,j);
                                                     break;
                                                  end                                       
                                              end
                                           end
                                        end
                                    end
                                    
                                    BZ = Bearbeitungszeit(tmp_A(:,AufKB(1:SP)),HZ,KZ); % Neue Bearbeitungszeit/Häufigkeit berechnen (auf Stellplatz beschränkte Matrix!!)
                                    HA = Haufigkeit(tmp_A(:,AufKB(1:SP)));
                                    
                                    if ~isequal(Auftrag_fertig,ones(1,size(tmp_A,2)))
                                        switch index
                                            case 1
                                                OrderArtikel = [1:m]'; %#ok<*NBRAK> unterdrückt die Fehlermeldung, dass die Klammern überflüssig sind
                                            case 2
                                                OrderArtikel = minBmaxH(HA,BZ);
                                            case 3
                                                OrderArtikel = maxBmaxH(HA,BZ);
                                            case 4
                                                OrderArtikel = minHtopo(HA,BZ);
                                            case 5
                                                OrderArtikel = maxHtopo(HA,BZ);
                                            case 6
                                                OrderArtikel = maxHminB(HA,BZ);
                                            case 7
                                                OrderArtikel = maxHmaxB(HA,BZ);
                                            case 8
                                                OrderArtikel = zenReihAufst(HA);
                                            case 9
                                                OrderArtikel = zenReihAbst(HA);
                                            case 10
                                                OrderArtikel = minAtopo(tmp_A(:,AufKB(1:SP)));
                                            case 11
                                                OrderArtikel = minAminB(tmp_A(:,AufKB(1:SP)),BZ);
                                            case 12
                                                OrderArtikel = minAmaxB(tmp_A(:,AufKB(1:SP)),BZ);
                                            case 13
                                                OrderArtikel = minAminH(tmp_A(:,AufKB(1:SP)),HA);
                                            case 14
                                                OrderArtikel = minAmaxH(tmp_A(:,AufKB(1:SP)),HA);
                                            case 15
                                                OrderArtikel = maxAtopo(tmp_A(:,AufKB(1:SP)));
                                            case 16
                                                OrderArtikel = maxAminB(tmp_A(:,AufKB(1:SP)),BZ);
                                            case 17
                                                OrderArtikel = maxAmaxB(tmp_A(:,AufKB(1:SP)),BZ);
                                            case 18
                                                OrderArtikel = maxAminH(tmp_A(:,AufKB(1:SP)),HA);
                                            case 19
                                                OrderArtikel = maxAmaxH(tmp_A(:,AufKB(1:SP)),HA);
                                        end
                                    end
                                        
                                    switch Ziel 
                                        case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte mit Stellplatzbegrenzung
                                            [GesamtHolArtOrder,AufKB,tmp_A,C,Auftrag_fertig] = FSZbSD(tmp_A,HZ,KZ,SP,OrderArtikel,OrderAuftrag,AufKB,GesamtHolArtOrder,C,Auftrag_fertig,Artikel_neu_berechnen);

                                        case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt mit Stellplatzbegrenzung
                                            [GesamtHolArtOrder,AufKB,tmp_A,C,Auftrag_fertig] = FFbSD(tmp_A,HZ,KZ,SP,OrderArtikel,OrderAuftrag,AufKB,GesamtHolArtOrder,C,Auftrag_fertig,Artikel_neu_berechnen);

                                        case 3 % Zielfunktion: min! sum. Durchlaufzeiten mit Stellplatzbegrenzung
                                            [GesamtHolArtOrder,AufKB,tmp_A,C,Auftrag_fertig] = DLZbSD(tmp_A,HZ,KZ,SP,OrderArtikel,OrderAuftrag,AufKB,GesamtHolArtOrder,C,Auftrag_fertig,Artikel_neu_berechnen);
                                    end
                                    
                                    % Überprüfe, ob die online-Methode
                                    % ausgewählt wurde
                                    if strcmp(str_auftrag,'online')
                                        
                                        % Überprüfe, ob die Dimensionen von
                                        % tmp_A und A unterschiedlich sind
                                        if size(tmp_A,2) ~= size(A,2)
                                            
                                           % Überprüfe, ob schon
                                           % Zufallszahlen bestimmt worden
                                           % sind oder neue erstellt werden
                                           % müssen
                                           if create_zufall
                                               
                                               
                                               % Bestimme eine neue
                                               % Zufallszahl und speichere
                                               % diese ab
                                               zufallszahl = randi([0 n],1,1);
                                               save_zufallszahl = [save_zufallszahl zufallszahl];
                                           else
                                               
                                               % Gehe die gespeicherten
                                               % Zufallszahlen durch
                                               zufallszahl = save_zufallszahl(q);
                                               q = q + 1;
                                           end
                                           
                                           % Überprüfe, ob die Zufallszahl
                                           % das Intervall überschreitet
                                           if zufallszahl + size(tmp_A,2) > size(A,2)
                                              zufallszahl = size(A,2) - size(tmp_A,2);
                                           end
                                           
                                           % Überprüfe, ob die Zufallszahl
                                           % nicht gleich 0 ist
                                           if zufallszahl ~= 0
                                               
                                               % Ergänze die tmp_A Matrix
                                               tmp_A(:,[size(tmp_A,2)+1:size(tmp_A,2)+zufallszahl]) = A(:,[size(tmp_A,2)+1:size(tmp_A,2)+zufallszahl]);
                                               
                                               % Ergänze den C Vektor
                                               C = [C zeros(1,zufallszahl)];
                                               
                                               % Ergänze den
                                               % Auftrags-Vektor
                                               tmp_Auftrag_fertig = [];
                                               tmp_Auftrag_fertig(1,zufallszahl) = false;
                                               Auftrag_fertig = [Auftrag_fertig tmp_Auftrag_fertig];
                                               
                                               % Setze die Variable wieder
                                               % auf true, da ein neuer
                                               % Auftrag gefunden werden
                                               % muss
                                               bestimme_auftrag = false;
                                           end
                                        end
                                    end
                                end
                                
                                switch Ziel 
                                    case 1
                                        Zielfunktionswert = sum(C); % Aufsummierte Zielfunktionswerte anzeigen
                                    case 2
                                        Zielfunktionswert = max(C); % Maximalen Zielfunktionswert anzeigen
                                    case 3
                                        Zielfunktionswert = sum(C); % Aufsummierte Zielfunktionswerte anzeigen
                                end

                                Rechenzeit = toc; % Rechenzeit stoppen
                                
                                if Ziel == 1
                                   Data(x,:) = {['---' ArtikelVerfahrenNamen{index} ' (Dynamisch)'],Zielfunktionswert,Rechenzeit,int2str(GesamtHolArtOrder),int2str(OrderAuftrag)};
                                end
                                
                                if Ziel == 2
                                   Data(x,:) = {['---' ArtikelVerfahrenNamen{index} ' (Dynamisch)'],Zielfunktionswert,Rechenzeit,int2str(GesamtHolArtOrder),int2str(OrderAuftrag)}; 
                                end
                                
                                if Ziel == 3
                                   Data(x,:) = {['---' ArtikelVerfahrenNamen{index} ' (Dynamisch)'],Zielfunktionswert,Rechenzeit,int2str(GesamtHolArtOrder),int2str(OrderAuftrag)}; 
                                end
                                
                                if getappdata(Info_waitbar,'canceling')
                                    delete(Info_waitbar)
                                    tmp_new = 1;
                                    KMT AuftragVerfahrenMitSPG                        
                                end
                                % Report current estimate in the waitbar's message field
                                waitbar(step/steps,Info_waitbar,'Berechnung läuft...')
                                
                                x = x+1;
                            end   
                        end

                    end
                    
                end
                
              
                % Die Güte der Zielfunktionswerte mit in Data aufnehmen
                AlleZielfunktionswerte = cell2mat(Data(:,2));
                % Die Güte berechnen
                Abweichung_rel = RelativeAbweichung(AlleZielfunktionswerte);
                % Die Nullen müssen jetzt wieder aufgenommen werden
                if sum(Auf) == 1
                    Abweichung_rel = [cell(1,1)
                                      Abweichung_rel];
                end
                if sum(Auf) == 2
                    Abweichung_rel = [cell(1,1)
                                      Abweichung_rel(1:(sum(Art)+sum(ArtR)+sum(ArtD)),:)
                                      cell(1,1)
                                      Abweichung_rel(1+(sum(Art)+sum(ArtR)+sum(ArtD)):end)];
                end
                if sum(Auf) == 3
                    Abweichung_rel = [cell(1,1)
                                      Abweichung_rel(1:(sum(Art)+sum(ArtR)+sum(ArtD)),:)
                                      cell(1,1)
                                      Abweichung_rel(1+(sum(Art)+sum(ArtR)+sum(ArtD)):2*(sum(Art)+sum(ArtR)+sum(ArtD)),:)
                                      cell(1,1)
                                      Abweichung_rel(1+2*(sum(Art)+sum(ArtR)+sum(ArtD)):end)];
                end
                Data = [Data(:,1:2) Abweichung_rel Data(:,3:end)];
    
                delete(Info_waitbar)

                Titel = {'Verfahren','Zielfunktionswert','Abweichung (%)','Rechenzeit (s)','Artikelreihenfolge','Auftragsreihenfolge'};
                Ausgabe = Data;
                
                Backgroundcolor_Matrix = [];
                for k = 1 : size(Data,1)
                    Data{k,2} = num2str(Data{k,2},'%0.2f');
                    Data{k,3} = num2str(Data{k,3},'%0.4f');
                    Data{k,4} = num2str(Data{k,4},'%0.4f');
                    if ~isempty(strfind(Data{k,1},'Hierarchisch'))
                       Backgroundcolor_Matrix = [Backgroundcolor_Matrix; 1 0.925490196078431 0.545098039215686];
                    elseif ~isempty(strfind(Data{k,1},'Rollierend'))
                       Backgroundcolor_Matrix = [Backgroundcolor_Matrix; 0.529411764705882 0.807843137254902 0.980392156862745];
                    elseif ~isempty(strfind(Data{k,1},'Dynamisch'))
                       Backgroundcolor_Matrix = [Backgroundcolor_Matrix; 0.596078431372549 0.984313725490196 0.596078431372549];
                    else
                       Backgroundcolor_Matrix = [Backgroundcolor_Matrix; 1 1 1];
                    end
                end

                hui(2032) = uitable('Data',Data,...
                                    'Units','normalized',...
                                    'Backgroundcolor',Backgroundcolor_Matrix,...
                                    'FontSize',Schriftgroesse1,...
                                    'FontUnits','normalized',...
                                    'ColumnFormat',{'char','char','char','char','char','char'},...
                                    'ColumnName',Titel,...
                                    'ColumnWidth',{750 'auto' 100 120 400 400},...
                                    'ColumnEditable',[false false false false false false ],...
                                    'RowName',[],...
                                    'Position',[0 0.25 1 0.6]);



                hui(2033) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.025 .1 .15 .05],...
                                      'String','zurück',...
                                      'CallBack','KMT BackAuftragVerfahrenMitSPG');
                                  
                hui(2034) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.225 .1 .15 .05],...
                                      'String','neustart',...
                                      'CallBack','KMT');
                                  
                hui(2035) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.425 .1 .15 .05],...
                                      'String','speichern',...
                                      'CallBack','KMT SpeicherZmSPG');
                                  
               hui(2036) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.625 .1 .15 .05],...
                                      'String','speichern klein',...
                                      'CallBack','KMT SpeicherZmSPG2');
                                  
                hui(2037) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.825 .1 .15 .05],...
                                      'String','schließen',...
                                      'CallBack','close');
                                  
            end
          
            
        case 'SpeicherZmSPG' % Für Zielfunktionen mit SPG
            AusgabedateiExcel = 'AusgabeZielfunktionMitSPG.xlsx';
            AusgabedateiMat = 'AusgabeZielfunktionMitSPG.mat';
            [AnzAusZmSPG] = speichern(Titel,Ausgabe,AusgabedateiExcel,AnzAusZmSPG,AusgabedateiMat);
            
            
        case 'SpeicherZmSPG2' % Für Zielfunktionen mit SPG, speichern ohne Artikel- und Auftragsreihenfolge
            AusgabedateiExcel = 'AusgabeZielfunktionMitSPG.xlsx';
            AusgabedateiMat = 'AusgabeZielfunktionMitSPG.mat';
            [AnzAusZmSPG] = speichern(Titel(:,1:4),Ausgabe(:,1:4),AusgabedateiExcel,AnzAusZmSPG,AusgabedateiMat);
            
            
        case 'BackAnzStellPlatzMitSPG'
            set(hui(100),'String','Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion');
            set(hui(103),'Callback','KMT InfoZielfunktion');
            set(hui(2000:2023),'Visible','off','Enable','inactive');
            set(hui(3001:3019),'Visible','off','Enable','inactive');
            set(hui(4001:4019),'Visible','off','Enable','inactive');
            set(hui(3030:3038),'Visible','off','Enable','inactive');
            Art = zeros(1,AnzArtikelVerfahren);
            KMT WeiterSeite2


        case 'BackArtikelVerfahrenMitSPG'
            tmp_value = get(hui(402),'Value');
            tmp_string = get(hui(402),'String');
            set(hui(100),'String',['Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion: ' tmp_string(tmp_value,:) '   >   Artikelreihenfolgeverfahren']);
            set(hui(103),'Callback','KMT InfoArtikelreihenfolgeverfahren');
            set(hui(2000:2023),'Visible','on','Enable','on'); 
            set(hui(3001:3019),'Visible','on','Enable','on'); 
            set(hui(4001:4019),'Visible','on','Enable','on');
            set(hui(3030:3038),'Visible','on','Enable','on');
            set(hui(2024:2031),'Visible','off','Enable','inactive');  
            Auf = zeros(1,AnzAuftragsVerfahren);
            AufRest = zeros(1,AnzAuftragsVerfahren);

        case 'BackAuftragVerfahrenMitSPG'
            tmp_value = get(hui(402),'Value');
            tmp_string = get(hui(402),'String');
            set(hui(100),'String',['Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion: ' tmp_string(tmp_value,:) '   >   Artikelreihenfolgeverfahren   >   Auftragsreihenfolgeverfahren']);    
            set(hui(103),'Callback','KMT InfoAuftragsreihenfolgeverfahren');       
            set(hui(2024:2031),'Visible','on','Enable','on'); 
            set(hui(2032:2037),'Visible','off','Enable','inactive'); 
            Auf = zeros(1,AnzAuftragsVerfahren);

            
        case 'AlleArtikelVerfahrenMitSPG'

            Art = ones(1,AnzArtikelVerfahren); 
            ArtR = ones(1,AnzArtikelVerfahren);
            ArtD = ones(1,AnzArtikelVerfahren);
            set(hui(2001:2019),'Value',1); 
            set(hui(3001:3019),'Value',1);
            set(hui(4001:4019),'Value',1);


        case 'KeineArtikelVerfahrenMitSPG'

            Art = zeros(1,AnzArtikelVerfahren);
            ArtR = zeros(1,AnzArtikelVerfahren);
            ArtD = zeros(1,AnzArtikelVerfahren);
            set(hui(2001:2019),'Value',0); 
            set(hui(3001:3019),'Value',0);
            set(hui(3036:3038),'Value',0);
            set(hui(4001:4019),'Value',0);


        case 'AlleAuftragVerfahrenMitSPG'

            Auf = ones(1,AnzAuftragsVerfahren);
            set(hui(2025:2027),'Value',1);


        case 'KeineAuftragVerfahrenMitSPG'

            Auf = zeros(1,AnzAuftragsVerfahren);
            set(hui(2025:2027),'Value',0);
            
        case 'AlleDynamisch'
            if get(hui(3036),'Value') == 1
               set(hui(4001:4019),'Value',1); 
            else
               set(hui(4001:4019),'Value',0); 
            end
            
        case 'AlleRollierend'
            if get(hui(3037),'Value') == 1
               set(hui(3001:3019),'Value',1); 
            else
               set(hui(3001:3019),'Value',0); 
            end
            
        case 'AlleHierarchisch'
            if get(hui(3038),'Value') == 1
               set(hui(2001:2019),'Value',1); 
            else
               set(hui(2001:2019),'Value',0); 
            end
            
%% Zielfunktionen mit Stellplatzbegrenzung und mit Deadline
            
        case 'ArtikelVerfahrenMitSPGUndDL'
            PositionCheckbox1 = [.08 .71 .44 .05;
                                .08 .66 .44 .05;
                                .08 .61 .44 .05;
                                .08 .56 .44 .05;
                                .08 .51 .44 .05;
                                .08 .46 .44 .05;
                                .08 .41 .44 .05;
                                .08 .36 .44 .05;
                                .08 .31 .44 .05;
                                .54 .71 .44 .05;
                                .54 .66 .44 .05;
                                .54 .61 .44 .05;
                                .54 .56 .44 .05;
                                .54 .51 .44 .05;
                                .54 .46 .44 .05;
                                .54 .41 .44 .05;
                                .54 .36 .44 .05;
                                .54 .31 .44 .05;
                                .54 .26 .44 .05];
                            
           PositionCheckbox2 = [.06 .71 .02 .05;
                                .06 .66 .02 .05;
                                .06 .61 .02 .05;
                                .06 .56 .02 .05;
                                .06 .51 .02 .05;
                                .06 .46 .02 .05;
                                .06 .41 .02 .05;
                                .06 .36 .02 .05;
                                .06 .31 .02 .05;
                                .52 .71 .02 .05;
                                .52 .66 .02 .05;
                                .52 .61 .02 .05;
                                .52 .56 .02 .05;
                                .52 .51 .02 .05;
                                .52 .46 .02 .05;
                                .52 .41 .02 .05;
                                .52 .36 .02 .05;
                                .52 .31 .02 .05;
                                .52 .26 .02 .05]; 
                            
           PositionCheckbox3 = [.04 .71 .02 .05;
                                .04 .66 .02 .05;
                                .04 .61 .02 .05;
                                .04 .56 .02 .05;
                                .04 .51 .02 .05;
                                .04 .46 .02 .05;
                                .04 .41 .02 .05;
                                .04 .36 .02 .05;
                                .04 .31 .02 .05;
                                .50 .71 .02 .05;
                                .50 .66 .02 .05;
                                .50 .61 .02 .05;
                                .50 .56 .02 .05;
                                .50 .51 .02 .05;
                                .50 .46 .02 .05;
                                .50 .41 .02 .05;
                                .50 .36 .02 .05;
                                .50 .31 .02 .05;
                                .50 .26 .02 .05];
                            
           hui(2000) = uicontrol('Style','text',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'HorizontalAlignment','center',...  % Damit der Text mittig ist
                                  'Position',[0 .82 1 .05],...
                                  'String','Artikelreihenfolgeverfahren:');
                              
            hui(5160) = uicontrol('Style','text',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'HorizontalAlignment','center',...  % Damit der Text mittig ist
                                  'Position',[0.04 .78 0.01 .05],...
                                  'String','D');
                              
            hui(5161) = uicontrol('Style','text',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'HorizontalAlignment','center',...  % Damit der Text mittig ist
                                  'Position',[0.06 .78 0.01 .05],...
                                  'String','R');
                              
            hui(5162) = uicontrol('Style','text',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'HorizontalAlignment','center',...  % Damit der Text mittig ist
                                  'Position',[0.08 .78 0.01 .05],...
                                  'String','H');
                              
            hui(5163) = uicontrol('Style','text',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'HorizontalAlignment','center',...  % Damit der Text mittig ist
                                  'Position',[0.50 .75 0.01 .05],...
                                  'String','D');
                              
            hui(5164) = uicontrol('Style','text',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'HorizontalAlignment','center',...  % Damit der Text mittig ist
                                  'Position',[0.52 .75 0.01 .05],...
                                  'String','R');
                              
            hui(5165) = uicontrol('Style','text',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'HorizontalAlignment','center',...  % Damit der Text mittig ist
                                  'Position',[0.54 .75 0.01 .05],...
                                  'String','H');     
                              
            hui(5166) = uicontrol('Style','checkbox',...
                                    'Units','normalized',...
                                    'FontSize',Schriftgroesse1,...
                                    'FontUnits','normalized',...
                                    'Position',[0.04 .75 0.02 .05],...
                                    'String','',...
                                    'Callback','KMT AlleDynamischDL');
                                
            hui(5167) = uicontrol('Style','checkbox',...
                                    'Units','normalized',...
                                    'FontSize',Schriftgroesse1,...
                                    'FontUnits','normalized',...
                                    'Position',[0.06 .75 0.02 .05],...
                                    'String','',...
                                    'Callback','KMT AlleRollierendDL');
                                
            hui(5168) = uicontrol('Style','checkbox',...
                                    'Units','normalized',...
                                    'FontSize',Schriftgroesse1,...
                                    'FontUnits','normalized',...
                                    'Position',[0.08 .75 0.02 .05],...
                                    'String','',...
                                    'Callback','KMT AlleHierarchischDL');

            for i = 1:length(ArtikelVerfahrenNamen)
            	hui(i+5100) = uicontrol('Style','checkbox',...
                                        'Units','normalized',...
                                        'FontSize',Schriftgroesse1,...
                                        'FontUnits','normalized',...
                                        'Position',PositionCheckbox1(i,:),...
                                        'Value',Art(i),...
                                        'String',ArtikelVerfahrenNamen{i});
                                    
            	hui(i+5100+length(ArtikelVerfahrenNamen)) = uicontrol('Style','checkbox',...
                                        'Units','normalized',...
                                        'FontSize',Schriftgroesse1,...
                                        'FontUnits','normalized',...
                                        'Position',PositionCheckbox2(i,:),...
                                        'Value',ArtR(i));
                                    
                hui(i+5100+2*(length(ArtikelVerfahrenNamen))) = uicontrol('Style','checkbox',...
                                        'Units','normalized',...
                                        'FontSize',Schriftgroesse1,...
                                        'FontUnits','normalized',...
                                        'Position',PositionCheckbox3(i,:),...
                                        'Value',ArtD(i));
            end
            
            hui(5169) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.8 .1 .15 .05],...
                                  'String','weiter',...
                                  'CallBack','KMT AuftragVerfahrenMitSPGundDL');

            hui(5170) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.05 .1 .15 .05],...
                                  'String','zurück',...
                                  'CallBack','KMT BackAnzStellPlatzMitSPGundDL'); 

            hui(5171) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.55 .1 .15 .05],...
                                  'String','alle auswählen',...
                                  'CallBack','KMT AlleArtikelVerfahrenMitSPGundDL');

            hui(5172) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.3 .1 .15 .05],...
                                  'String','keins auswählen',...
                                  'CallBack','KMT KeineArtikelVerfahrenMitSPGundDL'); 

        case 'AuftragVerfahrenMitSPGundDL'

            Art = [get(hui(5101),'Value')
                   get(hui(5102),'Value')
                   get(hui(5103),'Value')
                   get(hui(5104),'Value')
                   get(hui(5105),'Value')
                   get(hui(5106),'Value')
                   get(hui(5107),'Value')
                   get(hui(5108),'Value')
                   get(hui(5109),'Value')
                   get(hui(5110),'Value')
                   get(hui(5111),'Value')
                   get(hui(5112),'Value')
                   get(hui(5113),'Value')
                   get(hui(5114),'Value')
                   get(hui(5115),'Value')
                   get(hui(5116),'Value')
                   get(hui(5117),'Value')
                   get(hui(5118),'Value')
                   get(hui(5119),'Value')];
               
            ArtR = [get(hui(5120),'Value')
                   get(hui(5121),'Value')
                   get(hui(5122),'Value')
                   get(hui(5123),'Value')
                   get(hui(5124),'Value')
                   get(hui(5125),'Value')
                   get(hui(5126),'Value')
                   get(hui(5127),'Value')
                   get(hui(5128),'Value')
                   get(hui(5129),'Value')
                   get(hui(5130),'Value')
                   get(hui(5131),'Value')
                   get(hui(5132),'Value')
                   get(hui(5133),'Value')
                   get(hui(5134),'Value')
                   get(hui(5135),'Value')
                   get(hui(5136),'Value')
                   get(hui(5137),'Value')
                   get(hui(5138),'Value')];
               
             ArtD = [get(hui(5139),'Value')
                   get(hui(5140),'Value')
                   get(hui(5141),'Value')
                   get(hui(5142),'Value')
                   get(hui(5143),'Value')
                   get(hui(5144),'Value')
                   get(hui(5145),'Value')
                   get(hui(5146),'Value')
                   get(hui(5147),'Value')
                   get(hui(5148),'Value')
                   get(hui(5149),'Value')
                   get(hui(5150),'Value')
                   get(hui(5151),'Value')
                   get(hui(5152),'Value')
                   get(hui(5153),'Value')
                   get(hui(5154),'Value')
                   get(hui(5155),'Value')
                   get(hui(5156),'Value')
                   get(hui(5157),'Value')];
               
            if isempty(tmp_new)
                if ~isempty(find(ArtD(:,1) == 1,1)) % Fehlerabfangung für PopUp-Fenster 'Neue Artikelreihenfolgeberechnung'
                    Artikel_neu_berechnen = inputdlg('Bitte geben Sie eine gültige Zahl ein, nach wie vielen fertigen Auftraegen die Artikelreihenfolge neu berechnet werden soll.',...
                                                     'Neue Artikelreihenfolgeberechnung', [1 55],{'1'});

                    if ~isempty(Artikel_neu_berechnen)
                       Artikel_neu_berechnen = str2double(Artikel_neu_berechnen{1});       
                    else
                       Artikel_neu_berechnen = NaN;
                    end

                    while Artikel_neu_berechnen > size(A,2) || ...
                          isnan(Artikel_neu_berechnen) || ...
                          round(Artikel_neu_berechnen) ~= Artikel_neu_berechnen || ...
                          Artikel_neu_berechnen < 1

                          Artikel_neu_berechnen = inputdlg('Bitte geben Sie eine gültige Zahl ein, nach wie vielen fertigen Auftraegen die Artikelreihenfolge neu berechnet werden soll. Hinweis: Positive ganze Zahlen sind nur möglich!',...
                                                     'Neue Artikelreihenfolgeberechnung', [1 55],{'1'});

                          if ~isempty(Artikel_neu_berechnen)                       
                             Artikel_neu_berechnen = str2double(Artikel_neu_berechnen{1});  
                          else
                             Artikel_neu_berechnen = NaN;
                          end
                    end

                    str_auftrag = questdlg('Es wurde min. ein dynamisches Verfahren ausgewaehlt. Welches Verfahren möchten Sie verwenden?',...
                                           'Online/Offline Verfahren', ...
                                           'online','offline','offline');
                    while isempty(str_auftrag)
                         str_auftrag = questdlg('Es wurde min. ein dynamisches Verfahren ausgewaehlt. Welches Verfahren möchten Sie verwenden?',...
                                           'Online/Offline Verfahren', ...
                                           'online','offline','offline');
                    end
                end
            end
            tmp_new = [];
            
            if sum(Art)+sum(ArtR)+sum(ArtD) == 0
                errordlg('Bitte wählen Sie mindestens ein Artikelreihenfolgeverfahren aus.','Fehler')
            else
                tmp_value = get(hui(403),'Value');
                tmp_string = get(hui(403),'String');
                DL_enabled = 1;                         %wird zum tracken benötigt, ob die buttons zur auswahl des auftragsreihenfolgeverfahrens enabled sind oder nicht
                DL_alle = 1;                            % DL_alle == 1 heißt, alle Aufträge haben eine DL > 0 (Grundannahme).
                set(hui(100),'String',['Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion: ' tmp_string(tmp_value,:) '   >   Artikelreihenfolgeverfahren   >   Auftragsreihenfolgeverfahren']); 
                set(hui(103),'Callback','KMT InfoAuftragsreihenfolgeverfahren');
                set(hui(2000),'Visible','off','Enable','inactive');
                set(hui(5101:5157),'Visible','off','Enable','inactive'); 
                set(hui(5160:5172),'Visible','off','Enable','inactive');
           
                hui(5200) = uicontrol('Style','text',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'HorizontalAlignment','left',...  % Damit der Text linksbündig ist
                                      'Position',[.07 .65 .5 .05],...
                                      'String','Auftragsreihenfolgeverfahren:');
                
                hui(5208) = uicontrol('Style','text',...                %hui 5207 wird vor hui 5201-5206 erzeugt, damit es von jenen überschrieben werden kann. hui 5201-5206 müssen diese nummern beibehalten für 'LoeseMitSPUndDL' 
                                      'Units','normalized',...
                                      'FontSize',18,...
                                      'HorizontalAlignment','left',...  % Damit der Text linksbündig ist
                                      'Position',[.07 .35 .5 .09],...
                                      'String',{'Auftragsreihenfolgeverfahren',...
                                      'für Aufträge mit unendlich großer',...
                                      'Deadline bzw. bei gleicher Deadline:'});

                hui(5201) = uicontrol('Style','checkbox',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.28 .66 .6 .05],...
                                      'Value',Auf(1),...
                                      'String','Anordnung in topologischer Reihenfolge');

                hui(5202) = uicontrol('Style','checkbox',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.28 .61 .6 .05],...
                                      'Value',Auf(2),...
                                      'String','Anordnung nach aufsteigenden Deadline');

                hui(5203) = uicontrol('Style','checkbox',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.28 .56 .6 .05],...
                                      'Value',Auf(3),...
                                      'String','Anordnung nach aufsteigender Pufferzeit (statisch)');
                                  
                hui(5204) = uicontrol('Style','checkbox',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.28 .51 .6 .05],...
                                      'Value',Auf(4),...
                                      'String','Anordnung nach aufsteigender Pufferzeit (dynamisch)');

                                  
                hui(5205) = uicontrol('Style','checkbox',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.28 .41 .6 .05],...
                                      'Value',AufRest(1),...
                                      'String','Anordnung in topologischer Reihenfolge',...
                                      'Enable','off');
                                  
                hui(5206) = uicontrol('Style','checkbox',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.28 .36 .6 .05],...
                                      'Value',AufRest(2),...
                                      'String','Anordnung nach aufsteigenden spez. Fertigstellungszeitpunkten',...
                                      'Enable','off');
                                        
                hui(5207) = uicontrol('Style','checkbox',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.28 .31 .6 .05],...
                                      'Value',AufRest(3),...
                                      'String','Anordnung nach absteigenden spez. Fertigstellungszeitpunkten',...
                                      'Enable','off');
                               
                                  
                hui(5209) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.56 .61 .1 .05],...
                                      'String','OK',...
                                      'CallBack','KMT OKAufMitSPGundDL');
                                  
                hui(5210) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.71 .61 .1 .05],...
                                      'String','ändern',...
                                      'Enable','off',...
                                      'CallBack','KMT AendernAufMitSPGundDL');
                                  
                hui(5211) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.8 .1 .15 .05],...
                                      'String','lösen',...
                                      'Enable','off',...
                                      'CallBack','KMT LöseMitSPGundDL');

                hui(5212) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.05 .1 .15 .05],...
                                      'String','zurück',...
                                      'CallBack','KMT BackArtikelVerfahrenMitSPGundDL'); 

                hui(5213) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.55 .1 .15 .05],...
                                      'String','alle auswählen',...
                                      'CallBack','KMT AlleAuftragVerfahrenMitSPGundDL');

                hui(5214) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.3 .1 .15 .05],...
                                      'String','keins auswählen',...
                                      'CallBack','KMT KeineAuftragVerfahrenMitSPGundDL');
            end
            
        case 'LöseMitSPGundDL'

            AufRest = [get(hui(5205),'Value')
                       get(hui(5206),'Value')
                       get(hui(5207),'Value')];
                       
            if (DL_alle == 0 && sum(AufRest) == 0)
                    errordlg('Bitte wählen Sie mindestens ein Auftragsreihenfolgeverfahren aus, das auf Aufträge ohne Deadline angewendet werden soll.','Fehler')
            elseif (DL_alle == 1 && sum(Auf) == 0)
                    errordlg('Bitte wählen Sie mindestens ein Auftragsreihenfolgeverfahren aus.','Fehler')
            else
                
                tmp_value = get(hui(403),'Value');
                tmp_string = get(hui(403),'String');
                set(hui(100),'String',['Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion: ' tmp_string(tmp_value,:) '   >   Artikelreihenfolgeverfahren   >   Auftragsreihenfolgeverfahren   >   Lösung']);
                set(hui(103),'Callback','KMT InfoLoesungArtAuf');
                set(hui(5200:5214),'Visible','off','Enable','inactive');

                Info_waitbar = waitbar(0,'Berechnung läuft...','Name','Information',...
                                       'CreateCancelBtn',...
                                       'setappdata(gcbf,''canceling'',1)');
                children_info = get(Info_waitbar, 'children'); % Cancel Button
                set(children_info(1), 'String', 'abbrechen')   % umbennenen
                setappdata(Info_waitbar,'canceling',0)   
                waitbar(0,Info_waitbar,'Berechnung läuft...')

                % Berechnung der 'steps' für die waitbar
                AnzVerschAufVerf = sum(AufRest)*(sum(Auf)-Auf(1)) + Auf(1);
                steps = AnzVerschAufVerf*(sum(Art)+sum(ArtR)+sum(ArtD));
                step = 0;

                [m,n] = size(A);
                BZ = Bearbeitungszeit(A,HZ,KZ);
                HA = Haufigkeit(A);

                Data = cell(sum(Auf)*(sum(Art)+sum(ArtR)+sum(ArtD)+1),5);
                Platzhalter = cell(1,4);

                % Die Rechenzeit für das erste Verfahren ist langsamer als die anderen
                % Deswegen das Verfahren einmal durchlaufen lassen
                tic
                OrderAuftrag = MinSFSZ(A,HZ,KZ,BZ,[1:m]');
                OrderAuftrag = MaxSFSZ(A,HZ,KZ,BZ,[1:m]');
                switch Ziel 
                    case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte mit Stellplatzbegrenzung
                        [LoeschMich1,LoeschMich2] = FSZbS(A,HZ,KZ,SP,[1:m]',[1:n]); %#ok<*ASGLU>
                    case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt mit Stellplatzbegrenzung
                        [LoeschMich1,LoeschMich2] = FFbS(A,HZ,KZ,SP,[1:m]',[1:n]);
                    case 3 % Zielfunktion: min! sum. Durchlaufzeiten mit Stellplatzbegrenzung
                        [LoeschMich1,LoeschMich2] = DLZbS(A,HZ,KZ,SP,[1:m]',[1:n]);
                    case 4 % Zielfunktion: min! sum. Anzahl an Überschreitungen der Deadlines
                        [LoeschMich1,LoeschMich2] = AUFbS(A,HZ,KZ,SP,DL,[1:m]',[1:n]);
                    case 5 % Zielfunktion: min! sum. Überschreitungen der Deadlines    
                        [LoeschMich1,LoeschMich2] = UdFbS(A,HZ,KZ,SP,DL,[1:m]',[1:n]);
                    case 6 % Zielfunktion: min! max. Überschreitungen der Deadlines 
                        [LoeschMich1,LoeschMich2] = sUFbS(A,HZ,KZ,SP,DL,[1:m]',[1:n]);
                    case 7 % Zielfunktion: min! durchschnittliche Überschreitungen der Deadlines
                        [LoeschMich1,LoeschMich2] = dUFbS(A,HZ,KZ,SP,DL,[1:m]',[1:n]);
                    case 8 % Zielfunktion: min! sum. gewichtete Überschreitungen der Deadlines
                        [LoeschMich1,LoeschMich2] = gUFbS(A,HZ,KZ,SP,DL,[1:m]',[1:n],[1 2; 1 2; 1 0]);
                end
                clear LoeschMich*
                save_zufallszahl = [];

                Time = toc;

                x = 1;
                counter_AufR = 0;
                for i = 1:13
                    if (i == 2 || i == 3 || i == 4) % Wenn das Verfahren 'Edf' oder 'Lst' ausgewählt wurde (i == 2, 3 oder 4), wird diese Iteration...  
                        continue;                   % übersprungen , weil noch kein Verfahren zur Anordnung der Aufträge mit unendlich hoher...  
                    end                             % Deadline gewählt wurde. Dies geschieht erst bei den Iterationen i = 4-9. 
                    if ((get(hui(5201),'Value') == 1 && i == 1) || (i > 4 && get(hui(5200+i-(counter_AufR*3)),'Value') == 1 && get(hui(5202 + counter_AufR),'Value') == 1))
                        
                        if i == 1 
                            Data(x,:) = [get(hui(5201),'String') Platzhalter];
                        elseif i == 5 || i == 6 || i == 7                                                  %
                             temp = get(hui(5200+i-(counter_AufR*3)),'String');                            % Falls das Verfahren 'Edf' ausgewählt wurde (i == 5, 6 oder 7), 
                             temp(1:9)=[];                                                                 % muss die Benennung für die Ausgabe angepasst werden.
                             Data(x,:) = [['Anordnung nach aufsteigenden Deadline und' temp] Platzhalter]; % 
                             clear temp;                                                                   %
                         elseif i == 8 || i == 9 || i == 10
                             temp = get(hui(5200+i-(counter_AufR*3)),'String');                                         % Falls das Verfahren 'LstStatisch' ausgewählt wurde (i == 8, 9 oder 10), 
                             temp(1:9)=[];                                                                              % muss die Benennung für die Ausgabe angepasst werden.
                             Data(x,:) = [['Anordnung nach aufsteigenden Pufferzeit (statisch) und' temp] Platzhalter]; % 
                             clear temp;
                         elseif i == 11 || i == 12 || i == 13
                             temp = get(hui(5200+i-(counter_AufR*3)),'String');                                         % Falls das Verfahren 'LstDynamisch' ausgewählt wurde (i == 11, 12 oder 13), 
                             temp(1:9)=[];                                                                              % muss die Benennung für die Ausgabe angepasst werden.
                             Data(x,:) = [['Anordnung nach aufsteigenden Pufferzeit (dynamisch) und' temp] Platzhalter];% 
                             clear temp; 
                         end   
                        x = x+1;

                        for index = 1:length(ArtikelVerfahrenNamen)
                            if Art(index) == 1

                                BZ = Bearbeitungszeit(A,HZ,KZ);
                                HA = Haufigkeit(A);

                                step = step + 1;

                                tic % Rechenzeit beginnen

                                switch index
                                    case 1
                                        OrderArtikel = [1:m]'; %#ok<*NBRAK> unterdrückt die Fehlermeldung, dass die Klammern überflüssig sind
                                    case 2
                                        OrderArtikel = minBmaxH(HA,BZ);
                                    case 3
                                        OrderArtikel = maxBmaxH(HA,BZ);
                                    case 4
                                        OrderArtikel = minHtopo(HA,BZ);
                                    case 5
                                        OrderArtikel = maxHtopo(HA,BZ);
                                    case 6
                                        OrderArtikel = maxHminB(HA,BZ);
                                    case 7
                                        OrderArtikel = maxHmaxB(HA,BZ);
                                    case 8
                                        OrderArtikel = zenReihAufst(HA);
                                    case 9
                                        OrderArtikel = zenReihAbst(HA);
                                    case 10
                                        OrderArtikel = minAtopo(A);
                                    case 11
                                        OrderArtikel = minAminB(A,BZ);
                                    case 12
                                        OrderArtikel = minAmaxB(A,BZ);
                                    case 13
                                        OrderArtikel = minAminH(A,HA);
                                    case 14
                                        OrderArtikel = minAmaxH(A,HA);
                                    case 15
                                        OrderArtikel = maxAtopo(A);
                                    case 16
                                        OrderArtikel = maxAminB(A,BZ);
                                    case 17
                                        OrderArtikel = maxAmaxB(A,BZ);
                                    case 18
                                        OrderArtikel = maxAminH(A,HA);
                                    case 19
                                        OrderArtikel = maxAmaxH(A,HA);
                                end

                                switch i 
                                    case 1
                                        OrderAuftrag = [1:n];

                                    case 5
                                         OrderAuftrag = Edf(A,HZ,KZ,BZ,DL,OrderArtikel,'Topo');
                                    case 6
                                         OrderAuftrag = Edf(A,HZ,KZ,BZ,DL,OrderArtikel,'MinSFSZ');
                                    case 7
                                         OrderAuftrag = Edf(A,HZ,KZ,BZ,DL,OrderArtikel,'MaxSFSZ');
                                    case 8
                                         OrderAuftrag = LstStatisch(A,HZ,KZ,BZ,DL,OrderArtikel,'Topo');
                                    case 9
                                         OrderAuftrag = LstStatisch(A,HZ,KZ,BZ,DL,OrderArtikel,'MinSFSZ');
                                    case 10
                                         OrderAuftrag = LstStatisch(A,HZ,KZ,BZ,DL,OrderArtikel,'MaxSFSZ');
                                    case 11
                                         OrderAuftrag = LstDynamisch(A,HZ,KZ,BZ,DL,SP,OrderArtikel,'Topo','H');
                                    case 12
                                         OrderAuftrag = LstDynamisch(A,HZ,KZ,BZ,DL,SP,OrderArtikel,'MinSFSZ','H');
                                    case 13
                                         OrderAuftrag = LstDynamisch(A,HZ,KZ,BZ,DL,SP,OrderArtikel,'MaxSFSZ','H');
                                end

                                switch Ziel 
                                    case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte mit Stellplatzbegrenzung
                                        [Zielfunktionswert,GesamtHolArtOrder] = FSZbS(A,HZ,KZ,SP,OrderArtikel,OrderAuftrag);

                                    case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt mit Stellplatzbegrenzung
                                        [Zielfunktionswert,GesamtHolArtOrder] = FFbS(A,HZ,KZ,SP,OrderArtikel,OrderAuftrag);

                                    case 3 % Zielfunktion: min! sum. Durchlaufzeiten mit Stellplatzbegrenzung
                                        [Zielfunktionswert,GesamtHolArtOrder] = DLZbS(A,HZ,KZ,SP,OrderArtikel,OrderAuftrag);
                                        
                                    case 4 % Zielfunktion: min! sum. Anzahl an Überschreitungen der Deadlines    
                                        [Zielfunktionswert,GesamtHolArtOrder] = AUFbS(A,HZ,KZ,SP,DL,OrderArtikel,OrderAuftrag);
                                   
                                    case 5 % Zielfunktion: min! sum. Überschreitungen der Deadlines    
                                        [Zielfunktionswert,GesamtHolArtOrder] = UdFbS(A,HZ,KZ,SP,DL,OrderArtikel,OrderAuftrag);
                                    
                                    case 6 % Zielfunktion: min! max. Überschreitungen der Deadlines 
                                        [Zielfunktionswert,GesamtHolArtOrder] = sUFbS(A,HZ,KZ,SP,DL,OrderArtikel,OrderAuftrag);
                                        
                                    case 7 % Zielfunktion: min! durchschnittliche Überschreitungen der Deadlines
                                        [Zielfunktionswert,GesamtHolArtOrder] = dUFbS(A,HZ,KZ,SP,DL,OrderArtikel,OrderAuftrag);
                                    
                                    case 8 % Zielfunktion: min! sum. gewichtete Überschreitungen der Deadlines
                                        [Zielfunktionswert,GesamtHolArtOrder] = gUFbS(A,HZ,KZ,SP,DL,OrderArtikel,OrderAuftrag,Gewichtung);
                                end

                                Rechenzeit = toc; % Rechenzeit stoppen

                                Data(x,:) = {['---' ArtikelVerfahrenNamen{index} ' (Hierarchisch)'],Zielfunktionswert,Rechenzeit,int2str(GesamtHolArtOrder),int2str(OrderAuftrag)};

                                if getappdata(Info_waitbar,'canceling')
                                    delete(Info_waitbar)
                                    tmp_new = 1;
                                    KMT AuftragVerfahrenMitSPGundDL                        
                                end
                                % Report current estimate in the waitbar's message field
                                waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                                x = x+1;
                            end

                            if ArtR(index) == 1

                                BZ = Bearbeitungszeit(A,HZ,KZ);
                                HA = Haufigkeit(A);

                                step = step + 1;

                                tic % Rechenzeit beginnen

                                switch index
                                    case 1
                                        OrderArtikel = [1:m]'; %#ok<*NBRAK> unterdrückt die Fehlermeldung, dass die Klammern überflüssig sind
                                    case 2
                                        OrderArtikel = minBmaxH(HA,BZ);
                                    case 3
                                        OrderArtikel = maxBmaxH(HA,BZ);
                                    case 4
                                        OrderArtikel = minHtopo(HA,BZ);
                                    case 5
                                        OrderArtikel = maxHtopo(HA,BZ);
                                    case 6
                                        OrderArtikel = maxHminB(HA,BZ);
                                    case 7
                                        OrderArtikel = maxHmaxB(HA,BZ);
                                    case 8
                                        OrderArtikel = zenReihAufst(HA);
                                    case 9
                                        OrderArtikel = zenReihAbst(HA);
                                    case 10
                                        OrderArtikel = minAtopo(A);
                                    case 11
                                        OrderArtikel = minAminB(A,BZ);
                                    case 12
                                        OrderArtikel = minAmaxB(A,BZ);
                                    case 13
                                        OrderArtikel = minAminH(A,HA);
                                    case 14
                                        OrderArtikel = minAmaxH(A,HA);
                                    case 15
                                        OrderArtikel = maxAtopo(A);
                                    case 16
                                        OrderArtikel = maxAminB(A,BZ);
                                    case 17
                                        OrderArtikel = maxAmaxB(A,BZ);
                                    case 18
                                        OrderArtikel = maxAminH(A,HA);
                                    case 19
                                        OrderArtikel = maxAmaxH(A,HA);
                                end

                                switch i 
                                    case 1
                                        OrderAuftrag = [1:n];

                                    case 5
                                         OrderAuftrag = Edf(A,HZ,KZ,BZ,DL,OrderArtikel,'Topo');
                                    case 6
                                         OrderAuftrag = Edf(A,HZ,KZ,BZ,DL,OrderArtikel,'MinSFSZ');
                                    case 7
                                         OrderAuftrag = Edf(A,HZ,KZ,BZ,DL,OrderArtikel,'MaxSFSZ');
                                    case 8
                                         OrderAuftrag = LstStatisch(A,HZ,KZ,BZ,DL,OrderArtikel,'Topo');
                                    case 9
                                         OrderAuftrag = LstStatisch(A,HZ,KZ,BZ,DL,OrderArtikel,'MinSFSZ');
                                    case 10
                                         OrderAuftrag = LstStatisch(A,HZ,KZ,BZ,DL,OrderArtikel,'MaxSFSZ');
                                    case 11
                                         OrderAuftrag = LstDynamisch(A,HZ,KZ,BZ,DL,SP,OrderArtikel,'Topo','R');
                                    case 12
                                         OrderAuftrag = LstDynamisch(A,HZ,KZ,BZ,DL,SP,OrderArtikel,'MinSFSZ','R');
                                    case 13
                                         OrderAuftrag = LstDynamisch(A,HZ,KZ,BZ,DL,SP,OrderArtikel,'MaxSFSZ','R');
                                end
                                
                                switch Ziel 
                                    case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte mit Stellplatzbegrenzung
                                        [Zielfunktionswert,GesamtHolArtOrder] = FSZbSR(A,HZ,KZ,SP,OrderArtikel,OrderAuftrag);

                                    case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt mit Stellplatzbegrenzung
                                        [Zielfunktionswert,GesamtHolArtOrder] = FFbSR(A,HZ,KZ,SP,OrderArtikel,OrderAuftrag);

                                    case 3 % Zielfunktion: min! sum. Durchlaufzeiten mit Stellplatzbegrenzung
                                        [Zielfunktionswert,GesamtHolArtOrder] = DLZbSR(A,HZ,KZ,SP,OrderArtikel,OrderAuftrag);
                                        
                                    case 4 % Zielfunktion: min! sum. Anzahl an Überschreitungen der Deadlines
                                        [Zielfunktionswert,GesamtHolArtOrder] = AUFbSR(A,HZ,KZ,SP,DL,OrderArtikel,OrderAuftrag);
                                
                                    case 5 % Zielfunktion: min! sum. Überschreitungen der Deadlines    
                                        [Zielfunktionswert,GesamtHolArtOrder] = UdFbSR(A,HZ,KZ,SP,DL,OrderArtikel,OrderAuftrag);
                                    
                                    case 6 % Zielfunktion: min! max. Überschreitungen der Deadlines 
                                        [Zielfunktionswert,GesamtHolArtOrder] = sUFbSR(A,HZ,KZ,SP,DL,OrderArtikel,OrderAuftrag);
                                        
                                    case 7 % Zielfunktion: min! durchschnittliche Überschreitungen der Deadlines
                                        [Zielfunktionswert,GesamtHolArtOrder] = dUFbSR(A,HZ,KZ,SP,DL,OrderArtikel,OrderAuftrag);
                               
                                    case 8 % Zielfunktion: min! sum. gewichtete Überschreitungen der Deadlines
                                        [Zielfunktionswert,GesamtHolArtOrder] = gUFbSR(A,HZ,KZ,SP,DL,OrderArtikel,OrderAuftrag,Gewichtung);
                                end

                                Rechenzeit = toc; % Rechenzeit stoppen

                                Data(x,:) = {['---' ArtikelVerfahrenNamen{index} ' (Rollierend)'],Zielfunktionswert,Rechenzeit,int2str(GesamtHolArtOrder),int2str(OrderAuftrag)};

                                if getappdata(Info_waitbar,'canceling')
                                    delete(Info_waitbar)
                                    tmp_new = 1;
                                    KMT AuftragVerfahrenMitSPGundDL                        
                                end
                                % Report current estimate in the waitbar's message field
                                waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                                x = x+1;
                            end

                            % Überprüfe, ob Zufallszahlen schon generiert
                            % wurden

                            q = 1;

                            % Überprüfe, ob schon Zufallszahlen erstellt
                            % worden sind
                            if isempty(save_zufallszahl)
                               save_zufallszahl = [];

                               % Bestimme neue Zufallszahlen
                               create_zufall = true;
                            else

                               % Bestimme keine neuen Zufallszahlen
                               create_zufall = false;
                            end

                            if ArtD(index) == 1

                                step = step + 1;

                                tic % Rechenzeit beginnen

                                [m,n] = size(A);

                                GesamtHolArtOrder = []; % Vektor, welche Artikel geholt werden sollen

                                % Überprüfe, ob die online oder offline
                                % Methode angewendet wird
                                if strcmp(str_auftrag,'online')
                                    % Überprüfung, ob eine neue Zufallszahl
                                    % bestimmt werden soll oder die
                                    % nächsten genommen werden sollen
                                    if create_zufall
                                        zufallszahl =  randi([SP n],1,1); % Bestimme eine Zufallszahl
                                        save_zufallszahl = [save_zufallszahl zufallszahl];
                                    else
                                        zufallszahl = save_zufallszahl(q); % Nehme die nächste Zufallszahl
                                        q = q + 1;
                                    end
                                    tmp_A = A(:,[1:zufallszahl]); % Bestimme die Matrix
                                    C = zeros(1,zufallszahl); % Zielfunktionswert von jedem einzelnen Auftrag
                                    Auftrag_fertig = []; % Hilfsvektor, ob ein Auftrag abgearbeitet wurde
                                    Auftrag_fertig(1,zufallszahl) = false; 
                                elseif strcmp(str_auftrag,'offline')
                                    tmp_A = A; % temporäre Matrix 
                                    C = zeros(1,n); % Zielfunktionswert von jedem einzelnen Auftrag
                                    Auftrag_fertig = []; % Hilfsvektor, ob ein Auftrag abgearbeitet wurde
                                    Auftrag_fertig(1,n) = false;
                                end

                                bestimme_auftrag = false; % Hilfsvariable, um Auftrag zu bestimmen

                                bestimmte_ersten_auftrag = true; % Hilfsvariable, um den allerersten Auftrag zu bestimmen

                                while ~isequal(tmp_A,zeros(m,n)) || size(A,2) ~= size(tmp_A,2)% Überprüfung ob tmp_A = 0 Matrix

                                    if ~bestimme_auftrag % Das erste Mal wird eine Auftragsreihenfolge zu der ganzen Matrix bestimmt

                                        BZ = Bearbeitungszeit(tmp_A,HZ,KZ);
                                        HA = Haufigkeit(tmp_A);

                                        switch index
                                            case 1
                                                OrderArtikel = [1:m]'; %#ok<*NBRAK> unterdrückt die Fehlermeldung, dass die Klammern überflüssig sind
                                            case 2
                                                OrderArtikel = minBmaxH(HA,BZ);
                                            case 3
                                                OrderArtikel = maxBmaxH(HA,BZ);
                                            case 4
                                                OrderArtikel = minHtopo(HA,BZ);
                                            case 5
                                                OrderArtikel = maxHtopo(HA,BZ);
                                            case 6
                                                OrderArtikel = maxHminB(HA,BZ);
                                            case 7
                                                OrderArtikel = maxHmaxB(HA,BZ);
                                            case 8
                                                OrderArtikel = zenReihAufst(HA);
                                            case 9
                                                OrderArtikel = zenReihAbst(HA);
                                            case 10
                                                OrderArtikel = minAtopo(tmp_A);
                                            case 11
                                                OrderArtikel = minAminB(tmp_A,BZ);
                                            case 12
                                                OrderArtikel = minAmaxB(tmp_A,BZ);
                                            case 13
                                                OrderArtikel = minAminH(tmp_A,HA);
                                            case 14
                                                OrderArtikel = minAmaxH(tmp_A,HA);
                                            case 15
                                                OrderArtikel = maxAtopo(tmp_A);
                                            case 16
                                                OrderArtikel = maxAminB(tmp_A,BZ);
                                            case 17
                                                OrderArtikel = maxAmaxB(tmp_A,BZ);
                                            case 18
                                                OrderArtikel = maxAminH(tmp_A,HA);
                                            case 19
                                                OrderArtikel = maxAmaxH(tmp_A,HA);
                                        end

                                        %  Auswahl der Auftragsreihenfolgefunktionen
                                        switch i 
                                            case 1
                                                OrderAuftrag = [1:n];
                                                
                                            case 5
                                                 OrderAuftrag = Edf(A,HZ,KZ,BZ,DL,OrderArtikel,'Topo');
                                            case 6
                                                 OrderAuftrag = Edf(A,HZ,KZ,BZ,DL,OrderArtikel,'MinSFSZ');
                                            case 7
                                                 OrderAuftrag = Edf(A,HZ,KZ,BZ,DL,OrderArtikel,'MaxSFSZ');
                                            case 8
                                                 OrderAuftrag = LstStatisch(A,HZ,KZ,BZ,DL,OrderArtikel,'Topo');
                                            case 9
                                                 OrderAuftrag = LstStatisch(A,HZ,KZ,BZ,DL,OrderArtikel,'MinSFSZ');
                                            case 10
                                                 OrderAuftrag = LstStatisch(A,HZ,KZ,BZ,DL,OrderArtikel,'MaxSFSZ');
                                            case 11
                                                 OrderAuftrag = LstDynamisch(A,HZ,KZ,BZ,DL,SP,OrderArtikel,'Topo','D',index);
                                            case 12
                                                 OrderAuftrag = LstDynamisch(A,HZ,KZ,BZ,DL,SP,OrderArtikel,'MinSFSZ','D',index);
                                            case 13
                                                 OrderAuftrag = LstDynamisch(A,HZ,KZ,BZ,DL,SP,OrderArtikel,'MaxSFSZ','D',index);
                                        end

                                        if bestimmte_ersten_auftrag
                                           AufKB = OrderAuftrag(1:SP); % Aufträge (laut Auftragsreihenfolge) im Kommissionierbereich
                                           bestimmte_ersten_auftrag = false; % Setze Variable auf false, da ein Auftrag bestimmt wurde
                                        end

                                        bestimme_auftrag = true; % Auftragsreihenfolge wurde bestimmt

                                    end

                                    % Überprüfe, ob die online-Methode
                                    % ausgewäht wurde
                                    if strcmp(str_auftrag,'online')

                                        % Gehe den Vektor AufKB durch
                                        for k = 1 : size(AufKB,2)

                                           % Überprüfe, ob der Auftrag in
                                           % AufKB schon erledigt wurde
                                           if Auftrag_fertig(1,AufKB(1,k))

                                              % Bestimme einen neuen
                                              % Auftrag für den Platz, der
                                              % schon erledigt wurde
                                              for j = 1 : size(OrderAuftrag,2)
                                                  if isempty(find(OrderAuftrag(1,j) == AufKB(1,:),1)) && ~Auftrag_fertig(1,OrderAuftrag(1,j))

                                                     % Setze den neuen
                                                     % Auftrag
                                                     AufKB(1,k) = OrderAuftrag(1,j);
                                                     break;
                                                  end                                       
                                              end
                                           end
                                        end
                                    end

                                    BZ = Bearbeitungszeit(tmp_A(:,AufKB(1:SP)),HZ,KZ); % Neue Bearbeitungszeit/Häufigkeit berechnen (auf Stellplatz beschränkte Matrix!!)
                                    HA = Haufigkeit(tmp_A(:,AufKB(1:SP)));

                                    if ~isequal(Auftrag_fertig,ones(1,size(tmp_A,2)))
                                        switch index
                                            case 1
                                                OrderArtikel = [1:m]'; %#ok<*NBRAK> unterdrückt die Fehlermeldung, dass die Klammern überflüssig sind
                                            case 2
                                                OrderArtikel = minBmaxH(HA,BZ);
                                            case 3
                                                OrderArtikel = maxBmaxH(HA,BZ);
                                            case 4
                                                OrderArtikel = minHtopo(HA,BZ);
                                            case 5
                                                OrderArtikel = maxHtopo(HA,BZ);
                                            case 6
                                                OrderArtikel = maxHminB(HA,BZ);
                                            case 7
                                                OrderArtikel = maxHmaxB(HA,BZ);
                                            case 8
                                                OrderArtikel = zenReihAufst(HA);
                                            case 9
                                                OrderArtikel = zenReihAbst(HA);
                                            case 10
                                                OrderArtikel = minAtopo(tmp_A(:,AufKB(1:SP)));
                                            case 11
                                                OrderArtikel = minAminB(tmp_A(:,AufKB(1:SP)),BZ);
                                            case 12
                                                OrderArtikel = minAmaxB(tmp_A(:,AufKB(1:SP)),BZ);
                                            case 13
                                                OrderArtikel = minAminH(tmp_A(:,AufKB(1:SP)),HA);
                                            case 14
                                                OrderArtikel = minAmaxH(tmp_A(:,AufKB(1:SP)),HA);
                                            case 15
                                                OrderArtikel = maxAtopo(tmp_A(:,AufKB(1:SP)));
                                            case 16
                                                OrderArtikel = maxAminB(tmp_A(:,AufKB(1:SP)),BZ);
                                            case 17
                                                OrderArtikel = maxAmaxB(tmp_A(:,AufKB(1:SP)),BZ);
                                            case 18
                                                OrderArtikel = maxAminH(tmp_A(:,AufKB(1:SP)),HA);
                                            case 19
                                                OrderArtikel = maxAmaxH(tmp_A(:,AufKB(1:SP)),HA);
                                        end
                                    end

                                    switch Ziel 
                                        case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte mit Stellplatzbegrenzung
                                            [GesamtHolArtOrder,AufKB,tmp_A,C,Auftrag_fertig] = FSZbSD(tmp_A,HZ,KZ,SP,OrderArtikel,OrderAuftrag,AufKB,GesamtHolArtOrder,C,Auftrag_fertig,Artikel_neu_berechnen);

                                        case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt mit Stellplatzbegrenzung
                                            [GesamtHolArtOrder,AufKB,tmp_A,C,Auftrag_fertig] = FFbSD(tmp_A,HZ,KZ,SP,OrderArtikel,OrderAuftrag,AufKB,GesamtHolArtOrder,C,Auftrag_fertig,Artikel_neu_berechnen);

                                        case 3 % Zielfunktion: min! sum. Durchlaufzeiten mit Stellplatzbegrenzung
                                            [GesamtHolArtOrder,AufKB,tmp_A,C,Auftrag_fertig] = DLZbSD(tmp_A,HZ,KZ,SP,OrderArtikel,OrderAuftrag,AufKB,GesamtHolArtOrder,C,Auftrag_fertig,Artikel_neu_berechnen);
                                   
                                        case 4 % Zielfunktion: min! sum. Anzahl an Überschreitungen der Deadlines
                                            [GesamtHolArtOrder,AufKB,tmp_A,C,Auftrag_fertig] = FSZbSD(tmp_A,HZ,KZ,SP,OrderArtikel,OrderAuftrag,AufKB,GesamtHolArtOrder,C,Auftrag_fertig,Artikel_neu_berechnen);  
                                    
                                        case 5 % Zielfunktion: min! sum. Überschreitungen der Deadlines
                                            [GesamtHolArtOrder,AufKB,tmp_A,C,Auftrag_fertig] = FSZbSD(tmp_A,HZ,KZ,SP,OrderArtikel,OrderAuftrag,AufKB,GesamtHolArtOrder,C,Auftrag_fertig,Artikel_neu_berechnen); 
                                        
                                        case 6 % Zielfunktion: min! max. Überschreitung der Deadlines
                                            [GesamtHolArtOrder,AufKB,tmp_A,C,Auftrag_fertig] = FSZbSD(tmp_A,HZ,KZ,SP,OrderArtikel,OrderAuftrag,AufKB,GesamtHolArtOrder,C,Auftrag_fertig,Artikel_neu_berechnen);  
                                    
                                        case 7 % Zielfunktion: min! durchschnittliche Überschreitung der Deadlines
                                            [GesamtHolArtOrder,AufKB,tmp_A,C,Auftrag_fertig] = FSZbSD(tmp_A,HZ,KZ,SP,OrderArtikel,OrderAuftrag,AufKB,GesamtHolArtOrder,C,Auftrag_fertig,Artikel_neu_berechnen); 
                                    
                                        case 8 % Zielfunktion: min! sum. gewichtete Überschreitung der Deadlines
                                            [GesamtHolArtOrder,AufKB,tmp_A,C,Auftrag_fertig] = FSZbSD(tmp_A,HZ,KZ,SP,OrderArtikel,OrderAuftrag,AufKB,GesamtHolArtOrder,C,Auftrag_fertig,Artikel_neu_berechnen); 
                                    
                                    end

                                    % Überprüfe, ob die online-Methode
                                    % ausgewählt wurde
                                    if strcmp(str_auftrag,'online')

                                        % Überprüfe, ob die Dimensionen von
                                        % tmp_A und A unterschiedlich sind
                                        if size(tmp_A,2) ~= size(A,2)

                                           % Überprüfe, ob schon
                                           % Zufallszahlen bestimmt worden
                                           % sind oder neue erstellt werden
                                           % müssen
                                           if create_zufall


                                               % Bestimme eine neue
                                               % Zufallszahl und speichere
                                               % diese ab
                                               zufallszahl = randi([0 n],1,1);
                                               save_zufallszahl = [save_zufallszahl zufallszahl];
                                           else

                                               % Gehe die gespeicherten
                                               % Zufallszahlen durch
                                               zufallszahl = save_zufallszahl(q);
                                               q = q + 1;
                                           end

                                           % Überprüfe, ob die Zufallszahl
                                           % das Intervall überschreitet
                                           if zufallszahl + size(tmp_A,2) > size(A,2)
                                              zufallszahl = size(A,2) - size(tmp_A,2);
                                           end

                                           % Überprüfe, ob die Zufallszahl
                                           % nicht gleich 0 ist
                                           if zufallszahl ~= 0

                                               % Ergänze die tmp_A Matrix
                                               tmp_A(:,[size(tmp_A,2)+1:size(tmp_A,2)+zufallszahl]) = A(:,[size(tmp_A,2)+1:size(tmp_A,2)+zufallszahl]);

                                               % Ergänze den C Vektor
                                               C = [C zeros(1,zufallszahl)];

                                               % Ergänze den
                                               % Auftrags-Vektor
                                               tmp_Auftrag_fertig = [];
                                               tmp_Auftrag_fertig(1,zufallszahl) = false;
                                               Auftrag_fertig = [Auftrag_fertig tmp_Auftrag_fertig];

                                               % Setze die Variable wieder
                                               % auf true, da ein neuer
                                               % Auftrag gefunden werden
                                               % muss
                                               bestimme_auftrag = false;
                                           end
                                        end
                                    end
                                end

                                switch Ziel 
                                    case 1
                                        Zielfunktionswert = sum(C); % Aufsummierte Zielfunktionswerte anzeigen
                                    case 2
                                        Zielfunktionswert = max(C); % Maximalen Zielfunktionswert anzeigen
                                    case 3
                                        Zielfunktionswert = sum(C); % Aufsummierte Zielfunktionswerte anzeigen
                                    case 4
                                        Zielfunktionswert = 0;
                                        for j = 1:n
                                            if C(j) - DL(j) > 0
                                            Zielfunktionswert = Zielfunktionswert + 1;                                       
                                            end
                                        end
                                        clear DLtemp;
                                        
                                    case 5
                                        Zielfunktionswert = 0;
                                        for j = 1:n
                                            if C(j) - DL(j) > 0
                                                Zielfunktionswert = Zielfunktionswert + C(j) - DL(j);                                       
                                            end
                                        end
                                        clear DLtemp;
                                        
                                    case 6
                                        Zielfunktionswert = 0;
                                        for j = 1:n
                                            if C(j) - DL(j) > Zielfunktionswert
                                                Zielfunktionswert = C(j) - DL(j);                                       
                                            end
                                        end
                                        clear DLtemp;
                                        
                                    case 7
                                        Zielfunktionswert = 0;
                                        for j = 1:n
                                            if C(j) - DL(j) > 0
                                                Zielfunktionswert = Zielfunktionswert + C(j) - DL(j);
                                            end
                                        end
                                        Zielfunktionswert = Zielfunktionswert / n;
                                        clear q;
                                        
                                    case 8
                                        Zielfunktionswert = 0;
                                        for j = 1:n
                                            q = C(j) - DL(j); % q = Höhe der Überschreitung der Deadline des aktuellen Auftrags
                                            if q > 0
                                                for k = 1:size(Gewichtung,2) % gehe die eingegebenen Grenzen durch
                                                    if q <= Gewichtung(2,k) % ist die Gewichtung kleiner gleich der aktuellen Grenze...
                                                        Zielfunktionswert = Zielfunktionswert + Gewichtung(1,k) * q; % ...berechne die gewichtete Überschreitung der Deadline mithilfe des eingegebenen Gewichts
                                                        break;
                                                    end
                                                    if k == size(Gewichtung,2) % falls alle eingegebenen Grenzen überschritten wurden...
                                                        Zielfunktionswert = Zielfunktionswert + Gewichtung(3,1) * q; % berechne die gewichtete Überschreitung der Deadline mithilfe des eingegebenen Gewichts bei Überschreitung aller Grenzen
                                                    end
                                                end
                                            end
                                        end
                                end

                                Rechenzeit = toc; % Rechenzeit stoppen

                                if Ziel == 1
                                   Data(x,:) = {['---' ArtikelVerfahrenNamen{index} ' (Dynamisch)'],Zielfunktionswert,Rechenzeit,int2str(GesamtHolArtOrder),int2str(OrderAuftrag)};
                                end

                                if Ziel == 2
                                   Data(x,:) = {['---' ArtikelVerfahrenNamen{index} ' (Dynamisch)'],Zielfunktionswert,Rechenzeit,int2str(GesamtHolArtOrder),int2str(OrderAuftrag)}; 
                                end

                                if Ziel == 3
                                   Data(x,:) = {['---' ArtikelVerfahrenNamen{index} ' (Dynamisch)'],Zielfunktionswert,Rechenzeit,int2str(GesamtHolArtOrder),int2str(OrderAuftrag)}; 
                                end

                                if Ziel == 4
                                   Data(x,:) = {['---' ArtikelVerfahrenNamen{index} ' (Dynamisch)'],Zielfunktionswert,Rechenzeit,int2str(GesamtHolArtOrder),int2str(OrderAuftrag)}; 
                                end
                                
                                if Ziel == 5
                                   Data(x,:) = {['---' ArtikelVerfahrenNamen{index} ' (Dynamisch)'],Zielfunktionswert,Rechenzeit,int2str(GesamtHolArtOrder),int2str(OrderAuftrag)}; 
                                end
                                
                                if Ziel == 6
                                   Data(x,:) = {['---' ArtikelVerfahrenNamen{index} ' (Dynamisch)'],Zielfunktionswert,Rechenzeit,int2str(GesamtHolArtOrder),int2str(OrderAuftrag)}; 
                                end
                                
                                if Ziel == 7
                                   Data(x,:) = {['---' ArtikelVerfahrenNamen{index} ' (Dynamisch)'],Zielfunktionswert,Rechenzeit,int2str(GesamtHolArtOrder),int2str(OrderAuftrag)}; 
                                end
                                
                                if Ziel == 8
                                   Data(x,:) = {['---' ArtikelVerfahrenNamen{index} ' (Dynamisch)'],Zielfunktionswert,Rechenzeit,int2str(GesamtHolArtOrder),int2str(OrderAuftrag)}; 
                                end
                                
                                if getappdata(Info_waitbar,'canceling')
                                    delete(Info_waitbar)
                                    tmp_new = 1;
                                    KMT AuftragVerfahrenMitSPGundDL                        
                                end
                                % Report current estimate in the waitbar's message field
                                waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                                x = x+1;
                            end   
                        end 
                        
                    end
                    if mod(i,3) == 1 && i > 4
                        counter_AufR = counter_AufR + 1;
                    end 
                end
            end
            % Die Güte der Zielfunktionswerte mit in Data aufnehmen
            AlleZielfunktionswerte = cell2mat(Data(:,2));
            % Die Güte berechnen
            Abweichung_rel = RelativeAbweichung(AlleZielfunktionswerte);
            % Die Nullen müssen jetzt wieder aufgenommen werden
            
            if (Auf(2) == 0 && Auf(3) == 0 && Auf(4) == 0) % wenn die Verfahren 'Edf' oder 'Lst' nicht ausgewählt wurden:   % || ((Auf(2) == 1 || Auf(3) == 1 || Auf(4) == 1) && isempty(isinf(DL))) % wenn die Verfahren 'Edf' oder 'Lst' nicht ausgewählt wurden, oder wenn eines der drei augewählt wurde und alle Aufträge eine Deadline haben:
                
                switch sum(Auf)
                    case 1
                        Abweichung_rel = Ar2D(1,Abweichung_rel,sum(Art),sum(ArtR),sum(ArtD)); % wichtig bei 'Ar2D' ist der erste übergebene Parameter. Die '1' bedeutet, dass eine Leerzeile in dem Vektro der Zielfunktionswerte benötigt wird. '2' bedeutet, dass zwei benötigt werden etc.
                    case 2
                        Abweichung_rel = Ar2D(2,Abweichung_rel,sum(Art),sum(ArtR),sum(ArtD));
                    case 3
                        Abweichung_rel = Ar2D(3,Abweichung_rel,sum(Art),sum(ArtR),sum(ArtD));
                    case 4
                        Abweichung_rel = Ar2D(4,Abweichung_rel,sum(Art),sum(ArtR),sum(ArtD));
                end
                   
            elseif (sum(Auf) - Auf(1) == 1) % wenn EINES der Verfahren 'Edf', 'LstStatisch' oder 'LstDynamisch' ausgewählt wurde (nicht aber mehrere zusammen)

                if Auf(1) == 1 % wenn das Verfahren 'Topo' ausgewählt wurde:
                    switch sum(AufRest) 
                        case 1
                            Abweichung_rel = Ar2D(2,Abweichung_rel,sum(Art),sum(ArtR),sum(ArtD));
                        case 2
                            Abweichung_rel = Ar2D(3,Abweichung_rel,sum(Art),sum(ArtR),sum(ArtD));
                        case 3
                            Abweichung_rel = Ar2D(4,Abweichung_rel,sum(Art),sum(ArtR),sum(ArtD));
                    end
                else % wenn das Verfahren 'Topo' nicht ausgewählt wurde:
                    switch sum(AufRest)
                        case 1
                            Abweichung_rel = Ar2D(1,Abweichung_rel,sum(Art),sum(ArtR),sum(ArtD));
                        case 2
                            Abweichung_rel = Ar2D(2,Abweichung_rel,sum(Art),sum(ArtR),sum(ArtD));
                        case 3
                            Abweichung_rel = Ar2D(3,Abweichung_rel,sum(Art),sum(ArtR),sum(ArtD));
                    end
                end
                
            elseif (sum(Auf) - Auf(1) == 2) % wenn ZWEI der drei Verfahren 'Edf', 'LstStatisch' und 'LstDynamisch' ausgewählt wurden:
              
                if Auf(1) == 1  % wenn das Verfahren 'Topo' ausgewählt wurde:
                    switch sum(AufRest)
                        case 1
                            Abweichung_rel = Ar2D(3,Abweichung_rel,sum(Art),sum(ArtR),sum(ArtD));
                        case 2
                            Abweichung_rel = Ar2D(5,Abweichung_rel,sum(Art),sum(ArtR),sum(ArtD));
                        case 3
                            Abweichung_rel = Ar2D(7,Abweichung_rel,sum(Art),sum(ArtR),sum(ArtD));
                    end
                else % wenn das Verfahren 'Topo' nicht ausgewählt wurde:
                    switch sum(AufRest)
                        case 1
                            Abweichung_rel = Ar2D(2,Abweichung_rel,sum(Art),sum(ArtR),sum(ArtD));
                        case 2
                            Abweichung_rel = Ar2D(4,Abweichung_rel,sum(Art),sum(ArtR),sum(ArtD));
                        case 3
                            Abweichung_rel = Ar2D(6,Abweichung_rel,sum(Art),sum(ArtR),sum(ArtD));
                    end
                end
                
            elseif (sum(Auf) - Auf(1) == 3) % wenn alle DREI Verfahren 'Edf', 'LstStatisch' und 'LstDynamisch' ausgewählt wurden:    
                
                if Auf(1) == 1 % wenn das Verfahren 'Topo' ausgewählt wurde:
                    switch sum(AufRest)
                        case 1
                            Abweichung_rel = Ar2D(4,Abweichung_rel,sum(Art),sum(ArtR),sum(ArtD));
                        case 2
                            Abweichung_rel = Ar2D(7,Abweichung_rel,sum(Art),sum(ArtR),sum(ArtD));
                        case 3
                            Abweichung_rel = Ar2D(10,Abweichung_rel,sum(Art),sum(ArtR),sum(ArtD));
                    end
                else % wenn das Verfahren 'Topo' nicht ausgewählt wurde:
                    switch sum(AufRest)
                        case 1
                            Abweichung_rel = Ar2D(3,Abweichung_rel,sum(Art),sum(ArtR),sum(ArtD));
                        case 2
                            Abweichung_rel = Ar2D(6,Abweichung_rel,sum(Art),sum(ArtR),sum(ArtD));
                        case 3
                            Abweichung_rel = Ar2D(9,Abweichung_rel,sum(Art),sum(ArtR),sum(ArtD));
                    end
                end
            
            end
            Data = [Data(:,1:2) Abweichung_rel Data(:,3:end)];

            delete(Info_waitbar)

            Titel = {'Verfahren','Zielfunktionswert','Abweichung (%)','Rechenzeit (s)','Artikelreihenfolge','Auftragsreihenfolge'};
            Ausgabe = Data; 

            Backgroundcolor_Matrix = [];
            for k = 1 : size(Data,1)
                Data{k,2} = num2str(Data{k,2},'%0.2f');
                Data{k,3} = num2str(Data{k,3},'%0.4f');
                Data{k,4} = num2str(Data{k,4},'%0.4f');
                if ~isempty(strfind(Data{k,1},'Hierarchisch'))
                   Backgroundcolor_Matrix = [Backgroundcolor_Matrix; 1 0.925490196078431 0.545098039215686];
                elseif ~isempty(strfind(Data{k,1},'Rollierend'))
                   Backgroundcolor_Matrix = [Backgroundcolor_Matrix; 0.529411764705882 0.807843137254902 0.980392156862745];
                elseif ~isempty(strfind(Data{k,1},'Dynamisch'))
                   Backgroundcolor_Matrix = [Backgroundcolor_Matrix; 0.596078431372549 0.984313725490196 0.596078431372549];
                else
                   Backgroundcolor_Matrix = [Backgroundcolor_Matrix; 1 1 1];
                end
            end

            hui(5300) = uitable('Data',Data,...
                                'Units','normalized',...
                                'Backgroundcolor',Backgroundcolor_Matrix,...
                                'FontSize',Schriftgroesse1,...
                                'FontUnits','normalized',...
                                'ColumnFormat',{'char','char','char','char','char','char'},...
                                'ColumnName',Titel,...
                                'ColumnWidth',{750 'auto' 100 120 400 400},...
                                'ColumnEditable',[false false false false false false ],...
                                'RowName',[],...
                                'Position',[0 0.25 1 0.6]);


            hui(5301) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.025 .1 .15 .05],...
                                  'String','zurück',...
                                  'CallBack','KMT BackAuftragVerfahrenMitSPGundDL');

            hui(5302) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.225 .1 .15 .05],...
                                  'String','neustart',...
                                  'CallBack','KMT');

            hui(5303) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.425 .1 .15 .05],...
                                  'String','speichern',...
                                  'CallBack','KMT SpeicherZmSPGundDL');

            hui(5304) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.625 .1 .15 .05],...
                                  'String','speichern klein',...
                                  'CallBack','KMT SpeicherZmSPGundDL2');
                              
            hui(5305) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.825 .1 .15 .05],...
                                  'String','schließen',...
                                  'CallBack','close');
                              
            hui(5306) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize', Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.425 .18 .15 .05],...
                                  'String', 'verbessern',...
                                  'CallBack','KMT AuftragAuswahlVerbessernMitSPGundDL');

            
        

            
        case 'AuftragAuswahlVerbessernMitSPGundDL'
            tmp_value = get(hui(403),'Value');
            tmp_string = get(hui(403),'String');
            set(hui(100),'String',['Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion: ' tmp_string(tmp_value,:) '   >   Artikelreihenfolgeverfahren   >   Auftragsreihenfolgeverfahren   >   Lösung   >   Verbesserung']);
            set(hui(103),'Callback','KMT InfoVerbesserungMitDL');
            set(hui(5300:5306),'Visible','off','Enable','inactive');

            PositionCheckbox = [.08 .70 .70 .05;
                                .08 .65 .70 .05;
                                .08 .60 .70 .05;
                                .08 .55 .70 .05;
                                .08 .50 .70 .05;
                                .08 .45 .70 .05;
                                .08 .40 .70 .05;
                                .08 .35 .70 .05;
                                .08 .30 .70 .05;
                                .08 .25 .70 .05];       
                        
            Data = get(hui(5300),'Data');
            j = 1;
            
            for i = 1:size(Data,1)
                if isempty(Data{i,2})
                    
                    hui(5404+j) = uicontrol('Style','checkbox',...
                                            'Units','normalized',...
                                            'FontSize',Schriftgroesse1,...
                                            'FontUnits','normalized',...
                                            'String',Data{i,1},...
                                            'Position',PositionCheckbox(j,:));
                    j = j+1;
                    
                end
            end
            
            hui(5400) = uicontrol('Style','text',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'HorizontalAlignment','center',...  % Damit der Text linksbündig ist
                                  'Position',[0 .80 1 .05],...
                                  'String','Auftragsreihenfolgeverfahren wählen worauf Verbesserungsverfahren angewendet werden sollen:');

            hui(5401) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.05 .1 .15 .05],...
                                  'String','zurück',...
                                  'CallBack','KMT BackLösungMitSPGundDL'); 

            hui(5402) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.8 .1 .15 .05],...
                                  'String','weiter',...
                                  'CallBack','KMT ArtikelAuswahlVerbessernMitSPGundDL');

            hui(5403) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.55 .1 .15 .05],...
                                  'String','alle auswählen',...
                                  'CallBack','KMT AlleAufVerMitSPGundDL'); 

            hui(5404) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.3 .1 .15 .05],...
                                  'String','keins auswählen',...
                                  'CallBack','KMT KeinAufVerMitSPGundDL');

                              
         case 'ArtikelAuswahlVerbessernMitSPGundDL' 
            Data = get(hui(5300),'Data');
            z = sum(cellfun('isempty',Data(:,2))); % z = Anzahl an Auftragsreihenfolgeverfahren

            % Prüfen wie viele Verfahren verbessert werden sollen 
            SumAuftragsVerfahrenVerbessern = 0;
            for i=1:z
                SumAuftragsVerfahrenVerbessern = SumAuftragsVerfahrenVerbessern+get(hui(5404+i),'Value');
            end
            
            if SumAuftragsVerfahrenVerbessern == 0 
                errordlg('Bitte wählen Sie die Auftragsreihenfolgeverfahren aus die im nächsten Schritt, mit den entsprechenden Verfahren, verbessert werden.','Fehler')
            else
                
                tmp_value = get(hui(403),'Value');
                tmp_string = get(hui(403),'String');
                set(hui(100),'String',['Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion: ' tmp_string(tmp_value,:) '   >   Artikelreihenfolgeverfahren   >   Auftragsreihenfolgeverfahren   >   Lösung   >   Verbesserung']);
                set(hui(103),'Callback','KMT InfoArtVerbesserungMitDL');
                set(hui(5400:5404+sum(cellfun('isempty',Ausgabe(:,2)))),'Visible','off','Enable','inactive');

                PositionCheckbox1 = [.08 .71 .44 .05;
                                .08 .66 .44 .05;
                                .08 .61 .44 .05;
                                .08 .56 .44 .05;
                                .08 .51 .44 .05;
                                .08 .46 .44 .05;
                                .08 .41 .44 .05;
                                .08 .36 .44 .05;
                                .08 .31 .44 .05;
                                .54 .71 .44 .05;
                                .54 .66 .44 .05;
                                .54 .61 .44 .05;
                                .54 .56 .44 .05;
                                .54 .51 .44 .05;
                                .54 .46 .44 .05;
                                .54 .41 .44 .05;
                                .54 .36 .44 .05;
                                .54 .31 .44 .05;
                                .54 .26 .44 .05];
                            
                PositionCheckbox2 = [.06 .71 .02 .05;
                                .06 .66 .02 .05;
                                .06 .61 .02 .05;
                                .06 .56 .02 .05;
                                .06 .51 .02 .05;
                                .06 .46 .02 .05;
                                .06 .41 .02 .05;
                                .06 .36 .02 .05;
                                .06 .31 .02 .05;
                                .52 .71 .02 .05;
                                .52 .66 .02 .05;
                                .52 .61 .02 .05;
                                .52 .56 .02 .05;
                                .52 .51 .02 .05;
                                .52 .46 .02 .05;
                                .52 .41 .02 .05;
                                .52 .36 .02 .05;
                                .52 .31 .02 .05;
                                .52 .26 .02 .05]; 
                            
                PositionCheckbox3 = [.04 .71 .02 .05;
                                .04 .66 .02 .05;
                                .04 .61 .02 .05;
                                .04 .56 .02 .05;
                                .04 .51 .02 .05;
                                .04 .46 .02 .05;
                                .04 .41 .02 .05;
                                .04 .36 .02 .05;
                                .04 .31 .02 .05;
                                .50 .71 .02 .05;
                                .50 .66 .02 .05;
                                .50 .61 .02 .05;
                                .50 .56 .02 .05;
                                .50 .51 .02 .05;
                                .50 .46 .02 .05;
                                .50 .41 .02 .05;
                                .50 .36 .02 .05;
                                .50 .31 .02 .05;
                                .50 .26 .02 .05];    
                            
                PositionCheckbox4 = [.09 .70 .40 .05;
                                .09 .65 .40 .05;
                                .09 .60 .40 .05;
                                .09 .55 .40 .05;
                                .09 .50 .40 .05;
                                .09 .45 .40 .05;
                                .09 .40 .40 .05;
                                .09 .35 .40 .05;
                                .09 .30 .40 .05;
                                .55 .70 .44 .05;
                                .55 .65 .44 .05;
                                .55 .60 .44 .05;
                                .55 .55 .44 .05;
                                .55 .50 .44 .05;
                                .55 .45 .44 .05;
                                .55 .40 .44 .05;
                                .55 .35 .44 .05;
                                .55 .30 .44 .05;
                                .55 .25 .44 .05];

                for i = 1:length(ArtikelVerfahrenNamen)
                    
                    hui(i+5500) = uicontrol('Style','checkbox',...
                                            'Units','normalized',...
                                            'FontSize',Schriftgroesse1,...
                                            'FontUnits','normalized',...
                                            'Position',PositionCheckbox1(i,:),...
                                            'Value',0); 
                                        
                    if Art(i) == 0 
                        set(hui(i+5500),'Enable','off');
                    end
                    
                    hui(i+5500+length(ArtikelVerfahrenNamen)) = uicontrol('Style','checkbox',...
                                            'Units','normalized',...
                                            'FontSize',Schriftgroesse1,...
                                            'FontUnits','normalized',...
                                            'Position',PositionCheckbox2(i,:),...
                                            'Value',0);
                    
                    if ArtR(i) == 0
                        set(hui(i+5500+length(ArtikelVerfahrenNamen)),'Enable','off');
                    end
                   
                    hui(i+5500+2*(length(ArtikelVerfahrenNamen))) = uicontrol('Style','checkbox',...
                                            'Units','normalized',...
                                            'FontSize',Schriftgroesse1,...
                                            'FontUnits','normalized',...
                                            'Position',PositionCheckbox3(i,:),...
                                            'Value',0);
                                        
                    if ArtD(i) == 0
                        set(hui(i+5500+2*(length(ArtikelVerfahrenNamen))),'Enable','off');
                    end
                   
                end
                
                hui(5500) = uicontrol('Style','text',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'HorizontalAlignment','center',...  % Damit der Text linksbündig ist
                                  'Position',[0 .80 1 .05],...
                                  'String','Artikelreihenfolgeverfahren wählen worauf Verbesserungsverfahren angewendet werden sollen:');

                for i = 1:length(ArtikelVerfahrenNamen)
                    
                    hui(i+5557) = uicontrol('Style','text',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'HorizontalAlignment','left',...  % Damit der Text linksbündig ist
                                  'Position',PositionCheckbox4(i,:),...
                                  'String',ArtikelVerfahrenNamen{i});

                end
                                    
                hui(5577) = uicontrol('Style','text',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'HorizontalAlignment','center',...  % Damit der Text mittig ist
                                  'Position',[0.04 .78 0.01 .05],...
                                  'String','D');
                              
                hui(5578) = uicontrol('Style','text',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'HorizontalAlignment','center',...  % Damit der Text mittig ist
                                  'Position',[0.06 .78 0.01 .05],...
                                  'String','R');

                hui(5579) = uicontrol('Style','text',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'HorizontalAlignment','center',...  % Damit der Text mittig ist
                                  'Position',[0.08 .78 0.01 .05],...
                                  'String','H');

                hui(5580) = uicontrol('Style','text',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'HorizontalAlignment','center',...  % Damit der Text mittig ist
                                  'Position',[0.50 .75 0.01 .05],...
                                  'String','D');

                hui(5581) = uicontrol('Style','text',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'HorizontalAlignment','center',...  % Damit der Text mittig ist
                                  'Position',[0.52 .75 0.01 .05],...
                                  'String','R');

                hui(5582) = uicontrol('Style','text',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'HorizontalAlignment','center',...  % Damit der Text mittig ist
                                  'Position',[0.54 .75 0.01 .05],...
                                  'String','H');     

                hui(5583) = uicontrol('Style','checkbox',...
                                   'Units','normalized',...
                                   'FontSize',Schriftgroesse1,...
                                   'FontUnits','normalized',...
                                   'Position',[0.04 .75 0.02 .05],...
                                   'String','',...
                                   'Callback','KMT AlleDynamischDLVer');

                hui(5584) = uicontrol('Style','checkbox',...
                                   'Units','normalized',...
                                   'FontSize',Schriftgroesse1,...
                                   'FontUnits','normalized',...
                                   'Position',[0.06 .75 0.02 .05],...
                                   'String','',...
                                   'Callback','KMT AlleRollierendDLVer');
                                
                hui(5585) = uicontrol('Style','checkbox',...
                                   'Units','normalized',...
                                   'FontSize',Schriftgroesse1,...
                                   'FontUnits','normalized',...
                                   'Position',[0.08 .75 0.02 .05],...
                                   'String','',...
                                   'Callback','KMT AlleHierarchischDLVer');
                               
                hui(5586) = uicontrol('Style','push',...
                                   'Units','normalized',...
                                   'FontSize',Schriftgroesse1,...
                                   'FontUnits','normalized',...
                                   'Position',[.8 .1 .15 .05],...
                                   'String','weiter',...
                                   'CallBack','KMT VerbesserungMitSPGundDL');

                hui(5587) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.05 .1 .15 .05],...
                                  'String','zurück',...
                                  'CallBack','KMT BackAuftragAuswahlVerbessernMitSPGundDL'); 

                hui(5588) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.55 .1 .15 .05],...
                                  'String','alle auswählen',...
                                  'CallBack','KMT AlleArtikelVerfahrenMitSPGundDLVer');

                hui(5589) = uicontrol('Style','push',...
                                  'Units','normalized',...
                                  'FontSize',Schriftgroesse1,...
                                  'FontUnits','normalized',...
                                  'Position',[.3 .1 .15 .05],...
                                  'String','keins auswählen',...
                                  'CallBack','KMT KeineArtikelVerfahrenMitSPGundDLVer');             
                            
                if isempty(find(ArtD == 1,1)) % die ',1' am Ende bedeutet, dass die Suche abgebrochen wird, sobald eine 1 gefunden wurde, weil der Vektor dann nicht mehr leer sein kann
                    set(hui(5583),'Enable','off')
                end   
                
                if isempty(find(ArtR == 1,1))
                    set(hui(5584),'Enable','off')
                end     
                
                if isempty(find(Art == 1,1))
                    set(hui(5585),'Enable','off')
                end      

            end
             

        case 'VerbesserungMitSPGundDL'
            
            % Prüfe, wie viele Verfahren verbessert werden sollen 
            SumArtikelVerfahrenVerbessern = 0;   
            for i = 1:size(ArtikelVerfahrenNamen)*3
                if get(hui(i+5500),'Value') == 1
                    SumArtikelVerfahrenVerbessern = SumArtikelVerfahrenVerbessern + 1;
                end
            end

            if SumArtikelVerfahrenVerbessern == 0 
                errordlg('Bitte wählen Sie die Auftragsreihenfolgeverfahren aus, die im nächsten Schritt mit den entsprechenden Verfahren verbessert werden.','Fehler')
            else
                tmp_value = get(hui(403),'Value');
                tmp_string = get(hui(403),'String');
                set(hui(100),'String',['Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion: ' tmp_string(tmp_value,:) '   >   Artikelreihenfolgeverfahren   >   Lösung   >   Verbesserung   >   Verbesserungsverfahren']);
                set(hui(103),'Callback','KMT InfoVerbesserungsverfahrenMitDL');
                set(hui(5500:5589),'Visible','off','Enable','inactive');
                
                Plus_Abbruchbed = false; % Keine zusätzlichen Abbruchbedingungen der Verbesserungsverfahren

                PositionCheckbox1 = [.24 .61 .15 .05;
                                    .24 .56 .15 .05;
                                    .24 .51 .15 .05;
                                    .24 .46 .15 .05;
                                    .24 .41 .15 .05];
                
                hui(5600) = uicontrol('Style','text',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'HorizontalAlignment','left',...  % Damit der Text linksbündig ist
                                      'Position',[.08 .6 .15 .05],...
                                      'String','Verbesserungsverfahren:');
                                 
                hui(5601) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.48 .6 .245 .05],...
                                      'String','Mit zusätzlichen Abbruchbedingungen:',...
                                      'CallBack','KMT AbbruchbedingungenDL');
                                  
                hui(5602) = uicontrol('Style','text',...
                                      'Enable','off',... % Ausgrauen
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'HorizontalAlignment','left',...  % Damit der Text linksbündig ist
                                      'Position',[.48 .5 .15 .05],...
                                      'String','1. Rechenzeit von');
                                  
                hui(5603) = uicontrol('Style','edit',...                     
                                      'Enable','off',... % Ausgrauen
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.585 .51 .05 .05]);
                                  
                hui(5604) = uicontrol('Style','text',...
                                      'Enable','off',... % Ausgrauen
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'HorizontalAlignment','left',...  % Damit der Text linksbündig ist
                                      'Position',[.64 .5 .25 .05],...
                                      'String','Minuten');
                                  
                hui(5605) = uicontrol('Style','text',...
                                      'Enable','off',... % Ausgrauen
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'HorizontalAlignment','left',...  % Damit der Text linksbündig ist
                                      'Position',[.48 .45 .5 .05],...
                                      'String','2. Zielfunktionswertverbesserung ausgehend vom Artikelreihenfolgeverfahren');
                                  
                hui(5606) = uicontrol('Style','text',...
                                      'Enable','off',... % Ausgrauen
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'HorizontalAlignment','left',...  % Damit der Text linksbündig ist
                                      'Position',[.495 .4 .5 .05],...
                                      'String','um ');
                                  
                hui(5607) = uicontrol('Style','edit',... 
                                      'Enable','off',... % Ausgrauen
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.52 .41 .05 .05]);
                                  
                hui(5608) = uicontrol('Style','text',...
                                      'Enable','off',... % Ausgrauen
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'HorizontalAlignment','left',...  % Damit der Text linksbündig ist
                                      'Position',[.575 .4 .3 .05],...
                                      'String','%');
                                  
                hui(5609) = uicontrol('Style','text',...
                                      'Enable','off',... % Ausgrauen
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'HorizontalAlignment','left',...  % Damit der Text linksbündig ist
                                      'Position',[.48 .35 .3 .05],...
                                      'String','3. Zielfunktionswertverbesserung von weniger als ');
                                  
                hui(5610) = uicontrol('Style','edit',... 
                                      'Enable','off',... % Ausgrauen
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.76 .36 .05 .05]);
                                  
                hui(5611) = uicontrol('Style','text',...
                                      'Enable','off',... % Ausgrauen
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'HorizontalAlignment','left',...  % Damit der Text linksbündig ist
                                      'Position',[.815 .35 .3 .05],...
                                      'String','% in den letzten');
                                  
                hui(5612) = uicontrol('Style','edit',... 
                                      'Enable','off',... % Ausgrauen
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.495 .31 .05 .05]);
                                  
                hui(5613) = uicontrol('Style','text',...
                                      'Enable','off',... % Ausgrauen
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'HorizontalAlignment','left',...  % Damit der Text linksbündig ist
                                      'Position',[.55 .3 .3 .05],...
                                      'String','Vergleichen');

                hui(5614) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.8 .1 .15 .05],...
                                      'String','lösen',...
                                      'CallBack','KMT LösungVerbesserungMitSPGundDL');

                hui(5615) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.05 .1 .15 .05],...
                                      'String','zurück',...
                                      'CallBack','KMT BackArtikelAuswahlVerbessernMitSPGundDL'); 

                hui(5616) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.55 .1 .15 .05],...
                                      'String','alle auswählen',...
                                      'CallBack','KMT AlleAuftragsVerfahrenMitSPGundDLVer');

                hui(5617) = uicontrol('Style','push',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',[.3 .1 .15 .05],...
                                      'String','keins auswählen',...
                                      'CallBack','KMT KeinAuftragsVerfahrenMitSPGundDLVer');
            
                for i = 1:AnzVerbesserungsVerfahrenDL
                    
                    hui(i+5617) = uicontrol('Style','checkbox',...
                                      'Units','normalized',...
                                      'FontSize',Schriftgroesse1,...
                                      'FontUnits','normalized',...
                                      'Position',PositionCheckbox1(i,:),...
                                      'Value',VerbDL(i),...
                                      'String',VerbesserungsVerfahrenDLNamen{i});
                end
            end
            
            
        case 'AbbruchbedingungenDL'
            if get(hui(5601),'String') == 'Mit zusätzlichen Abbruchbedingungen:'
                set(hui(5602:5613),'Enable','on');
                set(hui(5601),'String','Ohne zusätzliche Abbruchbedingungen:')
                Plus_Abbruchbed = true;
            else
                set(hui(5602:5613),'Enable','off');
                set(hui(5601),'String','Mit zusätzlichen Abbruchbedingungen:')
                Plus_Abbruchbed = false;
            end
  
            
        case 'LösungVerbesserungMitSPGundDL'
            for i = 1:AnzVerbesserungsVerfahrenDL
                VerbDL(i) = get(hui(i+5617),'Value');
            end
                
            SummeVerb = sum(VerbDL);   

            fehler = false; % Kein Fehler
                
            if SummeVerb == 0 
                errordlg('Bitte wählen Sie mindestens ein Verbesserungsverfahren aus.','Fehler')
                fehler = true;
            end
            
            if Plus_Abbruchbed == true
                % Prüfen, ob eine der drei Abbruchbedingungen
                % korrekt eingegeben wurde

                % Strings in numerische Werte umwandeln
                Ab_zeit_str = get(hui(5603),'String');
                Ab_zeit = str2double(Ab_zeit_str);
                Ab_prozent2_str = get(hui(5607),'String');
                Ab_prozent2 = str2double(Ab_prozent2_str);
                Ab_prozent3_str = get(hui(5610),'String');
                Ab_prozent3 = str2double(Ab_prozent3_str);
                Ab_vergl_str = get(hui(5612),'String');
                Ab_vergl = str2double(Ab_vergl_str);
                
                if ~isempty(get(hui(5603),'String')) && isnan(Ab_zeit) && isnan(Ab_prozent2) && isnan(Ab_prozent3) && isnan(Ab_vergl)
                    errordlg('Bitte geben Sie mindestens eine zusätzliche Abbruchbedingung an.','Eingabe Fehler') 
                    fehler = true;
                else
                    if ~isempty(Ab_zeit_str) && (isnan(Ab_zeit) || Ab_zeit <= 0)
                        errordlg('Die maximal zu benötigende Rechenzeit muss positiv sein.','Eingabe Fehler') 
                        fehler = true;
                    end
                    if ~isempty(Ab_prozent2_str) && (isnan(Ab_prozent2) || Ab_prozent2 <= 0 || Ab_prozent2 >= 100)
                        errordlg('Die prozentuale Zielfunktionswertverbesserung des Verbesserungsverfahren gegenüber dem Artikelreihenfolgeverfahren muss aus dem Intervall (0,100) sein, d.h. zwischen 0 und 100 % liegen.','Eingabe Fehler') 
                        fehler = true;
                    end
                    if ( (~isempty(Ab_prozent3_str) && (isnan(Ab_prozent3) || Ab_prozent3 <= 0 || Ab_prozent3 >= 100)) ...
                            || (~isempty(Ab_vergl_str) && (isnan(Ab_vergl) || Ab_vergl <= 0 || round(Ab_vergl) ~= Ab_vergl)) ) ...
                            || xor(isempty(Ab_prozent3_str),isempty(Ab_vergl_str)) 
                        errordlg('Die Anzahl der Vergleiche muss positiv und ganzzahlig sein. Außerdem muss die prozentuale Zielfunktionswertverbesserung des Verbesserungsverfahren innerhalb der eingegebenen Anzahl der Vergleiche aus dem Intervall (0,100) sein, d.h. zwischen 0 und 100 % liegen.','Eingabe Fehler') 
                        fehler = true;
                    end
                end
            end
            
            tmp_value = get(hui(403),'Value');
            tmp_string = get(hui(403),'String');
            if fehler == false % Wenn kein Eingabefehler aufgetreten ist, beginne mit der Berechnung
                set(hui(100),'String',['Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion: ' tmp_string(tmp_value,:) '   >   Artikelreihenfolgeverfahren   >   Lösung   >   Verbesserung   >   Verbesserungsverfahren   >   Lösung']);
                set(hui(103),'Callback','KMT InfoLoesungVerbMitDL');
                set(hui(5600:5617+AnzVerbesserungsVerfahrenDL),'Visible','off','Enable','inactive');
 
                Info_waitbar = waitbar(0,'Berechnung läuft...','Name','Information',...
                                       'CreateCancelBtn',...
                                       'setappdata(gcbf,''canceling'',1)');
                children_info = get(Info_waitbar, 'children'); % Cancel Button
                set(children_info(1), 'String', 'abbrechen')   % umbennenen
                setappdata(Info_waitbar,'canceling',0)
                waitbar(0,Info_waitbar,'Berechnung läuft...')

                Data = Ausgabe;
                z = size(Data,1);

                % Lese aus, welche Auftrags- bzw. Artikelverfahren zum 
                % Verbessern ausgewählt wurden:
                % Auftragsverfahren:
                AufVerb = zeros(sum(cellfun('isempty',Data(:,2))),1);
                for i = 1:size(AufVerb,1)
                    AufVerb(i,1) = get(hui(i+5404),'Value');
                end 
                
                % Hierarchische Artikelverfahren
                ArtVerbH = zeros(AnzArtikelVerfahren,1);
                for i = 1:AnzArtikelVerfahren
                    ArtVerbH(i,1) = get(hui(i+5500),'Value');
                end
                
                % Rollierende Artikelverfahren
                ArtVerbR = zeros(AnzArtikelVerfahren,1);
                for i = 1:AnzArtikelVerfahren
                    ArtVerbR(i,1) = get(hui(i+5500+AnzArtikelVerfahren),'Value');
                end
                
                % Dynamische Artikelverfahren
                ArtVerbD = zeros(AnzArtikelVerfahren,1);
                for i = 1:AnzArtikelVerfahren
                    ArtVerbD(i,1) = get(hui(i+5500+2*AnzArtikelVerfahren),'Value');
                end
                
                BZ = Bearbeitungszeit(A,HZ,KZ);
                                
                % Prüfen wie viele Verfahren verbessert werden sollen
                % (= #AuftragsVerfahren * #ArtikelVerfahren * #VerbesserungsVerf)  
                SumAuftragsVerfahrenVerbessern = sum(AufVerb);
                SumArtikelVerfahrenVerbessern = sum(ArtVerbH) + sum(ArtVerbR) + sum(ArtVerbD);
                
                steps = SumAuftragsVerfahrenVerbessern * SumArtikelVerfahrenVerbessern * SummeVerb;
                step = 0;
               
                if Plus_Abbruchbed == false % Ohne zusätzliche Abbruchbedingungen

                    DataVerb = cell(SumAuftragsVerfahrenVerbessern * SumArtikelVerfahrenVerbessern * (SummeVerb + 1) + SumAuftragsVerfahrenVerbessern,10); %(2*steps+sum(AufVerb),10);
                    
                    % schreibe die Überschriften der zur Verbesserung 
                    % ausgewählten Auftragsverfahren an die entsprechende
                    % Stelle der späteren Ausgabe 'DataVerb':
                    j = 0;
                    PosName = find(cellfun('isempty',Data(:,2))); % Zeilenposition der Namen der ausgewählten Auftragsverfahren in 'Data' 
                    for i = 1:size(AufVerb,1)
                        if AufVerb(i) == 1  
                            DataVerb(1+(size(DataVerb,1)/sum(AufVerb))*j,1) = Data(PosName(i),1);
                            j = j + 1;
                        end
                    end
                    
                    k = 2;
                    [m,n] = size(A);
                    % gehe jedes Auftragsreihenfolgeverfahren durch
                    for i = 1:size(AufVerb,1)
                        if AufVerb(i) == 1
                            
                            % gehe jedes Artikelreihenfolgeverfahren durch
                            for j = 1:AnzArtikelVerfahren
                                
                                % berechne die ursprüngliche
                                % Artikelreihenfolge. (Diese Information
                                % ist verloren gegangen, es existiert nur
                                % noch die tatsächliche Holreihenfolge)
                                BZ = Bearbeitungszeit(A,HZ,KZ);
                                HA = Haufigkeit(A);
                                
                                switch j
                                    case 1
                                        OrderArtikel = [1:m]'; %#ok<*NBRAK> unterdrückt die Fehlermeldung, dass die Klammern überflüssig sind
                                    case 2
                                        OrderArtikel = minBmaxH(HA,BZ);
                                    case 3
                                        OrderArtikel = maxBmaxH(HA,BZ);
                                    case 4
                                        OrderArtikel = minHtopo(HA,BZ);
                                    case 5
                                        OrderArtikel = maxHtopo(HA,BZ);
                                    case 6
                                        OrderArtikel = maxHminB(HA,BZ);
                                    case 7
                                        OrderArtikel = maxHmaxB(HA,BZ);
                                    case 8
                                        OrderArtikel = zenReihAufst(HA);
                                    case 9
                                        OrderArtikel = zenReihAbst(HA);
                                    case 10
                                        OrderArtikel = minAtopo(A);
                                    case 11
                                        OrderArtikel = minAminB(A,BZ);
                                    case 12
                                        OrderArtikel = minAmaxB(A,BZ);
                                    case 13
                                        OrderArtikel = minAminH(A,HA);
                                    case 14
                                        OrderArtikel = minAmaxH(A,HA);
                                    case 15
                                        OrderArtikel = maxAtopo(A);
                                    case 16
                                        OrderArtikel = maxAminB(A,BZ);
                                    case 17
                                        OrderArtikel = maxAmaxB(A,BZ);
                                    case 18
                                        OrderArtikel = maxAminH(A,HA);
                                    case 19
                                        OrderArtikel = maxAmaxH(A,HA);
                                end
                                
                                if ArtVerbH(j) == 1
                                    
                                    v = 1;
                                    
                                    % finde die Zeile in Data, welche jetzt
                                    % verbessert werden soll (speichere in
                                    % lineNr)
                                    lineNr = find(ismember(Data(:,1),['---' ArtikelVerfahrenNamen{j} ' (Hierarchisch)']));
                                    DataVerb(k,:) = [Data(lineNr(i),1:2) ' ' ' ' ' ' ' ' ' ' Data(lineNr(i),4:end)];

                                    if VerbDL(1) == 1
                                        step = step + 1;

                                        tic % Rechenzeit beginnen

                                        switch Ziel 
                                            case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = insertDL(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'FSZbS',Gewichtung);

                                            case 2 % Zielfunktion: min! max. Fertigstellungszeitpunke
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = insertDL(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'FFbS',Gewichtung);

                                            case 3 % Zielfunktion: min! sum. spez. Fertigstellungszeitpunkte
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = insertDL(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'DLZbS',Gewichtung);
                                            
                                            case 4 % Zielfunktion: min! sum. Anzahl an Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = insertDL(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'AUFbS',Gewichtung);
                                            
                                            case 5 % Zielfunktion: min! sum. Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = insertDL(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'UdFbS',Gewichtung);
                                            
                                            case 6 % Zielfunktion: min! max. Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = insertDL(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'sUFbS',Gewichtung);
                                            
                                            case 7 % Zielfunktion: min! durchschnittliche Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = insertDL(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'dUFbS',Gewichtung);
                                            
                                            case 8 % Zielfunktion: min! sum. gewichtete Überschreitungen der Deadlines% Zielfunktion:
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = insertDL(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'gUFbS',Gewichtung);
                                        end

                                        RechenzeitVerb = toc;

                                        absolutVerb = DataVerb{k,2} - ZielfunktionswertVerb;
                                        if absolutVerb == 0
                                            relativVerb = 0;
                                        else
                                            relativVerb = 100 * (absolutVerb / DataVerb{k,2});
                                        end

                                        DataVerb(k+v,:) = {'------Insert',ZielfunktionswertVerb,absolutVerb,relativVerb,AnzVerg,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArt),int2str(OrderAuftragVerb)};
                                                                                                                                                                
                                        if getappdata(Info_waitbar,'canceling')
                                            delete(Info_waitbar)
                                            KMT VerbesserungOhneSPG                        
                                        end
                                        % Report current estimate in the waitbar's message field
                                        waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                                        v = v+1;
                                        
                                    end
                                    
                                    
                                    if VerbDL(2) == 1
                                        step = step + 1;

                                        tic % Rechenzeit beginnen

                                        switch Ziel 
                                            case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = tauschLite(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'FSZbS',Gewichtung);

                                            case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = tauschLite(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'FFbS',Gewichtung);

                                            case 3 % Zielfunktion: min! sum. spez. Fertigstellungszeitpunkte
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = tauschLite(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'DLZbS',Gewichtung);
                                            
                                            case 4 % Zielfunktion: min! sum. Anzahl an Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = tauschLite(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'AUFbS',Gewichtung);
                                            
                                            case 5 % Zielfunktion: min! sum. Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = tauschLite(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'UdFbS',Gewichtung);
                                            
                                            case 6 % Zielfunktion: min! max. Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = tauschLite(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'sUFbS',Gewichtung);
                                            
                                            case 7 % Zielfunktion: min! durchschnittliche Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = tauschLite(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'dUFbS',Gewichtung);
                                            
                                            case 8 % Zielfunktion: min! sum. gewichtete Überschreitungen der Deadlines% Zielfunktion:
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = tauschLite(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'gUFbS',Gewichtung);
                                        end
                                        
                                        RechenzeitVerb = toc;

                                        absolutVerb = DataVerb{k,2} - ZielfunktionswertVerb;
                                        if absolutVerb == 0
                                            relativVerb = 0;
                                        else
                                            relativVerb = 100 * (absolutVerb / DataVerb{k,2});
                                        end

                                        DataVerb(k+v,:) = {'------2-Tausch Lite',ZielfunktionswertVerb,absolutVerb,relativVerb,AnzVerg,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArt),int2str(OrderAuftragVerb)};
                                                                                                                                                                
                                        if getappdata(Info_waitbar,'canceling')
                                            delete(Info_waitbar)
                                            KMT VerbesserungOhneSPG                        
                                        end
                                        % Report current estimate in the waitbar's message field
                                        waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                                        v = v+1;
                                        
                                    end
                                    
                                    k = k+v;

                                end
                                
                                
                                if ArtVerbR(j) == 1
                                    
                                    v = 1;
                                    
                                    % finde die Zeile in Data, welche jetzt
                                    % verbessert werden soll (speichere in
                                    % lineNr)
                                    lineNr = find(ismember(Data(:,1),['---' ArtikelVerfahrenNamen{j} ' (Rollierend)']));
                                    DataVerb(k,:) = [Data(lineNr(i),1:2) ' ' ' ' ' ' ' ' ' ' Data(lineNr(i),4:end)];

                                    if VerbDL(1) == 1
                                        step = step + 1;

                                        tic % Rechenzeit beginnen

                                        switch Ziel 
                                            case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = insertDL(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'FSZbSR',Gewichtung);

                                            case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = insertDL(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'FFbSR',Gewichtung);

                                            case 3 % Zielfunktion: min! sum. spez. Fertigstellungszeitpunkte
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = insertDL(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'DLZbSR',Gewichtung);
                                            
                                            case 4 % Zielfunktion: min! sum. Anzahl an Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = insertDL(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'AUFbSR',Gewichtung);

                                            case 5 % Zielfunktion: min! sum. Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = insertDL(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'UdFbSR',Gewichtung);
                                            
                                            case 6 % Zielfunktion: min! max. Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = insertDL(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'sUFbSR',Gewichtung);

                                            case 7 % Zielfunktion: min! durchschnittliche Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = insertDL(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'dUFbSR',Gewichtung);
                                            
                                            case 8 % Zielfunktion: min! sum. gewichtete Überschreitungen der Deadlines 
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = insertDL(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'gUFbSR',Gewichtung);
                                        end

                                        RechenzeitVerb = toc;

                                        absolutVerb = DataVerb{k,2} - ZielfunktionswertVerb;
                                        if absolutVerb == 0
                                            relativVerb = 0;
                                        else
                                            relativVerb = 100 * (absolutVerb / DataVerb{k,2});
                                        end
                                        
                                        DataVerb(k+v,:) = {'------Insert',ZielfunktionswertVerb,absolutVerb,relativVerb,AnzVerg,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArt),int2str(OrderAuftragVerb)};

                                        if getappdata(Info_waitbar,'canceling')
                                            delete(Info_waitbar)
                                            KMT VerbesserungOhneSPG                        
                                        end
                                        % Report current estimate in the waitbar's message field
                                        waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                                        v = v+1;
                                        
                                    end
                                    
                                    
                                    if VerbDL(2) == 1
                                        step = step + 1;

                                        tic % Rechenzeit beginnen

                                        switch Ziel 
                                            case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = tauschLite(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'FSZbSR',Gewichtung);

                                            case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = tauschLite(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'FFbSR',Gewichtung);

                                            case 3 % Zielfunktion: min! sum. spez. Fertigstellungszeitpunkte
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = tauschLite(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'DLZbSR',Gewichtung);
                                            
                                            case 4 % Zielfunktion: min! sum. Anzahl an Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = tauschLite(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'AUFbSR',Gewichtung);
                                            
                                            case 5 % Zielfunktion: min! sum. Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = tauschLite(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'UdFbSR',Gewichtung);
                                            
                                            case 6 % Zielfunktion: min! max. Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = tauschLite(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'sUFbSR',Gewichtung);
                                            
                                            case 7 % Zielfunktion: min! durchschnittliche Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = tauschLite(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'dUFbSR',Gewichtung);
                                            
                                            case 8 % Zielfunktion: min! sum. gewichtete Überschreitungen der Deadlines 
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = tauschLite(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'gUFbSR',Gewichtung);
                                        end
                                        
                                        RechenzeitVerb = toc;

                                        absolutVerb = DataVerb{k,2} - ZielfunktionswertVerb;
                                        if absolutVerb == 0
                                            relativVerb = 0;
                                        else
                                            relativVerb = 100 * (absolutVerb / DataVerb{k,2});
                                        end

                                        DataVerb(k+v,:) = {'------2-Tausch Lite',ZielfunktionswertVerb,absolutVerb,relativVerb,AnzVerg,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArt),int2str(OrderAuftragVerb)};
                                                                                                                                                                
                                        if getappdata(Info_waitbar,'canceling')
                                            delete(Info_waitbar)
                                            KMT VerbesserungOhneSPG                        
                                        end
                                        % Report current estimate in the waitbar's message field
                                        waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                                        v = v+1;
                                        
                                    end
                                    
                                    k = k+v;
     
                                end
                                
                                
                                if ArtVerbD(j) == 1
                                    
                                    v = 1;
                                    
                                    % finde die Zeile in Data, welche jetzt
                                    % verbessert werden soll (speichere in
                                    % lineNr)
                                    lineNr = find(ismember(Data(:,1),['---' ArtikelVerfahrenNamen{j} ' (Dynamisch)']));
                                    DataVerb(k,:) = [Data(lineNr(i),1:2) ' ' ' ' ' ' ' ' ' ' Data(lineNr(i),4:end)];

                                    if VerbDL(1) == 1
                                        step = step + 1;

                                        tic % Rechenzeit beginnen

                                        switch Ziel 
                                            case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = insertDL(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'FSZbS',Gewichtung);

                                            case 2 % Zielfunktion: min! max. Fertigstellungszeitpunke
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = insertDL(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'FFbS',Gewichtung);

                                            case 3 % Zielfunktion: min! sum. spez. Fertigstellungszeitpunkte
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = insertDL(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'DLZbS',Gewichtung);
                                            
                                            case 4 % Zielfunktion: min! sum. Anzahl an Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = insertDL(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'AUFbSD',Gewichtung,j);
                                            
                                            case 5 % Zielfunktion: min! sum. Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = insertDL(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'UdFbSD',Gewichtung,j);
                                            
                                            case 6 % Zielfunktion: min! max. Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = insertDL(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'sUFbSD',Gewichtung,j);
                                            
                                            case 7 % Zielfunktion: min! durchschnittliche Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = insertDL(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'dUFbSD',Gewichtung,j);
                                            
                                            case 8 % Zielfunktion: min! sum. gewichtete Überschreitungen der Deadlines% Zielfunktion:
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = insertDL(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'gUFbSD',Gewichtung,j);
                                        end

                                        RechenzeitVerb = toc;

                                        absolutVerb = DataVerb{k,2} - ZielfunktionswertVerb;
                                        if absolutVerb == 0
                                            relativVerb = 0;
                                        else
                                            relativVerb = 100 * (absolutVerb / DataVerb{k,2});
                                        end

                                        DataVerb(k+v,:) = {'------Insert',ZielfunktionswertVerb,absolutVerb,relativVerb,AnzVerg,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArt),int2str(OrderAuftragVerb)};
                                                                                                                                                                
                                        if getappdata(Info_waitbar,'canceling')
                                            delete(Info_waitbar)
                                            KMT VerbesserungOhneSPG                        
                                        end
                                        % Report current estimate in the waitbar's message field
                                        waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                                        v = v+1;
                                        
                                    end
                                    
                                    
                                    if VerbDL(2) == 1
                                        step = step + 1;

                                        tic % Rechenzeit beginnen

                                        switch Ziel 
                                            case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = tauschLite(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'FSZbS',Gewichtung);

                                            case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = tauschLite(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'FFbS',Gewichtung);

                                            case 3 % Zielfunktion: min! sum. spez. Fertigstellungszeitpunkte
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = tauschLite(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'DLZbS',Gewichtung);
                                            
                                            case 4 % Zielfunktion: min! sum. Anzahl an Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = tauschLite(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'AUFbSD',Gewichtung,j);
                                            
                                            case 5 % Zielfunktion: min! sum. Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = tauschLite(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'UdFbSD',Gewichtung,j);
                                            
                                            case 6 % Zielfunktion: min! max. Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = tauschLite(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'sUFbSD',Gewichtung,j);
                                            
                                            case 7 % Zielfunktion: min! durchschnittliche Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = tauschLite(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'dUFbSD',Gewichtung,j);
                                            
                                            case 8 % Zielfunktion: min! sum. gewichtete Überschreitungen der Deadlines% Zielfunktion:
                                                [ZielfunktionswertVerb,OrderAuftragVerb,AnzVerg,AnzVerb,AnzNach,OrderArt] = tauschLite(str2num(DataVerb{k,10}),A,HZ,KZ,SP,DL,OrderArtikel,'gUFbSD',Gewichtung,j);
                                        end
                                        
                                        RechenzeitVerb = toc;

                                        absolutVerb = DataVerb{k,2} - ZielfunktionswertVerb;
                                        if absolutVerb == 0
                                            relativVerb = 0;
                                        else
                                            relativVerb = 100 * (absolutVerb / DataVerb{k,2});
                                        end

                                        DataVerb(k+v,:) = {'------2-Tausch Lite',ZielfunktionswertVerb,absolutVerb,relativVerb,AnzVerg,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArt),int2str(OrderAuftragVerb)};
                                                                                                                                                                
                                        if getappdata(Info_waitbar,'canceling')
                                            delete(Info_waitbar)
                                            KMT VerbesserungOhneSPG                        
                                        end
                                        % Report current estimate in the waitbar's message field
                                        waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                                        v = v+1;
                                        
                                    end
                                    
                                    k = k+v;

                                end
                                
                            end
                        k = k + 1;
                        end
                        
                    end

                    % Die Güte der Zielfunktionswerte mit in Data aufnehmen
                    AlleZielfunktionswerte = cell2mat(DataVerb(:,2));
                    Abweichung_rel = RelativeAbweichung(AlleZielfunktionswerte);
                    
                    % Passe die Länge von 'Abweichung_rel' an
                    PosNameVerb = find(cellfun('isempty',DataVerb(:,2))); % die Position der Überschriften in 'DataVerb'
                    PosNameVerb(1) = []; % die Position der ersten Überschrift ist immer 1 und kann gelöscht werden
                    Abweichung_rel = [cell(1,1);Abweichung_rel]; % an Position 1 wird in 'Abweichung_rel' eine leere Zelle für die 1. Überschrift eingefügt
                    
                    % bestimme die Differenz der Längen von 'Abweichung_rel' und 'DataVerb'
                    difl = size(DataVerb,1) - length(Abweichung_rel);
                    
                    for i = 1:difl
                       % füge für jede Überschrift, deren Position in 'PosNameVerb' gespeichert ist, an der jeweiligen Stelle eine leere Zelle in 'Abweichung_rel' ein
                       Abweichung_rel = [Abweichung_rel(1:PosNameVerb(i)-1,:) ; cell(1,1) ; Abweichung_rel(PosNameVerb(i):end,:)];
                    end
                    
                    % füge die relative Abweichung in 'DataVerb' ein
                    DataVerb = [DataVerb(:,1:2) Abweichung_rel DataVerb(:,3:end)];

                    % Einfärben (Bestimmung der Hintergrundfarben)
                    Backgroundcolor_Matrix = [];
                    for k = 1 : size(DataVerb,1)
                        DataVerb{k,2} = num2str(DataVerb{k,2},'%0.2f');
                        DataVerb{k,3} = num2str(DataVerb{k,3},'%0.4f');
                        DataVerb{k,4} = num2str(DataVerb{k,4},'%0.4f');
                        if size(Backgroundcolor_Matrix,1) < k
                            if SummeVerb == 1
                                if ~isempty(strfind(DataVerb{k,1},'Hierarchisch'))
                                   Backgroundcolor_Matrix = [Backgroundcolor_Matrix; 1 0.925490196078431 0.545098039215686; 1 0.925490196078431 0.545098039215686];
                                elseif ~isempty(strfind(DataVerb{k,1},'Rollierend'))
                                   Backgroundcolor_Matrix = [Backgroundcolor_Matrix; 0.529411764705882 0.807843137254902 0.980392156862745; 0.529411764705882 0.807843137254902 0.980392156862745];
                                elseif ~isempty(strfind(DataVerb{k,1},'Dynamisch'))
                                   Backgroundcolor_Matrix = [Backgroundcolor_Matrix; 0.596078431372549 0.984313725490196 0.596078431372549; 0.596078431372549 0.984313725490196 0.596078431372549];
                                else
                                   Backgroundcolor_Matrix = [Backgroundcolor_Matrix; 1 1 1];
                                end
                            elseif SummeVerb == 2
                                if ~isempty(strfind(DataVerb{k,1},'Hierarchisch'))
                                   Backgroundcolor_Matrix = [Backgroundcolor_Matrix; 1 0.925490196078431 0.545098039215686; 1 0.925490196078431 0.545098039215686; 1 0.925490196078431 0.545098039215686];
                                elseif ~isempty(strfind(DataVerb{k,1},'Rollierend'))
                                   Backgroundcolor_Matrix = [Backgroundcolor_Matrix; 0.529411764705882 0.807843137254902 0.980392156862745; 0.529411764705882 0.807843137254902 0.980392156862745; 0.529411764705882 0.807843137254902 0.980392156862745];
                                elseif ~isempty(strfind(DataVerb{k,1},'Dynamisch'))
                                   Backgroundcolor_Matrix = [Backgroundcolor_Matrix; 0.596078431372549 0.984313725490196 0.596078431372549; 0.596078431372549 0.984313725490196 0.596078431372549; 0.596078431372549 0.984313725490196 0.596078431372549];
                                else
                                   Backgroundcolor_Matrix = [Backgroundcolor_Matrix; 1 1 1];
                                end
                            end
                        end
                    end
                    
                    delete(Info_waitbar)
                    AusgabeVerb = DataVerb;
                    
                    Titel = {'Verfahren','Zielfunktionswert','Abweichung (%)','Absolute Verbesserung','Relative Verbesserung (%)','Anz. Vergleiche bis Best','Anz. Verbesserungen','Anz. Nachbarn','Rechenzeit (s)','Artikelreihenfolge','Auftragsreihenfolge' };  

                    hui(5700) = uitable('Data',AusgabeVerb,...
                                        'Units','normalized',...
                                        'Backgroundcolor',Backgroundcolor_Matrix,...
                                        'FontSize',Schriftgroesse1,...
                                        'FontUnits','normalized',...
                                        'ColumnFormat',{'char','char','char','char','char','char','char','char','char','char','char'},...
                                        'ColumnName',Titel,...
                                        'ColumnWidth',{600 'auto' 100 'auto' 'auto' 'auto' 'auto' 'auto' 120 500 500},...
                                        'ColumnEditable',[false false false false false false false false false false false],...
                                        'RowName',[],...
                                        'Position',[0 0.25 1 0.6]); 
                                    
                    hui(5701) = uicontrol('Style','push',...
                                          'Units','normalized',...
                                          'FontSize',Schriftgroesse1,...
                                          'FontUnits','normalized',...
                                          'Position',[.025 .1 .15 .05],...
                                          'String','zurück',...
                                          'CallBack','KMT BackVerbesserungMitSPGundDL');

                    hui(5702) = uicontrol('Style','push',...
                                          'Units','normalized',...
                                          'FontSize',Schriftgroesse1,...
                                          'FontUnits','normalized',...
                                          'Position',[.225 .1 .15 .05],...
                                          'String','neustart',...
                                          'CallBack','KMT');

                    hui(5703) = uicontrol('Style','push',...
                                          'Units','normalized',...
                                          'FontSize',Schriftgroesse1,...
                                          'FontUnits','normalized',...
                                          'Position',[.425 .1 .15 .05],...
                                          'String','speichern',...
                                          'CallBack','KMT SpeicherZmSPGundDLVerb');

                    hui(5704) = uicontrol('Style','push',...
                                          'Units','normalized',...
                                          'FontSize',Schriftgroesse1,...
                                          'FontUnits','normalized',...
                                          'Position',[.625 .1 .15 .05],...
                                          'String','speichern klein',...
                                          'CallBack','KMT SpeicherZmSPGundDL2Verb');

                    hui(5705) = uicontrol('Style','push',...
                                          'Units','normalized',...
                                          'FontSize',Schriftgroesse1,...
                                          'FontUnits','normalized',...
                                          'Position',[.825 .1 .15 .05],...
                                          'String','schließen',...
                                          'CallBack','close');
                    
                else % Mit zusätzlichen Abbruchbedingungen
                    
                    % Prüfen welche Abbruchbedingungen eingestellt wurden 
                    Abbruchbed1 = false;
                    Abbruchbed2 = false;
                    Abbruchbed3 = false;
                    
                    if ~isempty(Ab_zeit_str)
                        Abbruchbed1 = true; % Abbruchbedingung 1 ist aktiviert
                    end
                    if ~isempty(Ab_prozent2_str)
                        Abbruchbed2 = true; % Abbruchbedingung 2 ist aktiviert
                    end
                    if ~isempty(Ab_prozent3_str) && ~isempty(Ab_vergl_str)
                        Abbruchbed3 = true; % Abbruchbedingung 3 ist aktiviert
                    end
                    
                    DataVerb = cell(SumAuftragsVerfahrenVerbessern * SumArtikelVerfahrenVerbessern * (SummeVerb + 1) + SumAuftragsVerfahrenVerbessern,12);
                    
                    % schreibe die Überschriften der zur Verbesserung 
                    % ausgewählten Auftragsverfahren an die entsprechende
                    % Stelle der späteren Ausgabe 'DataVerb':
                    j = 0;
                    PosName = find(cellfun('isempty',Data(:,2))); % Zeilenposition der Namen der ausgewählten Auftragsverfahren in 'Data' 
                    for i = 1:size(AufVerb,1)
                        if AufVerb(i) == 1  
                            DataVerb(1+(size(DataVerb,1)/sum(AufVerb))*j,1) = Data(PosName(i),1);
                            j = j + 1;
                        end
                        
                    end
                    
                    k = 2;
                    [m,n] = size(A);
                    % gehe jedes Auftragsreihenfolgeverfahren durch
                    for i = 1:size(AufVerb,1)
                        if AufVerb(i) == 1
                            
                            % gehe jedes Artikelreihenfolgeverfahren durch
                            for j = 1:AnzArtikelVerfahren
                                
                                % berechne die ursprüngliche
                                % Artikelreihenfolge. (Diese Information
                                % ist verloren gegangen, es existiert nur
                                % noch die tatsächliche Holreihenfolge)
                                BZ = Bearbeitungszeit(A,HZ,KZ);
                                HA = Haufigkeit(A);
                                
                                switch j
                                    case 1
                                        OrderArtikel = [1:m]'; %#ok<*NBRAK> unterdrückt die Fehlermeldung, dass die Klammern überflüssig sind
                                    case 2
                                        OrderArtikel = minBmaxH(HA,BZ);
                                    case 3
                                        OrderArtikel = maxBmaxH(HA,BZ);
                                    case 4
                                        OrderArtikel = minHtopo(HA,BZ);
                                    case 5
                                        OrderArtikel = maxHtopo(HA,BZ);
                                    case 6
                                        OrderArtikel = maxHminB(HA,BZ);
                                    case 7
                                        OrderArtikel = maxHmaxB(HA,BZ);
                                    case 8
                                        OrderArtikel = zenReihAufst(HA);
                                    case 9
                                        OrderArtikel = zenReihAbst(HA);
                                    case 10
                                        OrderArtikel = minAtopo(A);
                                    case 11
                                        OrderArtikel = minAminB(A,BZ);
                                    case 12
                                        OrderArtikel = minAmaxB(A,BZ);
                                    case 13
                                        OrderArtikel = minAminH(A,HA);
                                    case 14
                                        OrderArtikel = minAmaxH(A,HA);
                                    case 15
                                        OrderArtikel = maxAtopo(A);
                                    case 16
                                        OrderArtikel = maxAminB(A,BZ);
                                    case 17
                                        OrderArtikel = maxAmaxB(A,BZ);
                                    case 18
                                        OrderArtikel = maxAminH(A,HA);
                                    case 19
                                        OrderArtikel = maxAmaxH(A,HA);
                                end
                                
                                if ArtVerbH(j) == 1
                                    
                                    v = 1;
                                    
                                    % finde die Zeile in Data, welche jetzt
                                    % verbessert werden soll (speichere in
                                    % lineNr)
                                    lineNr = find(ismember(Data(:,1),['---' ArtikelVerfahrenNamen{j} ' (Hierarchisch)']));
                                    DataVerb(k,:) = [Data(lineNr(i),1:2) ' ' ' ' ' ' ' ' ' ' ' ' ' ' Data(lineNr(i),4:end)];

                                    if VerbDL(1) == 1
                                        step = step + 1;

                                        switch Ziel 
                                            case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = insertDLA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'FSZbS',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);
 
                                            case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = insertDLA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'FFbS',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                            case 3 % Zielfunktion: min! sum. spez. Fertigstellungszeitpunkte
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = insertDLA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'DLZbS',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                            case 4 % Zielfunktion: min! sum. Anzahl an Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = insertDLA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'AUFbS',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                            case 5 % Zielfunktion: min! sum. Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = insertDLA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'UdFbS',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                            case 6 % Zielfunktion: min! max. Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = insertDLA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'sUFbS',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                            case 7 % Zielfunktion: min! durchschnittliche Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = insertDLA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'dUFbS',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                            case 8 % Zielfunktion: min! sum. gewichtete Überschreitungen der Deadlines 
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = insertDLA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'gUFbS',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);
                                        end

                                        absolutVerb = DataVerb{k,2} - ZielfunktionswertVerb;
                                        if absolutVerb == 0
                                            relativVerb = 0;
                                        else
                                            relativVerb = 100 * (absolutVerb / DataVerb{k,2});
                                        end
                                        
                                        DataVerb(k+v,:) = {'------Insert',ZielfunktionswertVerb,absolutVerb,relativVerb,Abbruchbed,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArt),int2str(OrderAuftragVerb)};
                                        
                                        if getappdata(Info_waitbar,'canceling')
                                            delete(Info_waitbar)
                                            KMT VerbesserungOhneSPG                        
                                        end
                                        % Report current estimate in the waitbar's message field
                                        waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                                        v = v+1;
                                        
                                    end
                                    
                                    if VerbDL(2) == 1
                                        step = step + 1;

                                        switch Ziel 
                                            case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = tauschLiteA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'FSZbS',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);
 
                                            case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = tauschLiteA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'FFbS',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                            case 3 % Zielfunktion: min! sum. spez. Fertigstellungszeitpunkte
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = tauschLiteA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'DLZbS',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                            case 4 % Zielfunktion: min! sum. Anzahl an Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = tauschLiteA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'AUFbS',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                            case 5 % Zielfunktion: min! sum. Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = tauschLiteA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'UdFbS',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                            case 6 % Zielfunktion: min! max. Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = tauschLiteA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'sUFbS',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                            case 7 % Zielfunktion: min! durchschnittliche Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = tauschLiteA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'dUFbS',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                            case 8 % Zielfunktion: min! sum. gewichtete Überschreitungen der Deadlines 
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = tauschLiteA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'gUFbS',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);
                                        end

                                        absolutVerb = DataVerb{k,2} - ZielfunktionswertVerb;
                                        if absolutVerb == 0
                                            relativVerb = 0;
                                        else
                                            relativVerb = 100 * (absolutVerb / DataVerb{k,2});
                                        end

                                        DataVerb(k+v,:) = {'------2-Tausch Lite',ZielfunktionswertVerb,absolutVerb,relativVerb,Abbruchbed,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArt),int2str(OrderAuftragVerb)};
                                        
                                        if getappdata(Info_waitbar,'canceling')
                                            delete(Info_waitbar)
                                            KMT VerbesserungOhneSPG                        
                                        end
                                        % Report current estimate in the waitbar's message field
                                        waitbar(step/steps,Info_waitbar,'Berechnung läuft...')
% 
                                        v = v+1;
                                        
                                    end
                                    
                                    k = k+v;
     
                                end
                                
                                
                                if ArtVerbR(j) == 1
                                    v = 1;
                                    
                                    % finde die Zeile in Data, welche jetzt
                                    % verbessert werden soll (speichere in
                                    % lineNr)
                                    lineNr = find(ismember(Data(:,1),['---' ArtikelVerfahrenNamen{j} ' (Rollierend)']));
                                    DataVerb(k,:) = [Data(lineNr(i),1:2) ' ' ' ' ' ' ' ' ' ' ' ' ' ' Data(lineNr(i),4:end)];

                                    if VerbDL(1) == 1
                                        step = step + 1;

                                        switch Ziel
                                            case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = insertDLA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'FSZbSR',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);
 
                                            case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = insertDLA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'FFbSR',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);
                                            
                                            case 3 % Zielfunktion: min! sum. spez. Fertigstellungszeitpunkte
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = insertDLA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'DLZbSR',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                            case 4 % Zielfunktion: min! sum. Anzahl an Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = insertDLA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'AUFbSR',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                            case 5 % Zielfunktion: min! sum. Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = insertDLA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'UdFbSR',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                            case 6 % Zielfunktion: min! max. Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = insertDLA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'sUFbSR',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                            case 7 % Zielfunktion: min! durchschnittliche Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = insertDLA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'dUFbSR',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                            case 8 % Zielfunktion: min! sum. gewichtete Überschreitungen der Deadlines 
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = insertDLA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'gUFbSR',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);
                                        end

                                        absolutVerb = DataVerb{k,2} - ZielfunktionswertVerb;
                                        if absolutVerb == 0
                                            relativVerb = 0;
                                        else
                                            relativVerb = 100 * (absolutVerb / DataVerb{k,2});
                                        end

                                        DataVerb(k+v,:) = {'------Insert',ZielfunktionswertVerb,absolutVerb,relativVerb,Abbruchbed,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArt),int2str(OrderAuftragVerb)};
                                        %DataVerb(k+v,:) = {'---2-Tausch First',ZielfunktionswertVerb,absolutVerb,relativVerb,Abbruchbed,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArtikelVerb),' '};
                                        

                                        if getappdata(Info_waitbar,'canceling')
                                            delete(Info_waitbar)
                                            KMT VerbesserungOhneSPG                        
                                        end
                                        % Report current estimate in the waitbar's message field
                                        waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                                        v = v+1;
                                        
                                    end
                                    
                                    
                                    if VerbDL(2) == 1
                                        step = step + 1;

                                        switch Ziel 
                                           case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = tauschLiteA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'FSZbSR',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);
 
                                            case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = tauschLiteA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'FFbSR',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                            case 3 % Zielfunktion: min! sum. spez. Fertigstellungszeitpunkte
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = tauschLiteA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'DLZbSR',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                            case 4 % Zielfunktion: min! sum. Anzahl an Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = tauschLiteA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'AUFbSR',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                            case 5 % Zielfunktion: min! sum. Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = tauschLiteA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'UdFbSR',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                            case 6 % Zielfunktion: min! max. Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = tauschLiteA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'sUFbSR',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                            case 7 % Zielfunktion: min! durchschnittliche Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = tauschLiteA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'dUFbSR',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                            case 8 % Zielfunktion: min! sum. gewichtete Überschreitungen der Deadlines 
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = tauschLiteA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'gUFbSR',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);
                                        end

                                        absolutVerb = DataVerb{k,2} - ZielfunktionswertVerb;
                                        if absolutVerb == 0
                                            relativVerb = 0;
                                        else
                                            relativVerb = 100 * (absolutVerb / DataVerb{k,2});
                                        end

                                        DataVerb(k+v,:) = {'------2-Tausch Lite',ZielfunktionswertVerb,absolutVerb,relativVerb,Abbruchbed,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArt),int2str(OrderAuftragVerb)};

                                        if getappdata(Info_waitbar,'canceling')
                                            delete(Info_waitbar)
                                            KMT VerbesserungOhneSPG                        
                                        end
                                        % Report current estimate in the waitbar's message field
                                        waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                                        v = v+1;
                                        
                                    end
                                    
                                    k = k+v;
     
                                end
                                
                                
                                if ArtVerbD(j) == 1
                                    
                                    v = 1;
                                    
                                    % finde die Zeile in Data, welche jetzt
                                    % verbessert werden soll (speichere in
                                    % lineNr)
                                    lineNr = find(ismember(Data(:,1),['---' ArtikelVerfahrenNamen{j} ' (Dynamisch)']));
                                    DataVerb(k,:) = [Data(lineNr(i),1:2) ' ' ' ' ' ' ' ' ' ' ' ' ' ' Data(lineNr(i),4:end)];

                                    if VerbDL(1) == 1
                                        step = step + 1;

                                        switch Ziel
                                            case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = insertDLA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'FSZbSR',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);
 
                                            case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = insertDLA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'FFbSR',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);
                                            
                                            case 3 % Zielfunktion: min! sum. spez. Fertigstellungszeitpunkte
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = insertDLA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'DLZbSR',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                            case 4 % Zielfunktion: min! sum. Anzahl an Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = insertDLA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'AUFbSD',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl,j);

                                            case 5 % Zielfunktion: min! sum. Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = insertDLA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'UdFbSD',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl,j);

                                            case 6 % Zielfunktion: min! max. Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = insertDLA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'sUFbSD',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl,j);

                                            case 7 % Zielfunktion: min! durchschnittliche Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = insertDLA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'dUFbSD',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl,j);

                                            case 8 % Zielfunktion: min! sum. gewichtete Überschreitungen der Deadlines 
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = insertDLA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'gUFbSD',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl,j);
                                        end

                                        absolutVerb = DataVerb{k,2} - ZielfunktionswertVerb;
                                        if absolutVerb == 0
                                            relativVerb = 0;
                                        else
                                            relativVerb = 100 * (absolutVerb / DataVerb{k,2});
                                        end

                                        DataVerb(k+v,:) = {'------Insert',ZielfunktionswertVerb,absolutVerb,relativVerb,Abbruchbed,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArt),int2str(OrderAuftragVerb)};
                                                                                                                                                                
                                        if getappdata(Info_waitbar,'canceling')
                                            delete(Info_waitbar)
                                            KMT VerbesserungOhneSPG                        
                                        end
                                        % Report current estimate in the waitbar's message field
                                        waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                                        v = v+1;
                                        
                                    end
                                    
                                    
                                    if VerbDL(2) == 1
                                        step = step + 1;

                                        tic % Rechenzeit beginnen

                                        switch Ziel 
                                           case 1 % Zielfunktion: min! sum. Fertigstellungszeitpunkte
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = tauschLiteA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'FSZbSD',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);
 
                                            case 2 % Zielfunktion: min! max. Fertigstellungszeitpunkt
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = tauschLiteA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'FFbSD',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                            case 3 % Zielfunktion: min! sum. spez. Fertigstellungszeitpunkte
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = tauschLiteA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'DLZbSD',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl);

                                            case 4 % Zielfunktion: min! sum. Anzahl an Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = tauschLiteA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'AUFbSD',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl,j);

                                            case 5 % Zielfunktion: min! sum. Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = tauschLiteA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'UdFbSD',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl,j);

                                            case 6 % Zielfunktion: min! max. Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = tauschLiteA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'sUFbSD',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl,j);

                                            case 7 % Zielfunktion: min! durchschnittliche Überschreitungen der Deadlines
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = tauschLiteA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'dUFbSD',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl,j);

                                            case 8 % Zielfunktion: min! sum. gewichtete Überschreitungen der Deadlines 
                                                [ZielfunktionswertVerb,Abbruchbed,OrderAuftragVerb,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,OrderArt,RechenzeitVerb] = tauschLiteA(str2num(DataVerb{k,12}),A,HZ,KZ,SP,DL,OrderArtikel,'gUFbSD',Gewichtung,Abbruchbed1,Abbruchbed2,Abbruchbed3,Ab_zeit,Ab_prozent2,Ab_prozent3,Ab_vergl,j);
                                        end
                                        
                                        RechenzeitVerb = toc;

                                        absolutVerb = DataVerb{k,2} - ZielfunktionswertVerb;
                                        if absolutVerb == 0
                                            relativVerb = 0;
                                        else
                                            relativVerb = 100 * (absolutVerb / DataVerb{k,2});
                                        end

                                        DataVerb(k+v,:) = {'------2-Tausch Lite',ZielfunktionswertVerb,absolutVerb,relativVerb,Abbruchbed,AnzVergIns,AnzVergBest,AnzVerb,AnzNach,RechenzeitVerb,int2str(OrderArt),int2str(OrderAuftragVerb)};
                                                                                                                                                                
                                        if getappdata(Info_waitbar,'canceling')
                                            delete(Info_waitbar)
                                            KMT VerbesserungOhneSPG                        
                                        end
                                        % Report current estimate in the waitbar's message field
                                        waitbar(step/steps,Info_waitbar,'Berechnung läuft...')

                                        v = v+1;
                                        
                                    end
                                    
                                    k = k+v;

                                end
                                
                            end
                        k = k + 1;
                        end
                         
                    end
                    
                    % Die Güte der Zielfunktionswerte mit in Data aufnehmen
                    AlleZielfunktionswerte = cell2mat(DataVerb(:,2));
                    Abweichung_rel = RelativeAbweichung(AlleZielfunktionswerte);
                    
                    % Passe die Länge von 'Abweichung_rel' an
                    PosNameVerb = find(cellfun('isempty',DataVerb(:,2))); % die Position der Überschriften in 'DataVerb'
                    PosNameVerb(1) = []; % die Position der ersten Überschrift ist immer 1 und kann gelöscht werden
                    Abweichung_rel = [cell(1,1);Abweichung_rel]; % an Position 1 wird in 'Abweichung_rel' eine leere Zelle für die 1. Überschrift eingefügt
                    
                    % bestimme die Differenz der Längen von 'Abweichung_rel' und 'DataVerb'
                    difl = size(DataVerb,1) - length(Abweichung_rel);
                    
                    for i = 1:difl
                       % füge für jede Überschrift, deren Position in 'PosNameVerb' gespeichert ist, an der jeweiligen Stelle eine leere Zelle in 'Abweichung_rel' ein
                       Abweichung_rel = [Abweichung_rel(1:PosNameVerb(i)-1,:) ; cell(1,1) ; Abweichung_rel(PosNameVerb(i):end,:)];
                    end
                    
                    % füge die relative Abweichung in 'DataVerb' ein
                    DataVerb = [DataVerb(:,1:2) Abweichung_rel DataVerb(:,3:end)];

                    % Einfärben (Bestimmung der Hintergrundfarben)
                    Backgroundcolor_Matrix = [];
                    for k = 1 : size(DataVerb,1)
                        DataVerb{k,2} = num2str(DataVerb{k,2},'%0.2f');
                        DataVerb{k,3} = num2str(DataVerb{k,3},'%0.4f');
                        DataVerb{k,4} = num2str(DataVerb{k,4},'%0.4f');
                        if size(Backgroundcolor_Matrix,1) < k
                            if SummeVerb == 1
                                if ~isempty(strfind(DataVerb{k,1},'Hierarchisch'))
                                   Backgroundcolor_Matrix = [Backgroundcolor_Matrix; 1 0.925490196078431 0.545098039215686; 1 0.925490196078431 0.545098039215686];
                                elseif ~isempty(strfind(DataVerb{k,1},'Rollierend'))
                                   Backgroundcolor_Matrix = [Backgroundcolor_Matrix; 0.529411764705882 0.807843137254902 0.980392156862745; 0.529411764705882 0.807843137254902 0.980392156862745];
                                elseif ~isempty(strfind(DataVerb{k,1},'Dynamisch'))
                                   Backgroundcolor_Matrix = [Backgroundcolor_Matrix; 0.596078431372549 0.984313725490196 0.596078431372549; 0.596078431372549 0.984313725490196 0.596078431372549];
                                else
                                   Backgroundcolor_Matrix = [Backgroundcolor_Matrix; 1 1 1];
                                end
                            elseif SummeVerb == 2
                                if ~isempty(strfind(DataVerb{k,1},'Hierarchisch'))
                                   Backgroundcolor_Matrix = [Backgroundcolor_Matrix; 1 0.925490196078431 0.545098039215686; 1 0.925490196078431 0.545098039215686; 1 0.925490196078431 0.545098039215686];
                                elseif ~isempty(strfind(DataVerb{k,1},'Rollierend'))
                                   Backgroundcolor_Matrix = [Backgroundcolor_Matrix; 0.529411764705882 0.807843137254902 0.980392156862745; 0.529411764705882 0.807843137254902 0.980392156862745; 0.529411764705882 0.807843137254902 0.980392156862745];
                                elseif ~isempty(strfind(DataVerb{k,1},'Dynamisch'))
                                   Backgroundcolor_Matrix = [Backgroundcolor_Matrix; 0.596078431372549 0.984313725490196 0.596078431372549; 0.596078431372549 0.984313725490196 0.596078431372549; 0.596078431372549 0.984313725490196 0.596078431372549];
                                else
                                   Backgroundcolor_Matrix = [Backgroundcolor_Matrix; 1 1 1];
                                end
                            end
                        end
                    end
                    
                    delete(Info_waitbar)
                    AusgabeVerb = DataVerb;
                    
                    Titel = {'Verfahren','Zielfunktionswert','Abweichung (%)','Absolute Verbesserung','Relative Verbesserung (%)','Abbruchbedingung','Anz. Vergleiche insgesamt','Anz. Vergleiche bis Best','Anz. Verbesserungen','Anz. Nachbarn','Rechenzeit (s)','Artikelreihenfolge','Auftragsreihenfolge' };  
                    hui(5700) = uitable('Data',AusgabeVerb,...
                                        'Units','normalized',...
                                        'Backgroundcolor',Backgroundcolor_Matrix,...
                                        'FontSize',Schriftgroesse1,...
                                        'FontUnits','normalized',...
                                        'ColumnFormat',{'char','char','char','char','char','char','char','char','char','char','char'},...
                                        'ColumnName',Titel,...
                                        'ColumnWidth',{600 'auto' 100 'auto' 'auto' 'auto' 'auto' 'auto' 120 'auto' 120 500 500},...
                                        'ColumnEditable',[false false false false false false false false false false false],...
                                        'RowName',[],...
                                        'Position',[0 0.25 1 0.6]); 
                                    
                    hui(5701) = uicontrol('Style','push',...
                                          'Units','normalized',...
                                          'FontSize',Schriftgroesse1,...
                                          'FontUnits','normalized',...
                                          'Position',[.025 .1 .15 .05],...
                                          'String','zurück',...
                                          'CallBack','KMT BackVerbesserungMitSPGundDL');

                    hui(5702) = uicontrol('Style','push',...
                                          'Units','normalized',...
                                          'FontSize',Schriftgroesse1,...
                                          'FontUnits','normalized',...
                                          'Position',[.225 .1 .15 .05],...
                                          'String','neustart',...
                                          'CallBack','KMT');

                    hui(5703) = uicontrol('Style','push',...
                                          'Units','normalized',...
                                          'FontSize',Schriftgroesse1,...
                                          'FontUnits','normalized',...
                                          'Position',[.425 .1 .15 .05],...
                                          'String','speichern',...
                                          'CallBack','KMT SpeicherZmSPGundDLVerb');

                    hui(5704) = uicontrol('Style','push',...
                                          'Units','normalized',...
                                          'FontSize',Schriftgroesse1,...
                                          'FontUnits','normalized',...
                                          'Position',[.625 .1 .15 .05],...
                                          'String','speichern klein',...
                                          'CallBack','KMT SpeicherZmSPGundDL2Verb');

                    hui(5705) = uicontrol('Style','push',...
                                          'Units','normalized',...
                                          'FontSize',Schriftgroesse1,...
                                          'FontUnits','normalized',...
                                          'Position',[.825 .1 .15 .05],...
                                          'String','schließen',...
                                          'CallBack','close');
                end
            end
            
            
        case 'SpeicherZmSPGundDL' % Für Zielfunktionen mit SPG
            AusgabedateiExcel = 'AusgabeZielfunktionMitSPGundDL.xlsx';
            AusgabedateiMat = 'AusgabeZielfunktionMitSPGundDL.mat';
            [AnzAusZmSPGundDL] = speichern(Titel,Ausgabe,AusgabedateiExcel,AnzAusZmSPGundDL,AusgabedateiMat);

        case 'SpeicherZmSPGundDLVerb' % Für Zielfunktionen mit SPG
            AusgabedateiExcel = 'AusgabeZielfunktionMitSPGundDL.xlsx';
            AusgabedateiMat = 'AusgabeZielfunktionMitSPGundDL.mat';
            [AnzAusZmSPGundDL] = speichern(Titel,AusgabeVerb,AusgabedateiExcel,AnzAusZmSPGundDLVerb,AusgabedateiMat);

        case 'SpeicherZmSPGundDL2' % Für Zielfunktionen mit SPG, speichern ohne Artikel- und Auftragsreihenfolge
            AusgabedateiExcel = 'AusgabeZielfunktionMitSPGundDL.xlsx';
            AusgabedateiMat = 'AusgabeZielfunktionMitSPGundDL.mat';
            [AnzAusZmSPGundDL] = speichern(Titel(:,1:4),Ausgabe(:,1:4),AusgabedateiExcel,AnzAusZmSPGundDL,AusgabedateiMat);

        case 'SpeicherZmSPGundDL2Verb' % Für Zielfunktionen mit SPG, speichern ohne Artikel- und Auftragsreihenfolge
            AusgabedateiExcel = 'AusgabeZielfunktionMitSPGundDL.xlsx';
            AusgabedateiMat = 'AusgabeZielfunktionMitSPGundDL.mat';
            [AnzAusZmSPGundDL] = speichern(Titel(:,1:4),AusgabeVerb(:,1:4),AusgabedateiExcel,AnzAusZmSPGundDLVerb,AusgabedateiMat);

        case 'BackAnzStellPlatzMitSPGundDL'
            set(hui(100),'String','Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion');
            set(hui(103),'Callback','KMT InfoZielfunktion');
            set(hui(2000),'Visible','off','Enable','inactive');
            set(hui(5101:5157),'Visible','off','Enable','inactive');
            set(hui(5160:5172),'Visible','off','Enable','inactive');
            Art = zeros(1,AnzArtikelVerfahren);
            KMT WeiterSeite2


        case 'BackArtikelVerfahrenMitSPGundDL'  
            tmp_value = get(hui(403),'Value');
            tmp_string = get(hui(403),'String');
            set(hui(100),'String',['Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion: ' tmp_string(tmp_value,:) '   >   Artikelreihenfolgeverfahren']);
            set(hui(103),'Callback','KMT InfoArtikelreihenfolgeverfahren');
            set(hui(2000),'Visible','on','Enable','inactive');
            set(hui(5101:5157),'Visible','on','Enable', 'on');
            set(hui(5160:5172),'Visible','on','Enable', 'on');
            set(hui(5200:5214),'Visible','off','Enable','inactive');
            Auf = zeros(1,AnzAuftragsVerfahrenMitDL);
            AufRest = zeros(1,AnzAuftragsVerfahren);   
 

        case 'BackAuftragVerfahrenMitSPGundDL'
            tmp_value = get(hui(403),'Value');
            tmp_string = get(hui(403),'String');
            set(hui(100),'String',['Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion: ' tmp_string(tmp_value,:) '   >   Artikelreihenfolgeverfahren   >   Auftragsreihenfolgeverfahren']);    
            set(hui(103),'Callback','KMT InfoAuftragsreihenfolgeverfahren');       
            set(hui(5300:5306),'Visible','off','Enable','inactive'); 
            set(hui(5200:5214),'Visible','on','Enable','on');
            switch DL_alle             
                case 0
                set(hui(5201:5204),'Enable','off'); 
                set(hui(5209),'Enable','off');
                case 1
                set(hui(5205:5207),'Enable','off');
                set(hui(5210:5211),'Enable','off');
            end

            
        case 'BackLösungMitSPGundDL'
            tmp_value = get(hui(403),'Value');
            tmp_string = get(hui(403),'String');
            set(hui(100),'String',['Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion: ' tmp_string(tmp_value,:) '   >   Artikelreihenfolgeverfahren   >   Auftragsreihenfolgeverfahren   >   Lösung']);
            set(hui(103),'Callback','KMT InfoLoesungArtAuf');
            set(hui(5300:5306),'Visible','on','Enable','on');
            set(hui(5400:(5404+sum(cellfun('isempty',Ausgabe(:,2))))),'Visible','off','Enable','inactive'); 
            % Erklärung zur letzten Zeile: um die Anzahl an auszuwählenden
            % Auftragsreihenfolgeverfahren zu bestimmen, wird auf jede
            % Zelle der 2. Spalte von 'Ausgabe' 'isempty' angewendet. In
            % dieser Spalte stehen die berechneten Zielfunktionswerte.
            % Steht in der Zeile jedoch die Überschrift eines
            % Auftragsverfahrens, so ist die 2. Spalte dieser Zeile leer.
            % Heraus kommt ein Vektor, der für jede Zeile in 'Ausgabe' 
            % eine 0 enthält, wenn diese eine Zahl beinhaltet, und eine 1,
            % wenn dies nicht der Fall ist. Davon wird dann die Summe
            % gebildet. So erhält man die Anzahl an ausgewählten
            % Auftragsreihenfolgeverfahren.
            
        case 'BackAuftragAuswahlVerbessernMitSPGundDL'
            tmp_value = get(hui(403),'Value');
            tmp_string = get(hui(403),'String');
            set(hui(100),'String',['Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion: ' tmp_string(tmp_value,:) '   >   Artikelreihenfolgeverfahren   >   Auftragsreihenfolgeverfahren   >   Lösung   >   Verbesserung']);
            set(hui(103),'Callback','KMT InfoVerbesserungMitDL');
            set(hui(5400:5404+sum(cellfun('isempty',Ausgabe(:,2)))),'Visible','on','Enable','on');
            set(hui(5500:5589),'Visible','off','Enable','inactive');
            
        case 'BackArtikelAuswahlVerbessernMitSPGundDL'
            tmp_value = get(hui(403),'Value');
            tmp_string = get(hui(403),'String');
            set(hui(100),'String',['Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion: ' tmp_string(tmp_value,:) '   >   Artikelreihenfolgeverfahren   >   Auftragsreihenfolgeverfahren   >   Lösung   >   Verbesserung']);
            set(hui(103),'Callback','KMT InfoArtVerbesserungMitDL');
            set(hui(5500:5589),'Visible','on','Enable','on');
            for i = 1:length(ArtikelVerfahrenNamen)
                if Art(i) == 0 
                    set(hui(i+5500),'Enable','off');
                end

                if ArtR(i) == 0
                    set(hui(i+5500+length(ArtikelVerfahrenNamen)),'Enable','off');
                end

                if ArtD(i) == 0
                    set(hui(i+5500+2*(length(ArtikelVerfahrenNamen))),'Enable','off');
                end
            end
            set(hui(5600:5617+AnzVerbesserungsVerfahrenDL),'Visible','off','Enable','inactive');
            
        case 'BackVerbesserungMitSPGundDL'
            tmp_value = get(hui(403),'Value');
            tmp_string = get(hui(403),'String');
            set(hui(100),'String',['Auftragsserie   >   Stellplatzbegrenzung und Deadline   >   Zielfunktion: ' tmp_string(tmp_value,:) '   >   Artikelreihenfolgeverfahren   >   Auftragsreihenfolgeverfahren   >   Lösung   >   Verbesserung   >   Verbesserungsverfahren']);
            set(hui(103),'Callback','KMT InfoVerbesserungsverfahrenMitDL');
            set(hui(5600:5617+AnzVerbesserungsVerfahrenDL),'Visible','on','Enable','on');
            if Plus_Abbruchbed == false
                set(hui(5602:5613),'Enable','off');
            end
            set(hui(5700:5705),'Visible','off','Enable','inactive');
            
            
        case 'OKAufMitSPGundDL'
            Auf = [get(hui(5201),'Value')
                   get(hui(5202),'Value')
                   get(hui(5203),'Value')
                   get(hui(5204),'Value')]; 
            if sum(Auf) == 0
                errordlg('Bitte wählen Sie mindestens ein Auftragsreihenfolgeverfahren aus.','Fehler')
            else
                
                if (Auf(2) == 1 || Auf(3) == 1 || Auf(4) == 1) %&& ~isempty(isinf(DL))
                    set(hui(5205:5207),'Enable','on');
                    Text = ['Sie haben das Verfahren',...
                        ' "Anordnung nach aufsteigender',...
                        ' Deadline" bzw. "Anordnung nach aufsteigender',...
                        ' Pufferzeit" ausgewählt. Bitte geben'...
                        ' Sie an, welches Verfahren auf',...
                        ' Aufträge mit unendlich großer Deadline',...
                        ' bzw. bei gleicher Deadline angewendet werden soll.']; 
                    helpdlg(Text,'Information');
                    DL_alle = 0;        % DL_alle == 0 heißt, es gibt Aufträge ohne DL (DL == 0). 
                else
                    DL_alle = 1;        % DL_alle == 1 heißt, alle Aufträge haben eine DL > 0.
                end
                
                set(hui(5201:5204),'Enable','off');
                DL_enabled = 0;
                set(hui(5209),'Enable','off');
                set(hui(5210:5211),'Enable','on');
            end
        
            
        case 'AendernAufMitSPGundDL'
            set(hui(5201:5204),'Enable','on');
            DL_enabled = 1;
            DL_alle = 1; % DL_alle == 1 heißt, alle Aufträge haben eine DL > 0 (Grundannahme).
            set(hui(5205:5207),'Enable','off','Value', 0);
            set(hui(5209),'Enable','on');
            set(hui(5210:5211),'Enable','off');
                        
        case 'AlleArtikelVerfahrenMitSPGundDL'
            Art = ones(1,AnzArtikelVerfahren); 
            ArtR = ones(1,AnzArtikelVerfahren);
            ArtD = ones(1,AnzArtikelVerfahren);
            set(hui(5101:5157),'Value',1);


        case 'KeineArtikelVerfahrenMitSPGundDL'
            Art = zeros(1,AnzArtikelVerfahren);
            ArtR = zeros(1,AnzArtikelVerfahren);
            ArtD = zeros(1,AnzArtikelVerfahren);
            set(hui(5101:5157),'Value',0); %disable all checkboxes
            set(hui(5166:5168),'Value',0); %disable head-checkboxes 


        case 'AlleAuftragVerfahrenMitSPGundDL'
            if DL_enabled == 1
                Auf = ones(1,AnzAuftragsVerfahrenMitDL);
                set(hui(5201:5204),'Value',1);
            else
                AufRest = ones(1,AnzAuftragsVerfahren);
                set(hui(5205:5207),'Value',1);
            end

            
        case 'KeineAuftragVerfahrenMitSPGundDL'
            if DL_enabled == 1
                Auf = ones(1,AnzAuftragsVerfahrenMitDL);
                set(hui(5201:5204),'Value',0);
            else
                AufRest = ones(1,AnzAuftragsVerfahren);
                set(hui(5205:5207),'Value',0);
            end

            
        case 'AlleAufVerMitSPGundDL'
            set(hui(5405:(5404+sum(cellfun('isempty',Ausgabe(:,2))))),'Value',1);
            
            
        case 'KeinAufVerMitSPGundDL'
            set(hui(5405:(5404+sum(cellfun('isempty',Ausgabe(:,2))))),'Value',0);
            
            
        case 'AlleArtikelVerfahrenMitSPGundDLVer'
            for i = 1:length(ArtikelVerfahrenNamen)
                if Art(i) == 1
                    set(hui(i+5500),'Value',1);
                end
                if ArtR(i) == 1
                    set(hui(i+5500+(length(ArtikelVerfahrenNamen))),'Value',1);
                end
                if ArtD(i) == 1
                    set(hui(i+5500+2*(length(ArtikelVerfahrenNamen))),'Value',1);
                end
            end
            
            
        case 'KeineArtikelVerfahrenMitSPGundDLVer'
            for i = 1:length(ArtikelVerfahrenNamen)
                if Art(i) == 1
                    set(hui(i+5500),'Value',0);
                end
                if ArtR(i) == 1
                    set(hui(i+5500+(length(ArtikelVerfahrenNamen))),'Value',0);
                end
                if ArtD(i) == 1
                    set(hui(i+5500+2*(length(ArtikelVerfahrenNamen))),'Value',0);
                end
            end
            
            
        case 'AlleAuftragsVerfahrenMitSPGundDLVer'
            VerbDL = ones(1,AnzVerbesserungsVerfahrenDL);
            set(hui(5618:5617+AnzVerbesserungsVerfahrenDL),'Value',1);
            
            
        case 'KeinAuftragsVerfahrenMitSPGundDLVer'
            VerbDL = ones(1,AnzVerbesserungsVerfahrenDL);
            set(hui(5618:5617+AnzVerbesserungsVerfahrenDL),'Value',0);
            
            
        case 'AlleDynamischDL'
            if get(hui(5166),'Value') == 1
               set(hui(5139:5157),'Value',1); 
            else
               set(hui(5139:5157),'Value',0); 
            end
            
            
        case 'AlleRollierendDL'
            if get(hui(5167),'Value') == 1
               set(hui(5120:5138),'Value',1); 
            else
               set(hui(5120:5138),'Value',0); 
            end
            
            
        case 'AlleHierarchischDL'
            if get(hui(5168),'Value') == 1
               set(hui(5101:5119),'Value',1); 
            else
               set(hui(5101:5119),'Value',0); 
            end
            
            
        case 'AlleDynamischDLVer'
            if get(hui(5583),'Value') == 1
                for i = 1:length(ArtikelVerfahrenNamen)
                    if ArtD(i) == 1
                        set(hui(i+5500+2*(length(ArtikelVerfahrenNamen))),'Value',1);
                    end
                end
            else
                for i = 1:length(ArtikelVerfahrenNamen)
                    if ArtD(i) == 1
                        set(hui(i+5500+2*(length(ArtikelVerfahrenNamen))),'Value',0);
                    end
                end
            end
            
            
        case 'AlleRollierendDLVer'
            if get(hui(5584),'Value') == 1
                for i = 1:length(ArtikelVerfahrenNamen)
                    if ArtR(i) == 1
                        set(hui(i+5500+length(ArtikelVerfahrenNamen)),'Value',1);
                    end
                end
            else
                for i = 1:length(ArtikelVerfahrenNamen)
                    if ArtR(i) == 1
                        set(hui(i+5500+length(ArtikelVerfahrenNamen)),'Value',0);
                    end
                end
            end
            
            
        case 'AlleHierarchischDLVer'
            if get(hui(5585),'Value') == 1
                for i = 1:length(ArtikelVerfahrenNamen)
                    if Art(i) == 1
                        set(hui(i+5500),'Value',1);
                    end
                end
            else
                for i = 1:length(ArtikelVerfahrenNamen)
                    if Art(i) == 1
                        set(hui(i+5500),'Value',0);
                    end
                end
            end
        %%
                 %% Fehlerabfrage    
        
        otherwise
        	clf;
            hui(6000) = uicontrol('Style','text',...
                                  'Units','normalized',...
                                  'FontSize',SchriftgroesseFehler,...
                                  'FontUnits','normalized',...
                                  'String','Fehler',...
                                  'Position',[.1 .3 .8 .4]);
    end
    
end  

clear

end % Function
 