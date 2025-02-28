# Ruby Mario

Prosta gra platformowa inspirowana Mario, napisana w języku Ruby z użyciem biblioteki Ruby2D. Gra oferuje podstawowe mechaniki platformowe, takie jak poruszanie się, skakanie, zbieranie monet, walka z przeciwnikami oraz możliwość przechodzenia poziomów.

---

## Spis treści
1. [Wymagania](#wymagania)
2. [Instrukcja uruchomienia](#instrukcja-uruchomienia)
3. [Opis gry](#opis-gry)
4. [Funkcje](#funkcje)
5. [Sterowanie](#sterowanie)

---

## Wymagania

1. Wersja Ruby 2.7 lub nowsza

## Instrukcja uruchomienia

1. Pobierz (wszystkie!) pliki projektu

2. Przejdź do katalogu gdzie znajdują się pliki projektu

3. Biblioteka do tworzenia gier 2D w Ruby. Można ją zainstalować za pomocą:

  - **gem install ruby2d**
4. Następnie uruchom program za pomocą:
  - **ruby mario.rb level1/level2/level3**

 
## Opis Gry

Gra polega na pokonaniu poziomu, zbieraniu monet i unikaniu przeciwników. Gracz ma 3 życia, które traci, gdy spadnie w przepaść lub zderzy się z przeciwnikiem. Po zebraniu wszystkich monet i pokonaniu przeciwników poziom zostaje ukończony.

## Funkcje

Poruszanie się: Gracz może poruszać się w lewo i prawo oraz skakać.

Zbieranie monet: Każda zebrana moneta dodaje 10 punktów.

Przeciwnicy: Gracz może pokonać przeciwników, skacząc na nich.


Zapis stanu gry: Gra automatycznie zapisuje stan poziomu (monety, przeciwnicy, przeszkody).

Restart: Możliwość restartu poziomu po przegranej.

## Sterowanie

Strzałka w lewo: Poruszanie się w lewo.

Strzałka w prawo: Poruszanie się w prawo.

Spacja: Skok.

R: Restart poziomu po przegranej.