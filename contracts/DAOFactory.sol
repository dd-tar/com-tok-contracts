pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
//import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./DAOToken.sol";

contract DAOFactory is Ownable, ReentrancyGuard {
    using EnumerableSet for EnumerableSet.AddressSet;

    /*using SafeERC20 for IERC20;

    //address public immutable paymentToken; // native

    //mapping(address => uint256) public subscriptions;
    */

    mapping(address => address) public tokenPerDao; // tokenPerDao[daoAddress] -> tokenAddress

    EnumerableSet.AddressSet private daos;

    event DAOTokenCreated(address dao, address token);

    function createDAOToken(
        string calldata _name,
        string calldata _symbol,
        uint256 _startPrice, // in wei
        address _dao
    )
    external
    nonReentrant
    returns (address tokenAddress) {

        //require(tokenPerDao[msg.sender] == address(0), "DAOFactory: can not change DAOToken");

        if(!daos.contains(_dao))
            require(daos.add(address(_dao)));

        DAOToken dt = new DAOToken(_name, _symbol, _startPrice, msg.sender);

        tokenPerDao[msg.sender] = address(dt);

        emit DAOTokenCreated(msg.sender, address(dt));

        return address(dt);
    }

    /*----view functions---------------------------------*/

    function daoAt(uint256 _i) external view returns (address) {
        return daos.at(_i);
    }

    function containsDao(address _dao) external view returns (bool) {
        return daos.contains(_dao);
    }

    function numberOfDaos() external view returns (uint256) {
        return daos.length();
    }

    function getDaos() external view returns (address[] memory) {
        uint256 daosLength = daos.length();

        if (daosLength == 0) {
            return new address[](0);
        } else {
            address[] memory daosArray = new address[](daosLength);

            for (uint256 i = 0; i < daosLength; i++) {
                daosArray[i] = daos.at(i);
            }

            return daosArray;
        }
    }

    // Some additional functionality that ComTokBot does not use
    //--------------------------- subscription ---------------------------------//
    /*

    uint256 public subscriptionCost;

    uint256 public freeTrial; // duration in sec

    uint256 public subscriptionDuration; // duration in sec

    function subscribe(address _dao)
    external
    payable
    returns (bool) {
        require(daos.contains(_dao));
        require(msg.value >= subscriptionCost,
            "DAOFactory: Insufficient funds have been sent to subscribe");

        if (subscriptions[_dao] < block.timestamp) {
            subscriptions[_dao] = block.timestamp + subscriptionDuration;
        } else {
            subscriptions[_dao] += subscriptionDuration;
        }

        //IERC20(paymentToken).safeTransferFrom(msg.sender, owner(), subscriptionCost);

        return true;
    }

    function changeSubscriptionCost(uint256 _cost)
    external
    onlyRabb
    returns (bool) {
        subscriptionCost = _cost;
        return true;
    }

    function changeFreeTrial(uint256 _freeTrial)
    external
    onlyRabb
    returns (bool){
        freeTrial = _freeTrial;
        return true;
    }

    function changeSubscriptionDuration(uint256 _duration)
    external
    onlyRabb
    returns (bool){
        subscriptionDuration = _duration;
        return true;
    }

    //--------------------------------------------------------------------------//

    event DaoAdded(address indexed dao);

    // Used during new gnosis-multisig initialization
    function addDAO(address _dao)
    external
    returns (bool){
        subscriptions[_dao] = block.timestamp + freeTrial;

        require(daos.add(address(_dao)));

        emit DaoAdded(_dao);

        return true;
    }

    // sends all the tokens received from subscriptions to the owner
    function withdraw(address wallet)
    external
    virtual
    onlyOwner {
        require(rabb != address(0), "Rabb not set");

        uint256 _balance = address(this).balance;

        require(payable(wallet).send(_balance));
    }

    function changeRabbAddress(address _rabbAddress)
    external
    onlyOwner {
        rabb = _rabbAddress;
    }
    */
}