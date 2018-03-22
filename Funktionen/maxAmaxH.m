function [Order] = maxAmaxH(A,HA)
%
% [Order] = <strong>maxAmaxH</strong>(A,HA)
%
% Artikelreihenfolgeverfahren:
%   Anordnung nach maximaler Auftragslänge und maximaler Häufigkeit
%
% Parameter:
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten Stückzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   HA: Häufigkeit der Artikel
%   Order: Artikelreihenfolge


[m,n] = size(A);

AL = AuftragsLaenge(A);

Order = zeros(m,1);

for i = 1:m
    clear BenoetigteArt;
    nichtAbgeschlosseneAuf = find(AL);
    groessteNichtAbgeschlosseneAuf = find(AL(nichtAbgeschlosseneAuf)==max(AL(nichtAbgeschlosseneAuf)));
    j = 1;
    for l = 1:m
        if sum(A(l,nichtAbgeschlosseneAuf(groessteNichtAbgeschlosseneAuf))>zeros(1,length(groessteNichtAbgeschlosseneAuf))) > 0;
            BenoetigteArt(j) = l;%#ok<AGROW> Unterdrückt die Fehlermeldung, dass sich die Größe von BenoetigteArt verändert
            j = j+1;
        end
    end
    
    % Falls eine Nullspalte in der Matrix vorhanden ist, wird der
    % nächstmögliche Wert genommen
    tmp_exist = exist('BenoetigteArt');
    if tmp_exist
        HAmaxArt = find(HA(BenoetigteArt)==max(HA(BenoetigteArt)),1,'first');
        Order(i) = BenoetigteArt(HAmaxArt);
        A(BenoetigteArt(HAmaxArt),:) = zeros(1,n);
        AL = AuftragsLaenge(A);
    else
        tmp_vec = setdiff([1:m]',Order); % sonst normal weiter
        Order(find(Order(:,1) == 0,1),1) = tmp_vec(1);
    end
end

end

