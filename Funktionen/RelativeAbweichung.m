function Abweichung = RelativeAbweichung(Zielfunktionswert)
%
% Abweichung = <strong>RelativeAbweichung</strong>(Zielfunktionswert)
%
% Berechnet die relative Abweichung (in Prozent) der Zielfunktionswerte von
% dem besten Zielfunktionswert.
%
% Parameter:
%   Zielfunktionswert: Vektor der Zielfunktionswerte f�r die jeweiligen Verfahren
%   Abweichung: relative Abweichung der Zielfunktionswerte


Zielfunktionswert = round(Zielfunktionswert,10); % Rechengenauigkeitsprobleme beheben,
                                                 % indem man auf die 10te
                                                 % Nachkommastelle rundet

miniZielfunktionswert = min(Zielfunktionswert);

Abweichung = cell(length(Zielfunktionswert),1);

if miniZielfunktionswert == 0
    for i = 1:length(Zielfunktionswert)    
        if Zielfunktionswert(i) == 0
            Abweichung{i} = '<html><body bgcolor="#ff0000">0</body></html>';
        else
            Abweichung{i} = '-';
        end
    end
else
    for i = 1:length(Zielfunktionswert)
        if Zielfunktionswert(i) == miniZielfunktionswert
            Abweichung{i} = '<html><body bgcolor="#ff0000">0</body></html>';
        else
            Abweichung{i} = 100 * ((Zielfunktionswert(i)-miniZielfunktionswert) / miniZielfunktionswert);
        end
    end
end

% #00CC07 gr�n1
% #0FFB13 gr�n2



end