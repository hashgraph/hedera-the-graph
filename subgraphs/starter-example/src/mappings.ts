import { Transfer as TransferEvent } from '../generated/ERC20/ERC20';
import { Transfer } from "../generated/schema";

export function handleTransfer(event: TransferEvent): void {

	let id = event.transaction.hash.toHex() + "-" + event.logIndex.toString();

	// Entities can be loaded from the store using a string ID; this ID
	// needs to be unique across all entities of the same type
	let entity = Transfer.load(id);

	// Entities only exist after they have been saved to the store;
	// `null` checks allow to create entities on demand
	if (!entity) {
		entity = new Transfer(id);
	}

	// Entity fields can be set based on event parameters
	entity.sender = event.params.from.toHexString();
	entity.recipient = event.params.to.toHexString();
	entity.amount = event.params.value.toString();

	// Entities can be written to the store with `.save()`
	entity.save();
}
