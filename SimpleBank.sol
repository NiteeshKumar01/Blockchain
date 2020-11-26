pragma solidity ^0.5.11;

contract SimpleBank {
    uint8 private custCount;
    address[] private accounts;
    mapping (address => uint) private balances;
    

  // Creating an event
    event Log(address indexed accountAddress, uint amount);

    // Constructor is "payable". 10 ether has to be paid and first 2 customers will be given rewards
    constructor() public payable {
        require(msg.value == 10 ether, "10 ether is required as initial funding");
        custCount = 0;
    }
    
    // check whether the customer is enrolled or not
    function check(address _addr) private returns(bool){
        bool flag=true;
        for(uint8 i=0; i<accounts.length; i++){
            if(accounts[i] == _addr){
                flag=false;
            }
        }
        return flag;
        
    }

    // Enroll a customer with the bank, 
    // giving the first 2 of them 5 ether as reward
    function createAccount() public returns (uint) {
        if(check(msg.sender)){
            if (custCount < 2) {
                balances[msg.sender] = 5 ether;
            }
            custCount++;
            accounts.push(msg.sender);
            }
        else{
            require(false, "You are already enrolled!");
        }
        return balances[msg.sender];
    }

    //Deposit ether into the bank
    function deposit() public payable returns (uint) {
        if(!check(msg.sender)){
            balances[msg.sender] += msg.value;
            emit Log(msg.sender, msg.value);
            
        }
        else{
            require(false, "You are not enrolled!");
        }
        return balances[msg.sender];
    }

    // Withdraw ether from the bank
    function withdraw(uint amount) public returns (uint) {
        if(!check(msg.sender)){
        // Check enough balance available, otherwise just return balance
            if (amount <= balances[msg.sender]) {
                balances[msg.sender] -= amount;
                msg.sender.transfer(amount);
    
            }
        }
        else{
            require(false, "You are not enrolled!");
        }
        return balances[msg.sender];
    }
    
    function MoneyTransfer(address payable recipient, uint amount) public returns(uint){
      if(!check(msg.sender) && !check(recipient)){
          if(amount <= balances[msg.sender]){
              balances[msg.sender] -= amount;
              recipient.transfer(amount);
              balances[recipient] += amount;
          }
      }   
    }

    // The balance of the user
    function balance() public view returns (uint) {
        return balances[msg.sender];
    }

    // The balance of the Simple Bank contract
    function bankBalance() public view returns (uint) {
        return address(this).balance;
    }
    
    // Customer count
    function customerCount() public view returns (uint8){
        return custCount;
    }
   
}
