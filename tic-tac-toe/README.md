# Kółko i Krzyżyk (Tic-Tac-Toe)

Prosta gra w Kółko i Krzyżyk napisana w Bashu. Gra oferuje tryb gry z komputerem, tryb gry z drugim graczem oraz możliwość zapisywania i wczytywania stanu gry.

---

## Spis treści
1. [Wymagania](#wymagania)
2. [Instrukcja uruchomienia](#instrukcja-uruchomienia)
3. [Opis gry](#opis-gry)
4. [Funkcje](#funkcje)
5. [Zapis i wczytanie gry](#zapis-i-wczytanie-gry)

---

## Wymagania

- System operacyjny: Linux, macOS lub inny system z obsługą Bash.
- Bash w wersji 4.x lub nowszej.

---

## Instrukcja uruchomienia

1. Pobierz plik skryptu `tic_tac_toe.sh`.
2. Nadaj plikowi uprawnienia do wykonywania:
   ```bash
   chmod +x tic_tac_toe.sh
   
## Opis gry
Gra w Kółko i Krzyżyk to klasyczna gra strategiczna dla dwóch graczy. Celem gry jest ułożenie trzech swoich symboli (X lub O) w jednej linii (poziomo, pionowo lub na ukos).

Tryby gry:
1. Gra z komputerem: Gracz gra przeciwko prostemu AI, które wykonuje losowe ruchy.
2. Gra z drugim graczem: Dwóch graczy rywalizuje ze sobą na zmianę.
3. Wczytaj grę: Możliwość wczytania zapisanego stanu gry.

## Funkcje

1. Wyświetlanie planszy: Plansza jest wyświetlana w terminalu w formie 3x3.

2. Wykrywanie zwycięzcy: Gra automatycznie wykrywa, gdy jeden z graczy ułoży trzy swoje symbole w linii.

3. Wykrywanie remisu: Jeśli wszystkie pola są zajęte i nie ma zwycięzcy, gra kończy się remisem.

4. Zapis gry: Możliwość zapisania stanu gry do pliku savegame.txt.

5. Wczytanie gry: Możliwość wczytania zapisanego stanu gry z pliku savegame.txt.

## Zapis i wczytanie gry

Zapis gry:
Podczas gry wpisz save, aby zapisać aktualny stan gry do pliku savegame.txt.

Wczytanie gry:
Na początku gry wybierz opcję 3. Wczytaj grę, aby wczytać zapisany stan gry z pliku savegame.txt.