# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
# Twinenyc::Application.config.secret_key_base = '5901998bc34d7504bb36b9aa578c6ae54a10e728b18fe3afd8f1114ca261c37ba08106d8c96d8b8323b9227c9c67fb029904d7419a64e9616b1a7b8bef9153d2'

secure = !Rails.env.match(/development|test/)
insecure_base = 'x' * 128
secure_base = ENV["SECRET_KEY_BASE"]
Twinenyc::Application.config.secret_key_base = secure ? secure_base : insecure_base
