forge build : to build or compile your code 
forge remappings: to see the packages you installed 

forge test --match-path test/HelloWorld.t.sol : to test a particular test file 

========= HOW TO INSTALL SOLMATE ================
forge install rari-capital/solmate : To install solmate
forge update/solmate => To update a package
forge remove solmate => To remove 


HOW TO INSTALL OPENZEPPELIN CONTRACT

 npm install @openzeppelin/contracts

 create a file called => remappings.txt and paste this ==>@openzeppelin/=node_modules/@openzeppelin

 ====> AUTO FORMATTER <====
forge fmt 

 ====> FIX CONFIG ISSUE <=====
forge config --fix 

====> SETTING FORK URL VARIABLE IN TERMINAL  <====
 FORK_URL=https://eth-mainnet.g.alchemy.com/v2/nsXvKew2RkxJEbcXLlWa3DcbaUAncLhC

====> OR SET IT ON THE FOUNDRY.TOML FILE <====
[profile.forking]
url = "https://eth-mainnet.g.alchemy.com/v2/nsXvKew2RkxJEbcXLlWa3DcbaUAncLhC"

====> TO RUN THE TEST FORK FILE <=====
  forge test --fork-url $FORK_URL --match-path test/Fork.t.sol -vvv

===> CONSOLE LOGGING <====
import "forge-std/console.sol => import it on the solidity or test file you want to use it. Note that it is used for debugging purpose and remove it when you want to deploy


