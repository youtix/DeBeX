/* global describe it before ethers */

const { deployDiamond } = require('../scripts/deploy.js')
const { assert, expect } = require('chai')
const { ethers } = require('hardhat')

describe('Pausable Facet Test', async function () {
  let diamondAddress
  let pausableFacet
  let ownershipFacet
  let accounts

  before(async function () {
    diamondAddress = await deployDiamond()
    pausableFacet = await ethers.getContractAt('PausableFacet', diamondAddress)
    ownershipFacet = await ethers.getContractAt('OwnershipFacet', diamondAddress)
    accounts = await ethers.getSigners()
  })

  it('should set the default pause state to true', async () => {
    const isPaused = await pausableFacet.paused()
    assert.isTrue(isPaused)
  })

  it('should change the pause state to false', async () => {
    await pausableFacet.unpause()
    const isPaused = await pausableFacet.paused()
    assert.isFalse(isPaused)
  })

  it('should change the pause state to true', async () => {
    await pausableFacet.pause()
    const isPaused = await pausableFacet.paused()
    assert.isTrue(isPaused)
  })

  it('should revert unpause when message sender is not owner', async () => {
    await ownershipFacet.transferOwnership(accounts[1].address)
    const tx = pausableFacet.unpause()
    await expect(tx).to.be.reverted;
  })

  it('should revert pause when message sender is not owner', async () => {
    const tx = pausableFacet.pause()
    await expect(tx).to.be.reverted;
  })
})
