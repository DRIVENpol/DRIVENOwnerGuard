//  PLEASE READ EVERY COMMENT TO FULLY UNDERSTAND THE UTILITY OF THIS LIBRARY

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// DRIVENsecurity TEAM INTRODUCED A NEW MECHANISM THAT WILL USE
// A SECOND ADDRESS TO ALLOW THE ORIGINAL OWNER TO CALL
// ADMIN-ONLY FUNCTIONS

// [NOTE] VERY-IMPORTANT
// FEEL FREE TO USE "isBlocked[msg.sender]" , "require(isBlocked[msg.sender] == false);" and  "require(approve == true)"
// IN THE MOST IMPORTANT FUNCTION OF YOUR SMART CONTRACT
// WE WILL COVER SOME EXAMPLES ABOUT THAT AT THE BOTTOM OF THE DOCUMENT

// ==== THE BEGINNING OF DRIVEN OWNER GUARD SMART CONTRACT

contract DRIVENOwnerGuard {

    // ADDRESS OF THE DEPLOYER
    address private owner;

    // ADDRESS OF THE 2nd ADDRESS THAT WILL NEED TO
    // ALLOW CHANGES TO BE MADE ON THE SMART CONTRACT
    address private approver;

    // TRUE OR FALSE VARIABLE
    bool public approve;

    // SEE IF AN ADDRESS IS BLOCKED OR NOT
    mapping(address => bool) public isBlocked;

    constructor() {

        // THE OWNER IS THE DEPLOYER OF THE CONTRACT
        owner = msg.sender;

        // HARDCODE THE APPROVER ADDRES

        // [PRO TIP]: FOR APPROVER USE A BRAND-NEW ADDRESS WHICH, IF POSSIBLE,
        // IS STORED ON A LEDGER
        approver = YOUR_2ND_ADDRESS;
        // REPLACE "YOUR_2ND_ADDRESS" WITH A WALLET ADDRESS THAT IS YOURS

        // AFTER THIS CONTRACT IS DEPLOYED THE CHANGES ARE NOT ALLOWED
        approve = false;
    }

    // CREATE THE ONLY-OWNER MODIFIER
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner of this smart contract!");
        require(approve == true, "Please allow changes on the smart contract!");
        _;

    // WE WILL USE A MUTEX TO SET THE APPROVE VARIABLE TO "FALSE" AGAIN
    // AFTER AN ONLY-OWNER FUNCTION IS CALLED
        approve = false;
    }

    // ALLOW CHANGES ON THE SMART CONTRACT
    function allowChanges(bool _approve) public {
        if(msg.sender == approver)
        {
            approve = _approve;
        } else {
            // IF THE CALLER OF THE SMART CONTRACT IS NOT THE APPROVER
            // WE WILL MARK THIS ADDRESS AS BLOCKED
            isBlocked[msg.sender] == true;
        }
    }

    // OWNERSHIP FUNCTIONS
    function setNewOwner(address _newOwner) public onlyOwner{
        require(isBlocked[msg.sender] == false, "Your address is blocked");
        owner = _newOwner;
    }

    // BLOCK OR UNBLOCK ADDRESS
    function setStatusForAddress(address _addr, bool whatIs) public onlyOwner {
        isBlocked[_addr] = whatIs;
    }


// ==== THE END OF DRIVEN OWNER GUARD SMART CONTRACT
// STOP TO COPY HERE


// START YOUR SMART CONTRACT HERE

contract myProject is DRIVENOwnerGuard {

// WRITE YOUR SMART CONTRACT

}

}




/* ==== EXAMPLES

1) require(approve == true) AND require(isBlocked[msg.sender] == false)
Use this sintax on very-important functions of your own smart contract + onlyOwner modifier
I.E.: On functions that will change the tokenomics, on functions that will allow or not swapping

DON'T USE IT ON AUTOMATIC FUNCTIONS (DIVIDENDS REDISTRIBUTION)


2) require(isBlocked[msg.sender] == false)
Use this sintax on functions like "transferFrom" or "claimDividends" so when one of your holders is hacked
you can simply mark the hacker's address as blocked and they will not be able to use
their tokens.

3) isBlocked[msg.sender] or setStatusForAddress function
Use this sintax / function when you want to blacklist an addres (as we did on the allowChanges function)

*/
