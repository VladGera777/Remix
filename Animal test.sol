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

abstract contract Animal {
    function consume(string memory food) pure virtual public returns(string memory){
        return string.concat("Animal eats", food);
    }

    function speak() pure virtual public returns(string memory){
        return "...";
    }

    function sleep() pure virtual public returns(string memory){
        return "Z-z-z-z-z-z";
    }
}

abstract contract Herbivore is Animal, HasName {
    string constant PLANT = "plant";

    modifier eatOnlyPlant(string memory food) {
        require(StringComparer.compare(food, PLANT), "Can only eat plant food");
        _;
    }

    function consume(string memory food) pure virtual override public returns(string memory){
        return super.consume(food);
    }
}

abstract contract Carnivore is Animal, HasName {
    modifier eatOnlyMeat(string memory food) {
        require(StringComparer.compare(food, "meat"), "Can only eat meat");
        _;
    }

    function consume(string memory food) pure virtual override public returns(string memory){
        return super.consume(food);
    }
}

contract Wolf is Carnivore {
    constructor(string memory name) HasName(name) {}

    function speak() pure override public returns(string memory){
        return "Awoo";
    }
}

contract Dog is Carnivore, Herbivore {
    constructor(string memory name) HasName(name) {}

    function consume(string memory food) pure override public returns(string memory){
        require(StringComparer.compare(food, "meat"), "Dogs can only eat meat");
        return "Dog eats " . food;
    }

    function Herbivoreconsume(string memory food) pure override public returns(string memory){
        require(StringComparer.compare(food, PLANT), "Dogs can only eat plants");
        return "Dog eats " . food;
    }

    function speak() pure override public returns(string memory){
        return "Woof";
    }
}


contract Cow is Herbivore {
    constructor(string memory name) HasName(name) {}

    function speak() pure override public returns(string memory){
        return "Mooooo";
    }
}

contract Horse is Herbivore {
    constructor(string memory name) HasName(name) {}

    function speak() pure override public returns(string memory){
        return "Igogo";
    }
}

contract Farmer {
    event AddedNewAnimal(string name, address animal);

    function addAnimal(string memory name, address animalAddress) public {
        emit AddedNewAnimal(name, animalAddress);
    }

    function feed(address animal, string memory food) pure public returns(string memory){
        return Animal(animal).consume(food);
    }

    function call(address animal) pure public returns(string memory){
        return Animal(animal).speak();
    }
}
