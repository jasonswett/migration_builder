require 'rails_helper'

RSpec.describe MigrationBuilder::Wizard do
  let(:wizard) { default_wizard }

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
          expected_question: 'Add column or remove column?',
          assert_options: -> options do
            expect(options).to eq(['Add column', 'Remove column'])
          end,
          response: 'Remove column'
        },
        {
          expected_question: 'Column name:',
          response: 'price_cents'
        },
        {
          expected_question: 'Add/remove another?',
          response: false
        },
      ])

      wizard.collect_input(prompt: prompt)
      expect(wizard.filename).to eq('remove_price_cents_from_menu_items')
      expect(wizard.content).to eq("    change_table :menu_items do |t|\n      t.remove :price_cents\n    end")
    end
  end
end
