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

*/