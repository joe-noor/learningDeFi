from tkinter import S
from solcx import compile_standard, install_solc
import json
from web3 import Web3

install_solc("0.6.0")

with open("./SimpleStorage.sol", "r") as file:
    simple_storage_file = file.read()

# compiles SimpleStorage.sol
compiled_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"SimpleStorage.sol": {"content": simple_storage_file}},
        "settings": {
            "outputSelection": {
                "*": {"*": ["abi", "metadata", "evm.bytecode", "evm.sourceMap"]}
            }
        },
    },
)

# json file of compiled SimpleStorage.sol
with open("compiled_code.json", "w") as file:
    json.dump(compiled_sol, file)

# needed bytecode,abi for contract
bytecode = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"][
    "bytecode"
]["object"]
abi = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["abi"]

# connecting to Ganache
# to connect to mainnet or testnet, replace address with url to main/test net
w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:8545"))
chain_id = 1337
my_address = "0x1f601221fbADEc2Aa3BF4f5DC60cB366436Af8ba"
# DON'T HARD CODE YOUR KEY IN - COULD GET STOLEN
private_key = "0x14c78961e2aff3f068e40468a996796d513d218a31404d72dad1466d622577b7"

# creating the contract in python
SimpleStorage = w3.eth.contract(abi=abi, bytecode=bytecode)

# Get the latest transaction
nonce = w3.eth.get_transaction_count(my_address)


# 1) Build a transaction
# 2) Sign a transaction
# 3) Send a transaction


# Submit the transaction that deploys the contract
# every contract technically has a constructor, SimpleStorage's is just blank
transaction = SimpleStorage.constructor().buildTransaction(
    {
        "chainId": chain_id,
        "gasPrice": w3.eth.gas_price,  # not necessarily needed
        "from": my_address,
        "nonce": nonce,
    }
)

# sign the transaction
signed_txn = w3.eth.account.sign_transaction(transaction, private_key=private_key)

# send the signed transaction
tx_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)

# getting confirmation the transaction went through
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)


# Working with the contract, we need:
#   1) Contract Address
#   2) Contract ABI
simple_storage = w3.eth.contract(address=tx_receipt.contractAddress, abi=abi)

# 2 ways to interact with transactions on blockchains:
#   1) Call: Simulate making a call and getting a return value, no state-change to blockchange
#   2) Transact: Make a statechange to blockchain

# inital value of favorite number
print(simple_storage.functions.retrieve().call())

# create a transaction
store_transaction = simple_storage.functions.store(15).buildTransaction(
    {
        "chainId": chain_id,
        "gasPrice": w3.eth.gas_price,
        "from": my_address,
        "nonce": nonce + 1,
    }
)

# sign transaction
signed_store_txn = w3.eth.account.sign_transaction(
    store_transaction, private_key=private_key
)

# send transaction
send_store_tx = w3.eth.send_raw_transaction(signed_store_txn.rawTransaction)

# get reciept
tx_receipt = w3.eth.wait_for_transaction_receipt(send_store_tx)

# check state change of the storage
print(simple_storage.functions.retrieve().call())
