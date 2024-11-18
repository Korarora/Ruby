require 'benchmark'
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

graph = {
  "A" => { "B" => 100, "C" => 200 },
  "B" => { "D" => 150 },
  "C" => { "D" => 50, "E" => 100 },
  "D" => { "E" => 300 },
  "E" => {}
}

# Генерація графа для тестування
def generate_graph(size, density)
  graph = {}
  size.times do |i|
    graph["Stop_#{i}"] = {}
  end

  size.times do |i|
    # Для поточної вершини Stop_i перевіряються всі наступні вершини Stop_j щоб уникнути дублювання ребер
    (i+1).upto(size-1) do |j|
      if rand < density
        graph["Stop_#{i}"]["Stop_#{j}"] = rand(1..1000)
      end
    end
  end
  graph
end

if __FILE__ == $0
puts "Бенчмарк для різних випадків"

# Пошук шляху між A та E
puts "test popular path from A to E size 6 density 0.3"
start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
res = find_most_popular_path(graph, "A", "E")
end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
puts "Найбільше пасажирів між A та E: #{res[:max_passengers]}, Шлях: #{res[:path].join(' -> ')}"
elapsed_time = end_time - start_time
puts "Час виконання: #{(elapsed_time * 1_000_000).round(3)} мікросекунд"


# Пошук найбільш популярного шляху взагалі
puts "test popular path overall size 6 density 0.3"
start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
overall_result = find_most_popular_overall(graph)
end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
puts "Найбільше пасажирів загалом: #{overall_result[:max_passengers]}, Шлях: #{overall_result[:path].join(' -> ')}"
elapsed_time = end_time - start_time
puts "Час виконання: #{(elapsed_time * 1_000_000).round(3)} мікросекунд"


small_graph = generate_graph(10, 0.2)
small_graph_avg_den = generate_graph(10, 0.5)
small_graph_high_den = generate_graph(10, 0.8)
large_graph_small_dens = generate_graph(30, 0.2)
large_graph_avg_dens = generate_graph(30, 0.5)
large_graph = generate_graph(30, 0.8)


# Малий граф (10 зупинок, низька щільність)
puts "Small Graph (10 nodes, 0.2 density) - Popular Path:"
start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
result = find_most_popular_path(small_graph, "Stop_0", "Stop_9")
end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
puts "Найбільше пасажирів між Stop_0 та Stop_9: #{result[:max_passengers]}, Шлях: #{result[:path].join(' -> ')}"
elapsed_time = end_time - start_time
puts "Час виконання: #{(elapsed_time * 1_000_000).round(3)} мікросекунд"


puts "Small Graph (10 nodes, 0.2 density) - Overall Popular Path:"
start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
overall_result = find_most_popular_overall(small_graph)
end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
puts "Найбільше пасажирів загалом: #{overall_result[:max_passengers]}, Шлях: #{overall_result[:path].join(' -> ')}"
elapsed_time = end_time - start_time
puts "Час виконання: #{(elapsed_time * 1_000_000).round(3)} мікросекунд"


# Малий граф (10 зупинок, середня щільність)
puts "Small Graph (10 nodes, 0.5 density) - Popular Path:"
start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
result = find_most_popular_path(small_graph_avg_den, "Stop_0", "Stop_9")
end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
puts "Найбільше пасажирів між Stop_0 та Stop_9: #{result[:max_passengers]}, Шлях: #{result[:path].join(' -> ')}"
elapsed_time = end_time - start_time
puts "Час виконання: #{(elapsed_time * 1_000_000).round(3)} мікросекунд"


puts "Small Graph (10 nodes, 0.5 density) - Overall Popular Path:"
start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
overall_result = find_most_popular_overall(small_graph_avg_den)
end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
puts "Найбільше пасажирів загалом: #{overall_result[:max_passengers]}, Шлях: #{overall_result[:path].join(' -> ')}"
elapsed_time = end_time - start_time
puts "Час виконання: #{(elapsed_time * 1_000_000).round(3)} мікросекунд"



Benchmark.bm do |x|

  # Малий граф (10 зупинок, велика щільність)
  x.report("Small Graph (10 nodes, 0.8 density) - Popular Path:") do
    result = find_most_popular_path(small_graph_high_den, "Stop_0", "Stop_9")
    puts "Найбільше пасажирів між Stop_0 та Stop_9: #{result[:max_passengers]}, Шлях: #{result[:path].join(' -> ')}"
  end

  x.report("Small Graph (10 nodes, 0.8 density) - Overall Popular Path:") do
    overall_result = find_most_popular_overall(small_graph_high_den)
    puts "Найбільше пасажирів загалом: #{overall_result[:max_passengers]}, Шлях: #{overall_result[:path].join(' -> ')}"
  end

  # Великий граф (30 зупинок, низька щільність)
  x.report("Large Graph (30 nodes, 0.2 density) - Popular Path:") do
    result = find_most_popular_path(large_graph_small_dens, "Stop_0", "Stop_29")
    puts "Найбільше пасажирів між Stop_0 та 29: #{result[:max_passengers]}, Шлях: #{result[:path].join(' -> ')}"
  end

  x.report("Large Graph (30 nodes, 0.2 density) - Overall Popular Path:") do
    overall_result = find_most_popular_overall(large_graph_small_dens)
    puts "Найбільше пасажирів загалом: #{overall_result[:max_passengers]}, Шлях: #{overall_result[:path].join(' -> ')}"
  end

  # Великий граф (30 зупинок, середня щільність)
  x.report("Large Graph (30 nodes, 0.5 density) - Popular Path:") do
    result = find_most_popular_path(large_graph_avg_dens, "Stop_0", "Stop_29")
    puts "Найбільше пасажирів між Stop_0 та Stop_29: #{result[:max_passengers]}, Шлях: #{result[:path].join(' -> ')}"
  end

  x.report("Large Graph (30 nodes, 0.5 density) - Overall Popular Path:") do
    overall_result = find_most_popular_overall(large_graph_avg_dens)
    puts "Найбільше пасажирів загалом: #{overall_result[:max_passengers]}, Шлях: #{overall_result[:path].join(' -> ')}"
  end

  # Великий граф (30 зупинок, висока щільність)
  x.report("Large Graph (30 nodes, 0.8 density) - Popular Path:") do
    result = find_most_popular_path(large_graph, "Stop_0", "Stop_29")
    puts "Найбільше пасажирів між Stop_0 та Stop_29: #{result[:max_passengers]}, Шлях: #{result[:path].join(' -> ')}"
  end

  x.report("Large Graph (30 nodes, 0.8 density) - Overall Popular Path:") do
    overall_result = find_most_popular_overall(large_graph)
    puts "Найбільше пасажирів загалом: #{overall_result[:max_passengers]}, Шлях: #{overall_result[:path].join(' -> ')}"
  end
end
end
