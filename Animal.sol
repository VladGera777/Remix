// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

library StringComparer {
    function compare(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }
}

contract HasName {
    string public _name;

    constructor (string memory name){
    _name = name;
    }
}

abstract contract Animal is HasName{
    function eat (string memory food) pure virtual public returns(string memory){
        return string.concat("Animal eats", food);}
    function speak () pure virtual public returns(string memory){
        return "...";}
     function sleep () pure virtual public returns(string memory){
        return "Z-z-z-z-z-z";}
}
abstract contract Herbivore is Animal {
    string constant PLANT="plant";
    modifier eatOnlyPlant(string memory food) {
        require(StringComparer.compare(food,PLANT),"Can only eat plant food");
        _;
    }
    function eat (string memory food) pure virtual override  public eatOnlyPlant(food) returns(string memory){
        return super.eat(food);
        }
    }

// Контракт Wolf
contract Wolf is Animal {
    constructor(string memory name) HasName(name) {}
    function speak() pure override public returns(string memory){
        return "Awoo";
    }

    function eat(string memory food) pure override public returns(string memory){
        // Логіка для поїдання м'яса
        require(StringComparer.compare(food, "meat"), "Wolves can only eat meat");
        return "Wolf eats meat";
    }
}

// Контракт Dog
contract Dog is Animal {
    constructor(string memory name) HasName(name) {}
    function speak() pure override public returns(string memory){
        return "Woof";
    }

    function eat(string memory food) pure override public returns(string memory){
        // Логіка для поїдання м'яса та рослин, але не шоколаду
        require(StringComparer.compare(food, "meat") || StringComparer.compare(food, "plant"), "Dogs can only eat meat or plants");
        require(!StringComparer.compare(food, "chocolate"), "Chocolate is harmful for dogs");
        return "Dog eats " ;
    }
}

contract Cow is Herbivore {
    constructor(string memory name) HasName(name) {}

    function speak() pure override  public returns(string memory){
        return "Mooooo";} 
    
}
contract Horse is Herbivore {
    constructor(string memory name) HasName(name) {}

    function speak() pure override  public returns(string memory){
        return "Igogo";} 
    
}
contract Farmer {
    event AddedNewAnimal(string name, address animal);

    function addCow(string memory name) public {
        Cow cow = new Cow(name);
        emit AddedNewAnimal(name, address(cow));
    }

    function addWolf(string memory name) public {
        Wolf wolf = new Wolf(name);
        emit AddedNewAnimal(name, address(wolf));
    }

    function addDog(string memory name) public {
        Dog dog = new Dog(name);
        emit AddedNewAnimal(name, address(dog));
    }

    function addHorse(string memory name) public {
        Horse horse = new Horse(name);
        emit AddedNewAnimal(name, address(horse));
    }

    function feed(address animal, string memory food) pure public returns(string memory) {
        return Animal(animal).eat(food);
    }

    function call(address animal) pure public returns(string memory) {
        return Animal(animal).speak();
    }
}
