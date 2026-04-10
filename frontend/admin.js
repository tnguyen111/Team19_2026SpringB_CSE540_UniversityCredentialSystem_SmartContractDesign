let web3;
let contract;
let account;

async function init() {
    web3 = new Web3("http://127.0.0.1:7545");

    const accounts = await web3.eth.getAccounts();
    
    account = localStorage.getItem("walletAddress") || accounts[0];
    console.log("Using account:", account);

    const response = await fetch("./contracts/UniversityCredential.json");
    const json = await response.json();

    console.log("ABI loaded:", json);

    const abi = json.abi;
    const address = json.networks["5777"].address;
    console.log("Contract address:", address);

    contract = new web3.eth.Contract(abi, address);
    console.log("Contract loaded:", contract);
}

window.onload = init;

async function approveIssuer() {
    if (!contract) {
        alert("Contract not loaded yet!");
        return;
    }

    let issuer = document.getElementById("issuerAddress").value;
    console.log(issuer);

    await contract.methods.ApproveIssuers(issuer).send({ from: account });

    alert("Issuer approved!");
}

async function revokeIssuer() {
    let issuer = document.getElementById("revokeIssuerAddress").value;

    await contract.methods.RevokeIssuers(issuer)
        .send({ from: account });

    alert("Issuer revoked!");
}