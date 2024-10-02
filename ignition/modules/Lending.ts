import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const LendingModule = buildModule("LendingModule", (m) => {
  const Lend = m.contract("Lending", [] );

  return { Lend };
});

export default LendingModule;