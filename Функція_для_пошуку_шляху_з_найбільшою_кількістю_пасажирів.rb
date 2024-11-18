require_relative '../BestWay/script'

RSpec.describe "Тести алгоритму пошуку шляху" do
  let(:graph) do
    {
      "A" => { "B" => 100, "C" => 200 },
      "B" => { "D" => 150 },
      "C" => { "D" => 50, "E" => 100 },
      "D" => { "E" => 300 },
      "E" => {}
    }
  end

  it "знаходить шлях з найбільшою кількістю пасажирів між двома станціями" do
    result = find_most_popular_path(graph, "A", "E")
    expect(result[:max_passengers]).to eq(550)  # Кількість пасажирів
    expect(result[:path]).to eq(["A", "B", "D", "E"])  # Перевіряємо шлях
  end

  it "знаходить найбільш популярний маршрут у всій мережі" do
    result = find_most_popular_overall(graph)
    expect(result[:max_passengers]).to eq(550)  # Найбільше пасажирів
    expect(result[:path]).to eq(["A", "B", "D", "E"])  # Найкращий шлях
  end

  it "повертає порожній шлях, якщо немає шляху між станціями" do
    result = find_most_popular_path(graph, "A", "Z")
    expect(result[:max_passengers]).to eq(0)
    expect(result[:path]).to eq([])
  end

  it "Повертає порожній шлях у графі з однією зупинкою" do
    single_node_graph = { "A" => {} }
    result = find_most_popular_path(single_node_graph, "A", "A")
    expect(result[:max_passengers]).to eq(0)
    expect(result[:path]).to eq([])
  end

  it "правильно працює з графом мінімального розміру (2 зупинки)" do
    small_graph = { "A" => { "B" => 100 }, "B" => {} }
    result = find_most_popular_path(small_graph, "A", "B")
    expect(result[:max_passengers]).to eq(100)
    expect(result[:path]).to eq(["A", "B"])
  end

  it "правильно працює з графом великого розміру (50 зупинок)" do
    large_graph = generate_graph(50, 0.2)
    result = find_most_popular_path(large_graph, "Stop_0", "Stop_99")
    expect(result).to have_key(:max_passengers)
    expect(result).to have_key(:path)
  end

  it "знаходить найбільш популярний шлях у графі з високою щільністю з'єднань" do
    dense_graph = generate_graph(10, 0.8)
    result = find_most_popular_overall(dense_graph)
    expect(result[:max_passengers]).to be > 0
    expect(result[:path]).not_to be_empty
  end

  it "знаходить найбільш популярний шлях у графі з низькою щільністю з'єднань" do
    sparse_graph = generate_graph(30, 0.2)
    result = find_most_popular_overall(sparse_graph)
    expect(result[:max_passengers]).to be > 0
    expect(result[:path]).not_to be_empty
  end
end
