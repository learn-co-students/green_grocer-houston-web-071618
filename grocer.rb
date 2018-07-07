require 'pry'

def consolidate_cart(cart)
  consolidated_cart = {}

  cart.each do |item|
    item.each do |item_name, item_details|
      consolidated_cart[item_name] ||= item_details
      consolidated_cart[item_name][:count] ||= 0
      consolidated_cart[item_name][:count] += 1
    end
  end

  consolidated_cart
end

def apply_coupons(cart, coupons)
  new_cart = cart.dup
  cart.each do |item|
    name, details = item.first, item.last

    coupons.each do |coupon|
      c_count = coupon[:num]
      i_count = details[:count]
      if coupon[:item] == name && i_count >= c_count
        new_cart[name][:count] = i_count - c_count
        new_name = "#{name} W/COUPON"

        if new_cart[new_name]
          new_cart[new_name][:count] += 1
        else
          new_cart[new_name] = {}
          new_cart[new_name][:price] = coupon[:cost]
          new_cart[new_name][:clearance] = details[:clearance]
          new_cart[new_name][:count] = 1
        end
      end
    end
  end
  new_cart
end

def apply_clearance(cart)
  cart.each do |item|
    details = item.last
    if details[:clearance]
      details[:price] = (details[:price] * 0.8).round(1)
    end
  end
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  discounted_cart = apply_clearance(couponed_cart)
  total = discounted_cart.map { |item| item.last[:price] * item.last[:count]}.reduce(:+)
  total > 100 ? total * 0.9 : total
end
