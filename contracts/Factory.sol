// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Collection.sol";
import "./FillionArtist.sol";

/*
 * @dev Factory contract for creating collections
 */
contract Factory is FillionArtist {
    /*
     * @dev Array of all collections
     */
    Collection[] public collections;

    /*
     * @dev Mapping of creator address to their collection addresses
     */
    mapping(address => address[]) public collectionsByCreator;

    /*
     * @dev Create a new collection
     * @param _collectionName The name of the collection
     * @param _uri The base uri for the collection
     * @param _contents The contents of the collection
     * @return The address of the collection
     */
    function createCollection(
        string memory _collectionName,
        string memory _uri,
        string[] memory _contents
    ) public onlyCreators returns (address) {
        Collection c = new Collection(_collectionName, _uri, _contents);
        collections.push(c);
        collectionsByCreator[msg.sender].push(address(c));
        return address(c);
    }

    /*
     * @dev Get a collection by id
     * @param _id The id of the collection
     * @return The address of the collection
     */
    function getCollectionById(uint256 _id) public view returns (address) {
        return address(collections[_id]);
    }

    /*
     * @dev Get all collections by a creator
     * @param _creator The address of the creator
     * @return An array of creator's collection addresses
     */
    function getCollectionsByCreator(address _creator) public view returns (address[] memory) {
        return collectionsByCreator[_creator];
    }

    /*
     * @dev Get all collections
     * @return An array of all collection addresses
     */
    function getAllCollections() public view returns (Collection[] memory) {
        return collections;
    }
}
