require 'rails_helper'

RSpec.describe MigrationBuilder::Wizard do
  let(:wizard) { default_wizard }

  describe 'rename column' do
    it 'generates remove_column code' do
      prompt = FakePrompt.new([
        {
          expected_question: 'What would you like to do?',
          assert_options: -> options do
            expect(options).to include('Rename/remove column(s) on existing table')
          end,
          response: 'Rename/remove column(s) on existing table'
        },
        {
          expected_question: 'Which table?',
          response: 'menu_items'
        },
        {
          expected_question: 'Rename or remove column?',
          assert_options: -> options do
            expect(options).to eq(['Rename column', 'Remove column'])
          end,
          response: 'Rename column'
        },
        {
          expected_question: 'Column to rename:',
          assert_options: -> options do
            expect(options).to eq(['name', 'price'])
          end,
          response: 'price'
        },
        {
          expected_question: 'New column name:',
          response: 'price_cents'
        },
        {
          expected_question: 'Rename/remove another?',
          response: false
        },
      ])

      wizard.collect_input(prompt: prompt)
      expect(wizard.filename).to eq('rename_menu_items_price_to_price_cents')
      expect(wizard.content).to eq("    change_table :menu_items do |t|\n      t.rename :price, :price_cents\n    end")
    end
  end
end
