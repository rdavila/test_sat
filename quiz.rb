require "csv"

QUESTION_FIELDS = %w(strand_id strand_name standard_id standard_name question_id difficulty)
USAGE_FIELDS = %w(student_id question_id assigned_hours_ago answered_hours_ago)

Question = Struct.new(*QUESTION_FIELDS.map(&:to_sym))
Usage = Struct.new(*USAGE_FIELDS.map(&:to_sym))

def generate_quiz(s_id = nil, total = nil)
  puts 'Please enter your student id:' if s_id.nil?
  student_id = s_id || gets
  return generate_quiz if student_id.chomp.empty?

  puts 'How many questions do you want?' if total.nil?
  total = total || gets.to_i
  return generate_quiz(student_id) if total <= 0

  select_questions(student_id.chomp, total)
end

def select_questions(student_id, total)
  answered_question_ids = usages.select { |u| u.student_id.to_s == student_id }.map(&:question_id)
  results =  questions.select { |q| answered_question_ids.include?(q.question_id) }[0..(total - 1)]
  results << questions.sample(results.size - total) if results.size < total

  puts "Question ids are:"
  puts results.map(&:question_id)
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
