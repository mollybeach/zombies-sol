pragma solidity >=0.5.0 <0.6.0;

import "./zombiefactory.sol";

// Create KittyInterface here
contract KittyInterface {
    function getKitty(uint256 _id) external view returns(
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
); //semi colon instead of curly braces with rest of the function 

}

contract ZombieFeeding is ZombieFactory {
    //Start here
    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    // Initialize kittyContract here using `ckAddress` from above
    KittyInterface kittyContract = KittyInterface(ckAddress);
    function feedAndMultiply(uint _zombieId, uint _targetDna) public {
        require(msg.sender == zombieToOwner[_zombieId]);
        Zombie storage myZombie = zombies[_zombieId];
        _targetDna = _targetDna % dnaModulus; //first make sure not longer than 16 digits 
        uint newDna = (myZombie.dna + _targetDna) /2; //average of the two dnas
        _createZombie("NoName", newDna); 
    }
      // define function here
    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        uint kittyDna; //we only care about one of the values returned from KittyInterface which is kittyDna
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna); 
    }
} 
