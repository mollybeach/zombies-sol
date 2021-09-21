pragma solidity 0.4.17; //pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {
    event NewZombie(uint zombieId, string name, uint dna);
    uint dnaDigits = 16; 
    uint dnaModulus = 10 ** dnaDigits; 
    
    struct Zombie {
        string name; 
        uint dna; 
    }

    Zombie[] public zombies; 
    //8 9
    function _createZombie(string memory _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        emit NewZombie(id, _name, _dna);
    }
    //10 11
    function _generateRandomDna(string memory _str) private view returns(uint){
        uint rand = uint(keccak256(abi.encodePacked(_str))); 
        return rand % dnaModulus;

    }
    //12
    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}

/*
Chapter 9: Private / Public Functions
In Solidity, functions are public by default. This means anyone (or any other contract) can call your contract's function and execute its code.
Obviously this isn't always desirable, and can make your contract vulnerable to attacks. 
Thus it's good practice to mark your functions as private by default, and then only make public the functions you want to expose to the world.
This means only other functions within our contract will be able to call this function and add to the numbers array.

As you can see, we use the keyword private after the function name. 
And as with function parameters, it's convention to start private function names with an underscore (_).
Put it to the test
Our contract's createZombie function is currently public by default — 
this means anyone could call it and create a new Zombie in our contract! 
Let's make it private.
Modify createZombie so it's a private function. Don't forget the naming convention!


public function createZombie(string memory _name, uint _dna) public {
private function : function _createZombie(string memory _name, uint _dna) private


Chapter 10: More on Functions
In this chapter, we're going to learn about function return values, and function modifiers.
Return Values
To return a value from a function, the declaration looks like this:

string greeting = "What's up dog";

function sayHello() public returns (string memory) {
    return greeting;
}
In Solidity, the function declaration contains the type of the return value (in this case string).
Function modifiers
The above function doesn't actually change state in Solidity — e.g. it doesn't change any values or write anything.
So in this case we could declare it as a view function, meaning it's only viewing the data but not modifying it:
function sayHello() public view returns (string memory) {
Solidity also contains pure functions, which means you're not even accessing any data in the app. Consider the following:
function _multiply(uint a, uint b) private pure returns (uint) {
  return a * b;
}
This function doesn't even read from the state of the app — its return value depends only on its function parameters. So in this case we would declare the function as pure.
It may be hard to remember when to mark functions as pure/view. Luckily the Solidity compiler is good about issuing warnings to let you know when you should use one of these modifiers.
Put it to the test
We're going to want a helper function that generates a random DNA number from a string.
Create a private function called _generateRandomDna. It will take one parameter named _str (a string), and return a uint. Don't forget to set the data location of the _str parameter to memory.
This function will view some of our contract's variables but not modify them, so mark it as view.
The function body should be empty at this point — we'll fill it in later.
Contract.sol
12345678910111213141516171819202122
pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;

Making the Zombie Factory
Chapter 11: Keccak256 and Typecasting
We want our _generateRandomDna function to return a (semi) random uint. How can we accomplish this?
Ethereum has the hash function keccak256 built in, which is a version of SHA3. A hash function basically maps an input into a random 256-bit hexadecimal number. A slight change in the input will cause a large change in the hash.

It's useful for many purposes in Ethereum, but for right now we're just going to use it for pseudo-random number generation.
Also important, keccak256 expects a single parameter of type bytes. This means that we have to "pack" any parameters before calling keccak256:

Example:
//6e91ec6b618bb462a4a6ee5aa2cb0e9cf30f7a052bb467b0ba58b8748c00d2e5
keccak256(abi.encodePacked("aaaab"));
//b1f078126895a1424524de5321b339ab00408010b7cf0e6ed451514981e58aa9
keccak256(abi.encodePacked("aaaac"));
As you can see, the returned values are totally different despite only a 1 character change in the input.
Secure random-number generation in blockchain is a very difficult problem. Our method here is insecure, but since security isn't top priority for our Zombie DNA, it will be good enough for our purposes.

Typecasting
Sometimes you need to convert between data types. Take the following example:
uint8 a = 5;
uint b = 6;
// throws an error because a * b returns a uint, not uint8:
uint8 c = a * b;
// we have to typecast b as a uint8 to make it work:
uint8 c = a * uint8(b);
In the above, a * b returns a uint, but we were trying to store it as a uint8, which could cause potential problems. By casting it as a uint8, it works and the compiler won't throw an error.
Put it to the test
Let's fill in the body of our _generateRandomDna function! Here's what it should do:
The first line of code should take the keccak256 hash of abi.encodePacked(_str) to generate a pseudo-random hexadecimal, typecast it as a uint, and finally store the result in a uint called rand.
We want our DNA to only be 16 digits long (remember our dnaModulus?). So the second line of code should return the above value modulus (%) dnaModulus.



Chapter 12: Putting It Together
We're close to being done with our random Zombie generator! Let's create a public function that ties everything together.
We're going to create a public function that takes an input, the zombie's name, and uses the name to create a zombie with random DNA.
Put it to the test
Create a public function named createRandomZombie. It will take one parameter named _name (a string with the data location set to memory). (Declare this function public just as you declared previous functions private)
The first line of the function should run the _generateRandomDna function on _name, and store it in a uint named randDna.
The second line should run the _createZombie function and pass it _name and randDna.

The solution should be 4 lines of code (including the closing } of the function).
Contract.sol
123456789101112131415161718192021222324
pragma solidity  >=0.5.0 <0.6.0;
contract ZombieFactory {
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;

Chapter 13: Events
Our contract is almost finished! Now let's add an event.
Events are a way for your contract to communicate that something happened on the blockchain to your app front-end, which can be 'listening' for certain events and take action when they happen.
Example:

// declare the event
event IntegersAdded(uint x, uint y, uint result);
function add(uint _x, uint _y) public returns (uint) {
  uint result = _x + _y;
  // fire an event to let the app know the function was called:
  emit IntegersAdded(_x, _y, result);
  return result;
}
Your app front-end could then listen for the event. A javascript implementation would look something like:
YourContract.IntegersAdded(function(error, result) {
  // do something with result
})
Put it to the test
We want an event to let our front-end know every time a new zombie was created, so the app can display it.

Declare an event called NewZombie. It should pass zombieId (a uint), name (a string), and dna (a uint).

Modify the _createZombie function to fire the NewZombie event after adding the new Zombie to our zombies array.

You're going to need the zombie's id. array.push() returns a uint of the new length of the array - and since the first item in an array has index 0, array.push() - 1 will be the index of the zombie we just added. 
Store the result of zombies.push() - 1 in a uint called id, so you can use this in the NewZombie event in the next line.
*/