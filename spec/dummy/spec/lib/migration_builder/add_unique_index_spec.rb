require 'rails_helper'

RSpec.describe MigrationBuilder::Wizard do
  let(:wizard) { default_wizard }

  describe 'add unique index' do
    it 'creates a migration' do
      @commands = [
        {
          expected_question: 'What would you like to do?',
          assert_options: -> options do
            expect(options).to include('Add unique index on existing table')
          end,
          response: 'Add unique index on existing table'
        },
        {
          expected_question: 'Which table?',
          response: 'menu_items'
        },
        {
          expected_question: 'Column:',
          assert_options: -> options do
            expect(options).to eq(['name', 'price'])
          end,
          response: 'name'
        },
        {
          expected_question: 'Add another column to the index?',
          response: true
        },
        {
          expected_question: 'Column:',
          assert_options: -> options do
            expect(options).to eq(['name', 'price'])
          end,
          response: 'price'
        },
        {
          expected_question: 'Add another column to the index?',
          response: false
        }
      ]

      wizard.collect_input(prompt: FakePrompt.new(@commands))
      expect(wizard.filename).to eq('add_unique_index_on_menu_items_name_price')
      expect(wizard.content).to eq("    add_index :menu_items, [:name, :price], unique: true")
    end
  end
end
