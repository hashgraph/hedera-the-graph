
import { assert, describe, newMockEvent, test } from 'matchstick-as';
import { Transfer as TransferEvent } from '../generated/ERC20/ERC20';
import { handleTransfer } from '../src/mappings';
import { Address, BigInt, ethereum } from '@graphprotocol/graph-ts';
import { Transfer } from '../generated/schema';

describe('handleTransfer', function () {
    test('should handle transfer event', function () {
        const mockEvent = newMockEvent();
        const transferEvent = new TransferEvent(
            Address.fromString('0x8692f704a20d11be3b32de68656651b5291ed26c'),
            mockEvent.logIndex,
            mockEvent.transactionLogIndex,
            mockEvent.logType,
            mockEvent.block,
            mockEvent.transaction,
            [
                new ethereum.EventParam('from', ethereum.Value.fromAddress(Address.fromString('0x1234567890abcdef1234567890abcdef12345678'))),
                new ethereum.EventParam('to', ethereum.Value.fromAddress(Address.fromString('0x1234567890abcdef1234567890abcdef12345679'))),
                new ethereum.EventParam('value', ethereum.Value.fromUnsignedBigInt(BigInt.fromString('4000'))),
            ],
            mockEvent.receipt,
        );

        handleTransfer(transferEvent);

        // Then you would assert that the Transfer entity was created and has the expected values
        const id = transferEvent.transaction.hash.toHex() + "-" + transferEvent.logIndex.toString();
        const transferEntity = Transfer.load(id);
        assert.assertNotNull(transferEntity, 'Transfer entity should not be null');
        assert.stringEquals(transferEntity!.sender, '0x1234567890abcdef1234567890abcdef12345678', 'Sender address should match');
        assert.stringEquals(transferEntity!.recipient, '0x1234567890abcdef1234567890abcdef12345679', 'Recipient address should match');
        assert.stringEquals(transferEntity!.amount, '4000', 'Amount value should match');
    });
});
