
# тут варіанти
choices = ["kamin", "nozhytsi", "papir"]

puts "Vyberit: kamin, nozhytsi abo papir"
user_choice = gets.chomp.downcase.strip  

# перевірка введення 
until choices.include?(user_choice)
  puts "Nevírnyj vybir. Sprobujte shche raz: kamin, nozhytsi abo papir"
  user_choice = gets.chomp.downcase.strip
end

# випадковий вибір комп
computer_choice = choices.sample
puts "Komp'yuter vybrav: #{computer_choice}"

# логіка визначення переможця
if user_choice == computer_choice
  puts "Nichyia!"
elsif (user_choice == "kamin" && computer_choice == "nozhytsi") ||
      (user_choice == "nozhytsi" && computer_choice == "papir") ||
      (user_choice == "papir" && computer_choice == "kamin")
  puts "Vy vyhraly!"
else
  puts "Komp'yuter vyhrav!"
end
