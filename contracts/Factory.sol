// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Collection.sol";
import "./Profile.sol";

contract Factory is Profile {
    Collection[] public collections;

    function createCollection(
        string memory _collectionName,
        string memory _uri,
        string[] memory _contents
    ) public onlyCreators returns (address) {
        Collection c = new Collection(_collectionName, _uri, _contents);
        collections.push(c);
        return address(c);
    }
}
