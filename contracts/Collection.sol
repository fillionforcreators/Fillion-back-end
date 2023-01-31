// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Collection is ERC1155, Ownable {
    string public collectionName;
    string public baseMetadataURI;
    string[] public contents;

    constructor(
        string memory _collectionName,
        string memory _uri,
        string[] memory _contents
    ) ERC1155(_uri) {
        collectionName = _collectionName;
        baseMetadataURI = _uri;
        contents = _contents;
        setURI(_uri);
        transferOwnership(tx.origin);
    }

    function uri(uint256 _tokenid) public view override returns (string memory) {
        if (_tokenid >= contents.length) {
            revert("Not an Id");
        }
        return string(abi.encodePacked(baseMetadataURI, Strings.toString(_tokenid), ".json"));
    }

    function getContentById(uint256 _id) public view returns (string memory) {
        return contents[_id];
    }

    function getContents() public view returns (string[] memory) {
        return contents;
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mint(
        address account,
        uint256 _contentId,
        uint256 amount
    ) public onlyOwner returns (uint256) {
        _mint(account, _contentId, amount, "");
        return _contentId;
    }

    function mintBatch(
        address to,
        uint256[] memory _ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyOwner {
        _mintBatch(to, _ids, amounts, data);
    }
}
