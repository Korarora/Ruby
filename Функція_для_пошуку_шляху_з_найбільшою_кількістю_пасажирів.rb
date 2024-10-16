# Функція для пошуку шляху з найбільшою кількістю пасажирів
def find_most_popular_path(graph, start, destination)
  # Черга для пошуку
  queue = [[start, 0, [start]]]
  # Максимальна кількість пасажирів
  max_passengers = 0
  best_path = []

  while !queue.empty?
    current_stop, passengers, path = queue.shift

    if current_stop == destination
      if passengers > max_passengers
        max_passengers = passengers
        best_path = path
      end
    else
      graph[current_stop].each do |next_stop, next_passengers|
        queue << [next_stop, passengers + next_passengers, path + [next_stop]]
      end
    end
  end

  return { max_passengers: max_passengers, path: best_path }
end

# Пошук найбільш популярного шляху взагалі
def find_most_popular_overall(graph)
  max_passengers = 0
  best_path = []

  graph.each_key do |start|
    graph.each_key do |destination|
      next if start == destination

      result = find_most_popular_path(graph, start, destination)
      if result[:max_passengers] > max_passengers
        max_passengers = result[:max_passengers]
        best_path = result[:path]
      end
    end
  end

  return { max_passengers: max_passengers, path: best_path }
end

# Приклад графа
graph = {
  "A" => { "B" => 100, "C" => 200 },
  "B" => { "D" => 150 },
  "C" => { "D" => 50, "E" => 100 },
  "D" => { "E" => 300 },
  "E" => {}
}

# Пошук шляху між A та E
result = find_most_popular_path(graph, "A", "E")
puts "Найбільше пасажирів між A та E: #{result[:max_passengers]}, Шлях: #{result[:path].join(' -> ')}"

# Пошук найбільш популярного шляху взагалі
overall_result = find_most_popular_overall(graph)
puts "Найбільше пасажирів загалом: #{overall_result[:max_passengers]}, Шлях: #{overall_result[:path].join(' -> ')}"