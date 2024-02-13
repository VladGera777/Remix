// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract Contact {
    string private _name;

    constructor(string memory name) {
        _name = name;
    }

    function getName() external view returns (string memory) {
        return _name;
    }

    function reply() external view returns (string memory) {
        return string(abi.encodePacked(_name, " on call!"));
    }
}

contract ContactBook {
    address[] private _contacts;

    event NewContactAdded(address contactAddress);

    function addContact(string memory contactName) external {
        Contact newContact = new Contact(contactName);
        _contacts.push(address(newContact));

        emit NewContactAdded(address(newContact));
    }

    function callContact(uint256 contactNumber) external view returns (string memory) {
        require(contactNumber < _contacts.length, "Invalid contact number");

        Contact contact = Contact(_contacts[contactNumber]);
        return contact.reply();
    }

    function getContactsCount() external view returns (uint256) {
        return _contacts.length;
    }
}
