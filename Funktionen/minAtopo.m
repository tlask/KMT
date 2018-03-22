function [Order] = minAtopo(A)
%
% [Order] = <strong>minAtopo</strong>(A)
%
% Artikelreihenfolgeverfahren:
%   Anordnung nach minimaler Auftragslänge und topologischer Reihenfolge
%
% Parameter:
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten Stückzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   Order: Artikelreihenfolge


[m,n] = size(A);

AL = AuftragsLaenge(A);

Order = zeros(m,1);

for i = 1:m
    nichtAbgeschlosseneAuf = find(AL);
    kleinsteNichtAbgeschlosseneAufIndex = find(AL(nichtAbgeschlosseneAuf)==min(AL(nichtAbgeschlosseneAuf)));
    kleinsteNichtAbgeschlosseneAuf = nichtAbgeschlosseneAuf(kleinsteNichtAbgeschlosseneAufIndex); %#ok<FNDSB>
    j = 1;
    l = 1; % Index des Artikels
    while j < 2 && l <= m % Bis der erste Artikel gefunden wurde, der in den Aufträgen vorkommt 
        if sum(A(l,kleinsteNichtAbgeschlosseneAuf)>zeros(1,length(kleinsteNichtAbgeschlosseneAuf))) > 0
            BenoetigteArt = l;
            j = j+1;
        end
        l = l+1; % Prüfen, ob der nächste Artikel im Auftrag enthalten ist
    end
    
    % Falls eine Nullspalte in der Matrix vorhanden ist, wird der
    % nächstmögliche Wert genommen
    if ~isempty(find(Order(:,1) == BenoetigteArt,1))
        tmp_vec = setdiff([1:m]',Order);
        Order(find(Order(:,1) == 0,1),1) = tmp_vec(1);
    else
       Order(i) = BenoetigteArt; % Den Artikel mit dem kleinsten Index (sonst normal weiter)
    end
    A(BenoetigteArt,:) = zeros(1,n);
    AL = AuftragsLaenge(A);
end

end