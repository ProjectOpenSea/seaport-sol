// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {
    OrderComponentsJson,
    OfferItemJson,
    ConsiderationItemJson,
    SpentItemJson,
    ReceivedItemJson,
    BasicOrderParametersJson,
    AdditionalRecipientJson,
    OrderParametersJson,
    OrderJson,
    AdvancedOrderJson,
    OrderStatusJson,
    CriteriaResolverJson,
    FulfillmentJson,
    FulfillmentComponentJson,
    ExecutionJson,
    ProtocolDataJson
} from "./SeaportJsonStructs.sol";

import {
    OrderComponents,
    OfferItem,
    ConsiderationItem,
    SpentItem,
    ReceivedItem,
    BasicOrderParameters,
    AdditionalRecipient,
    OrderParameters,
    Order,
    AdvancedOrder,
    OrderStatus,
    CriteriaResolver,
    Fulfillment,
    FulfillmentComponent,
    Execution
} from "seaport/lib/ConsiderationStructs.sol";

library JsonStructLib {
    using JsonStructLib for OrderComponentsJson;
    using JsonStructLib for OrderComponentsJson[];

    using JsonStructLib for OfferItemJson;
    using JsonStructLib for OfferItemJson[];

    using JsonStructLib for ConsiderationItemJson;
    using JsonStructLib for ConsiderationItemJson[];

    using JsonStructLib for SpentItemJson;
    using JsonStructLib for SpentItemJson[];

    using JsonStructLib for ReceivedItemJson;
    using JsonStructLib for ReceivedItemJson[];

    using JsonStructLib for BasicOrderParametersJson;
    using JsonStructLib for BasicOrderParametersJson[];

    using JsonStructLib for AdditionalRecipientJson;
    using JsonStructLib for AdditionalRecipientJson[];

    using JsonStructLib for OrderParametersJson;
    using JsonStructLib for OrderParametersJson[];

    using JsonStructLib for OrderJson;
    using JsonStructLib for OrderJson[];

    using JsonStructLib for AdvancedOrderJson;
    using JsonStructLib for AdvancedOrderJson[];

    using JsonStructLib for OrderStatusJson;
    using JsonStructLib for OrderStatusJson[];

    using JsonStructLib for CriteriaResolverJson;
    using JsonStructLib for CriteriaResolverJson[];

    using JsonStructLib for FulfillmentJson;
    using JsonStructLib for FulfillmentJson[];

    using JsonStructLib for FulfillmentComponentJson;
    using JsonStructLib for FulfillmentComponentJson[];

    using JsonStructLib for ExecutionJson;
    using JsonStructLib for ExecutionJson[];

    using JsonStructLib for ProtocolDataJson;

    function toOrderParameters(ProtocolDataJson memory a) internal pure returns (OrderParameters memory) {
        return OrderParameters({
            conduitKey: a.conduitKey,
            consideration: a.consideration.toStandard(),
            endTime: a.endTime,
            offer: a.offer.toStandard(),
            offerer: a.offerer,
            orderType: a.orderType,
            salt: a.salt,
            startTime: a.startTime,
            totalOriginalConsiderationItems: a.totalOriginalConsiderationItems,
            zone: a.zone,
            zoneHash: a.zoneHash
        });
    }

    function toOrderComponents(ProtocolDataJson memory a) internal pure returns (OrderComponents memory) {
        ConsiderationItem[] memory originalConsiderationItems =
            new ConsiderationItem[](a.totalOriginalConsiderationItems);
        for (uint256 i = 0; i < a.totalOriginalConsiderationItems; i++) {
            originalConsiderationItems[i] = a.consideration[i].toStandard();
        }
        return OrderComponents({
            conduitKey: a.conduitKey,
            consideration: originalConsiderationItems,
            counter: a.counter,
            endTime: a.endTime,
            offer: a.offer.toStandard(),
            offerer: a.offerer,
            orderType: a.orderType,
            salt: a.salt,
            startTime: a.startTime,
            zone: a.zone,
            zoneHash: a.zoneHash
        });
    }

    function toStandard(OrderComponentsJson memory a) internal pure returns (OrderComponents memory) {
        return OrderComponents({
            conduitKey: a.conduitKey,
            consideration: a.consideration.toStandard(),
            counter: a.counter,
            endTime: a.endTime,
            offer: a.offer.toStandard(),
            offerer: a.offerer,
            orderType: a.orderType,
            salt: a.salt,
            startTime: a.startTime,
            zone: a.zone,
            zoneHash: a.zoneHash
        });
    }

    function toStandard(OrderComponentsJson[] memory a) internal pure returns (OrderComponents[] memory) {
        OrderComponents[] memory b = new OrderComponents[](a.length);
        for (uint256 i = 0; i < a.length; i++) {
            b[i] = OrderComponents({
                conduitKey: a[i].conduitKey,
                consideration: a[i].consideration.toStandard(),
                counter: a[i].counter,
                endTime: a[i].endTime,
                offer: a[i].offer.toStandard(),
                offerer: a[i].offerer,
                orderType: a[i].orderType,
                salt: a[i].salt,
                startTime: a[i].startTime,
                zone: a[i].zone,
                zoneHash: a[i].zoneHash
            });
        }
        return b;
    }

    function toStandard(OfferItemJson memory a) internal pure returns (OfferItem memory) {
        return OfferItem({
            endAmount: a.endAmount,
            identifierOrCriteria: a.identifierOrCriteria,
            itemType: a.itemType,
            startAmount: a.startAmount,
            token: a.token
        });
    }

    function toStandard(OfferItemJson[] memory a) internal pure returns (OfferItem[] memory) {
        OfferItem[] memory b = new OfferItem[](a.length);
        for (uint256 i = 0; i < a.length; i++) {
            b[i] = OfferItem({
                endAmount: a[i].endAmount,
                identifierOrCriteria: a[i].identifierOrCriteria,
                itemType: a[i].itemType,
                startAmount: a[i].startAmount,
                token: a[i].token
            });
        }
        return b;
    }

    function toStandard(ConsiderationItemJson memory a) internal pure returns (ConsiderationItem memory) {
        return ConsiderationItem({
            endAmount: a.endAmount,
            identifierOrCriteria: a.identifierOrCriteria,
            itemType: a.itemType,
            recipient: a.recipient,
            startAmount: a.startAmount,
            token: a.token
        });
    }

    function toStandard(ConsiderationItemJson[] memory a) internal pure returns (ConsiderationItem[] memory) {
        ConsiderationItem[] memory b = new ConsiderationItem[](a.length);
        for (uint256 i = 0; i < a.length; i++) {
            b[i] = ConsiderationItem({
                endAmount: a[i].endAmount,
                identifierOrCriteria: a[i].identifierOrCriteria,
                itemType: a[i].itemType,
                recipient: a[i].recipient,
                startAmount: a[i].startAmount,
                token: a[i].token
            });
        }
        return b;
    }

    function toStandard(SpentItemJson memory a) internal pure returns (SpentItem memory) {
        return SpentItem({amount: a.amount, identifier: a.identifier, itemType: a.itemType, token: a.token});
    }

    function toStandard(SpentItemJson[] memory a) internal pure returns (SpentItem[] memory) {
        SpentItem[] memory b = new SpentItem[](a.length);
        for (uint256 i = 0; i < a.length; i++) {
            b[i] = SpentItem({
                amount: a[i].amount,
                identifier: a[i].identifier,
                itemType: a[i].itemType,
                token: a[i].token
            });
        }
        return b;
    }

    function toStandard(ReceivedItemJson memory a) internal pure returns (ReceivedItem memory) {
        return ReceivedItem({
            amount: a.amount,
            identifier: a.identifier,
            itemType: a.itemType,
            recipient: a.recipient,
            token: a.token
        });
    }

    function toStandard(ReceivedItemJson[] memory a) internal pure returns (ReceivedItem[] memory) {
        ReceivedItem[] memory b = new ReceivedItem[](a.length);
        for (uint256 i = 0; i < a.length; i++) {
            b[i] = ReceivedItem({
                amount: a[i].amount,
                identifier: a[i].identifier,
                itemType: a[i].itemType,
                recipient: a[i].recipient,
                token: a[i].token
            });
        }
        return b;
    }

    function toStandard(BasicOrderParametersJson memory a) internal pure returns (BasicOrderParameters memory) {
        return BasicOrderParameters({
            additionalRecipients: a.additionalRecipients.toStandard(),
            basicOrderType: a.basicOrderType,
            considerationAmount: a.considerationAmount,
            considerationIdentifier: a.considerationIdentifier,
            considerationToken: a.considerationToken,
            endTime: a.endTime,
            fulfillerConduitKey: a.fulfillerConduitKey,
            offerAmount: a.offerAmount,
            offerIdentifier: a.offerIdentifier,
            offerToken: a.offerToken,
            offerer: a.offerer,
            offererConduitKey: a.offererConduitKey,
            salt: a.salt,
            signature: a.signature,
            startTime: a.startTime,
            totalOriginalAdditionalRecipients: a.totalOriginalAdditionalRecipients,
            zone: a.zone,
            zoneHash: a.zoneHash
        });
    }

    function toStandard(BasicOrderParametersJson[] memory a) internal pure returns (BasicOrderParameters[] memory) {
        BasicOrderParameters[] memory b = new BasicOrderParameters[](a.length);
        for (uint256 i = 0; i < a.length; i++) {
            b[i] = BasicOrderParameters({
                additionalRecipients: a[i].additionalRecipients.toStandard(),
                basicOrderType: a[i].basicOrderType,
                considerationAmount: a[i].considerationAmount,
                considerationIdentifier: a[i].considerationIdentifier,
                considerationToken: a[i].considerationToken,
                endTime: a[i].endTime,
                fulfillerConduitKey: a[i].fulfillerConduitKey,
                offerAmount: a[i].offerAmount,
                offerIdentifier: a[i].offerIdentifier,
                offerToken: a[i].offerToken,
                offerer: a[i].offerer,
                offererConduitKey: a[i].offererConduitKey,
                salt: a[i].salt,
                signature: a[i].signature,
                startTime: a[i].startTime,
                totalOriginalAdditionalRecipients: a[i].totalOriginalAdditionalRecipients,
                zone: a[i].zone,
                zoneHash: a[i].zoneHash
            });
        }
        return b;
    }

    function toStandard(AdditionalRecipientJson memory a) internal pure returns (AdditionalRecipient memory) {
        return AdditionalRecipient({amount: a.amount, recipient: a.recipient});
    }

    function toStandard(AdditionalRecipientJson[] memory a) internal pure returns (AdditionalRecipient[] memory) {
        AdditionalRecipient[] memory b = new AdditionalRecipient[](a.length);
        for (uint256 i = 0; i < a.length; i++) {
            b[i] = AdditionalRecipient({amount: a[i].amount, recipient: a[i].recipient});
        }
        return b;
    }

    function toStandard(OrderParametersJson memory a) internal pure returns (OrderParameters memory) {
        return OrderParameters({
            conduitKey: a.conduitKey,
            consideration: a.consideration.toStandard(),
            endTime: a.endTime,
            offer: a.offer.toStandard(),
            offerer: a.offerer,
            orderType: a.orderType,
            salt: a.salt,
            startTime: a.startTime,
            totalOriginalConsiderationItems: a.totalOriginalConsiderationItems,
            zone: a.zone,
            zoneHash: a.zoneHash
        });
    }

    function toStandard(OrderParametersJson[] memory a) internal pure returns (OrderParameters[] memory) {
        OrderParameters[] memory b = new OrderParameters[](a.length);
        for (uint256 i = 0; i < a.length; i++) {
            b[i] = OrderParameters({
                conduitKey: a[i].conduitKey,
                consideration: a[i].consideration.toStandard(),
                endTime: a[i].endTime,
                offer: a[i].offer.toStandard(),
                offerer: a[i].offerer,
                orderType: a[i].orderType,
                salt: a[i].salt,
                startTime: a[i].startTime,
                totalOriginalConsiderationItems: a[i].totalOriginalConsiderationItems,
                zone: a[i].zone,
                zoneHash: a[i].zoneHash
            });
        }
        return b;
    }

    function toStandard(OrderJson memory a) internal pure returns (Order memory) {
        return Order({parameters: a.parameters.toStandard(), signature: a.signature});
    }

    function toStandard(OrderJson[] memory a) internal pure returns (Order[] memory) {
        Order[] memory b = new Order[](a.length);
        for (uint256 i = 0; i < a.length; i++) {
            b[i] = Order({parameters: a[i].parameters.toStandard(), signature: a[i].signature});
        }
        return b;
    }

    function toStandard(AdvancedOrderJson memory a) internal pure returns (AdvancedOrder memory) {
        return AdvancedOrder({
            denominator: a.denominator,
            extraData: a.extraData,
            numerator: a.numerator,
            parameters: a.parameters.toStandard(),
            signature: a.signature
        });
    }

    function toStandard(AdvancedOrderJson[] memory a) internal pure returns (AdvancedOrder[] memory) {
        AdvancedOrder[] memory b = new AdvancedOrder[](a.length);
        for (uint256 i = 0; i < a.length; i++) {
            b[i] = AdvancedOrder({
                denominator: a[i].denominator,
                extraData: a[i].extraData,
                numerator: a[i].numerator,
                parameters: a[i].parameters.toStandard(),
                signature: a[i].signature
            });
        }
        return b;
    }

    function toStandard(OrderStatusJson memory a) internal pure returns (OrderStatus memory) {
        return OrderStatus({
            denominator: a.denominator,
            isCancelled: a.isCancelled,
            isValidated: a.isValidated,
            numerator: a.numerator
        });
    }

    function toStandard(OrderStatusJson[] memory a) internal pure returns (OrderStatus[] memory) {
        OrderStatus[] memory b = new OrderStatus[](a.length);
        for (uint256 i = 0; i < a.length; i++) {
            b[i] = OrderStatus({
                denominator: a[i].denominator,
                isCancelled: a[i].isCancelled,
                isValidated: a[i].isValidated,
                numerator: a[i].numerator
            });
        }
        return b;
    }

    function toStandard(CriteriaResolverJson memory a) internal pure returns (CriteriaResolver memory) {
        return CriteriaResolver({
            criteriaProof: a.criteriaProof,
            identifier: a.identifier,
            index: a.index,
            orderIndex: a.orderIndex,
            side: a.side
        });
    }

    function toStandard(CriteriaResolverJson[] memory a) internal pure returns (CriteriaResolver[] memory) {
        CriteriaResolver[] memory b = new CriteriaResolver[](a.length);
        for (uint256 i = 0; i < a.length; i++) {
            b[i] = CriteriaResolver({
                criteriaProof: a[i].criteriaProof,
                identifier: a[i].identifier,
                index: a[i].index,
                orderIndex: a[i].orderIndex,
                side: a[i].side
            });
        }
        return b;
    }

    function toStandard(FulfillmentJson memory a) internal pure returns (Fulfillment memory) {
        return Fulfillment({
            considerationComponents: a.considerationComponents.toStandard(),
            offerComponents: a.offerComponents.toStandard()
        });
    }

    function toStandard(FulfillmentJson[] memory a) internal pure returns (Fulfillment[] memory) {
        Fulfillment[] memory b = new Fulfillment[](a.length);
        for (uint256 i = 0; i < a.length; i++) {
            b[i] = Fulfillment({
                considerationComponents: a[i].considerationComponents.toStandard(),
                offerComponents: a[i].offerComponents.toStandard()
            });
        }
        return b;
    }

    function toStandard(FulfillmentComponentJson memory a) internal pure returns (FulfillmentComponent memory) {
        return FulfillmentComponent({itemIndex: a.itemIndex, orderIndex: a.orderIndex});
    }

    function toStandard(FulfillmentComponentJson[] memory a) internal pure returns (FulfillmentComponent[] memory) {
        FulfillmentComponent[] memory b = new FulfillmentComponent[](a.length);
        for (uint256 i = 0; i < a.length; i++) {
            b[i] = FulfillmentComponent({itemIndex: a[i].itemIndex, orderIndex: a[i].orderIndex});
        }
        return b;
    }

    function toStandard(ExecutionJson memory a) internal pure returns (Execution memory) {
        return Execution({conduitKey: a.conduitKey, item: a.item.toStandard(), offerer: a.offerer});
    }

    function toStandard(ExecutionJson[] memory a) internal pure returns (Execution[] memory) {
        Execution[] memory b = new Execution[](a.length);
        for (uint256 i = 0; i < a.length; i++) {
            b[i] = Execution({conduitKey: a[i].conduitKey, item: a[i].item.toStandard(), offerer: a[i].offerer});
        }
        return b;
    }
}
