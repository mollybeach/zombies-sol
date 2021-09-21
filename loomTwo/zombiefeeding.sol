pragma solidity >=0.5.0 <0.6.0;

import "./zombiefactory.sol";

contract ZombieFeeding is ZombieFactory {
    //Start here
    function feedAndMultiply(uint _zombieId, uint _targetDna) public {
        require(msg.sender == zombieToOwner[_zombieId]);
        Zombie storage myZombie = zombies[_zombieId];
        _targetDna = _targetDna % dnaModulus; //first make sure not longer than 16 digits 
        uint newDna = (myZombie.dna + _targetDna) /2; //average of the two dnas
        _createZombie("NoName", newDna); 
    }
} 
