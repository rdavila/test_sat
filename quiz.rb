def generate_quiz
  puts 'How many questions do you want?'
  total = gets.to_i

  if total <= 0
    puts "You need to ask for 1 or more questions"
    generate_quiz
  end
end

generate_quiz
