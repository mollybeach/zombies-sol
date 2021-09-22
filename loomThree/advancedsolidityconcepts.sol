/*Chapter 1: Immutability of Contracts
Up until now, Solidity has looked quite similar to other languages like JavaScript. But there are a number of ways that Ethereum DApps are actually quite different from normal applications.

To start with, after you deploy a contract to Ethereum, it’s immutable, which means that it can never be modified or updated again.

The initial code you deploy to a contract is there to stay, permanently, on the blockchain. This is one reason security is such a huge concern in Solidity. If there's a flaw in your contract code, there's no way for you to patch it later. You would have to tell your users to start using a different smart contract address that has the fix.

But this is also a feature of smart contracts. The code is law. If you read the code of a smart contract and verify it, you can be sure that every time you call a function it's going to do exactly what the code says it will do. No one can later change that function and give you unexpected results.

External dependencies
In Lesson 2, we hard-coded the CryptoKitties contract address into our DApp. But what would happen if the CryptoKitties contract had a bug and someone destroyed all the kitties?

It's unlikely, but if this did happen it would render our DApp completely useless — our DApp would point to a hardcoded address that no longer returned any kitties. Our zombies would be unable to feed on kitties, and we'd be unable to modify our contract to fix it.

For this reason, it often makes sense to have functions that will allow you to update key portions of the DApp.

For example, instead of hard coding the CryptoKitties contract address into our DApp, we should probably have a setKittyContractAddress function that lets us change this address in the future in case something happens to the CryptoKitties contract.

Put it to the test
Let's update our code from Lesson 2 to be able to change the CryptoKitties contract address.

Delete the line of code where we hard-coded ckAddress.

Change the line where we created kittyContract to just declare the variable — i.e. don't set it equal to anything.

Create a function called setKittyContractAddress. It will take one argument, _address (an address), and it should be an external function.

Inside the function, add one line of code that sets kittyContract equal to KittyInterface(_address).

If you notice a security hole with this function, don't worry — we'll fix it in the next chapter ;)

zombiefeeding.sol
zombiefactory.sol
123456789101112131415161718
pragma solidity >=0.5.0 <0.6.0;

import "./zombiefactory.sol";

contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,



Chapter 2: Ownable Contracts
Did you spot the security hole in the previous chapter?
setKittyContractAddress is external, so anyone can call it! That means anyone who called the function could change the address of the CryptoKitties contract, and break our app for all its users.
We do want the ability to update this address in our contract, but we don't want everyone to be able to update it.
To handle cases like this, one common practice that has emerged is to make contracts Ownable — meaning they have an owner (you) who has special privileges.
OpenZeppelin's Ownable contract
Below is the Ownable contract taken from the OpenZeppelin Solidity library. OpenZeppelin is a library of secure and community-vetted smart contracts that you can use in your own DApps. After this lesson, we highly recommend you check out their site to further your learning!
Give the contract below a read-through. You're going to see a few things we haven't learned yet, but don't worry, we'll talk about them afterward.

 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 
contract Ownable {
  address private _owner;

  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.

  constructor() internal {
    _owner = msg.sender;
    emit OwnershipTransferred(address(0), _owner);
  }

 
   * @return the address of the owner.
  
  function owner() public view returns(address) {
    return _owner;
  }


   * @dev Throws if called by any account other than the owner.
 
  modifier onlyOwner() {
    require(isOwner());
    _;
  }


   * @return true if `msg.sender` is the owner of the contract.

  function isOwner() public view returns(bool) {
    return msg.sender == _owner;
  }


   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
 
  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
 
  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }


   * @dev Transfers control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
  
  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0));
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}
A few new things here we haven't seen before:
* Constructors: constructor() is a constructor, which is an optional special function that has the same name as the contract. It will get executed only one time, when the contract is first created.
* Function Modifiers: modifier onlyOwner(). Modifiers are kind of half-functions that are used to modify other functions, usually to check some requirements prior to execution. In this case, onlyOwner can be used to limit access so only the owner of the contract can run this function. We'll talk more about function modifiers in the next chapter, and what that weird _; does.
* indexed keyword: don't worry about this one, we don't need it yet.
So the Ownable contract basically does the following:
1. When a contract is created, its constructor sets the owner to msg.sender (the person who deployed it)
2. It adds an onlyOwner modifier, which can restrict access to certain functions to only the owner
3. It allows you to transfer the contract to a new owner
onlyOwner is such a common requirement for contracts that most Solidity DApps start with a copy/paste of this Ownable contract, and then their first contract inherits from it.
Since we want to limit setKittyContractAddress to onlyOwner, we're going to do the same for our contract.
Put it to the test
We've gone ahead and copied the code of the Ownable contract into a new file, ownable.sol. Let's go ahead and make ZombieFactory inherit from it.
1. Modify our code to import the contents of ownable.sol. If you don't remember how to do this take a look at zombiefeeding.sol.
2. Modify the ZombieFactory contract to inherit from Ownable. Again, you can take a look at zombiefeeding.sol if you don't remember how this is done.
*/