from brownie import accounts, config, SimpleStorage, network

# 3 ways to store your private keys
def deploy_simple_storage():
    # 1) import accounts and get the array index value
    # *** account = accounts[0] ***

    # 2) load accounts and choose a password yourself (reccommended)
    # *** account = accounts.load("freecodecamp-account2") ***

    # 3) have .env and brownie-config.yaml files
    # *** account = accounts.add(config["wallets"]["from_key"]) ***

    account = get_account()

    # deploy the SimpleStorage contract
    simple_storage = SimpleStorage.deploy({"from": account})

    # read stored value (0)
    stored_value = simple_storage.retrieve()

    # update stored value (15)
    transaction = simple_storage.store(15, {"from": account})
    transaction.wait(1)

    # read stored value (15)
    updated_stored_value = simple_storage.retrieve()
    print(updated_stored_value)


def get_account():
    if network.show_active() == "developement":
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])


def main():
    deploy_simple_storage()
