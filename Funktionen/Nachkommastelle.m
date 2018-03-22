function  [stelle] = Nachkommastelle(text)
%
% [stelle] = <strong>Nachkommastelle</strong>(text)
%
% Liefert die Nachkommastelle aus einem Wert, der als string angegeben
% werden muss.
%
% Parameter:
%   text: numerischer Wert


stelle = length(text) - find(text == '.');

if isempty(stelle)
    stelle = 0;
end