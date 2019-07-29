class FakePrompt
  def initialize(commands)
    @commands = commands
    @index = 0
  end

  def enum_select(question, options)
    accept_input(question, options)
  end

  def ask(question)
    accept_input(question)
  end

  private

  def accept_input(question, options = nil)
    command = @commands[@index]

    if command[:expected_question] != question
      raise "Script command \"#{command[:expected_question]}\" does not match question \"#{question}\""
    end

    if command[:assert_options]
      command[:assert_options].call(options)
    end

    @commands[@index][:response].tap do |value|
      @index += 1
    end
  end
end
