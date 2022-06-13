require_relative "lib/question"
require "timeout"

puts "\nThe Quiz!"

questions = Question.read_questions_from_xml("#{__dir__}/data/questions.xml")
right_answers_counter = 0
score = 0

questions.each do |question|
  puts
  puts question.text
  begin
    Timeout::timeout(question.time_in_seconds) do
      question.ask
    end
  rescue Timeout::Error
    puts "\nSorry, time is out!"
    break
  end
  if question.correctly_answered?
    right_answers_counter += 1
    score += question.points
    puts "Right!"
  else
    puts "Incorrect! The right answer is #{question.right_answer}"
  end
end

puts "\nRight answers: #{right_answers_counter} out of #{questions.size}"
puts "You've got #{score} points"
