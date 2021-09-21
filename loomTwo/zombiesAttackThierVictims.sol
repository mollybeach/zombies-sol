
pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    // declare mappings here
    mapping (uint => address) public zombieToOwner; //keeps track of that address that owns the zombie
    mapping (address => uint) ownerZombieCount; //how many zombies the owner has 

    function _createZombie(string memory _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        //start 
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        emit NewZombie(id, _name, _dna);
    } 

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {

        require(ownerZombieCount[msg.sender] == 0); //if the owner has a zombie, they can't create a new one if the value is not 0 the next line will fail and give an error
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
contract ZombieFeeding is ZombieFactory {
}





/*Chapter 1: Lesson 2 Overview
In lesson 1, we created a function that takes a name, uses it to generate a random zombie, and adds that zombie to our app's zombie database on the blockchain.
In lesson 2, we're going to make our app more game-like: We're going to make it multi-player, and we'll also be adding a more fun way to create zombies instead of just generating them randomly.
How will we create new zombies? By having our zombies "feed" on other lifeforms!

Zombie Feeding
When a zombie feeds, it infects the host with a virus. The virus then turns the host into a new zombie that joins your army. The new zombie's DNA will be calculated from the previous zombie's DNA and the host's DNA.
And what do our zombies like to feed on most?
To find that out... You'll have to complete lesson 2!

Put it to the test
There's a simple demo of feeding to the right. Click on a human to see what happens when your zombie feeds!
You can see that the new zombie's DNA is determined by your original zombie's DNA, as well as the host's DNA.
When you're ready, click "Next chapter" to move on, and let's get started by making our game multi-player.

Chapter 2: Mappings and Addresses
Let's make our game multi-player by giving the zombies in our database an owner.
To do this, we'll need 2 new data types: mapping and address.
Addresses
The Ethereum blockchain is made up of accounts, which you can think of like bank accounts. An account has a balance of Ether (the currency used on the Ethereum blockchain), and you can send and receive Ether payments to other accounts, just like your bank account can wire transfer money to other bank accounts.
Each account has an address, which you can think of like a bank account number. It's a unique identifier that points to that account, and it looks like this:
0x0cE446255506E92DF41614C46F1d6df9Cc969183
(This address belongs to the CryptoZombies team. If you're enjoying CryptoZombies, you can send us some Ether! 😉 )
We'll get into the nitty gritty of addresses in a later lesson, but for now you only need to understand that an address is owned by a specific user (or a smart contract).
So we can use it as a unique ID for ownership of our zombies. When a user creates new zombies by interacting with our app, we'll set ownership of those zombies to the Ethereum address that called the function.
Mappings
In Lesson 1 we looked at structs and arrays. Mappings are another way of storing organized data in Solidity.
Defining a mapping looks like this:
// For a financial app, storing a uint that holds the user's account balance:
mapping (address => uint) public accountBalance;
// Or could be used to store / lookup usernames based on userId
mapping (uint => string) userIdToName;
A mapping is essentially a key-value store for storing and looking up data. In the first example, the key is an address and the value is a uint, and in the second example the key is a uint and the value a string.
Put it to the test
To store zombie ownership, we're going to use two mappings: one that keeps track of the address that owns a zombie, and another that keeps track of how many zombies an owner has.
Create a mapping called zombieToOwner. The key will be a uint (we'll store and look up the zombie based on its id) and the value an address. Let's make this mapping public.
Create a mapping called ownerZombieCount, where the key is an address and the value a uint.
Contract.sol
123456789101112131415161718
pragma solidity >=0.5.0 <0.6.0;
contract ZombieFactory {
    event NewZombie(uint zombieId, string name, uint dna);
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    struct Zombie {
Zombies Attack Their Victims


Chapter 3: Msg.sender
Now that we have our mappings to keep track of who owns a zombie, we'll want to update the _createZombie method to use them.
In order to do this, we need to use something called msg.sender.
msg.sender
In Solidity, there are certain global variables that are available to all functions. One of these is msg.sender, which refers to the address of the person (or smart contract) who called the current function.
In Solidity, function execution always needs to start with an external caller. A contract will just sit on the blockchain doing nothing until someone calls one of its functions. So there will always be a msg.sender.
Here's an example of using msg.sender and updating a mapping:
mapping (address => uint) favoriteNumber;
function setMyNumber(uint _myNumber) public {
  // Update our `favoriteNumber` mapping to store `_myNumber` under `msg.sender`
  favoriteNumber[msg.sender] = _myNumber;
  // ^ The syntax for storing data in a mapping is just like with arrays
}
function whatIsMyNumber() public view returns (uint) {
  // Retrieve the value stored in the sender's address
  // Will be `0` if the sender hasn't called `setMyNumber` yet
  return favoriteNumber[msg.sender];
}
In this trivial example, anyone could call setMyNumber and store a uint in our contract, which would be tied to their address. Then when they called whatIsMyNumber, they would be returned the uint that they stored.
Using msg.sender gives you the security of the Ethereum blockchain — the only way someone can modify someone else's data would be to steal the private key associated with their Ethereum address.
Put it to the test
Let's update our _createZombie method from lesson 1 to assign ownership of the zombie to whoever called the function.
First, after we get back the new zombie's id, let's update our zombieToOwner mapping to store msg.sender under that id.
Second, let's increase ownerZombieCount for this msg.sender.
In Solidity, you can increase a uint with ++, just like in javascript:
uint number = 0;
number++;
// `number` is now `1`
Your final answer for this chapter should be 2 lines of code.


Chapter 4: Require
In lesson 1, we made it so users can create new zombies by calling createRandomZombie and entering a name. However, if users could keep calling this function to create unlimited zombies in their army, the game wouldn't be very fun.
Let's make it so each player can only call this function once. That way new players will call it when they first start the game in order to create the initial zombie in their army.
How can we make it so this function can only be called once per player?
For that we use require. require makes it so that the function will throw an error and stop executing if some condition is not true:
function sayHiToVitalik(string memory _name) public returns (string memory) {
  // Compares if _name equals "Vitalik". Throws an error and exits if not true.
  // (Side note: Solidity doesn't have native string comparison, so we
  // compare their keccak256 hashes to see if the strings are equal)
    require(keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked("Vitalik")));
  // If it's true, proceed with the function:
return "Hi!";
If you call this function with sayHiToVitalik("Vitalik"), it will return "Hi!". If you call it with any other input, it will throw an error and not execute.
Thus require is quite useful for verifying certain conditions that must be true before running a function.
Put it to the test
In our zombie game, we don't want the user to be able to create unlimited zombies in their army by repeatedly calling createRandomZombie — it would make the game not very fun.
Let's use require to make sure this function only gets executed one time per user, when they create their first zombie.
1. Put a require statement at the beginning of createRandomZombie. The function should check to make sure ownerZombieCount[msg.sender] is equal to 0, and throw an error otherwise.
In Solidity, it doesn't matter which term you put first — both orders are equivalent. However, since our answer checker is really basic, it will only accept one answer as correct — it's expecting ownerZombieCount[msg.sender] to come first.

}
Chapter 5: Inheritance
Our game code is getting quite long. Rather than making one extremely long contract, sometimes it makes sense to split your code logic across multiple contracts to organize the code.
One feature of Solidity that makes this more manageable is contract inheritance:
contract Doge {
  function catchphrase() public returns (string memory) {
    return "So Wow CryptoDoge";
  }
}

contract BabyDoge is Doge {
  function anotherCatchphrase() public returns (string memory) {
    return "Such Moon BabyDoge";
  }
}
BabyDoge inherits from Doge. That means if you compile and deploy BabyDoge, it will have access to both catchphrase() and anotherCatchphrase() (and any other public functions we may define on Doge).
This can be used for logical inheritance (such as with a subclass, a Cat is an Animal). But it can also be used simply for organizing your code by grouping similar logic together into different contracts.
Put it to the test
In the next chapters, we're going to be implementing the functionality for our zombies to feed and multiply. Let's put this logic into its own contract that inherits all the methods from ZombieFactory.
1. Make a contract called ZombieFeeding below ZombieFactory. This contract should inherit from our ZombieFactory contract.

* 		Contract.sol


*/