def consolidate_cart(cart)
  cart.each_with_object({}) do |groc_item, groc_details|
    groc_item.each do |item, details|
      if groc_details[item]
        details[:count] += 1 
      else 
        details[:count] = 1 
        groc_details[item] = details
      end
    end
  end
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    groc_item = coupon[:item]
    if cart[groc_item] && cart[groc_item][:count]  >= coupon[:num]
      if cart["#{groc_item} W/COUPON"]
        cart["#{groc_item} W/COUPON"][:count] += 1 
      else 
        cart["#{groc_item} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{groc_item} W/COUPON"][:clearance] = cart[groc_item][:clearance]
      end
      cart[groc_item][:count] -= coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |groc_item, price_data|
    if price_data[:clearance] == true
      clearance_price = price_data[:price] * 0.80
      price_data[:price] = clearance_price.round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  cart_consolidated = consolidate_cart(cart)
  coupons_applied = apply_coupons(cart_consolidated, coupons)
  cart_finalized = apply_clearance(coupons_applied)
  total = 0
  cart_finalized.each do |groc_item, price_data|
    total += price_data[:price] * price_data[:count]
  end
  if total > 100
    total = total * 0.90
  end
  total
end
  

