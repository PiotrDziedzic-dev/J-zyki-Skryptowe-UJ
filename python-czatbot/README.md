# Bot Discord do zamawiania jedzenia

Prosty bot Discord napisany w Pythonie z użyciem biblioteki `discord.py`. Bot umożliwia użytkownikom zamawianie jedzenia, wybór między odbiorem a dostawą, przeglądanie menu oraz sprawdzanie godzin otwarcia.

---

## Spis treści
1. [Wymagania](#wymagania)
2. [Instrukcja uruchomienia](#instrukcja-uruchomienia)
3. [Funkcje](#funkcje)

---

## Wymagania

- **Python**: Wersja 3.7 lub nowsza.
- **Biblioteki**:
    - `discord.py`: Biblioteka do tworzenia botów Discord.
    - `pyyaml`: Biblioteka do obsługi plików YAML.
    - `certifi`: Biblioteka do zarządzania certyfikatami SSL.

---

## Instrukcja uruchomienia

1. Sklonuj repozytorium lub pobierz pliki projektu.
2. Przejdź do folderu projektu:
   ```bash
   cd /ścieżka/do/projektu
3. Zainstaluj wymagane biblioteki
    ```
    pip install discord.py pyyaml certifi
4. Uruchom bota
    ```
   python3 bot.py
5. Następnie wejdź na serwer

https://discord.com/channels/1344669733592633396/1344669733592633400

6. Zacznij konwersować z botem według schematu takiego pliku

 ```yaml
{
  "intents": [
    {
      "tag": "greeting",
      "patterns": [
        "hi",
        "hello",
        "hey",
        "good morning"
      ],
      "responses": [
        "Hello! How can I assist you?"
      ]
    },
    {
      "tag": "opening_hours",
      "patterns": [
        "when are you open?",
        "opening hours?",
        "are you open now?"
      ],
      "responses": [
        "opening_hours"
      ]
    },
    {
      "tag": "menu",
      "patterns": [
        "show menu",
        "what's on the menu?",
        "what do you serve?"
      ],
      "responses": [
        "menu"
      ]
    },
    {
      "tag": "order",
      "patterns": [
        "I want to order",
        "place an order",
        "can I order food?"
      ],
      "responses": [
        "order_start"
      ]
    }
  ]
}
 ```

## Funkcje

Powitanie: Bot odpowiada na powitania użytkowników.

Godziny otwarcia: Bot wyświetla godziny otwarcia restauracji.

Menu: Bot wyświetla menu z cenami i opisami.

Zamówienia: Użytkownicy mogą składać zamówienia, wybierając między odbiorem a dostawą.

Dostawa: Bot pyta o adres dostawy i potwierdza zamówienie.

Odbior: Bot podaje czas odbioru zamówienia.