def consolidate_cart(cart)
  cart.each_with_object({}) do |item, result|
    item.each do |type, attributes|
      if result[type]
        attributes[:count] += 1
      else
        attributes[:count] = 1
        result[type] = attributes
      end
    end
  end
end

cart = [
  {"AVOCADO" => {:price => 3.0, :clearance => true}},
  {"AVOCADO" => {:price => 3.0, :clearance => true}},
  {"KALE" => {:price => 3.0, :clearance => false}},
]

consolidate_cart(cart)
