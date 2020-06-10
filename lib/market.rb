class Market
  attr_reader :name, :vendors

  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map { |vendor| vendor.name }
  end

  def vendors_that_sell(item)
    @vendors.find_all do |vendor|
      vendor.inventory.include?(item)
    end
  end

  def total_inventory # refactor!!!
    all_items = @vendors.flat_map { |vendor| vendor.inventory.keys }.uniq
    total_inventory_setup = all_items.reduce({}) do |setup, item|
      setup[item] = {}
      setup
    end

    inventory = total_inventory_setup.reduce({}) do |total_inventory, (item, sub_hash)|
      total_inventory[item] = {quantity: 0, vendors: []}
      vendors_that_sell(item).each do |vendor|
        total_inventory[item][:quantity] += vendor.check_stock(item)
        total_inventory[item][:vendors] << vendors_that_sell(item)
        total_inventory[item][:vendors] = total_inventory[item][:vendors].flatten.uniq
        end
      total_inventory
    end
  end

  def overstocked_items # more refactoring needed...
    items = total_inventory.find_all do |item, sub_hash|
      sub_hash[:vendors].count > 1 && sub_hash[:quantity] > 50
    end.flatten
    items.find_all do |item|
      item.class == Item
    end
  end

  def sorted_item_list
    total_inventory.map do |item, _sub_hash|
      item.name
    end.sort
  end
end
