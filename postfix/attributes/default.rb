default["postfix"]["hostname"] = node["fqdn"]
default["postfix"]["domain"] = nil
default["postfix"]["destinations"] = []

default["postfix"]["submission"] = true

default["postfix"]["relay"] = false
default["postfix"]["relay_username"] = nil
default["postfix"]["relay_password"] = nil

default["postfix"]["ssl_certificate_file"] = nil
default["postfix"]["ssl_key_file"] = nil

default["postfix"]["aliases"] = {}

default["postfix"]["incoming_message_size_limit"] = 104857600
default["postfix"]["outgoing_message_size_limit"] = 9961472
