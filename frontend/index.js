let web3;
let account;
let contract;

async function connectWallet() {
    if (window.ethereum) {
        web3 = new Web3("http://127.0.0.1:7545");   // Default Ganache RPC
        await ethereum.request({ method: "eth_requestAccounts" });
        
        // const accounts = await web3.eth.getAccounts();
        // account = accounts[0];
        account = document.getElementById("walletAddress").value;

        await loadContract();
        await detectRole();
    }
}

async function loadContract() {
    const abiFile = await fetch("./contracts/UniversityCredential.json");
    const json = await abiFile.json();

    const abi = json.abi;
    const address = json.networks["5777"].address;  // Ganache network ID

    contract = new web3.eth.Contract(abi, address);
}

async function detectRole() {
    const admin = await contract.methods.admin().call();

    if (account.toLowerCase() === admin.toLowerCase()) {
        // document.getElementById("userRole").innerText = "Admin";
        // document.getElementById("adminSection").style.display = "block";
        window.location.href = "admin.html"
        return;
    }

    const isIssuer = await contract.methods.approvedIssuers(account).call();

    if (isIssuer) {
        document.getElementById("userRole").innerText = "Issuer";
        document.getElementById("issuerSection").style.display = "block";
        return;
    }

    document.getElementById("userRole").innerText = "User";
    document.getElementById("userSection").style.display = "block";
}

// ADMIN SECTION
async function approveIssuer() {
    const issuer = document.getElementById("issuerAddress").value;

    await contract.methods.ApproveIssuers(issuer)
        .send({ from: account });

    alert("Issuer approved!");
}

async function revokeIssuer() {
    const issuer = document.getElementById("revokeIssuerAddress").value;

    await contract.methods.RevokeIssuers(issuer)
        .send({ from: account });

    alert("Issuer revoked!");
}

// ISSUER SECTION
async function issueCredential() {
    const user = document.getElementById("userAddress").value;
    const type = document.getElementById("credentialType").value;
    const hash = document.getElementById("documentHash").value;
    const cid = document.getElementById("ipfsCID").value;

    await contract.methods.IssueCredential(user, type, hash, cid)
        .send({ from: account });

    alert("Credential issued!");
}

async function revokeCredential() {
    const id = document.getElementById("credentialIdRevoke").value;

    await contract.methods.RevokeCredential(id)
        .send({ from: account });

    alert("Credential revoked.");
}

// USER SECTION
async function viewCredential() {
    const id = document.getElementById("credentialIdLookup").value;

    const data = await contract.methods.GetCredential(id).call();

    document.getElementById("credentialDetails").innerText =
        JSON.stringify(data, null, 2);
}