// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { AdvancedOrder, Order, OrderParameters } from "seaport/lib/ConsiderationStructs.sol";
import { OrderParametersLib } from "./OrderParametersLib.sol";

library AdvancedOrderLib {
    bytes32 private constant ADVANCED_ORDER_MAP_POSITION = keccak256("seaport.AdvancedOrderDefaults");

    using OrderParametersLib for OrderParameters;

    /**
     * @notice clears a default AdvancedOrder from storage
     * @param defaultName the name of the default to clear
     */
    function clear(string memory defaultName) internal {
        mapping(string => AdvancedOrder) storage advancedOrderMap = _advancedOrderMap();
        AdvancedOrder storage item = advancedOrderMap[defaultName];
        // clear all fields
        item.parameters.clear();
        item.signature = "";
    }

    /**
     * @notice gets a default AdvancedOrder from storage
     * @param defaultName the name of the default for retrieval
     */
    function fromDefault(string memory defaultName) internal view returns (AdvancedOrder memory item) {
        mapping(string => AdvancedOrder) storage advancedOrderMap = _advancedOrderMap();
        item = advancedOrderMap[defaultName];
    }

    /**
     * @notice saves an AdvancedOrder as a named default
     * @param advancedOrder the AdvancedOrder to save as a default
     * @param defaultName the name of the default for retrieval
     */
    function saveDefault(AdvancedOrder memory advancedOrder, string memory defaultName) internal {
        mapping(string => AdvancedOrder) storage advancedOrderMap = _advancedOrderMap();
        advancedOrderMap[defaultName] = advancedOrder;
    }

    /**
     * @notice makes a copy of an AdvancedOrder in-memory
     * @param item the AdvancedOrder to make a copy of in-memory
     */
    function copy(AdvancedOrder memory item) internal pure returns (AdvancedOrder memory) {
        return AdvancedOrder({
            parameters: item.parameters.copy(),
            numerator: item.numerator,
            denominator: item.denominator,
            signature: item.signature,
            extraData: item.extraData
        });
    }

    function copy(AdvancedOrder[] memory items) internal pure returns (AdvancedOrder[] memory) {
        AdvancedOrder[] memory copiedItems = new AdvancedOrder[](items.length);
        for (uint256 i = 0; i < items.length; i++) {
            copiedItems[i] = copy(items[i]);
        }
        return copiedItems;
    }

    /**
     * @notice gets the storage position of the default AdvancedOrder map
     */
    function _advancedOrderMap() private pure returns (mapping(string => AdvancedOrder) storage advancedOrderMap) {
        bytes32 position = ADVANCED_ORDER_MAP_POSITION;
        assembly {
            advancedOrderMap.slot := position
        }
    }

    // methods for configuring a single of each of an AdvancedOrder's fields, which modifies the AdvancedOrder in-place
    // and
    // returns it

    function withParameters(
        AdvancedOrder memory advancedOrder,
        OrderParameters memory parameters
    )
        internal
        pure
        returns (AdvancedOrder memory)
    {
        advancedOrder.parameters = parameters.copy();
        return advancedOrder;
    }

    function withNumerator(
        AdvancedOrder memory advancedOrder,
        uint120 numerator
    )
        internal
        pure
        returns (AdvancedOrder memory)
    {
        advancedOrder.numerator = numerator;
        return advancedOrder;
    }

    function withDenominator(
        AdvancedOrder memory advancedOrder,
        uint120 denominator
    )
        internal
        pure
        returns (AdvancedOrder memory)
    {
        advancedOrder.denominator = denominator;
        return advancedOrder;
    }

    function withSignature(
        AdvancedOrder memory advancedOrder,
        bytes memory signature
    )
        internal
        pure
        returns (AdvancedOrder memory)
    {
        advancedOrder.signature = signature;
        return advancedOrder;
    }

    function withExtraData(
        AdvancedOrder memory advancedOrder,
        bytes memory extraData
    )
        internal
        pure
        returns (AdvancedOrder memory)
    {
        advancedOrder.extraData = extraData;
        return advancedOrder;
    }

    function toOrder(AdvancedOrder memory advancedOrder) internal pure returns (Order memory order) {
        order.parameters = advancedOrder.parameters.copy();
        order.signature = advancedOrder.signature;
    }
}
