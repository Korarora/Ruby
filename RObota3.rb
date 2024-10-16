# Функція для знаходження координат родзинок у пирозі
def find_raisins(cake)
  raisins = []
  cake.each_with_index do |row, i|
    row.chars.each_with_index do |char, j|
      raisins << [i, j] if char == 'o'
    end
  end
  raisins
end

# Функція для перевірки, чи шматок пирога містить лише одну родзинку
def has_one_raisin?(piece)
  piece.flatten.count('o') == 1
end

# Функція для розділення пирога на прямокутні частини
def split_cake(cake, raisins)
  # Якщо тільки одна родзинка, не потрібно розрізати
  return [cake] if raisins.size == 1

  best_split = nil
  max_first_width = 0

  # Перебираємо всі можливі горизонтальні розрізи
  (1...cake.size).each do |i|
    top = cake[0...i]
    bottom = cake[i..-1]

    top_raisins = find_raisins(top)
    bottom_raisins = find_raisins(bottom)

    # Пропускаємо, якщо частина без родзинок
    next if top_raisins.empty? || bottom_raisins.empty?

    top_split = split_cake(top, top_raisins)
    bottom_split = split_cake(bottom, bottom_raisins)

    if top_split && bottom_split
      current_split = top_split + bottom_split
      current_width = top_split[0][0].length # Ширина першого шматка

      if current_width > max_first_width
        max_first_width = current_width
        best_split = current_split
      end
    end
  end

  # Перебираємо всі можливі вертикальні розрізи
  (1...cake[0].size).each do |j|
    left = cake.map { |row| row[0...j] }
    right = cake.map { |row| row[j..-1] }

    left_raisins = find_raisins(left)
    right_raisins = find_raisins(right)

    # Пропускаємо, якщо частина без родзинок
    next if left_raisins.empty? || right_raisins.empty?

    left_split = split_cake(left, left_raisins)
    right_split = split_cake(right, right_raisins)

    if left_split && right_split
      current_split = left_split + right_split
      current_width = left_split[0][0].length # Ширина першого шматка

      if current_width > max_first_width
        max_first_width = current_width
        best_split = current_split
      end
    end
  end

  best_split
end

# Основна функція для запуску програми
def solve(cake)
  raisins = find_raisins(cake)
  result = split_cake(cake, raisins)

  puts "Результат поділу:"
  result.each_with_index do |piece, i|
    puts "Шматок #{i + 1}:"
    piece.each { |row| puts row }
    puts
  end
end

# Приклад використання
cake = [
  '........',
  '..o.....',
  '...o....',
  '........'
]
solve(cake)
