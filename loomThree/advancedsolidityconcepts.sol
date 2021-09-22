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


Chapter 3: onlyOwner Function Modifier
Now that our base contract ZombieFactory inherits from Ownable, we can use the onlyOwner function modifier in ZombieFeeding as well.
This is because of how contract inheritance works. Remember:
ZombieFeeding is ZombieFactory
ZombieFactory is Ownable
Thus ZombieFeeding is also Ownable, and can access the functions / events / modifiers from the Ownable contract. This applies to any contracts that inherit from ZombieFeeding in the future as well.
Function Modifiers
A function modifier looks just like a function, but uses the keyword modifier instead of the keyword function. And it can't be called directly like a function can — instead we can attach the modifier's name at the end of a function definition to change that function's behavior.
Let's take a closer look by examining onlyOwner:
pragma solidity >=0.5.0 <0.6.0;

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
Notice the onlyOwner modifier on the renounceOwnership function. When you call renounceOwnership, the code inside onlyOwner executes first. Then when it hits the _; statement in onlyOwner, it goes back and executes the code inside renounceOwnership.
So while there are other ways you can use modifiers, one of the most common use-cases is to add a quick require check before a function executes.
In the case of onlyOwner, adding this modifier to a function makes it so only the owner of the contract (you, if you deployed it) can call that function.
Note: Giving the owner special powers over the contract like this is often necessary, but it could also be used maliciously. For example, the owner could add a backdoor function that would allow him to transfer anyone's zombies to himself!
So it's important to remember that just because a DApp is on Ethereum does not automatically mean it's decentralized — you have to actually read the full source code to make sure it's free of special controls by the owner that you need to potentially worry about. There's a careful balance as a developer between maintaining control over a DApp such that you can fix potential bugs, and building an owner-less platform that your users can trust to secure their data.
Put it to the test
Now we can restrict access to setKittyContractAddress so that no one but us can modify it in the future.
1. Add the onlyOwner modifier to setKittyContractAddress.


Chapter 4: Gas
Great! Now we know how to update key portions of the DApp while preventing other users from messing with our contracts.
Let's look at another way Solidity is quite different from other programming languages:
Gas — the fuel Ethereum DApps run on
In Solidity, your users have to pay every time they execute a function on your DApp using a currency called gas. Users buy gas with Ether (the currency on Ethereum), so your users have to spend ETH in order to execute functions on your DApp.
How much gas is required to execute a function depends on how complex that function's logic is. Each individual operation has a gas cost based roughly on how much computing resources will be required to perform that operation (e.g. writing to storage is much more expensive than adding two integers). The total gas cost of your function is the sum of the gas costs of all its individual operations.
Because running functions costs real money for your users, code optimization is much more important in Ethereum than in other programming languages. If your code is sloppy, your users are going to have to pay a premium to execute your functions — and this could add up to millions of dollars in unnecessary fees across thousands of users.
Why is gas necessary?
Ethereum is like a big, slow, but extremely secure computer. When you execute a function, every single node on the network needs to run that same function to verify its output — thousands of nodes verifying every function execution is what makes Ethereum decentralized, and its data immutable and censorship-resistant.
The creators of Ethereum wanted to make sure someone couldn't clog up the network with an infinite loop, or hog all the network resources with really intensive computations. So they made it so transactions aren't free, and users have to pay for computation time as well as storage.
Note: This isn't necessarily true for other blockchain, like the ones the CryptoZombies authors are building at Loom Network. It probably won't ever make sense to run a game like World of Warcraft directly on the Ethereum mainnet — the gas costs would be prohibitively expensive. But it could run on a blockchain with a different consensus algorithm. We'll talk more about what types of DApps you would want to deploy on Loom vs the Ethereum mainnet in a future lesson.
Struct packing to save gas
In Lesson 1, we mentioned that there are other types of uints: uint8, uint16, uint32, etc.
Normally there's no benefit to using these sub-types because Solidity reserves 256 bits of storage regardless of the uint size. For example, using uint8 instead of uint (uint256) won't save you any gas.
But there's an exception to this: inside structs.
If you have multiple uints inside a struct, using a smaller-sized uint when possible will allow Solidity to pack these variables together to take up less storage. For example:
struct NormalStruct {
  uint a;
  uint b;
  uint c;
}

struct MiniMe {
  uint32 a;
  uint32 b;
  uint c;
}

// `mini` will cost less gas than `normal` because of struct packing
NormalStruct normal = NormalStruct(10, 20, 30);
MiniMe mini = MiniMe(10, 20, 30); 
For this reason, inside a struct you'll want to use the smallest integer sub-types you can get away with.
You'll also want to cluster identical data types together (i.e. put them next to each other in the struct) so that Solidity can minimize the required storage space. For example, a struct with fields uint c; uint32 a; uint32 b; will cost less gas than a struct with fields uint32 a; uint c; uint32 b; because the uint32 fields are clustered together.
Put it to the test
In this lesson, we're going to add 2 new features to our zombies: level and readyTime — the latter will be used to implement a cooldown timer to limit how often a zombie can feed.
So let's jump back to zombiefactory.sol.
1. Add two more properties to our Zombie struct: level (a uint32), and readyTime (also a uint32). We want to pack these data types together, so let's put them at the end of the struct.
32 bits is more than enough to hold the zombie's level and timestamp, so this will save us some gas costs by packing the data more tightly than using a regular uint (256-bits).

*/