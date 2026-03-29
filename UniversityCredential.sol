// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract UniversityCredential 
{
    address public student;
    address public university;
    string public name;

    struct Credential {
        address student;
        address university;
        string name;
        uint256 grade;
    }

    Credential public credential;

    constructor(address _student, string memory _name, Credential memory _credential) {
        student = _student;
        name = _name;
        credential = _credential;
    }

    function getStudent() public view returns (address, string memory) {
        return (student, name);
    }

    modifier StudentOnly() {
        require(msg.sender == student);
        _;
    }

    modifier UniversityOnly() {
        require(msg.sender == university);
        _;
    }

    function editInfo(string memory _name) public StudentOnly 
    {
        name = _name;
    }

    function addCredential(address _student, address _organization, 
                                string memory _name, uint256 _grade) public UniversityOnly
    {
        Credential storage new_credential;
        new_credential.student = student;
        new_credential.organization = _organization;
        new_credential.name = _name;
        new_credential.grade = _grade;
    }

    function getCredential() public view returns (Credential memory)
    {
        return credential;
    }

    function editCredential(address _student, address _university, 
                                string memory _name, uint256 _grade) public UniversityOnly
    {
        credential.student = _student;
        credential.university = _university;
        credential.name = _name;
        credential.grade = _grade;
    }
}