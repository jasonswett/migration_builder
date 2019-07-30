def default_wizard
  utility_class = double()

  allow(utility_class).to receive(:table_names).and_return([
    'customers',
    'menu_items',
    'orders'
  ])

  MigrationBuilder::Wizard.new(utility_class: utility_class)
end
