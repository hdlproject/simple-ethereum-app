// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Citizenship.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract Money is ERC20, Ownable {
    using Address for address;
    using SafeMath for uint;

    Citizenship private citizenship;

    error CitizenNotRegistered(address citizenAddress);

    constructor (address citizenshipContractAddress)
    ERC20("money", "MNY")
    {
        citizenship = Citizenship(citizenshipContractAddress);
    }

    modifier onlyCitizen(address _address) {
        (string memory _id, uint8 _age) = citizenship.getCitizen(_address);

        if (bytes(_id).length == 0) {
            revert CitizenNotRegistered({citizenAddress: _address});
        }

        _;
    }

    modifier onlyPresident(address _address) {
        require(citizenship.hasRole(citizenship.PRESIDENT(), _address), "Money: not a president");
        _;
    }

    function mint(address account, uint amount)
    public
    onlyPresident(msg.sender)
    {
        _mint(account, amount);
    }

    function _mint(address to, uint256 amount)
    internal
    override(ERC20)
    {
        super._mint(to, amount);
    }

    function burn(address account, uint amount)
    public
    onlyPresident(msg.sender)
    {
        _burn(account, amount);
    }

    function _burn(address account, uint256 amount)
    internal
    override(ERC20)
    {
        super._burn(account, amount);
    }

    function transfer(address to, uint256 amount)
    public
    override(ERC20)
    onlyCitizen(msg.sender)
    onlyCitizen(to) returns (bool)
    {
        return super.transfer(to, amount);
    }
}
