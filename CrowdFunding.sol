pragma solidity ^0.5.11;

contract CrowdFunding{
    address payable owner;
    uint256 private duration;
    uint256 private time;
    uint256 public goalAmount;
    address payable[] investors;
    mapping (address => uint256) private investments;
    
    // constructor 
    constructor(uint256 _duration, uint256 _goalAmount) public payable {
        duration = _duration;
        goalAmount = _goalAmount*(1 ether); 
        owner = msg.sender;
        time = now;
    }
    
    
    // function to fund ethers to the CrowdFunding
    function fund() payable public {
        require(now-time < duration ,"Deadline completed");
        investments[msg.sender] += msg.value;
        investors.push(msg.sender);
        
    }
    
    // function to check whether goal is reached or not and accordingly take a an action
    // this function works only for owner and after the deadline
    function isGoalReached() public returns(bool){
        require(msg.sender == owner, "Sorry! You are not the owner..");
        require(now-time >= duration, "Deadline is not reached");
        //if goal is reached, transfer all money from contract to owner
        if(address(this).balance>=goalAmount){
            owner.transfer(address(this).balance);
            return true;
        }
        // if goal is not reached, transfer all money to all investors accordingly i.e. return the amounts
        else{
            for(uint8 i=0; i<investors.length; i++){
                investors[i].transfer(investments[investors[i]]);
                investments[investors[i]] = 0;
            }
            return false;
        }
    }
    
    // function to check how much fund has been raised till now.
    // i.e. balance of the contract
    function fundRaised() public view returns(uint256){
        return address(this).balance;
    }
    
    // function to check how much time is remaining to achieve end state.
    function timeRemaining() public view returns(uint256){
        if(duration > now-time){
            return duration-(now-time);
        }
        else{
            return 0;
        }
    }

    // function to check individual's contribution.
    // contributor can check only his contribution, not others.
    function investment() public view returns(uint256){
        return investments[msg.sender];
    }
    
    // function to check ether balance of the nodes.
    function checkBalance() public view returns(uint256){
        return msg.sender.balance;
    }

    
}