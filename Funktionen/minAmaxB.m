function [Order] = minAmaxB(A,BZ)
%
% [Order] = <strong>minAmaxB</strong>(A,BZ)
%
% Artikelreihenfolgeverfahren:
%   Anordnung nach minimaler Auftragsl�nge und maximaler Bearbeitungszeit
%
% Parameter:
%   A: Zuweisungsmatrix (mxn Matrix) mit nachgefragten St�ckzahlen [ME]
%      von Artikel Pi (i = 1...m) im Auftrag Aj (j = 1...n)
%   BZ: Bearbeitungszeit [ZE]
%   Order: Artikelreihenfolge


[m,n] = size(A);

AL = AuftragsLaenge(A);

Order = zeros(m,1);

for i = 1:m
    clear BenoetigteArt;
    nichtAbgeschlosseneAuf = find(AL);
    kleinsteNichtAbgeschlosseneAuf = find(AL(nichtAbgeschlosseneAuf)==min(AL(nichtAbgeschlosseneAuf)));
    j = 1;
    for l = 1:m
        if sum(A(l,nichtAbgeschlosseneAuf(kleinsteNichtAbgeschlosseneAuf))>zeros(1,length(kleinsteNichtAbgeschlosseneAuf))) > 0;
            BenoetigteArt(j) = l; %#ok<AGROW> Unterdr�ckt die Fehlermeldung, dass sich die Gr��e von BenoetigteArt ver�ndert
            j = j+1;
        end
    end
    
    % Falls eine Nullspalte in der Matrix vorhanden ist, wird der
    % n�chstm�gliche Wert genommen
    tmp_exist = exist('BenoetigteArt');
    if tmp_exist
        BZmaxArt = find(BZ(BenoetigteArt)==max(BZ(BenoetigteArt)),1,'first');
        Order(i) = BenoetigteArt(BZmaxArt);
        A(BenoetigteArt(BZmaxArt),:) = zeros(1,n);
        AL = AuftragsLaenge(A);
    else
        tmp_vec = setdiff([1:m]',Order); % sonst normal weiter
        Order(find(Order(:,1) == 0,1),1) = tmp_vec(1);
    end
end

end
