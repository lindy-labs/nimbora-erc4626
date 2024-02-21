// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC4626} from "@openzeppelin/contracts/interfaces/IERC4626.sol";
import {StrategyBase} from "nimbora-yields-l1-public/strategies/StrategyBase.sol";
import {ErrorLib} from "nimbora-yields-l1-public/lib/ErrorLib.sol";

contract Nimbora4626 is StrategyBase {
    constructor(address _poolingManager, address _underlyingToken, address _yieldToken, address _bridge) {
        //if (IERC4626(_yieldToken).asset() != _underlyingToken) revert ErrorLib.InvalidUnderlyingToken();
        _strategyBase__init(_poolingManager, _underlyingToken, _yieldToken, _bridge);
    }

    /// @inheritdoc StrategyBase
    function addressToApprove() external view override returns (address) {
        return (yieldToken);
    }

    /// @inheritdoc StrategyBase
    function depositCalldata(uint256 _amount) external view override returns (address target, bytes memory cdata) {
        target = yieldToken;
        cdata = abi.encodeWithSignature("deposit(uint256,address)", _amount, address(this));
    }

    /// @inheritdoc StrategyBase
    function _withdraw(uint256 _amount) internal override returns (uint256) {
        uint256 yieldAmountToWithdraw = IERC4626(yieldToken).previewWithdraw(_amount);
        uint256 strategyYieldBalance = _yieldBalance();
        if (yieldAmountToWithdraw > strategyYieldBalance) {
            return IERC4626(yieldToken).redeem(strategyYieldBalance, poolingManager, address(this));
        } else {
            return IERC4626(yieldToken).withdraw(_amount, poolingManager, address(this));
        }
    }

    /// @inheritdoc StrategyBase
    function _underlyingToYield(uint256 _amount) internal view override returns (uint256) {
        return IERC4626(yieldToken).previewDeposit(_amount);
    }

    /// @inheritdoc StrategyBase
    function _yieldToUnderlying(uint256 _amount) internal view override returns (uint256) {
        return IERC4626(yieldToken).previewRedeem(_amount);
    }
}
