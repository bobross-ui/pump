// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.27;

import {Token} from "./Token.sol";

contract Factory {
    uint256 public constant TARGET = 3 ether;
    uint256 public constant TOKEN_LIMIT = 500_000 ether;

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

    event Buy(address indexed token, uint256 amount);

    constructor(uint256 _fee) {
        fee = _fee;
        owner = msg.sender;
    }

    function getTokenSale(
        uint256 _index
    ) public view returns (TokenSale memory) {
        return tokenToSale[tokens[_index]];
    }

    function getCost(uint256 _sold) public pure returns (uint256) {
        uint256 floor = 0.0001 ether;
        uint256 step = 0.0001 ether;
        uint256 increment = 10000 ether;

        uint cost = (step * (_sold / increment)) + floor;
        return cost;
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
        TokenSale memory sale = TokenSale(
            address(token),
            _name,
            msg.sender,
            0,
            0,
            true
        );

        tokenToSale[address(token)] = sale;

        //it's livee
        emit Created(address(token));
    }

    function buy(address _token, uint256 _amount) external payable {
        TokenSale storage sale = tokenToSale[_token];

        //Check conditions
        require(sale.isOpen == true, "Buying closed");
        require(_amount >= 1 ether, "Amount too low");
        require(_amount <= 10000 ether, "Amount exceeded");

        //calc price of token based upon total bought

        uint256 cost = getCost(sale.sold);

        uint256 price = cost * (_amount / 10 ** 18);

        //make sure enough eth is sent
        require(msg.value >= price, "Less ETH recieved");

        //update sale
        sale.sold += _amount;
        sale.raised += price;

        //make sure fundraising goal isn't met
        if (sale.sold >= TOKEN_LIMIT || sale.raised >= TARGET) {
            sale.isOpen = false;
        }

        Token(_token).transfer(msg.sender, _amount);

        //emit
        emit Buy(_token, _amount);
    }

    function deposit(address _token) external {
        
        Token token = Token(_token);
        TokenSale memory sale = tokenToSale[_token];

        require(sale.isOpen == false, "Target not reached");

        //transfer tokens
        token.transfer(sale.creator, token.balanceOf(address(this)));

        //transfer eth
        (bool success, ) = payable(sale.creator).call{value: sale.raised}("");
        require(success, "eth transfer failed");        
    }

    function withdraw(uint256 _amount) external {
        require(msg.sender == owner, "Not owner");

        (bool success, ) = payable(owner).call{value : _amount}("");
        require(success, "eth transfer failed");
    }
}
