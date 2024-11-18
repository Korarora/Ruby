require_relative '../Prodram'

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
end
