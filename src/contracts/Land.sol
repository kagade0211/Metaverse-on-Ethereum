// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Land is ERC721 {
// Lets make this contract NFT, in order to make it this should inherit from 
//standard ERC721 contract in openzepplelin library
    uint256 public cost = 1 ether;
    uint256 public maxSupply = 5;
// Current supply of land. Initialise the variable with zero
    uint256 public totalSupply = 0;
// //every building will be defined  and created by below struct template. 
    struct Building {
        string name;
        address owner;
        int256 posX;
        int256 posY;
        int256 posZ;
        uint256 sizeX;
        uint256 sizeY;
        uint256 sizeZ;
    }
// we are going to store all buildings created using above template in array called buildings
    Building[] public buildings;
// constructor is function that gets auto-called immediately after contract migration to chain
// storage – permanent storage, memory keyword- temporary storage
//ERC721 is  gives another constructor from librabry which takes name and symbol

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _cost
    ) ERC721(_name, _symbol) {
        cost = _cost;

        buildings.push(
            Building("City Hall", address(0x0), 0, 0, 0, 10, 10, 10)
        );
        // address is 0x0 as currently there is no owner
        buildings.push(Building("Stadium", address(0x0), 0, 10, 0, 10, 5, 3));
        buildings.push(
            Building("University", address(0x0), 0, -10, 0, 10, 5, 3)
        );
        buildings.push(
            Building("Shopping Plaza 1", address(0x0), 10, 0, 0, 5, 25, 5)
        );
        buildings.push(
            Building("Shopping Plaza 2", address(0x0), -10, 0, 0, 5, 25, 5)
        );
    }

    function mint(uint256 _id) public payable {
    // public anybody can call it , payable it takes ether
    //id of land/plot , that to be bought
        uint256 supply = totalSupply;
        require(supply <= maxSupply);
        //building is not bought by other owner
        // id starts with 1 but arrays starts with 0
        require(buildings[_id - 1].owner == address(0x0));
        require(msg.value >= cost);
        // cost defined is 1 eth in contract
        // NOTE: tokenID always starts from 1, but our array starts from 0
        buildings[_id - 1].owner = msg.sender;
        totalSupply = totalSupply + 1; // it was initiated with 0

        _safeMint(msg.sender, _id);
        // this function gets from ERC721  library  
        //and handles all buying of land it gets two arguments 
        //first who bought land  and another id of owner
    }

    function transferFrom(
        // to transfer  land from one owner to another owner
        address from,
        address to,
        uint256 tokenId
    ) public override {
        //override keyword is used as this function 
        // is already implemented in ERC721 and we are using newer implementation /version //of it here 
        require(
            // this function from ERC721 contract, 
            //checks if transfer is approved by owner or this is actual owner of NFT
            _isApprovedOrOwner(_msgSender(), tokenId),
             //if false give below message
            "ERC721: transfer caller is not owner nor approved"
        );

        // Update Building ownership
        buildings[tokenId - 1].owner = to;

        _transfer(from, to, tokenId);
    }
    // safeTransferFrom is same as that of safeTransfer function 
    //except it has 4 arguments instead of 3. i.e.bytes memory _data
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public override {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            //if false give below message
            "ERC721: transfer caller is not owner nor approved"
        );

        // if true Update Building ownership
        buildings[tokenId - 1].owner = to;

        _safeTransfer(from, to, tokenId, _data);
    }

    // Public View Functions
    //we want to return building array stored in memory
    // as we are just reading this function hence view
    function getBuildings() public view returns (Building[] memory) {
        return buildings;
    }
   // another function to get specific building instead of complete array
    function getBuilding(uint256 _id) public view returns (Building memory) {
        return buildings[_id - 1];
    }
}