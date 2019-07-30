require 'rails_helper'

RSpec.describe MigrationBuilder::Wizard do
  context 'no existing tables' do
    it 'does not offer any altering options' do
      utility_class = double()
      expect(utility_class).to receive(:table_names).and_return([])
      wizard = MigrationBuilder::Wizard.new(utility_class: utility_class)

      prompt = FakePrompt.new([
        {
          expected_question: 'What would you like to do?',
          assert_options: -> options do
            expect(options).to eq(['Create new table'])
          end
        }
      ])

      wizard.collect_input(prompt: prompt)
    end
  end
end
