/* global describe it before ethers */

const { deployDiamond } = require('../scripts/deploy.js')
const { assert, expect } = require('chai')
const { ethers } = require('hardhat')

describe('Blacklistable Facet Test', async function () {
  let diamondAddress
  let blacklistableFacet
  let accounts

  before(async function () {
    diamondAddress = await deployDiamond()
    blacklistableFacet = await ethers.getContractAt('BlacklistableFacet', diamondAddress)
    accounts = await ethers.getSigners()
  })

  it('should blacklist an address', async () => {
    let isBlacklisted = await blacklistableFacet.isBlacklisted(accounts[1].address)
    assert.isFalse(isBlacklisted)
    await blacklistableFacet.blacklist(accounts[1].address)
    isBlacklisted = await blacklistableFacet.isBlacklisted(accounts[1].address)
    assert.isTrue(isBlacklisted)
  })

  it('should unblacklist an address', async () => {
    let isBlacklisted = await blacklistableFacet.isBlacklisted(accounts[1].address)
    assert.isTrue(isBlacklisted)
    await blacklistableFacet.unBlacklist(accounts[1].address)
    isBlacklisted = await blacklistableFacet.isBlacklisted(accounts[1].address)
    assert.isFalse(isBlacklisted)
  })

  it('should revert when trying to blacklist an address when the sender is not the blacklister', async () => {
    await blacklistableFacet.updateBlacklister(accounts[2].address)
    let tx = blacklistableFacet.blacklist(accounts[1].address)
    await expect(tx).to.be.reverted;
  })

  it('should revert when trying to unblacklist an address when the sender is not the blacklister', async () => {
    let tx = blacklistableFacet.unBlacklist(accounts[1].address)
    await expect(tx).to.be.reverted;
  })

  it('should revert when trying to updateBlacklister when the sender is not the blacklister', async () => {
    let tx = blacklistableFacet.updateBlacklister(accounts[2].address)
    await expect(tx).to.be.reverted;
  })
})
