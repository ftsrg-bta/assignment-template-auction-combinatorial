import { expect } from 'chai'
import hre from 'hardhat'
import { ContractFactory } from 'ethers'
import { CombinatorialAuction } from '../typechain-types'

// You can use '@nomicfoundation/hardhat-toolbox/network-helpers
// to simulate the passing of time

describe('CombinatorialAuction', function () {
  describe('Dummy', function () {
    it('Should deploy', async function () {
      const factory: ContractFactory = await hre.ethers.getContractFactory('CombinatorialAuction')
      const auction: CombinatorialAuction = await factory.deploy()
      expect(await auction.dummy()).to.be.true
    })
  })
})
