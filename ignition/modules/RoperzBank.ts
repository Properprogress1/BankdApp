import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const RoperzBankModule = buildModule("RoperzBankModule", (m) => {
  const RoperzBank = m.contract("RoperzBank", [] );

  return { RoperzBank };
});

export default RoperzBankModule;