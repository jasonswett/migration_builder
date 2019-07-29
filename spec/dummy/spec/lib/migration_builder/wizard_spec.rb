require 'rails_helper'
require 'stringio'

RSpec.describe MigrationBuilder::Wizard do
  before { @output = StringIO.new }

  context 'drop table' do
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

      migration_builder = MigrationBuilder::Wizard.new(prompt: prompt, output: @output)
      migration_builder.collect_input

      expect(migration_builder.filename).to eq('drop_menu_items')
      expect(migration_builder.content).to eq('drop_table :menu_items')
    end
  end

  context 'rename table' do
    it 'generates rename_table code' do
      prompt = FakePrompt.new([
        {
          expected_question: 'What would you like to do?',
          assert_options: -> options do
            expect(options).to include('Rename existing table')
          end,
          response: 'Rename existing table'
        },
        {
          expected_question: 'Which table?',
          response: 'menu_items'
        },
        {
          expected_question: 'New name:',
          response: 'tasty_menu_items'
        }
      ])

      migration_builder = MigrationBuilder::Wizard.new(prompt: prompt, output: @output)
      migration_builder.collect_input

      expect(migration_builder.filename).to eq('rename_menu_items_to_tasty_menu_items')
      expect(migration_builder.content).to eq("rename_table :menu_items, :tasty_menu_items")
    end
  end

  context 'add column' do
    it 'generates add_column code' do
      prompt = FakePrompt.new([
        {
          expected_question: 'What would you like to do?',
          assert_options: -> options do
            expect(options).to include('Add column to existing table')
          end,
          response: 'Add column to existing table'
        },
        {
          expected_question: 'Which table?',
          response: 'menu_items'
        },
        {
          expected_question: 'New column name:',
          response: 'price_cents'
        },
        {
          expected_question: 'Type:',
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
      ])

      migration_builder = MigrationBuilder::Wizard.new(prompt: prompt, output: @output)
      migration_builder.collect_input

      expect(migration_builder.filename).to eq('add_price_cents_to_menu_items')
      expect(migration_builder.content).to eq("add_column :menu_items, :price_cents, :integer")
    end
  end
end
