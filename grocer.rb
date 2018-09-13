require "pry"

def consolidate_cart(cart)
  cart_hash = {}
  cart.each do |cart_items|
    cart_items.each do |item, item_info|   
      if cart_hash[item].nil?
        cart_hash[item] = item_info.merge({:count => 1})
      else
        cart_hash[item][:count] += 1 
      end
    end 
  end 
  cart_hash
end 


def apply_coupons(cart, coupons)
  coupons.each do |coup|
    item = coup[:item]
    if cart[item] && cart[item][:count] >= coup[:num]
      if cart["#{item} W/COUPON"]
        cart["#{item} W/COUPON"][:count] += 1
      else
        cart["#{item} W/COUPON"] = {:count => 1, :price => coup[:cost]}
        cart["#{item} W/COUPON"][:clearance] = cart[item][:clearance]
      end
      cart[item][:count] -= coup[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, item_info|
    if cart[item][:clearance] == true 
      x = cart[item][:price] * 0.80
      cart[item][:price] = x.round(2)
    end
  end 
  cart 
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  saver_cart = apply_coupons(consolidated_cart, coupons)
  clearance_cart = apply_clearance(saver_cart)
  total = 0
  
  clearance_cart.each do |item, item_info|
    item_info.each do |key, value|
    item_total = clearance_cart[item][:price] * clearance_cart[item][:count]
    total += item_total
    end 
  end 
  
  if total > 100.00 
      cart_total = (total * 0.9).round(2)
      puts "Your total is $#{cart_total}."
  else 
    cart_total = total.round(2)
    puts "Your total is $#{cart_total}."
  end
    binding.pry 
end
