let web3;
let account;
let contract;

async function connectWallet() {
    if (window.ethereum) {
        web3 = new Web3("http://127.0.0.1:7545");   // Default Ganache RPC
        // await ethereum.request({ method: "eth_requestAccounts" });
        
        account = document.getElementById("walletAddress").value;
        // save account
        localStorage.setItem("walletAddress", account);

        await loadContract();
        await moveToRolePage();
    }
}

async function loadContract() {
    let abiFile = await fetch("./contracts/UniversityCredential.json");
    let json = await abiFile.json();

    let abi = json.abi;
    let address = json.networks["5777"].address;  // Ganache network ID

    contract = new web3.eth.Contract(abi, address);
}

async function moveToRolePage() {
    let admin = await contract.methods.admin().call();

    if (account.toLowerCase() === admin.toLowerCase()) {
        window.location.href = "admin.html"
        return;
    }

    const isIssuer = await contract.methods.approvedIssuers(account).call();

    if (isIssuer) {
        window.location.href = "issuer.html"
        return;
    }

    // Go to user page if none of the above are true
    window.location.href = "user.html"
    return;
}