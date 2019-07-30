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

  describe 'remove column' do
    it 'generates remove_column code' do
      prompt = FakePrompt.new([
        {
          expected_question: 'What would you like to do?',
          assert_options: -> options do
            expect(options).to include('Add/remove column(s) on existing table')
          end,
          response: 'Add/remove column(s) on existing table'
        },
        {
          expected_question: 'Which table?',
          response: 'menu_items'
        },
        {
          expected_question: 'Add or remove?',
          assert_options: -> options do
            expect(options).to eq(%w(Add Remove))
          end,
          response: 'Remove'
        },
        {
          expected_question: 'Column name:',
          response: 'price_cents'
        },
        {
          expected_question: 'Add/remove another?',
          response: 'n'
        },
      ])

      @wizard.collect_input(prompt: prompt)
      expect(@wizard.filename).to eq('add_price_cents_to_menu_items')
      expect(@wizard.content).to eq("    change_table :menu_items do |t|\n      t.remove :price_cents\n    end")
    end
  end
end
