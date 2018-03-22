function [Platz] = Platzierung(Abweichung)
% 
% [Platz] = <strong>Platzierung</strong>(Abweichung)
%
% Gibt in ganzen Zahlen an, wie gut die Verfahren sind.
% Das beste Verfahren hat die Platzierung 1.
% Das nächstbeste Verfahren hat die Platzierung 2 usw.
%
% Parameter:
%   Abweichung: relative Abweichung der Zielfunktionswerte
%   Platz: Platzierung der Verfahren


Platz = zeros(size(Abweichung));
index = 1; % Platzierung

while index <= length(Abweichung)
    x = find(Abweichung==min(Abweichung)); % Findet die Stelle, wo das Minimum ist.
    Abweichung(x) = inf;
    Platz(x) = index;
    index = index + length(x);
end

end
