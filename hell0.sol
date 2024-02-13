// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ContactManager {
    address public owner;
    
    struct Contact {
        string name;
        address contactAddress;
    }
    
    mapping(uint256 => Contact) private contactsByNumber;
    mapping(address => uint256) private contactNumbersByAddress;
    
    uint256 private contactCount;

    event NewContactAdded(string name, address contactAddress);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function addContact(string memory _name, address _contactAddress) external onlyOwner {
        Contact storage newContact = contactsByNumber[contactCount];
        newContact.name = _name;
        newContact.contactAddress = _contactAddress;

        contactNumbersByAddress[_contactAddress] = contactCount;

        emit NewContactAdded(_name, _contactAddress);

        contactCount++;
    }

    function getContactByNumber(uint256 contactNumber) external view returns (string memory, address) {
        Contact memory contact = contactsByNumber[contactNumber];
        return (contact.name, contact.contactAddress);
    }

    function getContactByAddress(address contactAddress) external view returns (string memory, uint256) {
        uint256 contactNumber = contactNumbersByAddress[contactAddress];
        Contact memory contact = contactsByNumber[contactNumber];
        return (contact.name, contactNumber);
    }
}
