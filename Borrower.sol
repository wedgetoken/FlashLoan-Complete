pragma solidity ^0.6.6;

import 'https://github.com/aave/aave-protocol/blob/master/contracts/configuration/LendingPoolAddressesProvider.sol'
import 'https://github.com/aave/aave-protocol/blob/master/contracts/lendingpool/LendingPool.sol'
import 'https://github.com/aave/aave-protocol/blob/master/contracts/flashloan/base/FlashLoanReceiverBase.sol'

contract Borrower is FlashLoanReceiverBase {
    LendingPoolAddressesProvider;
    adress dai;

    constructor(
        address_provider
        address_dai) 
        FlashLoanReceiverBase(_provider) 
        public {
        provider = LendingPoolAddressProvider(_provider)
        dai = _dai; 
    }

    funcion startloan(uint amount, bites calldata _params) external {
        LendingPool lendingPool  = LendingPool(provider.getlendingPool());
        lendingPool.flashloan(address(this), dai, amount, _params);
    }

    funcion executeOperation(
        address _reserve,
        uint _amount,
        uint _fee,
        bytes memory _params
    ) external {
        //arbitrage, refinance loan, change collateral
        transferFundsBackToPoolInternal (_reserve, amount +fee)
    }
