from brownie import accounts, SimpleStorage

# Testing seperated into 3 categories
# tests to see if you recieve what you are expecting
def test_deploy():
    # 1) Arrange
    account = accounts[0]

    # 2) Act
    simple_storage = SimpleStorage.deploy({"from": account})
    starting_value = simple_storage.retrieve()
    expected = 0

    # 3) Assert
    assert starting_value == expected


# updates address with value and makes sure it was updated correctly
def test_updating_storage():
    account = accounts[0]
    simple_storage = SimpleStorage.deploy({"from": account})
    expected = 15
    simple_storage.store(expected, {"from": account})
    assert expected == simple_storage.retrieve()
