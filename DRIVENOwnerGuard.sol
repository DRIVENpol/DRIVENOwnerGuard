// Created by Paul Socarde @DRIVENecosystem [https://www.drivenecosystem.com]

//  *** PLEASE READ EVERY COMMENT TO FULLY UNDERSTAND THE UTILITY OF THIS LIBRARY

// How does this mechanism work?
// DrivenOwnerGuard is using a 2nd address in order to allow changes on a smart contract.
// If somebody gain access to owner's wallet, the hacker will not be able to do changes on the smart contract because the "allowChanges" function can be called only by your second wallet (which is hardcoded).
// As well, you will be able to re-gain access to your smart contract by calling "regainOwnership" function using your second address. This function will transfer the ownership from the old hacked address to a new one.
// Note: If somebody which is not owner will try to call onlyOwner functions, their address will be automatically blocked by the smart contract.

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// ==== THE BEGINNING OF DRIVEN OWNER GUARD SMART CONTRACT

contract DRIVENOwnerGuard {

    // ADDRESS OF THE DEPLOYER
    address private owner;

    // 2nd ADDRESS THAT WILL NEED TO
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

        // [PRO TIP]: FOR APPROVER USE A BRAND-NEW ADDRESS WHICH IS NOT CONNECTED TO ANY DAPP AND HAVE ZERO PREVIOUS TRANSACTIONS
        approver = YOUR_2ND_ADDRESS;
        // REPLACE "YOUR_2ND_ADDRESS" WITH A WALLET ADDRESS THAT IS YOURS

        // AFTER THIS CONTRACT IS DEPLOYED THE CHANGES ARE NOT ALLOWED
        approve = false;
    }

    // CREATE THE ONLY-OWNER MODIFIER
     modifier onlyOwner() {

        if(msg.sender != owner){ //Check if the caller is the owner of the contract. If not, blacklist the address.
            _setStatusForAddress(msg.sender, true);
            } else { // Check if the address is blocked. Check if the changes are allowed on the smart contract.
        require(isBlocked[msg.sender] == false, "Your addres is blocked!");
        require(approve == true, "Please allow changes on the smart contract!");
        _;

    // WE WILL USE A MUTEX TO SET THE APPROVE VARIABLE TO "FALSE" AGAIN
    // AFTER AN ONLY-OWNER FUNCTION IS CALLED
        approve = false;}
    }

    // ALLOW CHANGES ON THE SMART CONTRACT
    function allowChanges(bool _approve) public onlyOwner {
            _setStatusForAddress(msg.sender, true);
        
    }

    // REGAIN OWNERSHIP
    function regainOwnership (address _newOwner) external {
        require(msg.sender == approver, "The caller is not the master-admin.");
        owner = _newOwner;
    }

    // BLOCK OR UNBLOCK ADDRESS
    function setStatusForAddress(address _addr, bool whatIs) public onlyOwner {
        isBlocked[_addr] = whatIs;
    }
    
    // BLOCK OR UNBLOCK ADDRESS - INTERNAL
    function _setStatusForAddress(address _addr, bool whatIs) internal {
        require(msg.sender != owner && msg.sender != approver, "Can't block official addresses. Plsese allow changes if you are the owner and want to do something on the smart contract!");
        isBlocked[_addr] = whatIs;
    }
}

// ==== THE END OF DRIVEN OWNER GUARD SMART CONTRACT

