//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract Create {
    using Counters for Counters.Counter;

    Counters.Counter public _voterId;
    Counters.Counter public _candidateId;

    address public votingOrganizer;

    //CANDIDATE FOR VOTING
    struct Candidate {
        uint256 candidateId;
        string age;
        string name;
        string image;
        uint256 voterCount;
        address _address;
        string ipfs;
    }

    event CandidateCreate (
         uint256 indexed candidateId,                                                      
        string age,
        string name,
        string image,
        uint256 voterCount,
        address _address,
        string ipfs
    );

    address[] public candidateAddress;

    mapping(address => Candidate) public candidates;

    //////////END OF CANDIDATE DATA

    //----------VOTER DATA

    address[] public votedVoters;

    address[] public votersAddress;
    mapping(address => Voter) public voters;

    struct Voter {
        uint256 voter_voterId;
        string voter_name;
        string voter_image;
        address voter_address;
        uint256 voter_allowed;
        bool voter_voted;
        uint256 voter_vote;
        string voter_ipfs;
    }

    event VoterCreated (
        uint256 indexed voter_voterId,
        string voter_name,
        string voter_image,
        address voter_address,
        uint256 voter_allowed,
        bool voter_voted,
        uint256 voter_vote,
        string voter_ipfs
    );

    //----------END OF VOTER DATA

    constructor (){
        votingOrganizer = msg.sender;
    }

    function setCandidate(
        address _address,
        string memory _age,
        string memory _name,
        string memory _image,
        string memory _ipfs
        ) public {
        require(
            votingOrganizer == msg.sender,
            "Only organizer can authorized candidates"
            );

        _candidateId.increment();

        uint256 idNumber = _candidateId.current();

        Candidate storage candidate = candidates[_address];

        candidate.age = _age;
        candidate.name = _name;
        candidate.candidateId = idNumber;
        candidate.image = _image;
        candidate.voterCount = 0;
        candidate._address = _address;
        candidate.ipfs = _ipfs;

        candidateAddress.push(_address);

        emit CandidateCreate(
            idNumber,
            _age,
            _name,
            _image,
            candidate.voterCount,
            _address,
            _ipfs
        );
    }

    function getCandidate() public view returns (address[] memory) {
        return candidateAddress;
    }

    function getCandidateLength() public view returns (uint256) {
        return candidateAddress.length;
    }

    function getCandidatedata(address _address) 
    public view returns(
        string memory,
        string memory,
        uint256,
        string memory,
        uint256,
        string memory,
        address
        )
    {

        return (
            candidates[_address].age,
            candidates[_address].name,
            candidates[_address].candidateId,
            candidates[_address].image,
            candidates[_address].voterCount,
            candidates[_address].ipfs,
            candidates[_address]._address

        );
    }

    ////---------------VOTER SECTION----------------

    function voterRight( address _address, string memory _name, string memory _image, string memory _ipfs) public{

        require(votingOrganizer == msg.sender, "Only Organizer can create voter");

        _voterId.increment();

        uint256 idNumber = _voterId.current();

        Voter storage voter = voters[_address];
        require(voter.voter_allowed == 0);

        voter.voter_allowed = 1;
        voter.voter_name = _name;
        voter.voter_image = _image;
        voter.voter_address = _address;
        voter.voter_voterId = idNumber;
        voter.voter_vote = 1000;
        voter.voter_voted = false;
        voter.voter_ipfs = _ipfs;

        votersAddress.push(_address);

        emit VoterCreated(
            idNumber,
            _name,
            _image,
            _address,
            voter.voter_allowed,
            voter.voter_voted,
            voter.voter_vote,
            _ipfs
        );
    }

    function vote(address _candidateAddress, uint256 _candidateVoteId) external{

        Voter storage voter = voters[msg.sender];

        require(!voter.voter_voted, "You have already voted");
        require(voter.voter_allowed != 0, 'You have no right to vote');

        voter.voter_voted = true;
        voter.voter_vote = _candidateVoteId;

        votedVoters.push(msg.sender);

        candidates[_candidateAddress].voterCount += voter.voter_allowed;

    }

    function getVoterLength() public view returns (uint256) {
        return votersAddress.length;
    }

    function getVoterdata (address _address) 
    public view returns (
        uint256, 
        string memory, 
        string memory, 
        address, 
        string memory, 
        uint256, 
        bool
        )
    {
        return(
            voters[_address].voter_voterId,
            voters[_address].voter_name,
            voters[_address].voter_image,
            voters[_address].voter_address,
            voters[_address].voter_ipfs,
            voters[_address].voter_allowed,
            voters[_address].voter_voted
        );
    }

    function getVotedVoterList() public view returns (address[] memory) {
        return votedVoters;

    }

    function getVoterList() public view returns (address[] memory) {
        return votersAddress;
    }

}
