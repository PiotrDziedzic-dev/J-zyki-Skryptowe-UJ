# Backend Sklepu Internetowego

Prosty backend sklepu internetowego napisany w Node.js z użyciem frameworku Express i bazy danych MongoDB. Aplikacja oferuje podstawowe endpointy API do zarządzania produktami i kategoriami.

---

## Spis treści
1. [Wymagania](#wymagania)
2. [Instrukcja uruchomienia](#instrukcja-uruchomienia)


---

## Wymagania

- **Node.js**: Wersja 14.x lub nowsza.
- **MongoDB**: Lokalna instalacja MongoDB na porcie (5002).
- **NPM**: Menadżer pakietów Node.js.

---

## Instrukcja uruchomienia

1. Sklonuj repozytorium lub pobierz pliki projektu.
2. Przejdź do folderu projektu:
   ```bash
   cd /ścieżka/do/projektu
3. Zainstaluj zależności npm install
4. Stwórz lokalną instancję mongodb za pomocą dockera
   ```bash
   docker run -d --name mongodb-custom -p 5001:27017 -v mongo-data:/data/db mongo:latest
5. Uruchom server
    ```bash
   node server.js
6. Serwer będzie dostępny pod adresem: http://localhost:5000