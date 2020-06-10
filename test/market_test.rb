require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/item'
require './lib/vendor'
require './lib/market'

class MarketTest < Minitest::Test
  def setup
    @market = Market.new("South Pearl Street Farmers Market")
    @vendor1 = Vendor.new("Rocky Mountain Fresh")
    @item1 = Item.new({name: 'Peach', price: "$0.75"})
    @item2 = Item.new({name: 'Tomato', price: "$0.50"})
    @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
    @item5 = Item.new({name: 'Onion', price: '$0.25'})
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2 = Vendor.new("Ba-Nom-a-Nom")
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3 = Vendor.new("Palisade Peach Shack")
    @vendor3.stock(@item1, 65)
  end

  def test_it_exists
    assert_instance_of Market, @market
  end

  def test_it_has_attributes
    assert_equal "South Pearl Street Farmers Market", @market.name
    assert_equal [], @market.vendors
  end

  def test_it_can_add_vendors
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    assert_equal [@vendor1, @vendor2, @vendor3], @market.vendors
  end

  def test_it_can_list_vendor_names
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    assert_equal ["Rocky Mountain Fresh", "Ba-Nom-a-Nom", "Palisade Peach Shack"], @market.vendor_names
  end

  def test_it_can_list_vendors_that_sell_specific_item
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    assert_equal [@vendor1, @vendor3], @market.vendors_that_sell(@item1)
    assert_equal [@vendor2], @market.vendors_that_sell(@item4)
  end

  def test_it_can_list_total_inventory
    @vendor3.stock(@item3, 10)
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    inventory = {
        @item1 => {
          quantity: 100,
          vendors: [@vendor1, @vendor3]
        },
        @item2 => {
          quantity: 7,
          vendors: [@vendor1]
        },
        @item4 => {
          quantity: 50,
          vendors: [@vendor2]
        },
        @item3 => {
          quantity: 35,
          vendors: [@vendor2, @vendor3]
        },
      }
    assert_equal inventory, @market.total_inventory
  end

  def test_it_can_find_verstocked_items
    @vendor3.stock(@item3, 10)
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    assert_equal [@item1], @market.overstocked_items
  end

  def test_it_can_sort_item_list
    @vendor3.stock(@item3, 10)
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    sorted = ["Banana Nice Cream", "Peach", "Peach-Raspberry Nice Cream", "Tomato"]
    assert_equal sorted, @market.sorted_item_list
  end

  def test_it_has_date
    Date.stubs(:today).returns(Date.new(2020, 02, 24))
    market = Market.new("South Pearl Street Farmers Market")
    assert_equal "24/02/2020", market.date
    # A market will now be created with a date -
    # whatever date the market is created on through
    # the use of `Date.today`. The addition of a
    # date to the market should NOT break any previous
    # tests.  The `date` method will return a string
    # representation of the date - 'dd/mm/yyyy'. We
    # want you to test this in with a date that is
    # IN THE PAST. In order to test the date method
    # in a way that will work today, tomorrow and on
    # any date in the future, you will need to use a stub :)

  end
end
