//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.5.0;

import "https://github.com/pkdcryptos/OpenZeppelin-openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol";
import "https://github.com/pkdcryptos/OpenZeppelin-openzeppelin-solidity/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/pkdcryptos/OpenZeppelin-openzeppelin-solidity/blob/master/contracts/token/ERC20/SafeERC20.sol";
import "https://github.com/aave/aave-protocol/blob/master/contracts/flashloan/interfaces/IFlashLoanReceiver.sol";
import "https://github.com/aave/aave-protocol/blob/master/contracts/interfaces/ILendingPoolAddressesProvider.sol";
import "https://github.com/aave/aave-protocol/blob/master/contracts/libraries/EthAddressLib.sol";

contract FlashLoanReceiverBase is IFlashLoanReceiver {

    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    ILendingPoolAddressesProvider public addressesProvider;

    constructor(ILendingPoolAddressesProvider _provider) public {
        addressesProvider = _provider;
    }

    function () external payable {
    }

    function transferFundsBackToPoolInternal(address _reserve, uint256 _amount) internal {

        address payable core = addressesProvider.getLendingPoolCore();

        transferInternal(core,_reserve, _amount);
    }

    function transferInternal(address payable _destination, address _reserve, uint256  _amount) internal {
        if(_reserve == EthAddressLib.ethAddress()) {
            //solium-disable-next-line
            _destination.call.value(_amount)("");
            return;
        }

        IERC20(_reserve).safeTransfer(_destination, _amount);

    }

    function getBalanceInternal(address _target, address _reserve) internal view returns(uint256) {
        if(_reserve == EthAddressLib.ethAddress()) {

            return _target.balance;
        }

        return IERC20(_reserve).balanceOf(_target);

    }
}
