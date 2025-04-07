import { buildModule } from '@nomicfoundation/hardhat-ignition/modules'

const CombinatorialAuctionModule = buildModule('CombinatorialAuctionModule', (m) => {
  const auction = m.contract('CombinatorialAuction')
  return { auction }
})

export default CombinatorialAuctionModule
