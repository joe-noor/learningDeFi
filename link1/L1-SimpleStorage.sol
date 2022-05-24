// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.9.0;

contract SimpleStorage {

    // this initializes the variable to 0 even thought its not defined
    // Variables defined outside functions has global scope
    // Techinically a function (see visibility types)
    // Type of variable - visibilty (internal is default) - name
    uint256 favoriteNumber;

    // structs create new types of objects
    // Defining a object of the struct
    // Syntax: People public person = People({favoriteNumber: 2, name: "Patrick"});
    struct People {
        uint256 favoriteNumber;
        string name;
    }

    // Dynamic array (not fixed sized)
    // Arrays can be fixed by putting the size in the brackets
    People[] public people;


    // mapping takes some type of key and spits out the variable it's mapped to
    mapping(string => uint256) public nameToFavoriteNumber;



    // public defines visibility of the variable or function
    // types of visibility:
    //      1) Public: Public functions are part of the contract interface and can be either called internally or via message calls.
    //      2) External: Function can't be called by same contract, must be called by external contract
    //      3) Internal: Internal functions/state variables can only be accessed from within the contract they are defined in and in derived contracts. They cannot be accessed externally. This is the default visibility level for state variables.
    //      4) Private: Private f unctions state variables are like internal ones but they are not visible in derived contracts.
    // Default visibilty for state variable in set to internal
    // State-changing function calls are transactions
    // Variables defined in function have local scope and can only be used in the function they are defined in
    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }


    // View and Pure are non-state changing function types and ARE NOT transactions
    //      1) View: Is used to read something off the blockchain; variables can be view functions too (uint256 favoriteNumber;) 
    //      2) Pure: Do some kind of math, but does not save state anywhere
    function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }


    // adds a person to the array
    // Can store an object in memory or storage
    //      1) Memory: Object only stored during exectution or contract call
    //      2) Storage: Data will persist even after function executes 
    // String is an array of bytes (similar to C memory)
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People({favoriteNumber: _favoriteNumber, name: _name}));
        // EQUIVALENT: people.push(People({_favoriteNumber, _name}));
        nameToFavoriteNumber[_name] = _favoriteNumber; 
    }

}
