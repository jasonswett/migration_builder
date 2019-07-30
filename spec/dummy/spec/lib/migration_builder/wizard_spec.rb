require 'rails_helper'
require 'stringio'

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

  context 'some existing tables' do
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
          }
        ])

        @wizard.collect_input(prompt: prompt)
        expect(@wizard.filename).to eq('create_menu_items')
        expect(@wizard.content).to eq(%(create_table :menu_items do |t|\nt.string :name\nend))
      end
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

    describe 'rename table' do
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

        @wizard.collect_input(prompt: prompt)
        expect(@wizard.filename).to eq('rename_menu_items_to_tasty_menu_items')
        expect(@wizard.content).to eq("rename_table :menu_items, :tasty_menu_items")
      end
    end

    describe 'add column' do
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
            expected_question: 'Column name:',
            response: 'price_cents'
          },
          {
            expected_question: 'Column type for price_cents:',
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

        @wizard.collect_input(prompt: prompt)
        expect(@wizard.filename).to eq('add_price_cents_to_menu_items')
        expect(@wizard.content).to eq("change_table :menu_items do |t|\nt.integer :price_cents\nend")
      end
    end
  end
end
