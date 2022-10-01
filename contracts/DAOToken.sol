// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "./interfaces/IDAOFactory.sol";

contract DAOToken is ReentrancyGuard,  ERC20Votes {

    address public immutable dao;

    address public immutable daoFactory;

    uint256 internal price; // Price in wei

    bool public mintable = true;
    bool public mintableStatusFrozen = false;

    event TokensMinted(address senderAddress, uint256 amount);

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _price,
        address _dao
    ) ERC20(_name, _symbol) ERC20Permit(_name){
        dao = _dao;
        price = _price;
        daoFactory = msg.sender;
    }

    modifier onlyDAO{
        require(msg.sender == dao, "DAOToken: caller is not the dao");
        _;
    }

    function mint(uint256 _amount) // Amount in wei
    external
    payable
    nonReentrant
    returns (bool)
    {
        require(mintable, "DAOToken: minting is disabled");

        uint256 surplus = msg.value - (price * _amount) / 1e18;

        require(
            surplus  >= 0,
            "Insufficient funds have been sent to purchase tokens");

        if (surplus > 0){
            (bool sent, ) = payable(msg.sender).call{value: surplus}("");
            require(sent, "DAOToken: Failed to return surplus");
        }

        (bool sent2, ) = payable(dao).call{value: msg.value - surplus}("");
        require(sent2, "DAOToken: Failed to send funds");

        _mint(msg.sender, _amount); // Amount in wei

        emit TokensMinted(msg.sender, _amount);

        return true;
    }

    function getPrice() public view virtual returns (uint256){
        return price;
    }

    /*----Only Dao-----------------------------------------*/

    event PriceChanged(address tokenAddress, uint256 newPrice);

    function setPrice(uint256 _newPrice)
    external
    onlyDAO
    virtual {
        price = _newPrice;
        emit PriceChanged(address(this), _newPrice);
    }

    function changeMintable(bool _mintable)
    external
    onlyDAO
    returns (bool) {
        require(!mintableStatusFrozen, "DAOToken: minting status is frozen");
        mintable = _mintable;
        return true;
    }

    function freezeMintingStatus()
    external
    onlyDAO
    returns (bool) {
        mintableStatusFrozen = true;
        return true;
    }
}