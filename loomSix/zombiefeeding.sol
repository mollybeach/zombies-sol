pragma solidity >=0.5.0 <0.6.0;

import "./zombiefactory.sol";

contract KittyInterface {
    function getKitty(uint256 _id) external view returns (
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
    );
}

contract ZombieFeeding is ZombieFactory {
    //1. Create modifier here
    modifier onlyOwnerOf(uint _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId]);
        _;
    }
  // 1. Remove this:
    //address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  // 2. Change this to just a declaration:    KittyInterface kittyContract = KittyInterface(ckAddress); ->    KittyInterface kittyContract;
    KittyInterface kittyContract;

  // 3. Add setKittyContractAddress method here
  //1. Modify this function onlyOwner
    function setKittyContractAddress(address _address) external OnlyOwner {
        kittyContract = KittyInterface(_address);
    }
    // 1. Define `_triggerCooldown` function here
    function _triggerCooldown(Zombie storage _zombie) internal {
        _zombie.readyTime = uint32(now + cooldownTime);
    }

  // 2. Define `_isReady` function here
    function _isReady(Zombie storage _zombie) internal view returns (bool) {
        return(_zombie.readyTime <= now);
    }
    //make internal so contract more secure
    function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) internal onlyOwnerOf(_zombieId) {
         // 3. Remove this line
        //require(msg.sender == zombieToOwner[_zombieId]);
        Zombie storage myZombie = zombies[_zombieId];
        // 2. Add a check for `_isReady` here
        require(_isReady(myZombie));
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + _targetDna) / 2;
        if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
        newDna = newDna - newDna % 100 + 99;
    }
        _createZombie("NoName", newDna);
        //3. call trigger cool down
        _triggerCooldown(myZombie);
    }

    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }

}
