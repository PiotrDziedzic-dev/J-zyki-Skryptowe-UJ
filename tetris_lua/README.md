# Tetris w Lua (LÖVE)

Prosta implementacja klasycznej gry Tetris napisana w języku Lua z użyciem frameworku LÖVE. Gra oferuje podstawowe funkcje Tetrisa, takie jak poruszanie klockami, rotacja, automatyczne opadanie, wykrywanie linii, zapisywanie i wczytywanie stanu gry.

---

## Spis treści
1. [Wymagania](#wymagania)
2. [Instrukcja uruchomienia](#instrukcja-uruchomienia)
3. [Opis gry](#opis-gry)
4. [Funkcje](#funkcje)
5. [Sterowanie](#sterowanie)
6. [Zapis i wczytanie gry](#zapis-i-wczytanie-gry)

---

## Wymagania

- **LÖVE**: Framework LÖVE w wersji 11.x lub nowszej. Możesz go pobrać z [oficjalnej strony](https://love2d.org/).
- **System operacyjny**: Windows, macOS, Linux lub inny system obsługiwany przez LÖVE.

---

## Instrukcja uruchomienia

1. Pobierz i zainstaluj LÖVE.
2. Pobierz (wszystkie!) pliki projektu
3. Przejdź do katalogu gdzie znajdują się pliki projektu 
3. Uruchom grę za pomocą LÖVE:
   ```bash
   love .
   
## Opis Gry

Tetris to klasyczna gra logiczna, w której gracz układa spadające klocki w linie. Gdy linia zostanie wypełniona, znika, a gracz zdobywa punkty. Celem gry jest zdobycie jak największej liczby punktów, zanim klocki sięgną góry planszy.

## Funkcje

Różne kształty klocków: I, O, T, L.

Automatyczne opadanie: Klocki spadają w dół w regularnych odstępach czasu.

Rotacja klocków: Możliwość obracania klocków w prawo

Wykrywanie linii: Pełne linie są automatycznie usuwane, a gracz zdobywa punkty.

Zapis i wczytanie gry: Możliwość zapisania i wczytania stanu gry.

Efekty dźwiękowe: Dźwięki dla ruchów, rotacji, usuwania linii i końca gry.

Prosta grafika: Kolorowe klocki i plansza.

## Sterowanie

Strzałka w lewo: Przesuń klocek w lewo.

Strzałka w prawo: Przesuń klocek w prawo.

Strzałka w dół: Przyspiesz opadanie klocka.

Strzałka w górę: Obróć klocek w prawo.

Spacja: Natychmiastowe opuszczenie klocka na dół.

F5: Zapisz stan gry.

F8: Wczytaj stan gry.

R: Zrestartuj grę.

## Zapis i wczytanie gry

Zapis gry:
Podczas gry naciśnij klawisz F5, aby zapisać aktualny stan gry do pliku save.txt.

Wczytanie gry:
Podczas gry naciśnij klawisz F8, aby wczytać zapisany stan gry z pliku save.txt.