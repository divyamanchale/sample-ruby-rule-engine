sample_env = {
              cart: {products: [{name: 'Water'}, {name: 'Fire'}, {name: 'Air'}, {name: 'Earth'}]},
              stack: [] 
              }

class RuleEngine
  def run(cart, products)
    stack = []

    stack << ValidateAddressRule
    if cart[:products]
      stack << IsValidProductRule
    end

    env = {cart: cart,
           stack: stack}

    while rule = env[:stack].pop
      env = rule.new.call(env)
    end

    env[:cart]
  end
end

class Rule 
  def call(env)
    env
  end
end

class IsValidProductRule < Rule 
  def call(env)
    valid_products = ["Water", "Air", "Fire"]

    should_check_inventory = false

    env[:cart][:products].each do |product|
      product[:is_valid] = valid_products.include? product[:name]
      should_check_inventory = should_check_inventory || product[:is_valid]
    end

    if should_check_inventory
      env[:stack] << CheckInventoryRule
    end

    env
  end
end

class CheckInventoryRule < Rule
  def call(env)
  end
end

class AbortRule < Rule
  def call(env)
    env[:stack] = []
    env
  end
end