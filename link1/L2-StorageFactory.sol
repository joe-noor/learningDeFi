// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.9.0;

// imports other file from filepath
import "./SimpleStorage.sol";

// is xxx is inheritance from SimpleStorage
// gets all the functions from SimpleStorage 
contract StorageFactory is SimpleStorage {


    // array that will hold all the contracts
    SimpleStorage[] public simpleStorageArray;


    // creates SimpleStorage contracts
    function createSimpleStorageContract() public {
        // create an object of type "SimpleStorage" contract, name it, creates new SimpleStorage contract
        SimpleStorage simpleStorage = new SimpleStorage();
        // adds new contract to simpleStorageArray
        // address of new contract is now in the array
        simpleStorageArray.push(simpleStorage);
    }


    // Calls the store and retrieve functions from SimpleStorage.sol
    // Stores a number on a contract in the array "simpleStorageArray"
    // Need 2 things to interact with contracts:
    //      1) Address
    //      2) ABI (Application Binary Interface)
    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
        // gets the contract we want to interact with
        SimpleStorage simpleStorage = SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]));

        // stores number in new contract
        simpleStorage.store(_simpleStorageNumber);
    }


    // gets the favorite number from a SimpleStorage contract
    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        // calls the retrieve function from SimpleStorage.sol
        return SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).retrieve();
    }

}
