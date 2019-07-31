require 'rails_helper'

RSpec.describe MigrationBuilder::Wizard do
  let(:wizard) { default_wizard }

  describe 'add column' do
    it 'generates add_column code' do
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
          response: 'Add column'
        },
        {
          expected_question: 'Column name:',
          response: 'price_cents'
        },
        {
          expected_question: 'Type for column price_cents:',
          assert_options: -> options do
            expect(options).to eq(%w(
              string
              text
              integer
              bigint
              float
              decimal
              numeric
              datetime
              time
              date
              binary
              boolean
              primary_key
            ))
          end,
          response: 'integer'
        },
        {
          expected_question: 'Add/remove another?',
          response: false
        },
      ])

      wizard.collect_input(prompt: prompt)
      expect(wizard.filename).to eq('add_price_cents_to_menu_items')
      expect(wizard.content).to eq("    change_table :menu_items do |t|\n      t.integer :price_cents\n    end")
    end
  end
end
