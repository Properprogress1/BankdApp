import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const RoperzTokenModule = buildModule("RoperzTokenModule", (m) => {
  const Token = m.contract("RoperzBankToken", [] );

  return { Token };
});

export default RoperzTokenModule;