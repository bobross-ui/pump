// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.27;

import {Token} from "./Token.sol";

contract Factory {
    uint256 public immutable fee;
    address public owner;

    address[] public tokens;
    uint256 public totalTokens;
    mapping(address => TokenSale) public tokenToSale;

    struct TokenSale {
        address token;
        string name;
        address creator;
        uint256 sold;
        uint256 raised;
        bool isOpen;
    }

    event Created(address indexed token);

    constructor(uint256 _fee) {
        fee = _fee;
        owner = msg.sender;
    }

    function getTokenSale(uint256 _index) public view returns (TokenSale memory) {
        return tokenToSale[tokens[_index]];
    }

    function create(
        string memory _name,
        string memory _symbol
    ) external payable {
        
        //make sure fee is correct 
        require(msg.value >= fee, "Give me more fee");

        // create token
        Token token = new Token(msg.sender, _name, _symbol, 1_000_000 ether);

        //save token
        tokens.push(address(token));

        totalTokens++;

        //list token
        TokenSale memory sale = TokenSale(address(token), _name, msg.sender, 0, 0, true);

        tokenToSale[address(token)] = sale;

        //it's livee
        emit Created(address(token));
    }

    function buy(address _token, uint256 _amount) external payable {

        Token(_token).transfer(msg.sender, _amount);
    }
}
