import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const InsuranceModule = buildModule("InsuranceModule", (m) => {
  const Insurance = m.contract("Insurance", [] );

  return { Insurance };
});

export default InsuranceModule;