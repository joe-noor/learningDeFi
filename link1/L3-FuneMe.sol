// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

// link to code: https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
// link to code: https://docs.openzeppelin.com/contracts/4.x/api/utils#SafeMath
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe {
    // automatically checked for integer overflow
    // safemath not needed for solidity > 0.8
    using SafeMathChainlink for uint256;

    // keeps track of who sent money
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;

    constructor() public {
        // since owner is set at beggining of contract, msg.sender would be the person who deployed it
        owner = msg.sender;
    }



    // payable means function can be used to pay for things
    function fund() public payable {
        // checks that the minimum amount was sent
        uint256 minimumUSD = 50 * 10**18;
        require(getConversionRate(msg.value) >= minimumUSD, "You need to spend more ETH");
        // msg.sender is the sender of function call
        // msg.value is how much the sender sent
        addressToAmountFunded[msg.sender] += msg.value;
        // need to know what ETH -> USD conversion rate is

        funders.push(msg.sender);
    }

    
    // ABI (Application Binary Interface): Tells solidity what functions can be called on another contract
    // If you want to interact with an already deployed contract, you need the ABI of that contract
    // Interface compiles down to an ABI

    // gets version of eth from chainlink import
    function getVersion() public view returns (uint256) {
        // AggregatorV3Interface is name of interface
        // functions defined in the interface are located at the below address
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        // returns the version of the AggregatorV3Interface
        return priceFeed.version();
    }


    // returns current price of eth to usd
    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        // tuple of variable from latestRoundData() from interface
        (,int256 answer,,,) =  priceFeed.latestRoundData();
        // typecasted tuple so we could return answer
        // multiplies by 10 so result has 18 decimal places instead of 8 (standardizing everything)
        return uint256(answer * 10**10);
    }


    // converts eth to usd
    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        // gets current price
        uint256 ethPrice = getPrice();
        // simple calc, divide by 10^18 cause of standardization
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 10**18;
        // USD = result/10^18
        return ethAmountInUsd;
    }


    // Modifiers are used to change the behavior of a function in a declarative way
    // makes sure only owner contract can call a function
    modifier onlyOwner {
        // run the require statement before the function
        // run the rest of the code when you hit the underscore
        require(msg.sender == owner);
        _;
    }


    // withdraws full balance from contract address
    function withdraw() payable onlyOwner public {
        // makes sure only owner can withdraw money
        // Commented out because of modifier: require(msg.sender == owner);

        // sends balance of contract to msg.sender from the contract address ("this")
        msg.sender.transfer(address(this).balance);
        // sets all funders balance to 0
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // empty the funders array
        funders = new address[](0);
    }


}
