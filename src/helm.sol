// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {console} from "forge-std/console.sol";

import {LibString} from "solady/src/utils/LibString.sol";

import {BasicOrderType, ItemType, OrderType, Side} from "seaport-types/src/lib/ConsiderationEnums.sol";

import {
    AdditionalRecipient,
    AdvancedOrder,
    BasicOrderParameters,
    ConsiderationItem,
    CriteriaResolver,
    Execution,
    Fulfillment,
    FulfillmentComponent,
    OfferItem,
    Order,
    OrderComponents,
    OrderParameters,
    ReceivedItem,
    SpentItem,
    ZoneParameters
} from "seaport-types/src/lib/ConsiderationStructs.sol";

import {ConduitItemType} from "seaport-types/src/conduit/lib/ConduitEnums.sol";

import {ConduitBatch1155Transfer, ConduitTransfer} from "seaport-types/src/conduit/lib/ConduitStructs.sol";

import {
    TransferHelperItem, TransferHelperItemsWithRecipient
} from "seaport-types/src/helpers/TransferHelperStructs.sol";

import {
    Amount,
    BroadOrderType,
    Caller,
    ConduitChoice,
    ContractOrderRebate,
    Criteria,
    EOASignature,
    ExtraData,
    FulfillmentRecipient,
    Offerer,
    Recipient,
    SignatureMethod,
    Time,
    Tips,
    TokenIndex,
    UnavailableReason,
    Zone,
    ZoneHash
} from "./SpaceEnums.sol";

import {
    AggregationStrategy,
    FulfillAvailableStrategy,
    FulfillmentStrategy,
    MatchStrategy
} from "./fulfillments/lib/FulfillmentLib.sol";

import {FulfillmentDetails, OrderDetails} from "./fulfillments/lib/Structs.sol";

import {
    AdvancedOrdersSpace,
    ConsiderationItemSpace,
    OfferItemSpace,
    OrderComponentsSpace,
    ReceivedItemSpace,
    SpentItemSpace
} from "./StructSpace.sol";

/**
 * @title helm
 * @author snotrocket.eth
 * @notice helm is an extension of the console.sol library that provides
 *         additional logging functionality for Seaport-related structs.
 */
library helm {
    function log(OrderComponents memory orderComponents) public view {
        logOrderComponents(orderComponents, 0);
    }

    function log(OrderComponents[] memory orderComponentsArray) public view {
        console.log(gStr(0, "orderComponentsArray: ["));
        for (uint256 j = 0; j < orderComponentsArray.length; j++) {
            logOrderComponents(orderComponentsArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logOrderComponents(
        OrderComponents memory oc,
        uint256 i // indent
    ) internal view {
        console.log(gStr(i, "OrderComponents: {"));
        console.log(gStr(i + 1, "offerer", oc.offerer));
        console.log(gStr(i + 1, "zone", oc.zone));
        logOffer(oc.offer, i + 1);
        logConsideration(oc.consideration, i + 1);
        console.log(gStr(i + 1, "orderType", _orderTypeStr(oc.orderType)));
        console.log(gStr(i + 1, "startTime", oc.startTime));
        console.log(gStr(i + 1, "endTime", oc.endTime));
        console.log(gStr(i + 1, "zoneHash", oc.zoneHash));
        console.log(gStr(i + 1, "salt", oc.salt));
        console.log(gStr(i + 1, "conduitKey", oc.conduitKey));
        console.log(gStr(i + 1, "counter", oc.counter));
        console.log(gStr(i, "}"));
    }

    function log(OfferItem memory offerItem) public view {
        logOfferItem(offerItem, 0);
    }

    function log(OfferItem[] memory offerItemArray) public view {
        console.log(gStr(0, "offerItemArray: ["));
        for (uint256 j = 0; j < offerItemArray.length; j++) {
            logOfferItem(offerItemArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logOfferItem(
        OfferItem memory oi,
        uint256 i // indent
    ) internal view {
        console.log(gStr(i, "OfferItem: {"));
        console.log(gStr(i + 1, "itemType", _itemTypeStr(oi.itemType)));
        console.log(gStr(i + 1, "token", oi.token));
        console.log(gStr(i + 1, "identifierOrCriteria", oi.identifierOrCriteria));
        console.log(gStr(i + 1, "startAmount", oi.startAmount));
        console.log(gStr(i + 1, "endAmount", oi.endAmount));
        console.log(gStr(i, "}"));
    }

    function log(ConsiderationItem memory considerationItem) public view {
        logConsiderationItem(considerationItem, 0);
    }

    function log(ConsiderationItem[] memory considerationItemArray) public view {
        console.log(gStr(0, "considerationItemArray: ["));
        for (uint256 j = 0; j < considerationItemArray.length; j++) {
            logConsiderationItem(considerationItemArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logConsiderationItem(
        ConsiderationItem memory ci,
        uint256 i // indent
    ) internal view {
        console.log(gStr(i, "ConsiderationItem: {"));
        console.log(gStr(i + 1, "itemType", _itemTypeStr(ci.itemType)));
        console.log(gStr(i + 1, "token", ci.token));
        console.log(gStr(i + 1, "identifierOrCriteria", ci.identifierOrCriteria));
        console.log(gStr(i + 1, "startAmount", ci.startAmount));
        console.log(gStr(i + 1, "endAmount", ci.endAmount));
        console.log(gStr(i, "}"));
    }

    function log(SpentItem memory spentItem) public view {
        logSpentItem(spentItem, 0);
    }

    function log(SpentItem[] memory spentItemArray) public view {
        console.log(gStr(0, "spentItemArray: ["));
        for (uint256 j = 0; j < spentItemArray.length; j++) {
            logSpentItem(spentItemArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logSpentItem(
        SpentItem memory si,
        uint256 i // indent
    ) internal view {
        console.log(gStr(i, "SpentItem: {"));
        console.log(gStr(i + 1, "itemType", _itemTypeStr(si.itemType)));
        console.log(gStr(i + 1, "token", si.token));
        console.log(gStr(i + 1, "identifier", si.identifier));
        console.log(gStr(i + 1, "amount", si.amount));
        console.log(gStr(i, "}"));
    }

    function log(ReceivedItem memory receivedItem) public view {
        logReceivedItem(receivedItem, 0);
    }

    function log(ReceivedItem[] memory receivedItemArray) public view {
        console.log(gStr(0, "receivedItemArray: ["));
        for (uint256 j = 0; j < receivedItemArray.length; j++) {
            logReceivedItem(receivedItemArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logReceivedItem(
        ReceivedItem memory ri,
        uint256 i // indent
    ) internal view {
        console.log(gStr(i, "ReceivedItem: {"));
        console.log(gStr(i + 1, "itemType", _itemTypeStr(ri.itemType)));
        console.log(gStr(i + 1, "token", ri.token));
        console.log(gStr(i + 1, "identifier", ri.identifier));
        console.log(gStr(i + 1, "amount", ri.amount));
        console.log(gStr(i + 1, "recipient", ri.recipient));
        console.log(gStr(i, "}"));
    }

    function log(BasicOrderParameters memory basicOrderParameters) public view {
        logBasicOrderParameters(basicOrderParameters, 0);
    }

    function log(BasicOrderParameters[] memory basicOrderParametersArray) public view {
        console.log(gStr(0, "basicOrderParametersArray: ["));
        for (uint256 j = 0; j < basicOrderParametersArray.length; j++) {
            logBasicOrderParameters(basicOrderParametersArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logBasicOrderParameters(
        BasicOrderParameters memory bop,
        uint256 i // indent
    ) internal view {
        console.log(gStr(i, "BasicOrderParameters: {"));
        console.log(gStr(i + 1, "considerationToken", bop.considerationToken));
        console.log(gStr(i + 1, "considerationIdentifier", bop.considerationIdentifier));
        console.log(gStr(i + 1, "considerationAmount", bop.considerationAmount));
        console.log(gStr(i + 1, "offerer", bop.offerer));
        console.log(gStr(i + 1, "zone", bop.zone));
        console.log(gStr(i + 1, "offerToken", bop.offerToken));
        console.log(gStr(i + 1, "offerIdentifier", bop.offerIdentifier));
        console.log(gStr(i + 1, "offerAmount", bop.offerAmount));
        console.log(gStr(i + 1, "basicOrderType", _basicOrderTypeStr(bop.basicOrderType)));
        console.log(gStr(i + 1, "startTime", bop.startTime));
        console.log(gStr(i + 1, "endTime", bop.endTime));
        console.log(gStr(i + 1, "zoneHash", bop.zoneHash));
        console.log(gStr(i + 1, "salt", bop.salt));
        console.log(gStr(i + 1, "offererConduitKey", bop.offererConduitKey));
        console.log(gStr(i + 1, "fulfillerConduitKey", bop.fulfillerConduitKey));
        console.log(gStr(i + 1, "totalOriginalAdditionalRecipients", bop.totalOriginalAdditionalRecipients));
        console.log(gStr(i + 1, "additionalRecipients: ["));
        for (uint256 j = 0; j < bop.additionalRecipients.length; j++) {
            logAdditionalRecipient(bop.additionalRecipients[j], i + 1);
        }
        console.log(gStr(i + 1, "]"));
        console.log(gStr(i + 1, "signature", bop.signature));
        console.log(gStr(i, "}"));
    }

    function log(AdditionalRecipient memory additionalRecipient) public view {
        logAdditionalRecipient(additionalRecipient, 0);
    }

    function log(AdditionalRecipient[] memory additionalRecipientArray) public view {
        console.log(gStr(0, "additionalRecipientArray: ["));
        for (uint256 j = 0; j < additionalRecipientArray.length; j++) {
            logAdditionalRecipient(additionalRecipientArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logAdditionalRecipient(
        AdditionalRecipient memory ar,
        uint256 i // indent
    ) internal view {
        console.log(gStr(i, "AdditionalRecipient: {"));
        console.log(gStr(i + 1, "recipient", ar.recipient));
        console.log(gStr(i + 1, "amount", ar.amount));
        console.log(gStr(i, "}"));
    }

    function log(OrderParameters memory orderParameters) public view {
        logOrderParameters(orderParameters, 0);
    }

    function log(OrderParameters[] memory orderParametersArray) public view {
        console.log(gStr(0, "orderParametersArray: ["));
        for (uint256 j = 0; j < orderParametersArray.length; j++) {
            logOrderParameters(orderParametersArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logOrderParameters(
        OrderParameters memory op,
        uint256 i // indent
    ) internal view {
        console.log(gStr(i, "OrderParameters: {"));
        console.log(gStr(i + 1, "offerer", op.offerer));
        console.log(gStr(i + 1, "zone", op.zone));
        logOffer(op.offer, i + 1);
        logConsideration(op.consideration, i + 1);
        console.log(gStr(i + 1, "orderType", _orderTypeStr(op.orderType)));
        console.log(gStr(i + 1, "startTime", op.startTime));
        console.log(gStr(i + 1, "endTime", op.endTime));
        console.log(gStr(i + 1, "zoneHash", op.zoneHash));
        console.log(gStr(i + 1, "salt", op.salt));
        console.log(gStr(i + 1, "conduitKey", op.conduitKey));
        console.log(gStr(i + 1, "totalOriginalConsiderationItems", op.totalOriginalConsiderationItems));
        console.log(gStr(i, "}"));
    }

    function log(Order memory order) public view {
        logOrder(order, 0);
    }

    function log(Order[] memory orderArray) public view {
        console.log(gStr(0, "orderArray: ["));
        for (uint256 j = 0; j < orderArray.length; j++) {
            logOrder(orderArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logOrder(Order memory order, uint256 i /* indent */ ) internal view {
        console.log(gStr(i, "Order: {"));
        logOrderParameters(order.parameters, i + 1);
        console.log(gStr(i + 1, "signature", order.signature));
        console.log(gStr(i, "}"));
    }

    function log(AdvancedOrder memory advancedOrder) public view {
        logAdvancedOrder(advancedOrder, 0);
    }

    function log(AdvancedOrder[] memory advancedOrderArray) public view {
        console.log(gStr(0, "advancedOrderArray: ["));
        for (uint256 j = 0; j < advancedOrderArray.length; j++) {
            logAdvancedOrder(advancedOrderArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logAdvancedOrder(
        AdvancedOrder memory advancedOrder,
        uint256 i // indent
    ) internal view {
        console.log(gStr(i, "AdvancedOrder: {"));
        logOrderParameters(advancedOrder.parameters, i + 1);
        console.log(gStr(i + 1, "numerator", advancedOrder.numerator));
        console.log(gStr(i + 1, "denominator", advancedOrder.denominator));
        console.log(gStr(i + 1, "signature", advancedOrder.signature));
        console.log(gStr(i + 1, "extraData", advancedOrder.extraData));
        console.log(gStr(i, "}"));
    }

    function log(CriteriaResolver memory criteriaResolver) public view {
        logCriteriaResolver(criteriaResolver, 0);
    }

    function log(CriteriaResolver[] memory criteriaResolverArray) public view {
        console.log(gStr(0, "criteriaResolverArray: ["));
        for (uint256 j = 0; j < criteriaResolverArray.length; j++) {
            logCriteriaResolver(criteriaResolverArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logCriteriaResolver(
        CriteriaResolver memory cr,
        uint256 i // indent
    ) internal view {
        console.log(gStr(i, "CriteriaResolver: {"));
        console.log(gStr(i + 1, "orderIndex", cr.orderIndex));
        console.log(gStr(i + 1, "side", _sideStr(cr.side)));
        console.log(gStr(i + 1, "index", cr.index));
        console.log(gStr(i + 1, "identifier", cr.identifier));
        for (uint256 j = 0; j < cr.criteriaProof.length; j++) {
            console.log(gStr(i + 2, "criteriaProof", cr.criteriaProof[j]));
        }
        console.log(gStr(i, "}"));
    }

    function log(Fulfillment memory fulfillment) public view {
        logFulfillment(fulfillment, 0);
    }

    function log(Fulfillment[] memory fulfillmentArray) public view {
        console.log(gStr(0, "fulfillmentArray: ["));
        for (uint256 j = 0; j < fulfillmentArray.length; j++) {
            logFulfillment(fulfillmentArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logFulfillment(
        Fulfillment memory f,
        uint256 i // indent
    ) internal view {
        console.log(gStr(i, "Fulfillment: {"));
        console.log(gStr(i + 1, "offerComponents: ["));
        for (uint256 j = 0; j < f.offerComponents.length; j++) {
            logFulfillmentComponent(f.offerComponents[j], i + 2);
        }
        console.log(gStr(i + 1, "]"));
        console.log(gStr(i + 1, "considerationComponents: ["));
        for (uint256 j = 0; j < f.considerationComponents.length; j++) {
            logFulfillmentComponent(f.considerationComponents[j], i + 2);
        }
        console.log(gStr(i + 1, "]"));
        console.log(gStr(i, "}"));
    }

    function log(FulfillmentComponent memory fulfillmentComponent) public view {
        logFulfillmentComponent(fulfillmentComponent, 0);
    }

    function log(FulfillmentComponent[] memory fulfillmentComponentArray) public view {
        console.log(gStr(0, "fulfillmentComponentArray: ["));
        for (uint256 j = 0; j < fulfillmentComponentArray.length; j++) {
            logFulfillmentComponent(fulfillmentComponentArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logFulfillmentComponent(
        FulfillmentComponent memory fc,
        uint256 i // indent
    ) internal view {
        console.log(gStr(i, "FulfillmentComponent: {"));
        console.log(gStr(i + 1, "orderIndex", fc.orderIndex));
        console.log(gStr(i + 1, "itemIndex", fc.itemIndex));
        console.log(gStr(i, "}"));
    }

    function log(Execution memory execution) public view {
        logExecution(execution, 0);
    }

    function log(Execution[] memory executionArray) public view {
        console.log(gStr(0, "executionArray: ["));
        for (uint256 j = 0; j < executionArray.length; j++) {
            logExecution(executionArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logExecution(
        Execution memory execution,
        uint256 i // indent
    ) internal view {
        console.log(gStr(i, "Execution: {"));
        logReceivedItem(execution.item, i + 1);
        console.log(gStr(i + 1, "offerer", execution.offerer));
        console.log(gStr(i + 1, "conduitKey", execution.conduitKey));
        console.log(gStr(i, "}"));
    }

    function log(ZoneParameters memory zoneParameters) public view {
        logZoneParameters(zoneParameters, 0);
    }

    function log(ZoneParameters[] memory zoneParametersArray) public view {
        console.log(gStr(0, "zoneParametersArray: ["));
        for (uint256 j = 0; j < zoneParametersArray.length; j++) {
            logZoneParameters(zoneParametersArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logZoneParameters(
        ZoneParameters memory zp,
        uint256 i // indent
    ) internal view {
        console.log(gStr(i, "ZoneParameters: {"));
        console.log(gStr(i + 1, "orderHash", zp.orderHash));
        console.log(gStr(i + 1, "fulfiller", zp.fulfiller));
        console.log(gStr(i + 1, "offerer", zp.offerer));
        console.log(gStr(i + 1, "offer: ["));
        for (uint256 j = 0; j < zp.offer.length; j++) {
            logSpentItem(zp.offer[j], i + 1);
        }
        console.log(gStr(i + 1, "]"));
        console.log(gStr(i + 1, "consideration: ["));
        for (uint256 j = 0; j < zp.consideration.length; j++) {
            logReceivedItem(zp.consideration[j], i + 1);
        }
        console.log(gStr(i + 1, "]"));
        console.log(gStr(i + 1, "extraData", zp.extraData));
        console.log(gStr(i + 1, "orderHashes: ["));
        for (uint256 j = 0; j < zp.orderHashes.length; j++) {
            console.log(gStr(i + 2, "", zp.orderHashes[j]));
        }
        console.log(gStr(i + 1, "]"));
        console.log(gStr(i + 1, "startTime", zp.startTime));
        console.log(gStr(i + 1, "endTime", zp.endTime));
        console.log(gStr(i + 1, "zoneHash", zp.zoneHash));
        console.log(gStr(i, "}"));
    }

    function log(ConduitTransfer memory conduitTransfer) public view {
        logConduitTransfer(conduitTransfer, 0);
    }

    function log(ConduitTransfer[] memory conduitTransferArray) public view {
        console.log(gStr(0, "conduitTransferArray: ["));
        for (uint256 j = 0; j < conduitTransferArray.length; j++) {
            logConduitTransfer(conduitTransferArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logConduitTransfer(
        ConduitTransfer memory ct,
        uint256 i // indent
    ) internal view {
        console.log(gStr(i, "ConduitTransfer: {"));
        console.log(gStr(i + 1, "itemType", _conduitItemTypeStr(ct.itemType)));
        console.log(gStr(i + 1, "token", ct.token));
        console.log(gStr(i + 1, "from", ct.from));
        console.log(gStr(i + 1, "to", ct.to));
        console.log(gStr(i + 1, "identifier", ct.identifier));
        console.log(gStr(i + 1, "amount", ct.amount));
        console.log(gStr(i, "}"));
    }

    function log(ConduitBatch1155Transfer memory conduitBatch1155Transfer) public view {
        logConduitBatch1155Transfer(conduitBatch1155Transfer, 0);
    }

    function log(ConduitBatch1155Transfer[] memory conduitBatch1155TransferArray) public view {
        console.log(gStr(0, "conduitBatch1155TransferArray: ["));
        for (uint256 j = 0; j < conduitBatch1155TransferArray.length; j++) {
            logConduitBatch1155Transfer(conduitBatch1155TransferArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logConduitBatch1155Transfer(
        ConduitBatch1155Transfer memory cbt,
        uint256 i // indent
    ) internal view {
        console.log(gStr(i, "ConduitBatch1155Transfer: {"));
        console.log(gStr(i + 1, "token", cbt.token));
        console.log(gStr(i + 1, "from", cbt.from));
        console.log(gStr(i + 1, "to", cbt.to));
        console.log(gStr(i + 1, "ids: ["));
        for (uint256 j = 0; j < cbt.ids.length; j++) {
            console.log(gStr(i + 2, "", cbt.ids[j]));
        }
        console.log(gStr(i + 1, "]"));
        console.log(gStr(i + 1, "amounts: ["));
        for (uint256 j = 0; j < cbt.amounts.length; j++) {
            console.log(gStr(i + 2, "", cbt.amounts[j]));
        }
        console.log(gStr(i + 1, "]"));
        console.log(gStr(i, "}"));
    }

    function log(TransferHelperItem memory transferHelperItem) public view {
        logTransferHelperItem(transferHelperItem, 0);
    }

    function log(TransferHelperItem[] memory transferHelperItemArray) public view {
        console.log(gStr(0, "transferHelperItemArray: ["));
        for (uint256 j = 0; j < transferHelperItemArray.length; j++) {
            logTransferHelperItem(transferHelperItemArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logTransferHelperItem(
        TransferHelperItem memory thi,
        uint256 i // indent
    ) internal view {
        console.log(gStr(i, "TransferHelperItem: {"));
        console.log(gStr(i + 1, "itemType", _conduitItemTypeStr(thi.itemType)));
        console.log(gStr(i + 1, "token", thi.token));
        console.log(gStr(i + 1, "identifier", thi.identifier));
        console.log(gStr(i + 1, "amount", thi.amount));
        console.log(gStr(i, "}"));
    }

    function log(TransferHelperItemsWithRecipient memory transferHelperItemsWithRecipient) public view {
        logTransferHelperItemsWithRecipient(transferHelperItemsWithRecipient, 0);
    }

    function log(TransferHelperItemsWithRecipient[] memory transferHelperItemsWithRecipientArray) public view {
        console.log(gStr(0, "transferHelperItemsWithRecipientArray: ["));
        for (uint256 j = 0; j < transferHelperItemsWithRecipientArray.length; j++) {
            logTransferHelperItemsWithRecipient(transferHelperItemsWithRecipientArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logTransferHelperItemsWithRecipient(
        TransferHelperItemsWithRecipient memory thiwr,
        uint256 i // indent
    ) internal view {
        console.log(gStr(i, "TransferHelperItemsWithRecipient: {"));
        console.log(gStr(i + 1, "items: ["));
        for (uint256 j = 0; j < thiwr.items.length; j++) {
            logTransferHelperItem(thiwr.items[j], i + 2);
        }
        console.log(gStr(i + 1, "]"));
        console.log(gStr(i + 1, "recipient", thiwr.recipient));
        console.log(gStr(i + 1, "validateERC721Receiver", thiwr.validateERC721Receiver));
        console.log(gStr(i, "}"));
    }

    function log(OrderDetails memory orderDetails) public view {
        logOrderDetails(orderDetails, 0);
    }

    function log(OrderDetails[] memory orderDetailsArray) public view {
        console.log(gStr(0, "orderDetailsArray: ["));
        for (uint256 j = 0; j < orderDetailsArray.length; j++) {
            logOrderDetails(orderDetailsArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logOrderDetails(
        OrderDetails memory od,
        uint256 i // indent
    ) internal view {
        console.log(gStr(i, "OrderDetails: {"));
        console.log(gStr(i + 1, "offerer", od.offerer));
        console.log(gStr(i + 1, "conduitKey", od.conduitKey));
        console.log(gStr(i + 1, "offer: ["));
        for (uint256 j = 0; j < od.offer.length; j++) {
            logSpentItem(od.offer[j], i + 2);
        }
        console.log(gStr(i + 1, "]"));
        console.log(gStr(i + 1, "consideration: ["));
        for (uint256 j = 0; j < od.consideration.length; j++) {
            logReceivedItem(od.consideration[j], i + 2);
        }
        console.log(gStr(i + 1, "]"));
        console.log(gStr(i + 1, "isContract", od.isContract));
        console.log(gStr(i + 1, "orderHash", od.orderHash));
        console.log(gStr(i + 1, "unavailableReason", _unavailableReasonStr(od.unavailableReason)));
        console.log(gStr(i, "}"));
    }

    function log(FulfillmentDetails memory fulfillmentDetails) public view {
        logFulfillmentDetails(fulfillmentDetails, 0);
    }

    function log(FulfillmentDetails[] memory fulfillmentDetailsArray) public view {
        console.log(gStr(0, "fulfillmentDetailsArray: ["));
        for (uint256 j = 0; j < fulfillmentDetailsArray.length; j++) {
            logFulfillmentDetails(fulfillmentDetailsArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logFulfillmentDetails(
        FulfillmentDetails memory fd,
        uint256 i // indent
    ) internal view {
        console.log(gStr(i, "FulfillmentDetails: {"));
        console.log(gStr(i + 1, "orders: ["));
        for (uint256 j = 0; j < fd.orders.length; j++) {
            logOrderDetails(fd.orders[j], i + 2);
        }
        console.log(gStr(i + 1, "]"));
        console.log(gStr(i + 1, "recipient", fd.recipient));
        console.log(gStr(i + 1, "fulfiller", fd.fulfiller));
        console.log(gStr(i + 1, "nativeTokensSupplied", fd.nativeTokensSupplied));
        console.log(gStr(i + 1, "fulfillerConduitKey", fd.fulfillerConduitKey));
        console.log(gStr(i + 1, "seaport", fd.seaport));
        console.log(gStr(i, "}"));
    }

    function log(OfferItemSpace memory offerItemSpace) public view {
        logOfferItemSpace(offerItemSpace, 0);
    }

    function log(OfferItemSpace[] memory offerItemSpaceArray) public view {
        console.log(gStr(0, "offerItemSpaceArray: ["));
        for (uint256 j = 0; j < offerItemSpaceArray.length; j++) {
            logOfferItemSpace(offerItemSpaceArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logOfferItemSpace(
        OfferItemSpace memory ois,
        uint256 i // indent
    ) internal view {
        console.log(gStr(i, "OfferItemSpace: {"));
        console.log(gStr(i + 1, "itemType", _itemTypeStr(ois.itemType)));
        console.log(gStr(i + 1, "tokenIndex", _tokenIndexStr(ois.tokenIndex)));
        console.log(gStr(i + 1, "criteria", _criteriaStr(ois.criteria)));
        console.log(gStr(i + 1, "amount", _amountStr(ois.amount)));
        console.log(gStr(i, "}"));
    }

    function log(ConsiderationItemSpace memory considerationItemSpace) public view {
        logConsiderationItemSpace(considerationItemSpace, 0);
    }

    function log(ConsiderationItemSpace[] memory considerationItemSpaceArray) public view {
        console.log(gStr(0, "considerationItemSpaceArray: ["));
        for (uint256 j = 0; j < considerationItemSpaceArray.length; j++) {
            logConsiderationItemSpace(considerationItemSpaceArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logConsiderationItemSpace(
        ConsiderationItemSpace memory cis,
        uint256 i // indent
    ) internal view {
        console.log(gStr(i, "ConsiderationItemSpace: {"));
        console.log(gStr(i + 1, "itemType", _itemTypeStr(cis.itemType)));
        console.log(gStr(i + 1, "tokenIndex", _tokenIndexStr(cis.tokenIndex)));
        console.log(gStr(i + 1, "criteria", _criteriaStr(cis.criteria)));
        console.log(gStr(i + 1, "amount", _amountStr(cis.amount)));
        console.log(gStr(i + 1, "recipient", _recipientStr(cis.recipient)));
        console.log(gStr(i, "}"));
    }

    function log(SpentItemSpace memory spentItemSpace) public view {
        logSpentItemSpace(spentItemSpace, 0);
    }

    function log(SpentItemSpace[] memory spentItemSpaceArray) public view {
        console.log(gStr(0, "spentItemSpaceArray: ["));
        for (uint256 j = 0; j < spentItemSpaceArray.length; j++) {
            logSpentItemSpace(spentItemSpaceArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logSpentItemSpace(
        SpentItemSpace memory sis,
        uint256 i // indent
    ) internal view {
        console.log(gStr(i, "SpentItemSpace: {"));
        console.log(gStr(i + 1, "itemType", _itemTypeStr(sis.itemType)));
        console.log(gStr(i + 1, "tokenIndex", _tokenIndexStr(sis.tokenIndex)));
        console.log(gStr(i, "}"));
    }

    function log(ReceivedItemSpace memory receivedItemSpace) public view {
        logReceivedItemSpace(receivedItemSpace, 0);
    }

    function log(ReceivedItemSpace[] memory receivedItemSpaceArray) public view {
        console.log(gStr(0, "receivedItemSpaceArray: ["));
        for (uint256 j = 0; j < receivedItemSpaceArray.length; j++) {
            logReceivedItemSpace(receivedItemSpaceArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logReceivedItemSpace(
        ReceivedItemSpace memory ris,
        uint256 i // indent
    ) internal view {
        console.log(gStr(i, "ReceivedItemSpace: {"));
        console.log(gStr(i + 1, "itemType", _itemTypeStr(ris.itemType)));
        console.log(gStr(i + 1, "tokenIndex", _tokenIndexStr(ris.tokenIndex)));
        console.log(gStr(i + 1, "recipient", _recipientStr(ris.recipient)));
        console.log(gStr(i, "}"));
    }

    function log(OrderComponentsSpace memory orderComponentsSpace) public view {
        logOrderComponentsSpace(orderComponentsSpace, 0);
    }

    function log(OrderComponentsSpace[] memory orderComponentsSpaceArray) public view {
        console.log(gStr(0, "orderComponentsSpaceArray: ["));
        for (uint256 j = 0; j < orderComponentsSpaceArray.length; j++) {
            logOrderComponentsSpace(orderComponentsSpaceArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logOrderComponentsSpace(
        OrderComponentsSpace memory ocs,
        uint256 i // indent
    ) internal view {
        console.log(gStr(i, "OrderComponentsSpace: {"));
        console.log(gStr(i + 1, "offerer", _offererStr(ocs.offerer)));
        console.log(gStr(i + 1, "zone", _zoneStr(ocs.zone)));
        console.log(gStr(i + 1, "offer: ["));
        for (uint256 j = 0; j < ocs.offer.length; j++) {
            logOfferItemSpace(ocs.offer[j], i + 2);
        }
        console.log(gStr(i + 1, "]"));
        console.log(gStr(i + 1, "consideration: ["));
        for (uint256 j = 0; j < ocs.consideration.length; j++) {
            logConsiderationItemSpace(ocs.consideration[j], i + 2);
        }
        console.log(gStr(i + 1, "]"));
        console.log(gStr(i + 1, "orderType", _broadOrderTypeStr(ocs.orderType)));
        console.log(gStr(i + 1, "time", _timeStr(ocs.time)));
        console.log(gStr(i + 1, "zoneHash", _zoneHashStr(ocs.zoneHash)));
        console.log(gStr(i + 1, "signatureMethod", _signatureMethodStr(ocs.signatureMethod)));
        console.log(gStr(i + 1, "eoaSignatureType", _eoaSignatureTypeStr(ocs.eoaSignatureType)));
        console.log(gStr(i + 1, "bulkSigHeight", ocs.bulkSigHeight));
        console.log(gStr(i + 1, "bulkSigIndex", ocs.bulkSigIndex));
        console.log(gStr(i + 1, "conduit", _conduitChoiceStr(ocs.conduit)));
        console.log(gStr(i + 1, "tips", _tipsStr(ocs.tips)));
        console.log(gStr(i + 1, "unavailableReason", _unavailableReasonStr(ocs.unavailableReason)));
        console.log(gStr(i + 1, "extraData", _extraDataStr(ocs.extraData)));
        console.log(gStr(i + 1, "rebate", _contractOrderRebateStr(ocs.rebate)));
        console.log(gStr(i, "}"));
    }

    function log(AdvancedOrdersSpace memory advancedOrdersSpace) public view {
        logAdvancedOrdersSpace(advancedOrdersSpace, 0);
    }

    function log(AdvancedOrdersSpace[] memory advancedOrdersSpaceArray) public view {
        console.log(gStr(0, "advancedOrdersSpaceArray: ["));
        for (uint256 j = 0; j < advancedOrdersSpaceArray.length; j++) {
            logAdvancedOrdersSpace(advancedOrdersSpaceArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logAdvancedOrdersSpace(
        AdvancedOrdersSpace memory aos,
        uint256 i // indent
    ) internal view {
        console.log(gStr(i, "AdvancedOrdersSpace: {"));
        console.log(gStr(i + 1, "orders: ["));
        for (uint256 j = 0; j < aos.orders.length; j++) {
            logOrderComponentsSpace(aos.orders[j], i + 2);
        }
        console.log(gStr(i + 1, "]"));
        console.log(gStr(i + 1, "isMatchable", aos.isMatchable));
        console.log(gStr(i + 1, "maximumFulfilled", aos.maximumFulfilled));
        console.log(gStr(i + 1, "recipient", _fulfillmentRecipientStr(aos.recipient)));
        console.log(gStr(i + 1, "conduit", _conduitChoiceStr(aos.conduit)));
        console.log(gStr(i + 1, "caller", _callerStr(aos.caller)));
        logFulfillmentStrategy(aos.strategy, i + 1);
        console.log(gStr(i, "}"));
    }

    function log(FulfillmentStrategy memory fulfillmentStrategy) public view {
        logFulfillmentStrategy(fulfillmentStrategy, 0);
    }

    function log(FulfillmentStrategy[] memory fulfillmentStrategyArray) public view {
        console.log(gStr(0, "fulfillmentStrategyArray: ["));
        for (uint256 j = 0; j < fulfillmentStrategyArray.length; j++) {
            logFulfillmentStrategy(fulfillmentStrategyArray[j], 1);
        }
        console.log(gStr(0, "]"));
    }

    function logFulfillmentStrategy(
        FulfillmentStrategy memory fs,
        uint256 i // indent
    ) internal view {
        console.log(gStr(i, "FulfillmentStrategy: {"));
        console.log(gStr(i + 1, "aggregationStrategy", _aggregationStrategyStr(fs.aggregationStrategy)));
        console.log(gStr(i + 1, "fulfillAvailableStrategy", _fulfillAvailableStrategyStr(fs.fulfillAvailableStrategy)));
        console.log(gStr(i + 1, "matchStrategy", _matchStrategyStr(fs.matchStrategy)));
        console.log(gStr(i, "}"));
    }

    ////////////////////////////////////////////////////////////////////////////
    //                              Helpers                                   //
    ////////////////////////////////////////////////////////////////////////////

    function generateIndentString(
        uint256 i // indent
    ) public pure returns (string memory) {
        string memory indentString = "";
        for (uint256 j = 0; j < i; j++) {
            indentString = string.concat(indentString, "    ");
        }
        return indentString;
    }

    function gStr(
        // generateString
        uint256 i, // indent
        string memory stringToIndent
    ) public pure returns (string memory) {
        string memory indentString = generateIndentString(i);
        return string.concat(indentString, stringToIndent);
    }

    function gStr(
        uint256 i, // indent
        string memory labelString,
        string memory valueString
    ) public pure returns (string memory) {
        string memory indentString = generateIndentString(i);
        return string.concat(indentString, string.concat(labelString, ": ", valueString));
    }

    function gStr(
        uint256 i, // indent
        string memory labelString,
        uint256 value
    ) public pure returns (string memory) {
        string memory indentString = generateIndentString(i);
        return string.concat(indentString, string.concat(labelString, ": ", LibString.toString(value)));
    }

    function gStr(
        uint256 i, // indent
        string memory labelString,
        address value
    ) public pure returns (string memory) {
        string memory indentString = generateIndentString(i);
        return string.concat(indentString, string.concat(labelString, ": ", LibString.toHexString(value)));
    }

    function gStr(
        uint256 i, // indent
        string memory labelString,
        bytes32 value
    ) public pure returns (string memory) {
        string memory indentString = generateIndentString(i);
        return string.concat(indentString, string.concat(labelString, ": ", LibString.toHexString(uint256(value))));
    }

    function gStr(
        uint256 i, // indent
        string memory labelString,
        bytes memory value
    ) public pure returns (string memory) {
        string memory indentString = generateIndentString(i);
        return string.concat(indentString, string.concat(labelString, ": ", LibString.toHexString(value)));
    }

    function gStr(
        uint256 i, // indent
        string memory labelString,
        bool value
    ) public pure returns (string memory) {
        string memory indentString = generateIndentString(i);
        return string.concat(indentString, string.concat(labelString, ": ", value ? "True" : "False"));
    }

    ////////////////////////////////////////////////////////////////////////////
    //                              Log Arrays                                //
    ////////////////////////////////////////////////////////////////////////////

    function logOffer(OfferItem[] memory offer, uint256 i /* indent */ ) public view {
        console.log(gStr(i, "offer: ["));
        for (uint256 j = 0; j < offer.length; j++) {
            logOfferItem(offer[j], i + 1);
        }
        console.log(gStr(i, "]"));
    }

    function logConsideration(
        ConsiderationItem[] memory consideration,
        uint256 i // indent
    ) public view {
        console.log(gStr(i, "consideration: ["));
        for (uint256 j = 0; j < consideration.length; j++) {
            logConsiderationItem(consideration[j], i + 1);
        }
        console.log(gStr(i, "]"));
    }

    ////////////////////////////////////////////////////////////////////////////
    //                          Get Enum String Values                        //
    ////////////////////////////////////////////////////////////////////////////

    function _itemTypeStr(ItemType itemType) internal pure returns (string memory) {
        if (itemType == ItemType.NATIVE) return "NATIVE";
        if (itemType == ItemType.ERC20) return "ERC20";
        if (itemType == ItemType.ERC721) return "ERC721";
        if (itemType == ItemType.ERC1155) return "ERC1155";
        if (itemType == ItemType.ERC721_WITH_CRITERIA) {
            return "ERC721_WITH_CRITERIA";
        }
        if (itemType == ItemType.ERC1155_WITH_CRITERIA) {
            return "ERC1155_WITH_CRITERIA";
        }

        return "UNKNOWN";
    }

    function _orderTypeStr(OrderType orderType) internal pure returns (string memory) {
        if (orderType == OrderType.FULL_OPEN) return "FULL_OPEN";
        if (orderType == OrderType.PARTIAL_OPEN) return "PARTIAL_OPEN";
        if (orderType == OrderType.FULL_RESTRICTED) return "FULL_RESTRICTED";
        if (orderType == OrderType.PARTIAL_RESTRICTED) {
            return "PARTIAL_RESTRICTED";
        }
        if (orderType == OrderType.CONTRACT) return "CONTRACT";

        return "UNKNOWN";
    }

    function _basicOrderTypeStr(BasicOrderType basicOrderType) internal pure returns (string memory) {
        if (basicOrderType == BasicOrderType.ETH_TO_ERC721_FULL_OPEN) {
            return "ETH_TO_ERC721_FULL_OPEN";
        }
        if (basicOrderType == BasicOrderType.ETH_TO_ERC721_PARTIAL_OPEN) {
            return "ETH_TO_ERC721_PARTIAL_OPEN";
        }
        if (basicOrderType == BasicOrderType.ETH_TO_ERC721_FULL_RESTRICTED) {
            return "ETH_TO_ERC721_FULL_RESTRICTED";
        }
        if (basicOrderType == BasicOrderType.ETH_TO_ERC721_PARTIAL_RESTRICTED) {
            return "ETH_TO_ERC721_PARTIAL_RESTRICTED";
        }
        if (basicOrderType == BasicOrderType.ETH_TO_ERC1155_FULL_OPEN) {
            return "ETH_TO_ERC1155_FULL_OPEN";
        }
        if (basicOrderType == BasicOrderType.ETH_TO_ERC1155_PARTIAL_OPEN) {
            return "ETH_TO_ERC1155_PARTIAL_OPEN";
        }
        if (basicOrderType == BasicOrderType.ETH_TO_ERC1155_FULL_RESTRICTED) {
            return "ETH_TO_ERC1155_FULL_RESTRICTED";
        }
        if (basicOrderType == BasicOrderType.ETH_TO_ERC1155_PARTIAL_RESTRICTED) {
            return "ETH_TO_ERC1155_PARTIAL_RESTRICTED";
        }
        if (basicOrderType == BasicOrderType.ERC20_TO_ERC721_FULL_OPEN) {
            return "ERC20_TO_ERC721_FULL_OPEN";
        }
        if (basicOrderType == BasicOrderType.ERC20_TO_ERC721_PARTIAL_OPEN) {
            return "ERC20_TO_ERC721_PARTIAL_OPEN";
        }
        if (basicOrderType == BasicOrderType.ERC20_TO_ERC721_FULL_RESTRICTED) {
            return "ERC20_TO_ERC721_FULL_RESTRICTED";
        }
        if (basicOrderType == BasicOrderType.ERC20_TO_ERC721_PARTIAL_RESTRICTED) {
            return "ERC20_TO_ERC721_PARTIAL_RESTRICTED";
        }
        if (basicOrderType == BasicOrderType.ERC20_TO_ERC1155_FULL_OPEN) {
            return "ERC20_TO_ERC1155_FULL_OPEN";
        }
        if (basicOrderType == BasicOrderType.ERC20_TO_ERC1155_PARTIAL_OPEN) {
            return "ERC20_TO_ERC1155_PARTIAL_OPEN";
        }
        if (basicOrderType == BasicOrderType.ERC20_TO_ERC1155_FULL_RESTRICTED) {
            return "ERC20_TO_ERC1155_FULL_RESTRICTED";
        }
        if (basicOrderType == BasicOrderType.ERC20_TO_ERC1155_PARTIAL_RESTRICTED) {
            return "ERC20_TO_ERC1155_PARTIAL_RESTRICTED";
        }
        if (basicOrderType == BasicOrderType.ERC721_TO_ERC20_FULL_OPEN) {
            return "ERC721_TO_ERC20_FULL_OPEN";
        }
        if (basicOrderType == BasicOrderType.ERC721_TO_ERC20_PARTIAL_OPEN) {
            return "ERC721_TO_ERC20_PARTIAL_OPEN";
        }
        if (basicOrderType == BasicOrderType.ERC721_TO_ERC20_FULL_RESTRICTED) {
            return "ERC721_TO_ERC20_FULL_RESTRICTED";
        }
        if (basicOrderType == BasicOrderType.ERC721_TO_ERC20_PARTIAL_RESTRICTED) {
            return "ERC721_TO_ERC20_PARTIAL_RESTRICTED";
        }
        if (basicOrderType == BasicOrderType.ERC1155_TO_ERC20_FULL_OPEN) {
            return "ERC1155_TO_ERC20_FULL_OPEN";
        }
        if (basicOrderType == BasicOrderType.ERC1155_TO_ERC20_PARTIAL_OPEN) {
            return "ERC1155_TO_ERC20_PARTIAL_OPEN";
        }
        if (basicOrderType == BasicOrderType.ERC1155_TO_ERC20_FULL_RESTRICTED) {
            return "ERC1155_TO_ERC20_FULL_RESTRICTED";
        }
        if (basicOrderType == BasicOrderType.ERC1155_TO_ERC20_PARTIAL_RESTRICTED) {
            return "ERC1155_TO_ERC20_PARTIAL_RESTRICTED";
        }

        return "UNKNOWN";
    }

    function _sideStr(Side side) internal pure returns (string memory) {
        if (side == Side.OFFER) return "OFFER";
        if (side == Side.CONSIDERATION) return "CONSIDERATION";

        return "UNKNOWN";
    }

    function _conduitItemTypeStr(ConduitItemType conduitItemType) internal pure returns (string memory) {
        if (conduitItemType == ConduitItemType.NATIVE) return "NATIVE";
        if (conduitItemType == ConduitItemType.ERC20) return "ERC20";
        if (conduitItemType == ConduitItemType.ERC721) return "ERC721";
        if (conduitItemType == ConduitItemType.ERC1155) return "ERC1155";

        return "UNKNOWN";
    }

    function _amountStr(Amount amount) internal pure returns (string memory) {
        if (amount == Amount.FIXED) return "FIXED";
        if (amount == Amount.ASCENDING) return "ASCENDING";
        if (amount == Amount.DESCENDING) return "DESCENDING";

        return "UNKNOWN";
    }

    function _broadOrderTypeStr(BroadOrderType broadOrderType) internal pure returns (string memory) {
        if (broadOrderType == BroadOrderType.FULL) return "FULL";
        if (broadOrderType == BroadOrderType.PARTIAL) return "PARTIAL";
        if (broadOrderType == BroadOrderType.CONTRACT) return "CONTRACT";

        return "UNKNOWN";
    }

    function _callerStr(Caller caller) internal pure returns (string memory) {
        if (caller == Caller.TEST_CONTRACT) return "TEST_CONTRACT";
        if (caller == Caller.ALICE) return "ALICE";
        if (caller == Caller.BOB) return "BOB";
        if (caller == Caller.CAROL) return "CAROL";
        if (caller == Caller.DILLON) return "DILLON";
        if (caller == Caller.EVE) return "EVE";
        if (caller == Caller.FRANK) return "FRANK";

        return "UNKNOWN";
    }

    function _conduitChoiceStr(ConduitChoice conduitChoice) internal pure returns (string memory) {
        if (conduitChoice == ConduitChoice.NONE) return "NONE";
        if (conduitChoice == ConduitChoice.ONE) return "ONE";
        if (conduitChoice == ConduitChoice.TWO) return "TWO";

        return "UNKNOWN";
    }

    function _contractOrderRebateStr(ContractOrderRebate contractOrderRebate) internal pure returns (string memory) {
        if (contractOrderRebate == ContractOrderRebate.NONE) return "NONE";
        if (contractOrderRebate == ContractOrderRebate.MORE_OFFER_ITEMS) return "MORE_OFFER_ITEMS";
        if (contractOrderRebate == ContractOrderRebate.MORE_OFFER_ITEM_AMOUNTS) {
            return "MORE_OFFER_ITEM_AMOUNTS";
        }
        if (contractOrderRebate == ContractOrderRebate.LESS_CONSIDERATION_ITEMS) {
            return "LESS_CONSIDERATION_ITEMS";
        }
        if (contractOrderRebate == ContractOrderRebate.LESS_CONSIDERATION_ITEM_AMOUNTS) {
            return "LESS_CONSIDERATION_ITEM_AMOUNTS";
        }

        return "UNKNOWN";
    }

    function _criteriaStr(Criteria criteria) internal pure returns (string memory) {
        if (criteria == Criteria.MERKLE) return "MERKLE";
        if (criteria == Criteria.WILDCARD) return "WILDCARD";

        return "UNKNOWN";
    }

    function _eoaSignatureTypeStr(EOASignature eoaSignature) internal pure returns (string memory) {
        if (eoaSignature == EOASignature.STANDARD) return "STANDARD";
        if (eoaSignature == EOASignature.EIP2098) return "EIP2098";
        if (eoaSignature == EOASignature.BULK) return "BULK";
        if (eoaSignature == EOASignature.BULK2098) return "BULK2098";

        return "UNKNOWN";
    }

    function _extraDataStr(ExtraData extraData) internal pure returns (string memory) {
        if (extraData == ExtraData.NONE) return "NONE";
        if (extraData == ExtraData.RANDOM) return "RANDOM";

        return "UNKNOWN";
    }

    function _fulfillmentRecipientStr(FulfillmentRecipient fulfillmentRecipient)
        internal
        pure
        returns (string memory)
    {
        if (fulfillmentRecipient == FulfillmentRecipient.ZERO) return "ZERO";
        if (fulfillmentRecipient == FulfillmentRecipient.ALICE) return "ALICE";
        if (fulfillmentRecipient == FulfillmentRecipient.BOB) return "BOB";
        if (fulfillmentRecipient == FulfillmentRecipient.EVE) return "EVE";

        return "UNKNOWN";
    }

    function _offererStr(Offerer offerer) internal pure returns (string memory) {
        if (offerer == Offerer.TEST_CONTRACT) return "TEST_CONTRACT";
        if (offerer == Offerer.ALICE) return "ALICE";
        if (offerer == Offerer.BOB) return "BOB";
        if (offerer == Offerer.CONTRACT_OFFERER) return "CONTRACT_OFFERER";
        if (offerer == Offerer.EIP1271) return "EIP1271";

        return "UNKNOWN";
    }

    function _recipientStr(Recipient recipient) internal pure returns (string memory) {
        if (recipient == Recipient.OFFERER) return "OFFERER";
        if (recipient == Recipient.RECIPIENT) return "RECIPIENT";
        if (recipient == Recipient.DILLON) return "DILLON";
        if (recipient == Recipient.EVE) return "EVE";
        if (recipient == Recipient.FRANK) return "FRANK";

        return "UNKNOWN";
    }

    function _signatureMethodStr(SignatureMethod signatureMethod) internal pure returns (string memory) {
        if (signatureMethod == SignatureMethod.EOA) return "EOA";
        if (signatureMethod == SignatureMethod.VALIDATE) return "VALIDATE";
        if (signatureMethod == SignatureMethod.EIP1271) return "EIP1271";
        if (signatureMethod == SignatureMethod.CONTRACT) return "CONTRACT";
        if (signatureMethod == SignatureMethod.SELF_AD_HOC) return "SELF_AD_HOC";

        return "UNKNOWN";
    }

    function _timeStr(Time time) internal pure returns (string memory) {
        if (time == Time.STARTS_IN_FUTURE) return "STARTS_IN_FUTURE";
        if (time == Time.EXACT_START) return "EXACT_START";
        if (time == Time.ONGOING) return "ONGOING";
        if (time == Time.EXACT_END) return "EXACT_END";
        if (time == Time.EXPIRED) return "EXPIRED";

        return "UNKNOWN";
    }

    function _tipsStr(Tips tips) internal pure returns (string memory) {
        if (tips == Tips.NONE) return "NONE";
        if (tips == Tips.TIPS) return "TIPS";

        return "UNKNOWN";
    }

    function _tokenIndexStr(TokenIndex tokenIndex) internal pure returns (string memory) {
        if (tokenIndex == TokenIndex.ONE) return "ONE";
        if (tokenIndex == TokenIndex.TWO) return "TWO";
        if (tokenIndex == TokenIndex.THREE) return "THREE";

        return "UNKNOWN";
    }

    function _unavailableReasonStr(UnavailableReason unavailableReason) internal pure returns (string memory) {
        if (unavailableReason == UnavailableReason.AVAILABLE) return "AVAILABLE";
        if (unavailableReason == UnavailableReason.EXPIRED) return "EXPIRED";
        if (unavailableReason == UnavailableReason.STARTS_IN_FUTURE) return "STARTS_IN_FUTURE";
        if (unavailableReason == UnavailableReason.CANCELLED) return "CANCELLED";
        if (unavailableReason == UnavailableReason.ALREADY_FULFILLED) return "ALREADY_FULFILLED";
        if (unavailableReason == UnavailableReason.MAX_FULFILLED_SATISFIED) return "MAX_FULFILLED_SATISFIED";
        if (unavailableReason == UnavailableReason.GENERATE_ORDER_FAILURE) return "GENERATE_ORDER_FAILURE";

        return "UNKNOWN";
    }

    function _zoneStr(Zone zone) internal pure returns (string memory) {
        if (zone == Zone.NONE) return "NONE";
        if (zone == Zone.PASS) return "PASS";
        if (zone == Zone.FAIL) return "FAIL";

        return "UNKNOWN";
    }

    function _zoneHashStr(ZoneHash zoneHash) internal pure returns (string memory) {
        if (zoneHash == ZoneHash.NONE) return "NONE";
        if (zoneHash == ZoneHash.VALID) return "VALID";
        if (zoneHash == ZoneHash.INVALID) return "INVALID";

        return "UNKNOWN";
    }

    function _aggregationStrategyStr(AggregationStrategy aggregationStrategy) internal pure returns (string memory) {
        if (aggregationStrategy == AggregationStrategy.MINIMUM) return "MINIMUM";
        if (aggregationStrategy == AggregationStrategy.MAXIMUM) return "MAXIMUM";
        if (aggregationStrategy == AggregationStrategy.RANDOM) return "RANDOM";

        return "UNKNOWN";
    }

    function _fulfillAvailableStrategyStr(FulfillAvailableStrategy fulfillAvailableStrategy)
        internal
        pure
        returns (string memory)
    {
        if (fulfillAvailableStrategy == FulfillAvailableStrategy.KEEP_ALL) return "KEEP_ALL";
        if (fulfillAvailableStrategy == FulfillAvailableStrategy.DROP_SINGLE_OFFER) return "DROP_SINGLE_OFFER";
        if (fulfillAvailableStrategy == FulfillAvailableStrategy.DROP_ALL_OFFER) return "DROP_ALL_OFFER";
        if (fulfillAvailableStrategy == FulfillAvailableStrategy.DROP_RANDOM_OFFER) return "DROP_RANDOM_OFFER";
        if (fulfillAvailableStrategy == FulfillAvailableStrategy.DROP_SINGLE_KEEP_FILTERED) {
            return "DROP_SINGLE_KEEP_FILTERED";
        }
        if (fulfillAvailableStrategy == FulfillAvailableStrategy.DROP_ALL_KEEP_FILTERED) {
            return "DROP_ALL_KEEP_FILTERED";
        }
        if (fulfillAvailableStrategy == FulfillAvailableStrategy.DROP_RANDOM_KEEP_FILTERED) {
            return "DROP_RANDOM_KEEP_FILTERED";
        }

        return "UNKNOWN";
    }

    function _matchStrategyStr(MatchStrategy matchStrategy) internal pure returns (string memory) {
        if (matchStrategy == MatchStrategy.MAX_FILTERS) return "MAX_FILTERS";
        if (matchStrategy == MatchStrategy.MIN_FILTERS) return "MIN_FILTERS";
        if (matchStrategy == MatchStrategy.MAX_INCLUSION) return "MAX_INCLUSION";
        if (matchStrategy == MatchStrategy.MIN_INCLUSION) return "MIN_INCLUSION";
        if (matchStrategy == MatchStrategy.MIN_INCLUSION_MAX_FILTERS) return "MIN_INCLUSION_MAX_FILTERS";
        if (matchStrategy == MatchStrategy.MAX_EXECUTIONS) return "MAX_EXECUTIONS";
        if (matchStrategy == MatchStrategy.MIN_EXECUTIONS) return "MIN_EXECUTIONS";
        if (matchStrategy == MatchStrategy.MIN_EXECUTIONS_MAX_FILTERS) return "MIN_EXECUTIONS_MAX_FILTERS";

        return "UNKNOWN";
    }
}
