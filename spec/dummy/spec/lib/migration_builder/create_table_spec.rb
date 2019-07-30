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

  describe 'create table' do
    it 'generates create_table code' do
      prompt = FakePrompt.new([
        {
          expected_question: 'What would you like to do?',
          assert_options: -> options do
            expect(options).to include('Create new table')
          end,
          response: 'Create new table'
        },
        {
          expected_question: 'Table name:',
          response: 'menu_items'
        },
        {
          expected_question: 'Column name:',
          response: 'name'
        },
        {
          expected_question: 'Column type for name:',
          assert_options: -> options { expect(options).to include('string') },
          response: 'string'
        },
        {
          expected_question: 'Add another?',
          response: 'y'
        },
        {
          expected_question: 'Column name:',
          response: 'price_cents'
        },
        {
          expected_question: 'Column type for price_cents:',
          assert_options: -> options { expect(options).to include('integer') },
          response: 'integer'
        },
        {
          expected_question: 'Add another?',
          response: 'n'
        },
      ])

      @wizard.collect_input(prompt: prompt)
      expect(@wizard.filename).to eq('create_menu_items')
      expect(@wizard.content).to eq(%(    create_table :menu_items do |t|\n      t.string :name\n      t.integer :price_cents\n    end))
    end
  end
end
