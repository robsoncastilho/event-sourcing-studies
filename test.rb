require_relative 'product'
require_relative 'repository'

product = Sample::Product.new
product.add_sale_price(price_type: 'normal', price_amount: 100.00)
product.add_sale_price(price_type: 'promo', price_amount: 80.00)

repository = Sample::Repository.new
repository.append(product, 1)

puts '###### read results #######'
replayed_product = repository.find_by_id(product.id)

puts replayed_product.sale_prices.inspect

puts '###### removing first sale price'
price_id = replayed_product.sale_prices.first.id
replayed_product.remove_sale_price(price_id: price_id)

repository.append(replayed_product, 1)

puts replayed_product.sale_prices.inspect
