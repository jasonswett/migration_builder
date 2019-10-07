require 'rails_helper'

RSpec.describe MigrationBuilder::Wizard do
  let(:wizard) { default_wizard }

  describe 'add column' do
    before do
      @commands = [
        {
          expected_question: 'What would you like to do?',
          assert_options: -> options do
            expect(options).to include('Add/rename/remove column(s) on existing table')
          end,
          response: 'Add/rename/remove column(s) on existing table'
        },
        {
          expected_question: 'Which table?',
          response: 'menu_items'
        },
        {
          expected_question: 'Add, rename or remove column?',
          assert_options: -> options do
            expect(options).to eq(['Add column', 'Rename column', 'Remove column'])
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
      ]
    end

    context 'not nullable' do
      it 'generates add_column code with null: false' do
        @commands += [
          {
            expected_question: 'Nullable?',
            assert_options: -> options do
              expect(options).to eq([
                'nullable',
                'not nullable'
              ])
            end,
            response: 'not nullable'
          },
          {
            expected_question: 'Add/rename/remove another?',
            response: false
          },
        ]

        wizard.collect_input(prompt: FakePrompt.new(@commands))
        expect(wizard.filename).to eq('add_price_cents_to_menu_items')
        expect(wizard.content).to eq("    change_table :menu_items do |t|\n      t.integer :price_cents, null: false\n    end")
      end
    end

    context 'nullable' do
      it 'generates add_column code without null argument' do
        @commands += [
          {
            expected_question: 'Nullable?',
            assert_options: -> options do
              expect(options).to eq([
                'nullable',
                'not nullable'
              ])
            end,
            response: 'nullable'
          },
          {
            expected_question: 'Add/rename/remove another?',
            response: false
          },
        ]

        wizard.collect_input(prompt: FakePrompt.new(@commands))
        expect(wizard.filename).to eq('add_price_cents_to_menu_items')
        expect(wizard.content).to eq("    change_table :menu_items do |t|\n      t.integer :price_cents\n    end")
      end
    end
  end
end
