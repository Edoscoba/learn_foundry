from eth_account import Account
from eth_account.messages import encode_defunct

private_key = "0x4c0883a69102937d623414b82a665d1fe6033f8db2f6725800a3fd99db3e7f8b"
message = "Hello, Foundry!"

# Create a hash of the message with Ethereum-specific prefix
message_hash = encode_defunct(text=message)

# Sign the message
signed_message = Account.sign_message(message_hash, private_key)

# Calculate the address from the private key
address = Account.from_key(private_key).address

# Combine the signature and address into a single hex-encoded string
import json
output = {
    "signature": signed_message.signature.hex(),
    "address": address
}

# Print the JSON object
print(json.dumps(output))
