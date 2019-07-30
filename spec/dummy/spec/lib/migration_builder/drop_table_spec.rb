require 'rails_helper'

RSpec.describe MigrationBuilder::Wizard do
  before do
    @utility_class = double()

    allow(@utility_class).to receive(:table_names).and_return([
      'customers',
      'menu_items',
      'orders'
    ])

    @wizard = MigrationBuilder::Wizard.new(utility_class: @utility_class)
  end

  describe 'drop table' do
    it 'generates drop_table code' do
      prompt = FakePrompt.new([
        {
          expected_question: 'What would you like to do?',
          assert_options: -> options do
            expect(options).to include('Drop existing table')
          end,
          response: 'Drop existing table'
        },
        {
          expected_question: 'Which table?',
          response: 'menu_items'
        },
      ])

      @wizard.collect_input(prompt: prompt)
      expect(@wizard.filename).to eq('drop_menu_items')
      expect(@wizard.content).to eq('drop_table :menu_items')
    end
  end
end
