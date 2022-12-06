/* global describe it before ethers */

const { deployDiamond } = require('../scripts/deploy.js')
const { assert, expect } = require('chai')
const { ethers } = require('hardhat')

describe('Ownership Facet Test', async function () {
  let diamondAddress
  let ownershipFacet
  let accounts

  before(async function () {
    diamondAddress = await deployDiamond()
    ownershipFacet = await ethers.getContractAt('OwnershipFacet', diamondAddress)
    accounts = await ethers.getSigners()
  })

  it('should have the sender address to be the owner address after diamond is deployed', async () => {
    const owner = await ownershipFacet.owner()
    assert.equal(owner, accounts[0].address)
  })

  it('should revert because the new owner is address zero', async () => {
    const tx = ownershipFacet.transferOwnership(ethers.constants.AddressZero)
    await expect(tx).to.be.reverted;
  })

  it('should change the address owner', async () => {
    await ownershipFacet.transferOwnership(accounts[1].address)
    const owner = await ownershipFacet.owner()
    assert.equal(owner, accounts[1].address)
  })

  it('should revert because the sender is not the owner', async () => {
    const tx = ownershipFacet.transferOwnership(accounts[0].address)
    await expect(tx).to.be.reverted;
  })
})
