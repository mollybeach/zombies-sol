/*Chapter 2: Web3 Providers
Great! Now that we have Web3.js in our project, let's get it initialized and talking to the blockchain.
The first thing we need is a Web3 Provider.
Remember, Ethereum is made up of nodes that all share a copy of the same data. Setting a Web3 Provider in Web3.js tells our code which node we should be talking to handle our reads and writes. It's kind of like setting the URL of the remote web server for your API calls in a traditional web app.
You could host your own Ethereum node as a provider. However, there's a third-party service that makes your life easier so you don't need to maintain your own Ethereum node in order to provide a DApp for your users — Infura.
Infura
Infura is a service that maintains a set of Ethereum nodes with a caching layer for fast reads, which you can access for free through their API. Using Infura as a provider, you can reliably send and receive messages to/from the Ethereum blockchain without needing to set up and maintain your own node.
You can set up Web3 to use Infura as your web3 provider as follows:
var web3 = new Web3(new Web3.providers.WebsocketProvider("wss://mainnet.infura.io/ws"));
However, since our DApp is going to be used by many users — and these users are going to WRITE to the blockchain and not just read from it — we'll need a way for these users to sign transactions with their private key.
Note: Ethereum (and blockchains in general) use a public / private key pair to digitally sign transactions. Think of it like an extremely secure password for a digital signature. That way if I change some data on the blockchain, I can prove via my public key that I was the one who signed it — but since no one knows my private key, no one can forge a transaction for me.
Cryptography is complicated, so unless you're a security expert and you really know what you're doing, it's probably not a good idea to try to manage users' private keys yourself in our app's front-end.
But luckily you don't need to — there are already services that handle this for you. The most popular of these is Metamask.
Metamask
Metamask is a browser extension for Chrome and Firefox that lets users securely manage their Ethereum accounts and private keys, and use these accounts to interact with websites that are using Web3.js. (If you haven't used it before, you'll definitely want to go and install it — then your browser is Web3 enabled, and you can now interact with any website that communicates with the Ethereum blockchain!).
And as a developer, if you want users to interact with your DApp through a website in their web browser (like we're doing with our CryptoZombies game), you'll definitely want to make it Metamask-compatible.
Note: Metamask uses Infura's servers under the hood as a web3 provider, just like we did above — but it also gives the user the option to choose their own web3 provider. So by using Metamask's web3 provider, you're giving the user a choice, and it's one less thing you have to worry about in your app.
Using Metamask's web3 provider
Metamask injects their web3 provider into the browser in the global JavaScript object web3. So your app can check to see if web3 exists, and if it does use web3.currentProvider as its provider.
Here's some template code provided by Metamask for how we can detect to see if the user has Metamask installed, and if not tell them they'll need to install it to use our app:
window.addEventListener('load', function() {

  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    // Use Mist/MetaMask's provider
    web3js = new Web3(web3.currentProvider);
  } else {
    // Handle the case where the user doesn't have web3. Probably
    // show them a message telling them to install Metamask in
    // order to use our app.
  }

  // Now you can start your app & access web3js freely:
  startApp()

})
You can use this boilerplate code in all the apps you create in order to require users to have Metamask to use your DApp.
Note: There are other private key management programs your users might be using besides MetaMask, such as the web browser Mist. However, they all implement a common pattern of injecting the variable web3, so the method we describe here for detecting the user's web3 provider will work for these as well.
Put it to the Test
We've created some empty script tags before the closing </body> tag in our HTML file. We can write our javascript code for this lesson here.
1. Go ahead and copy/paste the template code from above for detecting Metamask. It's the block that starts with window.addEventListener.
Chapter 3: Talking to Contracts
Now that we've initialized Web3.js with MetaMask's Web3 provider, let's set it up to talk to our smart contract.

Web3.js will need 2 things to talk to your contract: its address and its ABI.

Contract Address
After you finish writing your smart contract, you will compile it and deploy it to Ethereum. We're going to cover deployment in the next lesson, but since that's quite a different process from writing code, we've decided to go out of order and cover Web3.js first.

After you deploy your contract, it gets a fixed address on Ethereum where it will live forever. If you recall from Lesson 2, the address of the CryptoKitties contract on Ethereum mainnet is 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d.

You'll need to copy this address after deploying in order to talk to your smart contract.

Contract ABI
The other thing Web3.js will need to talk to your contract is its ABI.

ABI stands for Application Binary Interface. Basically it's a representation of your contracts' methods in JSON format that tells Web3.js how to format function calls in a way your contract will understand.

When you compile your contract to deploy to Ethereum (which we'll cover in Lesson 7), the Solidity compiler will give you the ABI, so you'll need to copy and save this in addition to the contract address.

Since we haven't covered deployment yet, for this lesson we've compiled the ABI for you and put it in a file named cryptozombies_abi.js, stored in variable called cryptoZombiesABI.

If we include cryptozombies_abi.js in our project, we'll be able to access the CryptoZombies ABI using that variable.

Instantiating a Web3.js Contract
Once you have your contract's address and ABI, you can instantiate it in Web3 as follows:

// Instantiate myContract
var myContract = new web3js.eth.Contract(myABI, myContractAddress);
Put it to the Test
In the <head> of our document, include another script tag for cryptozombies_abi.js so we can import the ABI definition into our project.

At the beginning of our <script> tag in the <body>, declare a var named cryptoZombies, but don't set it equal to anything. Later we'll use this variable to store our instantiated contract.

Next, create a function named startApp(). We'll fill in the body in the next 2 steps.

The first thing startApp() should do is declare a var named cryptoZombiesAddress and set it equal to the string "YOUR_CONTRACT_ADDRESS" (this is the address of the CryptoZombies contract on mainnet).

Lastly, let's instantiate our contract. Set cryptoZombies equal to an new web3js.eth.Contract like we did in the example code above. (Using cryptoZombiesABI, which gets imported with our script tag, and cryptoZombiesAddress from above).

index.html
cryptozombies_abi.js
zombieownership.sol
zombieattack.sol
zombiehelper.sol
zombiefeeding.sol
zombiefactory.sol
ownable.sol
safemath.sol
erc721.sol
12345678910111213141516171819202122
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <title>CryptoZombies front-end</title>
    <script language="javascript" type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script language="javascript" type="text/javascript" src="web3.min.js"></script>
    <!-- 1. Include cryptozombies_abi.js here -->
  </head>
  <body>

Chapter 5: Metamask & Accounts
Awesome! You've successfully written front-end code to interact with your first smart contract.

Now let's put some pieces together — let's say we want our app's homepage to display a user's entire zombie army.

Obviously we'd first need to use our function getZombiesByOwner(owner) to look up all the IDs of zombies the current user owns.

But our Solidity contract is expecting owner to be a Solidity address. How can we know the address of the user using our app?

Getting the user's account in MetaMask
MetaMask allows the user to manage multiple accounts in their extension.

We can see which account is currently active on the injected web3 variable via:

var userAccount = web3.eth.accounts[0]
Because the user can switch the active account at any time in MetaMask, our app needs to monitor this variable to see if it has changed and update the UI accordingly. For example, if the user's homepage displays their zombie army, when they change their account in MetaMask, we'll want to update the page to show the zombie army for the new account they've selected.

We can do that with a setInterval loop as follows:

var accountInterval = setInterval(function() {
  // Check if account has changed
  if (web3.eth.accounts[0] !== userAccount) {
    userAccount = web3.eth.accounts[0];
    // Call some function to update the UI with the new account
    updateInterface();
  }
}, 100);
What this does is check every 100 milliseconds to see if userAccount is still equal web3.eth.accounts[0] (i.e. does the user still have that account active). If not, it reassigns userAccount to the currently active account, and calls a function to update the display.

Put it to the Test
Let's make it so our app will display the user's zombie army when the page first loads, and monitor the active account in MetaMask to refresh the display if it changes.

Declare a var named userAccount, but don't assign it to anything.

At the end of startApp(), copy/paste the boilerplate accountInterval code from above

Replace the line updateInterface(); with a call to getZombiesByOwner, and pass it userAccount

Chain a then statement after getZombiesByOwner and pass the result to a function named displayZombies. (The syntax is: .then(displayZombies);).

We don't have a function called displayZombies yet, but we'll implement it in the next chapter.

index.html
zombieownership.sol
zombieattack.sol
zombiehelper.sol
zombiefeeding.sol
zombiefactory.sol
ownable.sol
safemath.sol
erc721.sol
12345678910111213141516171819202122
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <title>CryptoZombies front-end</title>
    <script language="javascript" type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script language="javascript" type="text/javascript" src="web3.min.js"></script>
    <script language="javascript" type="text/javascript" src="cryptozombies_abi.js"></script>
  </head>
  <body>

App Front-ends & Web3.js

 App Front-ends & Web3.js

*/