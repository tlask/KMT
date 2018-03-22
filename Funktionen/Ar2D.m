function [Abweichung_rel_out] = Ar2D (AnzVerf,Abweichung_rel,SumArt,SumArtR,SumArtD)
%
% [Abweichung_rel] = <strong>Ar2D</strong>(AnzVerf,Abweichung_rel,SumArt,SumArtR,SumArtD)
%
% Fügt dem Vektor "Abweichung_rel" an den passenden Stellen eine Leerzeile
% hinzu, damit er in die Ausgabe-Datei eingebunden werden kann.
%
% Parameter:
%   Abweichung_rel_out: Vektor der Abweichungen; für jedes Verfahren ist eine 
%                       Leerzeile an der passenden Stelle eingefügt
%   AnzVerf: Anzahl an ausgewählten Verfahren, welche die Anzahl an 
%            benötigten Leerzeilen vorgibt.
%   Abweichung_rel: Vektor der Abweichungen
%   SumArt:  Summe der hierarchischen Artikelreihenfolgeverfahren
%   SumArtR: Summe der rollierenden Artikelreihenfolgeverfahren
%   SumArtD: Summe der dynamischen Artikelreihenfolgeverfahren


SumArtGesamt = SumArt+SumArtR+SumArtD;

switch AnzVerf
    
    case 1
         Abweichung_rel_out = [cell(1,1)
                            Abweichung_rel];
    case 2
          Abweichung_rel_out = [cell(1,1)
                              Abweichung_rel(1:(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+(SumArtGesamt):end)];
    case 3
         Abweichung_rel_out = [cell(1,1)
                              Abweichung_rel(1:(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+(SumArtGesamt):2*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+2*(SumArtGesamt):end)];
    case 4
        Abweichung_rel_out = [cell(1,1)
                              Abweichung_rel(1:(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+(SumArtGesamt):2*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+2*(SumArtGesamt):3*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+3*(SumArtGesamt):end)];
    case 5
        Abweichung_rel_out = [cell(1,1)
                              Abweichung_rel(1:(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+(SumArtGesamt):2*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+2*(SumArtGesamt):3*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+3*(SumArtGesamt):4*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+4*(SumArtGesamt):end)];
    case 6
        Abweichung_rel_out = [cell(1,1)
                              Abweichung_rel(1:(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+(SumArtGesamt):2*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+2*(SumArtGesamt):3*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+3*(SumArtGesamt):4*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+4*(SumArtGesamt):5*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+5*(SumArtGesamt):end)];
    case 7
        Abweichung_rel_out = [cell(1,1)
                              Abweichung_rel(1:(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+(SumArtGesamt):2*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+2*(SumArtGesamt):3*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+3*(SumArtGesamt):4*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+4*(SumArtGesamt):5*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+5*(SumArtGesamt):6*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+6*(SumArtGesamt):end)];
    case 8
        Abweichung_rel_out = [cell(1,1)
                              Abweichung_rel(1:(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+(SumArtGesamt):2*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+2*(SumArtGesamt):3*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+3*(SumArtGesamt):4*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+4*(SumArtGesamt):5*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+5*(SumArtGesamt):6*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+6*(SumArtGesamt):7*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+7*(SumArtGesamt):end)];
    case 9
        Abweichung_rel_out = [cell(1,1)
                              Abweichung_rel(1:(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+(SumArtGesamt):2*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+2*(SumArtGesamt):3*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+3*(SumArtGesamt):4*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+4*(SumArtGesamt):5*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+5*(SumArtGesamt):6*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+6*(SumArtGesamt):7*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+7*(SumArtGesamt):8*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+8*(SumArtGesamt):end)];
    case 10
        Abweichung_rel_out = [cell(1,1)
                              Abweichung_rel(1:(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+(SumArtGesamt):2*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+2*(SumArtGesamt):3*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+3*(SumArtGesamt):4*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+4*(SumArtGesamt):5*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+5*(SumArtGesamt):6*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+6*(SumArtGesamt):7*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+7*(SumArtGesamt):8*(SumArtGesamt),:)
                               cell(1,1)
                              Abweichung_rel(1+8*(SumArtGesamt):9*(SumArtGesamt),:)
                              cell(1,1)
                              Abweichung_rel(1+9*(SumArtGesamt):end)];
end
end