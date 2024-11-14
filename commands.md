forge build : to build or compile your code 
forge remappings: to see the packages you installed 

forge test --match-path test/HeloWorld.t.sol : to test a particular test file 

========= HOW TO INSTALL SOLMATE ================
forge install rari-capital/solmate : To install solmate
forge update/solmate => To update a package
forge remove solmate => To remove 


HOW TO INSTALL OPENZEPPELIN CONTRACT

 npm install @openzeppelin/contracts

 create a file called => remappings.txt and paste this ==>@openzeppelin/=node_modules/@openzeppelin

 AUTO FOMATTER
forge fmt 

CONSOLE LOGGING
import "forge-std/console.sol => import it on the solidity or test file you want to use it. Note thatit is used for debugging purpose and remove it when you want to deploy


