//SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

interface IDAOFactory {
    function getDaos() external view returns (address[] memory);

    function monthlyCost() external view returns (uint256);

    function subscriptions(address _dao) external view returns (uint256);

    function containsDao(address _dao) external view returns (bool);

    function addDAO(address _dao) external returns (bool);

    function tokenPerDao(address _dao) external view returns(address);

}
