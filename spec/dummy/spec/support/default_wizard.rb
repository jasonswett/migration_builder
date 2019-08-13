def default_wizard
  utility_class = double()

  allow(utility_class).to receive(:table_names).and_return([
    'customers',
    'menu_items',
    'orders'
  ])

  allow(utility_class).to receive(:column_names).and_return([
    'name',
    'price'
  ])

  MigrationBuilder::Wizard.new(utility_class: utility_class)
end
