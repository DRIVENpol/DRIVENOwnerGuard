<b><i>DRIVENsecurity TEAM INTRODUCED A NEW MECHANISM THAT WILL USE A SECOND ADDRESS TO ALLOW THE ORIGINAL OWNER TO CALL ADMIN-ONLY FUNCTIONS</b></i>

<b>=== EXAMPLES ===</b>

1) require(approve == true) AND require(isBlocked[msg.sender] == false)<br>
Use this sintax on very-important functions of your own smart contract + onlyOwner modifier<br>
I.E.: On functions that will change the tokenomics, on functions that will allow or not swapping

DON'T USE IT ON AUTOMATIC FUNCTIONS (DIVIDENDS REDISTRIBUTION)


2) require(isBlocked[msg.sender] == false)<br>
Use this sintax on functions like "transferFrom" or "claimDividends" so when one of your holders is hacked
you can simply mark the hacker's address as blocked and they will not be able to use
their tokens.

3) isBlocked[msg.sender] or setStatusForAddress function<br>
Use this sintax / function when you want to blacklist an addres (as we did on the allowChanges function)

<b>=== IMPORT THE SMART CONTRACT IN SOLIDITY === </b>
<br>import "https://github.com/polthemarketer/DRIVENOwnerGuard/blob/main/DRIVENOwnerGuard.sol";

<b>=== INHEREIT THE SMART CONTRACT === </b>
contract myContract is DRIVENOwnerGuard {
}
