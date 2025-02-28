#!/bin/bash

display_board() {
  clear
  echo " ${cells[0]} | ${cells[1]} | ${cells[2]} "
  echo "-----------"
  echo " ${cells[3]} | ${cells[4]} | ${cells[5]} "
  echo "-----------"
  echo " ${cells[6]} | ${cells[7]} | ${cells[8]} "
}

check_win() {
  local symbol=$1
  for i in 0 3 6; do
    if [[ ${cells[$i]} == $symbol && ${cells[$((i+1))]} == $symbol && ${cells[$((i+2))]} == $symbol ]]; then
      return 0
    fi
  done


  for i in 0 1 2; do
    if [[ ${cells[$i]} == $symbol && ${cells[$((i+3))]} == $symbol && ${cells[$((i+6))]} == $symbol ]]; then
      return 0
    fi
  done

  if [[ ${cells[0]} == $symbol && ${cells[4]} == $symbol && ${cells[8]} == $symbol ]]; then
    return 0
  fi
  if [[ ${cells[2]} == $symbol && ${cells[4]} == $symbol && ${cells[6]} == $symbol ]]; then
    return 0
  fi

  return 1
}

check_draw() {
  for cell in "${cells[@]}"; do
    if [[ $cell =~ [1-9] ]]; then
      return 1
    fi
  done
  return 0
}

echo "Witaj w Kółko i Krzyżyk!"
echo "1. Nowa gra z komputerem"
echo "2. Nowa gra z drugim graczem"
echo "3. Wczytaj grę"
read -p "Wybierz opcję: " choice

case $choice in
1)
  game_mode="computer"
  cells=("1" "2" "3" "4" "5" "6" "7" "8" "9")
  current_player="X"
  ;;
2)
  game_mode="player"
  cells=("1" "2" "3" "4" "5" "6" "7" "8" "9")
  current_player="X"
  ;;
3)
  if [ -f savegame.txt ]; then
    source savegame.txt
    echo "Gra wczytana!"
  else
    echo "Brak zapisanej gry!"
    exit 1
  fi
  ;;
*)
  echo "Nieprawidłowy wybór!"
  exit 1
  ;;
esac


while true; do
  display_board
  
  if [[ $game_mode == "computer" && $current_player == "O" ]]; then
    echo "Ruch komputera..."
    available=()
    for i in {0..8}; do
      if [[ ${cells[$i]} =~ [1-9] ]]; then
        available+=($((i+1)))
      fi
    done
    if [ ${#available[@]} -gt 0 ]; then
      move=${available[$((RANDOM % ${#available[@]}))]}
      cells[$((move-1))]="O"
    fi
  else
    while true; do
      read -p "Gracz $current_player, podaj numer (1-9) lub 'save' aby zapisać: " input
      
      if [[ $input == "save" ]]; then
        echo "cells=(" > savegame.txt
        for cell in "${cells[@]}"; do
          echo "\"$cell\"" >> savegame.txt
        done
        echo ")" >> savegame.txt
        echo "current_player=\"$current_player\"" >> savegame.txt
        echo "game_mode=\"$game_mode\"" >> savegame.txt
        echo "Gra zapisana!"
        exit 0
      elif [[ $input =~ ^[1-9]$ ]]; then
        index=$((input-1))
        if [[ ${cells[$index]} == $input ]]; then
          cells[$index]=$current_player
          break
        else
          echo "Nieprawidłowy ruch! Pole zajęte."
        fi
      else
        echo "Nieprawidłowa komenda!"
      fi
    done
  fi

  if check_win "$current_player"; then
    display_board
    echo "Gracz $current_player wygrywa!"
    exit 0
  elif check_draw; then
    display_board
    echo "Remis!"
    exit 0
  fi

  if [[ $current_player == "X" ]]; then
    current_player="O"
  else
    current_player="X"
  fi
done