import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
import { TransformCurve__factory } from "../typechain-types";

describe("TransformCurves", function () {
    const N = 10;

    async function deployTransformCurveFixture() {
        const [deployer] = await ethers.getSigners();

        const TransformCurve = await ethers.getContractFactory("TransformCurve");
        const transformCurve = await TransformCurve.deploy(N);

        return { deployer, transformCurve };
    }

    describe("Deployment", function () {
        it("Should deploy the contract", async function () {
            const { transformCurve } = await loadFixture(deployTransformCurveFixture);

            expect(transformCurve.address).to.be.properAddress;
        });

        it("Should set the correct owner", async function () {
            const { deployer, transformCurve } = await loadFixture(deployTransformCurveFixture);

            expect(await transformCurve.owner()).to.equal(deployer.address);
        });

        it("Should set the correct N value", async function () {
            const { transformCurve } = await loadFixture(deployTransformCurveFixture);

            expect(await transformCurve.N()).to.equal(N);
        });

        it("Should get the correct curve", async function () {
            const { transformCurve } = await loadFixture(deployTransformCurveFixture);

            const radii = [1,1,1];
            const frequencies = [1,2,3];
            const phases = [0,0,0];

            const {x,y} = await transformCurve.getCurve(
                radii,
                frequencies,
                phases
            );

            // zip coords together
            const coords = x.map((x, i) => [x / 1e18, y[i] / 1e18]);

            console.log(coords)
        });
    });
    
    // instantiate the labor market
    // setup the pay curve
    // simulate the pay curve and yoink all the indexes out
});

// it("Should set the right N", async function () {
//     const { lock, unlockTime } = await loadFixture(deployOneYearLockFixture);

//     expect(await lock.unlockTime()).to.equal(unlockTime);
// });

// it("Should set the right owner", async function () {
//     const { lock, owner } = await loadFixture(deployOneYearLockFixture);

//     expect(await lock.owner()).to.equal(owner.address);
// });

// it("Should receive and store the funds to lock", async function () {
//     const { lock, lockedAmount } = await loadFixture(
//         deployOneYearLockFixture
//     );

//     expect(await ethers.provider.getBalance(lock.address)).to.equal(
//         lockedAmount
//     );
// });

// it("Should fail if the unlockTime is not in the future", async function () {
//     // We don't use the fixture here because we want a different deployment
//     const latestTime = await time.latest();
//     const Lock = await ethers.getContractFactory("Lock");
//     await expect(Lock.deploy(latestTime, { value: 1 })).to.be.revertedWith(
//         "Unlock time should be in the future"
//     );
// });

// describe("Withdrawals", function () {
//     describe("Validations", function () {
//         it("Should revert with the right error if called too soon", async function () {
//             const { lock } = await loadFixture(deployOneYearLockFixture);

//             await expect(lock.withdraw()).to.be.revertedWith(
//                 "You can't withdraw yet"
//             );
//         });

//         it("Should revert with the right error if called from another account", async function () {
//             const { lock, unlockTime, otherAccount } = await loadFixture(
//                 deployOneYearLockFixture
//             );

//             // We can increase the time in Hardhat Network
//             await time.increaseTo(unlockTime);

//             // We use lock.connect() to send a transaction from another account
//             await expect(lock.connect(otherAccount).withdraw()).to.be.revertedWith(
//                 "You aren't the owner"
//             );
//         });

//         it("Shouldn't fail if the unlockTime has arrived and the owner calls it", async function () {
//             const { lock, unlockTime } = await loadFixture(
//                 deployOneYearLockFixture
//             );

//             // Transactions are sent using the first signer by default
//             await time.increaseTo(unlockTime);

//             await expect(lock.withdraw()).not.to.be.reverted;
//         });
//     });

//     describe("Events", function () {
//         it("Should emit an event on withdrawals", async function () {
//             const { lock, unlockTime, lockedAmount } = await loadFixture(
//                 deployOneYearLockFixture
//             );

//             await time.increaseTo(unlockTime);

//             await expect(lock.withdraw())
//                 .to.emit(lock, "Withdrawal")
//                 .withArgs(lockedAmount, anyValue); // We accept any value as `when` arg
//         });
//     });

//     describe("Transfers", function () {
//         it("Should transfer the funds to the owner", async function () {
//             const { lock, unlockTime, lockedAmount, owner } = await loadFixture(
//                 deployOneYearLockFixture
//             );

//             await time.increaseTo(unlockTime);

//             await expect(lock.withdraw()).to.changeEtherBalances(
//                 [owner, lock],
//                 [lockedAmount, -lockedAmount]
//             );
//         });
//     });
// });