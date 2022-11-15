import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("TransformCurves", function () {
    const N = 10;

    async function deployTransformCurveFixture() {
        const [deployer] = await ethers.getSigners();

        const TransformCurve = await ethers.getContractFactory("TransformCurve");
        const transformCurve = await TransformCurve.deploy();

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

        // it("Should set the correct N value", async function () {
        //     const { transformCurve } = await loadFixture(deployTransformCurveFixture);

        //     expect(await transformCurve.N()).to.equal(N);
        // });

        // it("Should get the correct curve", async function () {
        //     const { transformCurve } = await loadFixture(deployTransformCurveFixture);

        //     const radii = [1,1,1];
        //     const frequencies = [1,2,3];
        //     const phases = [0,0,0];

        //     const {x,y} = await transformCurve.getCurve(
        //         radii,
        //         frequencies,
        //         phases
        //     );

        //     // zip coords together
        //     const coords = x.map((x: number, i: number) => [x / 1e18, y[i] / 1e18]);

        //     console.log(coords)
        // });
    });
    
    // instantiate the labor market
    // setup the pay curve
    // simulate the pay curve and yoink all the indexes out
});