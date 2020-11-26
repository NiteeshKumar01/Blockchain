pragma solidity ^0.5.11;

contract CellSubscription {
	uint256 monthlyFee;
	mapping(address => uint8) balances;
	address payable owner;
    
    // constructor
    constructor(uint256 fee) public {
        monthlyFee = fee;
        owner = msg.sender;
    }
    
    // Subscriber functinality
    function payFee() payable public {
        
    }
    
    // Company functinality
    function withdrawBalance() public {
        owner.transfer(address(this).balance);
    }

    function checkStatus(uint256 monthsElapsed) public view returns (bool) {
        return monthlyFee * monthsElapsed <= address(this).balance;
    }
    
    // Owner's Balance
    function ownerBalance() public view returns(uint256){
        return owner.balance;
    }
    
    // Subscription balance
    function subsBalance() public view returns(uint256){
        return address(this).balance;
    }
}