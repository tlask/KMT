function [erg] = FehlerhafterAuftrag(A,HZ,KZ)
%
% [erg] = <strong>FehlerhafterAuftrag</strong>(A,HZ,KZ)
%
% Pr�ft, ob die Zuweisungsmatrix sowie der Holzeitenvektor und der
% Kommissionierzeitvektor zul�ssig sind.
%
% Parameter:
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten St�ckzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   HZ: Holzeit [ZE]
%   KZ: Kommissionierzeit [ZE/ME]
%   erg: Gibt true zur�ck, wenn der Auftrag fehlerhaft ist sonst false


erg = false;
[m,n] = size(A);
h = zeros(m,1); % Gibt an in wie vielen Auftr�gen ein Artikel vorkommt
a = zeros(1,n); % Gibt an wie viele verschiedene Artikel in einem Auftrag vorkommen

% Zuweisungsmatrix A pr�fen
for i = 1:m
    for j = 1:n
        if A(i,j) < 0 || round(A(i,j)) ~= A(i,j) % Nichtnegativ und ganzzahlig
            erg = true;
        end
        if A(i,j) > 0 
            h(i) = h(i) + 1;
            a(j) = a(j) + 1;
        end
    end
end

% Nullzeile
if find(h==0)
    erg = true;
end

% Nullspalte
if find(a==0)
    erg = true;
end


% Holzeitenvektor HZ pr�fen
if find(HZ<0)
    erg = true;
end


% Kommissionierzeitektor KZ pr�fen
if find(KZ<0)
    erg = true;
end


end