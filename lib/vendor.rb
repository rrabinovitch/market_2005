class Vendor
  attr_reader :name, :inventory

  def initialize(name)
    @name = name
    @inventory = Hash.new(0)
  end

  def check_stock(item)
    @inventory[item]
  end

  def stock(item, amt)
    @inventory[item] += amt
  end

  def potential_revenue #refactor later if time
    rev = 0
    @inventory.each do |item, amt|
      rev += item.price * amt
    end
    rev
  end
end
