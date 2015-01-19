Rails.configuration.stripe = {
  :publishable_key => 'pk_test_OEdBWD1rV2qA0bqUENanAI81',
  :secret_key      => 'sk_test_N1Su50gj3ZMwfXcVgipgPc9a'
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]