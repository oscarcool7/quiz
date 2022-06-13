require "rexml/document"

class Question
  attr_reader :text, :right_answer, :points, :time_in_seconds

  def initialize(text:, answer_variants:, right_answer:, points:, time_in_seconds:)
    @text = text
    @answer_variants = answer_variants
    @right_answer = right_answer
    @points = points
    @time_in_seconds = time_in_seconds
  end

  def ask
    @answer_variants.each.with_index(1) do |variant, index|
      puts "#{index}. #{variant}"
    end

    user_index = STDIN.gets.chomp.to_i - 1
    user_choise = @answer_variants[user_index]
    @correct = @right_answer == user_choise
  end

  def correctly_answered?
    @correct
  end

  def self.read_questions_from_xml(file_name)
    doc = File.open(file_name, "r:UTF-8") { |file| REXML::Document.new(file) }
    doc.root.get_elements("question").map do |question_element|
      right_answer = ""
      answer_variants =
        question_element.get_elements("variants/variant").map do |variant|
          right_answer = variant.text if variant.attributes["right"]
          variant.text
        end

      answer_variants = answer_variants.shuffle
      new(
        text: question_element.elements["text"].text,
        answer_variants: answer_variants,
        right_answer: right_answer,
        points: question_element.elements["points"].text.to_i,
        time_in_seconds: question_element.elements["time_in_seconds"].text.to_i
      )
    end
  end
end
