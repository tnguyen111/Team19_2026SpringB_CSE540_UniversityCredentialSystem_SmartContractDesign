# Team19_2026SpringB_CSE540_UniversityCredentialSystem_SmartContractDesign

## Abstract
With the rise of digital information, it is getting increasingly difficult for companies and organizations to verify the authenticity of students’ degrees and transcripts. As a result, many cases of degree fraud and falsified transcripts have occurred over the years, and even more so in recent years. Thus, our team seeks to address the issue with a blockchain-based solution to verify authenticity and safely manage student degrees and transcripts.

## Proposed Architecture:
### Stakeholders:
-Users: Students, degree holders, alumni.
-Issuers: Universities, education institutes, certificate providers.
-Verifiers: Accreditation companies, third-party organizations, or individuals of interest.
### Identity Lifecycle:
- Registration: Issuers create Decentralized Identifiers (DID) and register their public keys on a blockchain registry. Users create their own profiles along with DID and a digital wallet to receive and manage their credentials.
- Issuance: Issuers generate a digital diploma/transcript/micro-credential and sign it. The actual credential is stored off-chain while the hash is recorded on-chain. The signed Verifiable Credential(VC) is sent to the user's digital wallet. 
- Presentation: Users share a Verifiable Presentation(VP) from their wallet, which can share only the needed parts of their credentials utilizing zero-knowledge proofs.
- Verification: Verifiers check the signature of the presentation against the issuer’s public key from the blockchain, use the smart contract to verify the hash to confirm the credential’s integration, and ensure the credential hasn’t been revoked. 
### Smart Contracts: 
Blockchain control layer (e.g. Ethereum), executes business logic (issuer issuance, public verification/revocation), stores DID document references, and records only the certificate hash on-chain. Its contract structure can include admin-managed issuer authorization, hash mapping to certificate data, and an actual certificate. 
### Off-Chain Storage: 
An encrypted off-chain database stores the actual document/JSON data (user institution, degree details) to IPFS, IPFS returns a unique Content Identifier(CID)/hash, which is passed to the certificate issuance phase. 
### Digital Wallets/DIDs: 
Students store their credentials and sign requests using self-sovereign identity principles.

## Application Interface
### Overview:
The front-end of the application will be web-based, which acts as the main interface for users, issuers, and verifiers. Instead of requiring users to manually install software or run blockchain scripts locally, the entire interaction happens through a browser-based UI. The page would connect to the blockchain using a wallet that lets users authenticate themselves through cryptographic signatures. Each user type will see different dashboard features based on their permissions.

![Interaction_Idea](https://github.com/user-attachments/assets/7ed4f606-fedb-47ac-a347-5e15e267647b)

### How Users Log In:
Users authenticate by connecting their Web3 wallet:
- The wallet address acts as the user’s blockchain identity.
- Issuers must be pre-approved by the admin contract.
- Users/Students use the wallet they own to receive credentials.
- Verifiers simply connect any wallet to perform checks.
The website could verify the user’s role by reading on-chain data such as:
- From the approvedIssuers[address]
- Whether the address is a part of the credential holders
- General wallet connection status
