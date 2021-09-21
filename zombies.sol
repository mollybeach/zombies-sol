pragma solidity 0.4.17; //pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {
    uint dnaDigits = 16; 
    uint dnaModulus = 10 ** dnaDigits; 
    
    struct Zombie {
        string name; 
        uint dna; 
    }

    Zombie[] public zombies; 

    function _createZombie(string memory _name, uint _dna) private{
        zombies.push(Zombie(_name, _dna)); 
    }
   // function _generateRandomDna(string memory _str) private view returns(uint){
    //}

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



*/