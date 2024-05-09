
from web3 import Web3, HTTPProvider
import json

## This function makes a house to each node in the system

web3 = Web3(HTTPProvider('http://localhost:8545'))
jsonFile = open('./build/contracts/FlexCoin.json', 'r')
values = json.load(jsonFile)
jsonFile.close()

abi = values['abi']

address = input("What is the contract address? - FlexCoin: ")
FlexCoin = web3.eth.contract(address, abi = abi)

numHouses = FlexCoin.caller().numHouses()

print("Number of houses:", numHouses)
print("Number of nodes:", len(web3.eth.accounts))
print("Accounts:", web3.eth.accounts)
if(numHouses == 0):
    for i in range(len(web3.eth.accounts)):
        FlexCoin.transact({'from': web3.eth.accounts[i]}).newHouse()
        print("House made for node: ", i)