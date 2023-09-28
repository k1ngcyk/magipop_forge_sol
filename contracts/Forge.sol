// SPDX-License-Identifier: MIT
// Author: Blink Chen
pragma solidity >=0.8.0 <0.9.0;

contract Forge {
    struct Voter {
        uint weight;
        address delegate;
        uint votes;
    }

    struct Location {
        address owner;
        uint map;
        bytes32 name;
        string description;
        string x;
        string y;
        string tags;
        string image;
        uint voteCount;
    }

    address public administrator;

    mapping(address => Voter) public voters;

    Location[] public locations;

    constructor() {
        administrator = msg.sender;
        voters[administrator].weight = 1;
    }

    function allowToVote(address voter) external {
        require(
            msg.sender == administrator,
            "Only administrator can give right to vote."
        );
        require(
            voters[voter].votes == 0,
            "The voter already voted."
        );
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    function vote(uint location) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(sender.votes == 0, "Already voted.");
        sender.votes = 1;
        locations[location].voteCount += sender.weight;
    }

    function ownerOf(uint location) public view returns (address owner_) {
        owner_ = locations[location].owner;
    }

    function detailOf(uint location) public view returns (Location memory) {
        return locations[location];
    }

    function getAdmin() public view returns (address administrator_) {
        administrator_ = administrator;
    }

    function getLocationCount() public view returns (uint count) {
        count = locations.length;
    }

    function post(
        uint map,
        bytes32 name,
        string memory description,
        string memory x,
        string memory y,
        string memory tags,
        string memory image
    ) external {
        require(msg.sender == administrator, "Only admin can post new locations");
        locations.push(Location({
            owner: msg.sender,
            map: map,
            name: name,
            description: description,
            x: x,
            y: y,
            tags: tags,
            image: image,
            voteCount: 0
        }));
    }
}