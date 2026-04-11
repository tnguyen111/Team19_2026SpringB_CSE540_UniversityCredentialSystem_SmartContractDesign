// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// UniversityCredential Smart Contract
// Group 19: Ba Le Nguyen, Chaolun Cai, Hang Qu, Khac Long Pham, Tung Nguyen

contract UniversityCredential 
{
    // Set admin once when the contract is deployed
    address public admin;

    // Constructor when the contract is deployed
    constructor() {
        admin = msg.sender;
    }

    // A credential record to store everything about one issued credential
    struct Credential 
    {
        address issuer;         // who issued it, e.g. universities, education institutes, certificate providers 
        address user;           // who received it, e.g. students, degree holders, alumnus
        string  credentialType; // type of credential, e.g. "Diploma", "Transcript"
        bytes32 documentHash;   // keccak256 hash of the off-chain document
        string  ipfsCID;        // IPFS link to the actual document
        bool    isRevoked;      // true if the issuer revoked it
        uint256 issuedAt;       // timestamp of the issuance
    }

    // Storage for all credentials using credential ID as key and credentialCount to track latest/next ID
    mapping(uint256 => Credential) public credentials;
    
    // Track approved universities using issuer wallet address as key and returns true if approved, false otherwise
    mapping(address => bool) public approvedIssuers;

    // Credential counter for unique IDs
    uint256 public credentialCount;

    // Storage for valid user
    address[] public registeredUsers;

    // Event when admin approves a issuer
    event IssuerApproved(address indexed issuer);

    // Event when a credential is issued
    event CredentialIssued(
        uint256 indexed credentialId,
        address indexed issuer,
        address indexed user,
        string  credentialType,
        bytes32 documentHash
    );

    // Event when a credential is revoked
    event CredentialRevoked(uint256 indexed credentialId);

    // Event when someone verifies a credential
    event CredentialVerified(uint256 indexed credentialId, bool isValid);

    //// Admin functions ////
    // Function modifier to check admin permission
    modifier AdminOnly() {
        require(msg.sender == admin, "Only admin can use this function!");
        _;
    }

    // Approve a issuer so it can issue credentials.
    function ApproveIssuers(address issuer) public AdminOnly 
    {
        require(issuer != address(0), "Invalid address"); // Validate issuer's address
        approvedIssuers[issuer] = true;
        emit IssuerApproved(issuer);
    }

    // Remove a issuer's approval
    function RevokeIssuers(address issuer) public AdminOnly
    {
        approvedIssuers[issuer] = false;
    }

    //// Issuance functions ////
    // Issue a new credential for a user
    function IssueCredential(address user, string calldata credentialType, 
                                bytes32 documentHash, string calldata ipfsCID) 
    external returns (uint256 credentialId) 
    {
        require(approvedIssuers[msg.sender], "Not an approved issuer"); // Check issuer permission
        require(user != address(0), "Invalid user address");            // Validate user address
        require(documentHash != bytes32(0), "Document hash required");  // Check document hash
        require(bytes(ipfsCID).length > 0, "IPFS CID required");        // Check CID

        // Assign the next available ID
        credentialId = ++credentialCount;

        // Store the credential on-chain
        credentials[credentialId] = Credential({
            issuer: msg.sender,
            user: user,
            credentialType: credentialType,
            documentHash: documentHash,
            ipfsCID: ipfsCID,
            isRevoked: false,
            issuedAt: block.timestamp
        });

        emit CredentialIssued(
            credentialId,
            msg.sender,
            user,
            credentialType,
            documentHash
        );
    }

    // Revoke an issued credential
    function RevokeCredential(uint256 credentialId) external {
        Credential storage cred = credentials[credentialId];
        require(cred.issuer == msg.sender, "Only the issuing issuer can revoke");   // Verify the issuer permission
        require(!cred.isRevoked, "Already revoked");                                // Check credential revoke status
        
        // Revoke the credential (The record is still kept on chain)
        cred.isRevoked = true;
        emit CredentialRevoked(credentialId);
    }

    //// Verification functions ////
    // Verify that a credential is authentic and active
    function VerifyCredential(uint256 credentialId, bytes32 documentHash) external returns (bool isValid) {
        Credential storage cred = credentials[credentialId];

        require(cred.issuer != address(0), "Credential does not exist");    // Validate credential

        // Valid = hash matches what was issued AND not revoked
        isValid = (cred.documentHash == documentHash) && !cred.isRevoked;

        emit CredentialVerified(credentialId, isValid);
        return isValid;
    }

    // Verify that a credential is authentic and active without emitting verification event
    function CheckCredential(uint256 credentialId, bytes32 documentHash) external view returns (bool) {
        Credential storage cred = credentials[credentialId];
        return (cred.documentHash == documentHash) && !cred.isRevoked;
    }

    // Get all stored details about a credential
    function GetCredential(uint256 credentialId) external view returns (Credential memory) {
        require(credentials[credentialId].issuer != address(0), "Credential does not exist");   // Verify that the credetial exists
        return credentials[credentialId];
    }
}