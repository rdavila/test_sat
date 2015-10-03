require "csv"

QUESTION_FIELDS = %w(strand_id strand_name standard_id standard_name question_id difficulty)
USAGE_FIELDS = %w(student_id question_id assigned_hours_ago answered_hours_ago)

Question = Struct.new(*QUESTION_FIELDS.map(&:to_sym))
Usage = Struct.new(*QUESTION_FIELDS.map(&:to_sym))

def generate_quiz
  puts 'How many questions do you want?'
  total = gets.to_i

  if total <= 0
    puts "You need to ask for 1 or more questions"
    generate_quiz
  else
    puts "Question ids are:"
    puts questions.sample(total).map(&:question_id)
  end
end

def questions
  @questions ||= begin
    CSV.new(File.open('./questions.csv'), :headers => :first_row).inject([]) do |list, line|
      list << Question.new(*line.to_hash.values_at(*QUESTION_FIELDS))
    end
  end
end

def usages
  @usages ||= begin
    CSV.new(File.open('./usage.csv'), :headers => :first_row).inject([]) do |list, line|
      list << Usage.new(*line.to_hash.values_at(*USAGE_FIELDS))
    end
  end
end

generate_quiz
