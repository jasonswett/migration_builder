class FakePrompt
  def initialize(commands)
    @commands = commands
    @index = 0
  end

  def enum_select(question, *args)
    accept_input(question, args[0])
  end

  def ask(question)
    accept_input(question)
  end

  private

  def accept_input(question, *args)
    command = @commands[@index]
    raise "Expecting command for question \"#{question}\"" unless command

    if command[:expected_question] != question
      raise "Script command \"#{command[:expected_question]}\" does not match question \"#{question}\""
    end

    if command[:assert_options]
      command[:assert_options].call(args[0])
    end

    @commands[@index][:response].tap do |value|
      @index += 1
    end
  end
end
