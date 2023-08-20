// SPDX-License-Identifier: GPL-2.0-or-later
// Gearbox Protocol. Generalized leverage for DeFi protocols
// (c) Gearbox Foundation, 2023.
pragma solidity ^0.8.17;

import {AdapterType} from "@gearbox-protocol/sdk/contracts/AdapterType.sol";
import {IAdapter} from "@gearbox-protocol/core-v2/contracts/interfaces/IAdapter.sol";

import {N_COINS} from "../../integrations/curve/ICurvePool_2.sol";
import {ICurveV1_2AssetsAdapter} from "../../interfaces/curve/ICurveV1_2AssetsAdapter.sol";
import {CurveV1AdapterBase} from "./CurveV1_Base.sol";

/// @title Curve V1 2 assets adapter
/// @notice Implements logic allowing to interact with Curve pools with 2 assets
contract CurveV1Adapter2Assets is CurveV1AdapterBase, ICurveV1_2AssetsAdapter {
    function _gearboxAdapterType() external pure virtual override(CurveV1AdapterBase, IAdapter) returns (AdapterType) {
        return AdapterType.CURVE_V1_2ASSETS;
    }

    /// @notice Constructor
    /// @param _creditManager Credit manager address
    /// @param _curvePool Target Curve pool address
    /// @param _lp_token Pool LP token address
    /// @param _metapoolBase Base pool address (for metapools only) or zero address
    constructor(address _creditManager, address _curvePool, address _lp_token, address _metapoolBase)
        CurveV1AdapterBase(_creditManager, _curvePool, _lp_token, _metapoolBase, N_COINS)
    {}

    /// @inheritdoc ICurveV1_2AssetsAdapter
    function add_liquidity(uint256[N_COINS] calldata amounts, uint256)
        external
        creditFacadeOnly
        returns (uint256 tokensToEnable, uint256 tokensToDisable)
    {
        (tokensToEnable, tokensToDisable) = _add_liquidity(amounts[0] > 1, amounts[1] > 1, false, false); // F: [ACV1_2-4, ACV1S-1]
    }

    /// @inheritdoc ICurveV1_2AssetsAdapter
    function remove_liquidity(uint256, uint256[N_COINS] calldata)
        external
        virtual
        creditFacadeOnly
        returns (uint256 tokensToEnable, uint256 tokensToDisable)
    {
        (tokensToEnable, tokensToDisable) = _remove_liquidity(); // F: [ACV1_2-5]
    }

    /// @inheritdoc ICurveV1_2AssetsAdapter
    function remove_liquidity_imbalance(uint256[N_COINS] calldata amounts, uint256)
        external
        virtual
        override
        creditFacadeOnly
        returns (uint256 tokensToEnable, uint256 tokensToDisable)
    {
        (tokensToEnable, tokensToDisable) = _remove_liquidity_imbalance(amounts[0] > 1, amounts[1] > 1, false, false); // F: [ACV1_2-6]
    }
}
