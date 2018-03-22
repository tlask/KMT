function [M,HZ,KZ,DL] = ZufaelligeZuweisungsmatrix(m,n,lamda,mat_int1,mat_int2,hz_int1,hz_int2,kz_int1,kz_int2,nachk_hz_int1,nachk_hz_int2,nachk_kz_int1,nachk_kz_int2,dl_menge,dl_int1,dl_int2,nachk_dl_int1,nachk_dl_int2)
% 
% [M,HZ,KZ] = <strong>ZufaelligeZuweisungsmatrix</strong>(m,n,lamda,mat_int1,mat_int2,hz_int1,hz_int2,kz_int1,kz_int2,nachk_hz_int1,nachk_hz_int2,nachk_kz_int1,nachk_kz_int2)
% 
% Liefert eine mxn-Zuweisungsmatrix, dabei werden die Werte
% zufällig, mit einer Dichte von lamda, erzeugt. Die Dichte gibt an, wie 
% viel Prozent der Matrix mit Nichtnullelementen belegt ist.
% Des Weiteren werden die beiden Vektoren für die Holzeit und die 
% Kommissionierzeit der Artikel zufällig erstellt. 
%
% Parameter:
%   m: Anzahl der Artikel
%   n: Anzahl der Aufträge
%   lamda: Dichte der Zuweisungsmatrix
%   mat_int1: Intervallanfang der Zufallszahlen für die Zuweisungsmatrix
%   mat_int2: Intervallende der Zufallszahlen für die Zuweisungsmatrix
%   hz_int1: Intervallanfang der Zufallszahlen für die Holzeiten der Artikel
%   hz_int2: Intervallende der Zufallszahlen für die Holzeiten der Artikel
%   kz_int1: Intervallanfang der Zufallszahlen für die Kommissionierzeiten der Artikel
%   kz_int2: Intervallende der Zufallszahlen für die Kommissionierzeiten der Artikel
%   nachk_hz_int1: Nachkommestelle für den Intervallanfang der Zufallszahlen für die Holzeiten der Artikel
%   nachk_hz_int2: Nachkommestelle für das Intervallende der Zufallszahlen für die Holzeiten der Artikel
%   nachk_kz_int1: Nachkommestelle für den Intervallanfang der Zufallszahlen für die Kommissionierzeiten der Artikel
%   nachk_kz_int2: Nachkommestelle für das Intervallende der Zufallszahlen für die Kommissionierzeiten der Artikel


% Rechengenauigkeitsprobleme beheben, indem man 
% auf die 5te Nachkommastelle rundet
nachk_hz_int1 = round(nachk_hz_int1,5); 
nachk_hz_int2 = round(nachk_hz_int2,5); 
nachk_kz_int1 = round(nachk_kz_int1,5); 
nachk_kz_int2 = round(nachk_kz_int2,5); 
if dl_menge > 1
    nachk_dl_int1 = round(nachk_dl_int1,5);
    nachk_dl_int2 = round(nachk_dl_int2,5);
end

% Intervallgrenzen anpassen, dass es keine Nachkommastellen mehr gibt 
hz_multipli = 1;
if nachk_hz_int1 > nachk_hz_int2
    if nachk_hz_int1 == 1
        hz_int1 = hz_int1 * 10;
        hz_int2 = hz_int2 * 10;
        hz_multipli = 10;
    end
    if nachk_hz_int1 == 2
        hz_int1 = hz_int1 * 100;
        hz_int2 = hz_int2 * 100;
        hz_multipli = 100;
    end
    if nachk_hz_int1 == 3
        hz_int1 = hz_int1 * 1000;
        hz_int2 = hz_int2 * 1000;
        hz_multipli = 1000;
    end
else
    if nachk_hz_int2 == 1
        hz_int1 = hz_int1 * 10;
        hz_int2 = hz_int2 * 10;
        hz_multipli = 10;
    end
    if nachk_hz_int2 == 2
        hz_int1 = hz_int1 * 100;
        hz_int2 = hz_int2 * 100;
        hz_multipli = 100;
    end
    if nachk_hz_int2 == 3
        hz_int1 = hz_int1 * 1000;
        hz_int2 = hz_int2 * 1000;
        hz_multipli = 1000;
    end
end

kz_multipli = 1;
if nachk_kz_int1 > nachk_kz_int2
    if nachk_kz_int1 == 1
        kz_int1 = kz_int1 * 10;
        kz_int2 = kz_int2 * 10;
        kz_multipli = 10;
    end
    if nachk_kz_int1 == 2
        kz_int1 = kz_int1 * 100;
        kz_int2 = kz_int2 * 100;
        kz_multipli = 100;
    end
    if nachk_kz_int1 == 3
        kz_int1 = kz_int1 * 1000;
        kz_int2 = kz_int2 * 1000;
        kz_multipli = 1000;
    end
else
    if nachk_kz_int2 == 1
        kz_int1 = kz_int1 * 10;
        kz_int2 = kz_int2 * 10;
        kz_multipli = 10;
    end
    if nachk_kz_int2 == 2
        kz_int1 = kz_int1 * 100;
        kz_int2 = kz_int2 * 100;
        kz_multipli = 100;
    end
    if nachk_kz_int2 == 3
        kz_int1 = kz_int1 * 1000;
        kz_int2 = kz_int2 * 1000;
        kz_multipli = 1000;
    end
end

if dl_menge > 1
dl_multipli = 1;
    if nachk_dl_int1 > nachk_dl_int2
        if nachk_dl_int1 == 1
            dl_int1 = dl_int1 * 10;
            dl_int2 = dl_int2 * 10;
            dl_multipli = 10;
        end
        if nachk_dl_int1 == 2
            dl_int1 = dl_int1 * 100;
            dl_int2 = dl_int2 * 100;
            dl_multipli = 100;
        end
        if nachk_dl_int1 == 3
            dl_int1 = dl_int1 * 1000;
            dl_int2 = dl_int2 * 1000;
            dl_multipli = 1000;
        end
    else
        if nachk_dl_int2 == 1
            dl_int1 = dl_int1 * 10;
            dl_int2 = dl_int2 * 10;
            dl_multipli = 10;
        end
        if nachk_dl_int2 == 2
            dl_int1 = dl_int1 * 100;
            dl_int2 = dl_int2 * 100;
            dl_multipli = 100;
        end
        if nachk_dl_int2 == 3
            dl_int1 = dl_int1 * 1000;
            dl_int2 = dl_int2 * 1000;
            dl_multipli = 1000;
        end
    end
end

M = rand(m,n);
HZ = randi([hz_int1,hz_int2],m,1)/hz_multipli;
KZ = randi([kz_int1,kz_int2],m,1)/kz_multipli;
h = zeros(m,1);
a = zeros(1,n);
DL = Inf(n,1);

if dl_menge > 1
    if dl_menge == 2 % 'wenige'
        anzahl_dl = ceil(n*0.3);
    elseif dl_menge == 3 % 'mitte'
        anzahl_dl = ceil(n*0.5);
    elseif dl_menge == 4 % 'viele'
        anzahl_dl = ceil(n*0.7);
    elseif dl_menge == 5 % 'alle'
        anzahl_dl = m;
    end
    position_dl = randperm(n,anzahl_dl);
    DL(position_dl) = randi([dl_int1,dl_int2],anzahl_dl,1)/dl_multipli;
end

% Damit nicht noch mehr Nullen in der Zuweisungsmatrix entstehen
if mat_int1 == 0 && mat_int1~= mat_int2
    mat_int1 = mat_int1 + 1;
end

for i = 1:m
    for j = 1:n
        if M(i,j) < lamda
            M(i,j) = 1*randi([mat_int1,mat_int2]);
            h(i) = h(i) + 1;
            a(j) = a(j) + 1;
        else
            M(i,j) = 0;
        end
    end
end

for i = 1:m % Wenn M eine Nullzeile enthält, wird eine zufällige Spalte
            % gewählt, in der die Null durch eine Zufallszahl ersetzt wird.
    if h(i) == 0
        k = ceil(rand*(n));
        M(i,k) = 1*randi([mat_int1,mat_int2]);
        h(i) = 1;
        a(k) = a(k) + 1;
    end
end

for j = 1:n % Wenn M eine Nullspalte enthält, wird eine zufällige Zeile
            % gewählt, in der die Null durch eine Zufallszahl ersetzt wird.
    if a(j) == 0
        k = ceil(rand*(m));
        M(k,j) = 1*randi([mat_int1,mat_int2]);
        a(j) = 1;
        h(k) = h(k) + 1;
    end
end

end