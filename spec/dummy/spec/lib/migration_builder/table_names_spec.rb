require 'rails_helper'

RSpec.describe MigrationBuilder::Wizard do
  context 'no existing tables' do
    before do
      utility_class = double()
      expect(utility_class).to receive(:table_names).and_return([])
      @wizard = MigrationBuilder::Wizard.new(utility_class: utility_class)
    end

    it 'does not offer any altering options' do
      prompt = FakePrompt.new([
        {
          expected_question: 'What would you like to do?',
          assert_options: -> options do
            expect(options).to eq(['Create new table'])
          end
        }
      ])

      @wizard.collect_input(prompt: prompt)
    end
  end

  describe 'sorting' do
    before do
      utility_class = double()

      expect(utility_class).to receive(:table_names).and_return([
        'zebras',
        'apes',
        'lions'
      ])

      @wizard = MigrationBuilder::Wizard.new(utility_class: utility_class)
    end

    it 'sorts the table names' do
      expect(@wizard.table_names).to eq([
        'apes',
        'lions',
        'zebras'
      ])
    end
  end
end
