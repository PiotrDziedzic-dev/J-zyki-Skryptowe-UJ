require 'ruby2d'

if ARGV.empty?
  puts "Użycie: ruby mario.rb <nazwa_poziomu>"
  puts "Przykład: ruby mario.rb level1"
  exit
end

level_name = ARGV[0]

set title: "Ruby Mario", width: 800, height: 400

grid_size = 40
$lives = 3
$points = 0
$game_over_text = nil
$player_velocity_y = 0
$gravity = 0.8
$jump_force = -12
$on_ground = false
$moving_left = false
$moving_right = false
$speed = 5

$score_text = Text.new("Punkty: #{$points}", x: 10, y: 10, size: 20, color: 'red', z: 2)
$lives_text = Text.new("Życia: #{$lives}", x: 10, y: 40, size: 20, color: 'red', z: 2)
Text.new("Pokonaj wszystkich przeciwników i zbierz wszystkie monety, aby przejść poziom!", x: 50, y: Window.height - 40, size: 20, color: 'red')

obstacles = []
holes = []
coins = []
enemies = []

def load_level(level_name)
  level_file = "levels/#{level_name}.txt"
  if File.exist?(level_file)
    File.readlines(level_file).map(&:chomp)
  else
    raise "Plik poziomu #{level_file} nie istnieje!"
  end
end

def generate_level(width, height)
  level = []
  height.times do |y|
    row = ""
    width.times do |x|
      if y == height - 1
        row += "#" #
      else
        case rand(10)
        when 0..1
          row += "#"
        when 2
          row += "o"
        when 3
          row += "e"
        else
          row += " "
        end
      end
    end
    level << row
  end
  level
end

$player = Square.new(x: 40, y: 200, size: grid_size, color: 'blue', z: 2)

def reset_game(obstacles, holes, coins, enemies, grid_size, level_name)
  $lives = 3
  $points = 0
  $score_text.text = "Punkty: #{$points}"
  $lives_text.text = "Życia: #{$lives}"
  $player.x, $player.y = 40, 200
  $game_over_text&.remove
  $game_over_text = nil
  obstacles.clear
  holes.clear
  coins.each(&:remove)
  coins.clear
  enemies.each { |e| e[:object].remove }
  enemies.clear
  setup_level(obstacles, holes, coins, enemies, grid_size, level_name)
end


def setup_level(obstacles, holes, coins, enemies, grid_size, level_name)

  if !File.exist?("levels/#{level_name}.txt")
    level = generate_level(20, 10)
  else
    level = load_level(level_name)
  end

  y_offset = 0
  level.each do |row|
    x_offset = 0
    row.chars.each do |char|
      case char
      when '#'
        obstacles << Square.new(x: x_offset, y: y_offset, size: grid_size, color: 'gray')
      when 'o'
        coins << Circle.new(x: x_offset + grid_size/2, y: y_offset + grid_size/2, radius: 10, color: 'yellow')
      when 'e'
        enemy = Square.new(x: x_offset, y: y_offset, size: grid_size, color: 'red', z: 1)
        enemies << { object: enemy, dx: 1 }
      when ' '
        if y_offset + grid_size >= Window.height - grid_size
          holes << [x_offset, y_offset, grid_size, grid_size]
        end
      end
      x_offset += grid_size
    end
    y_offset += grid_size
  end
end

def collision?(a, b, grid_size)
  a.x < b.x + grid_size &&
  a.x + grid_size > b.x &&
  a.y < b.y + grid_size &&
  a.y + grid_size > b.y
end

def collision_below?(player, obstacle, grid_size)
  player.y + grid_size >= obstacle.y &&
  player.y + grid_size <= obstacle.y + grid_size &&
  (player.x + grid_size > obstacle.x && player.x < obstacle.x + grid_size)
end

setup_level(obstacles, holes, coins, enemies, grid_size, level_name)

on :key_down do |event|
  if $game_over_text
    reset_game(obstacles, holes, coins, enemies, grid_size, level_name) if event.key == 'r'
    next
  end

  case event.key
  when 'left'
    $moving_left = true
  when 'right'
    $moving_right = true
  when 'space'
    if $on_ground
      $player_velocity_y = $jump_force
      $on_ground = false
    end
  end
end

on :key_up do |event|
  case event.key
  when 'left'
    $moving_left = false
  when 'right'
    $moving_right = false
  end
end

update do
  unless $game_over_text
    if $moving_left
      $player.x -= $speed
      obstacles.each do |obs|
        if $player.x < obs.x + grid_size && $player.x + grid_size > obs.x &&
           $player.y < obs.y + grid_size && $player.y + grid_size > obs.y
          $player.x = obs.x + grid_size
          break
        end
      end
    end

    if $moving_right
      $player.x += $speed
      obstacles.each do |obs|
        if $player.x < obs.x + grid_size && $player.x + grid_size > obs.x &&
           $player.y < obs.y + grid_size && $player.y + grid_size > obs.y
          $player.x = obs.x - grid_size
          break
        end
      end
    end

    $player_velocity_y += $gravity
    $player.y += $player_velocity_y

    $on_ground = false
    obstacles.each do |obs|
      if collision_below?($player, obs, grid_size)
        $player.y = obs.y - grid_size
        $player_velocity_y = 0
        $on_ground = true
        break
      end
    end

    if ($player.y + grid_size) > Window.height
      $lives -= 1
      $lives_text.text = "Życia: #{$lives}"
      if $lives <= 0
        $game_over_text = Text.new("GAME OVER - Wciśnij R, aby zrestartować", x: 200, y: 180, size: 30, color: 'red')
      else
        $player.x, $player.y = 40, 200
        $player_velocity_y = 0
        $on_ground = true
      end
    end

    coins.each do |coin|
      if $player.contains?(coin.x, coin.y)
        coin.remove
        coins.delete(coin)
        $points += 10
        $score_text.text = "Punkty: #{$points}"
      end
    end


    enemies.each do |enemy|
      new_x = enemy[:object].x + enemy[:dx] * 2
      collision = obstacles.any? { |obs| obs.x == new_x && obs.y == enemy[:object].y }
      out_of_bounds = new_x < 0 || new_x + grid_size > Window.width
      enemy[:dx] *= -1 if collision || out_of_bounds
      enemy[:object].x += enemy[:dx] * 2 unless collision || out_of_bounds
    end


    enemies.each do |enemy|
      e = enemy[:object]
      if collision?($player, e, grid_size)
        if $player.y + grid_size <= e.y + 10 && $player_velocity_y > 0
          e.remove
          enemies.delete(enemy)
          $points += 100
          $score_text.text = "Punkty: #{$points}"
          $player_velocity_y = $jump_force / 2
        else
          $lives -= 1
          $lives_text.text = "Życia: #{$lives}"
          if $lives <= 0
            $game_over_text = Text.new("GAME OVER - Wciśnij R, aby zrestartować", x: 200, y: 180, size: 30, color: 'red')
          else
            $player.x, $player.y = 40, 200
            $player_velocity_y = 0
            $on_ground = true
          end
          break
        end
      end
    end

    if coins.empty? && enemies.empty? && $game_over_text.nil?
      $game_over_text = Text.new("Poziom ukończony! Wciśnij R, aby zagrać ponownie.", x: 200, y: 180, size: 30, color: 'green')
    end
  end
end

show