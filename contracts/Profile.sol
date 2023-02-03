//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

contract FillionArtist {
    error Fillion__AlreadyAnArtist();
    error Fillion__OnlyArtists();

    uint public artistCount = 0;
    uint randomArtistID;

    mapping(address => bool) public isArtist;
    mapping(address => Artist) public artistByAddress;
    mapping(uint256 => address) public addressById;

    struct Artist {
        uint id;
        uint dateJoined;
        address artistAddress;
        string artistDetails;
    }

    event newArtistJoined(
        uint id,
        uint dateJoined,
        address artistAddress,
        string artistDetails
    );

    Artist[] public artists;

    function newArtistSignup(string memory _artistDetails)
        external
        onlyNonArtists
    {
        require(bytes(_artistDetails).length > 0);
        artistCount++;
        Artist memory newArtist = Artist({
            id: artistCount,
            dateJoined: block.timestamp,
            artistAddress: msg.sender,
            artistDetails: _artistDetails
        });
        isArtist[msg.sender] = true;
        artists.push(newArtist);
        artistByAddress[msg.sender] = newArtist;
        addressById[artistCount] = msg.sender;
        emit newArtistJoined(
            artistCount,
            block.timestamp,
            msg.sender,
            _artistDetails
        );
    }

    function updateArtistDetails(
        string memory _artistDetails,
        uint256 _artistid
    ) external onlyNonArtists {
        require(addressById[_artistid] == msg.sender);
        artistByAddress[msg.sender].artistDetails = _artistDetails;
        emit newArtistJoined(
            _artistid,
            block.timestamp,
            msg.sender,
            _artistDetails
        );
    }

    function getAllArtists() external view returns (Artist[] memory) {
        return artists;
    }

    modifier onlyArtists() {
        if (isArtist[msg.sender] == false) {
            revert Fillion__OnlyArtists();
        }
        _;
    }
    
    modifier onlyNonArtists() {
        if (isArtist[msg.sender] == true) {
            revert Fillion__AlreadyAnArtist();
        }
        _;
    }
}
