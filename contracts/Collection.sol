// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "./market.sol";

/*
* @dev Collection contract for creating an ERC1155 collection
*/
contract Collection is ERC1155, Ownable {

    FillionMarketplace public fmp;

    /*
    * @dev The name of the collection
    */
    string public collectionName;

    /*
    * @dev The base uri for the collection
    */
    string public baseMetadataURI; 

    /*
    * @dev The contents of the collection
    */
    string[] public contents;

    /*
    * @dev The marketplace address
    */
    address marketPlace;

    /*
    * @dev Constructor for the collection
    * @param _collectionName The name of the collection
    * @param _uri The base uri for the collection
    * @param _contents The contents of the collection
    */
    constructor(string memory _collectionName, string memory _uri, string[] memory _contents, address _marketPlace) ERC1155(_uri) {
        collectionName = _collectionName;
        baseMetadataURI = _uri;
        contents = _contents;
        setURI(_uri);
        transferOwnership(tx.origin);
        marketPlace = _marketPlace;
    }   

    /*
    * @dev Get the uri for a token
    * @param _tokenid The id of the token
    * @return The uri for the token
    */
    function uri(uint256 _tokenid) override public view returns (string memory) {
        if(_tokenid == 0 || _tokenid > (contents.length)) {
            revert("Not an Id");
        }
        return string(
            abi.encodePacked(
                baseMetadataURI,
                Strings.toString(_tokenid),".json"
            )
        );
    }

    /*
    * @dev Get the content for a token
    * @param _tokenid The id of the token
    * @return The content for the token
    */
    function getContentById(uint256 _id) public view returns(string memory) {
        _id--;
        return contents[_id];
    }  

    /*
    * @dev Get the contents of the collection
    * @return The contents of the collection
    */
    function getContents() public view returns(string[] memory) {
        return contents;
    }

    /*
    * @dev Set the base uri for the collection
    * @param newuri The new base uri for the collection
    */
    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    /*
    * @dev Mint a new token to an address
    * @param account The address to mint the token to
    * @param _contentId The id of the content
    * @param amount The amount of tokens to mint
    * @return The id of the content
    */
    function mint(address account, uint _contentId, uint256 amount) 
        public onlyOwner returns (uint)
    {
        if(_contentId == 0 || _contentId > (contents.length)) {
            revert("Not an Id");
        }

        fmp = FillionMarketplace(marketPlace);
        fmp.addNFTOwnership(address(this), _contentId, account);

        _mint(account, _contentId, amount, "");
        return _contentId;
    }

    /*
    * @dev Mint a batch of tokens to an address
    * @param to The address to mint the tokens to
    * @param _ids The ids of the contents
    * @param amounts The amounts of tokens to mint
    * @param data The data to pass to the receiver
    */
    function mintBatch(address to, uint256[] memory _ids, uint256[] memory amounts, bytes memory data)
        public onlyOwner 
    {  
        for(uint i = 0; i < _ids.length; i++) {
            if(_ids[i] == 0 || _ids[i] > (contents.length)) {
                revert("Not an Id");
            }
        }

        fmp = FillionMarketplace(marketPlace);
        for(uint i = 0; i < _ids.length; i++) {
            fmp.addNFTOwnership(address(this), _ids[i], to);
        }

        _mintBatch(to, _ids, amounts, data);
    }
}