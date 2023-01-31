//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

contract Profile {
    mapping(address => bool) public isCreator;
    mapping(address => Creator) public creatorByAddress;

    struct Creator {
        uint256 id;
        address creatorAddress;
        uint256 dateCreated;
        string details;
    }

    Creator[] public creators;

    function createProfile(string memory _details) public {
        if (isCreator[msg.sender]) {
            revert("You have an account");
        }
        if (bytes(_details).length == 0) {
            revert("Input Details");
        }

        Creator memory c = Creator({
            id: creators.length,
            creatorAddress: msg.sender,
            dateCreated: block.timestamp,
            details: _details
        });

        creators.push(c);
        isCreator[msg.sender] = true;
        creatorByAddress[msg.sender] = c;
    }

    function updateDetails(string memory _details) public onlyCreators {
        uint256 id = creatorByAddress[msg.sender].id;

        for (uint256 i = 0; i < creators.length; i++) {
            if (i == id) {
                creators[i] = creators[creators.length - 1];
                creators.pop();
                break;
            }
        }

        Creator memory c = Creator({
            id: creators.length,
            creatorAddress: msg.sender,
            dateCreated: block.timestamp,
            details: _details
        });

        creators.push(c);
        creatorByAddress[msg.sender] = c;
    }

    function getAllCreators() external view returns (Creator[] memory) {
        return creators;
    }

    function getCreatorById(uint256 _id) public view returns (Creator memory) {
        return creators[_id];
    }

    function getCreatorByAddress(address _creatorAddress) public view returns (Creator memory) {
        return creatorByAddress[_creatorAddress];
    }

    modifier onlyCreators() {
        if (!isCreator[msg.sender]) {
            revert("Not a Creator");
        }
        _;
    }
}
