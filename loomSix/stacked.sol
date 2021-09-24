pragma solidity >=0.5.0 <0.6.0;

import "https://etherscan.io/address/0x07edbd02923435fe2c141f390510178c79dbbc46#events";


//We need to query the event logs labeled ‘staked’ in this contract: 
//Here is an api to do it 
//https://api.etherscan.io/apis
//Endpoint is in the ‘event logs’ portion 
//https://api.etherscan.io/apis/

contract EventTest {
    event Staked(address indexed _staker, uint256 _amount);
    

}

